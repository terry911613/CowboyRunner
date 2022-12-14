//
//  GameplayScene.swift
//  CowboyRunner
//
//  Created by 李泰儀 on 2022/8/23.
//

import SpriteKit

class GameplayScene: SKScene {
    
    var player: Player?
    var obstacles = [SKSpriteNode]()
    var canJump = false
    var movePlayer = false
    var playerOnObstacle = false
    var isAlive = false
    var spawner: Timer?
    var scoreTimer: Timer?
    var scoreLabel = SKLabelNode()
    var score = 0
    var pausePanel = SKSpriteNode()
    var isPause = false
    
    let bgCount = 3
    var bgWidth: CGFloat {
        SKSpriteNode(imageNamed: "BG").frame.width
    }
    
    override func didMove(to view: SKView) {
        setup()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            
            let location = touch.location(in: self)
            
            if atPoint(location).name == "Restart" {
                guard let gameplay = GameplayScene(fileNamed: "GameplayScene") else { return }
                gameplay.scaleMode = .aspectFill
                view?.presentScene(gameplay, transition: SKTransition.doorway(withDuration: 1.5))
            } else if atPoint(location).name == "Quit" {
                guard let gameplay = MenuScene(fileNamed: "MenuScene") else { return }
                gameplay.scaleMode = .aspectFill
                view?.presentScene(gameplay, transition: SKTransition.doorway(withDuration: 1.5))
            } else if atPoint(location).name == "Pause" {
                if !isPause {
                    isPause = true
                    createPausePanel()
                }
            } else if atPoint(location).name == "Resume" {
                isPause = false
                pausePanel.removeFromParent()
                scene?.isPaused = false
                setupTimer(valid: true)
            } else if atPoint(location).name == "Quit" {
                isPause = false
                guard let gameplay = MenuScene(fileNamed: "MenuScene") else { return }
                gameplay.scaleMode = .aspectFill
                view?.presentScene(gameplay, transition: SKTransition.doorway(withDuration: 1.5))
            } else {
                if canJump {
                    canJump = false
                    player?.jump()
                }
                
                if playerOnObstacle {
                    player?.jump()
                }
            }
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        if isAlive {
            moveBGAndGround()
        }
        
        if movePlayer {
            player?.position.x -= 1
        }
        
        checkPlayerBounds()
    }
    
    func setup() {
        physicsWorld.contactDelegate = self
        
        isAlive = true
        
        setupPlayer()
        setupBG()
        setupGrounds()
        setupObstables()
        getScoreLabel()
        setupTimer(valid: true)
    }
    
    func setupTimer(valid: Bool) {
        if valid {
            spawner = Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { [weak self] _ in
                self?.spawnObstacles()
            }
            
            scoreTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] _ in
                self?.incrementScore()
            })
        } else {
            spawner?.invalidate()
            scoreTimer?.invalidate()
        }
    }
    
    func setupPlayer() {
        player = Player(imageNamed: "Player 1")
        player?.setup()
        player?.position = CGPoint(x: -10, y: 20)
        guard let player = player else { return }
        addChild(player)
    }
    
    func setupBG() {
        for i in 0..<bgCount {
            let bg = SKSpriteNode(imageNamed: "BG")
            bg.setScale(frame.height / bg.frame.height)
            bg.name = "BG"
            let x = -((frame.width / 2) - (bg.frame.width / 2))
            bg.position = CGPoint(x: CGFloat(i) * bg.size.width + x, y: 0)
            bg.zPosition = 0
            addChild(bg)
        }
    }
    
    var groundMaxY: CGFloat = .zero
    
    func setupGrounds() {
        for i in 0..<bgCount {
            let ground = SKSpriteNode(imageNamed: "Ground")
            let scale = 0.5
            ground.setScale(scale)
            groundMaxY = ground.frame.maxY
            ground.name = "Ground"
            let x = -((frame.width / 2) - (ground.frame.width / 2))
            ground.position = CGPoint(x: CGFloat(i) * ground.size.width + x, y: -(frame.size.height / 2))
            ground.zPosition = 3
            
            ground.physicsBody = SKPhysicsBody(rectangleOf: ground.size)
            ground.physicsBody?.affectedByGravity = false
            ground.physicsBody?.isDynamic = false
            ground.physicsBody?.restitution = 0
            ground.physicsBody?.categoryBitMask = ColliderType.Ground
            
            addChild(ground)
        }
    }
    
    func moveBGAndGround() {
        enumerateChildNodes(withName: "BG") { [weak self] node, _ in
            guard let self = self, let node = node as? SKSpriteNode else { return }
            
            node.position.x -= 4
            
            if node.position.x < -(self.frame.width / 2 + node.frame.width / 2) {
                node.position.x += node.frame.size.width * CGFloat(self.bgCount)
            }
        }
        
        enumerateChildNodes(withName: "Ground") { [weak self] node, _ in
            guard let self = self, let node = node as? SKSpriteNode else { return }
            
            node.position.x -= 2
            
            if node.position.x < -(self.frame.width / 2 + node.frame.width / 2) {
                node.position.x += node.frame.size.width * CGFloat(self.bgCount)
            }
        }
    }
    
    func setupObstables() {
        for i in 0...5 {
            let obstable = SKSpriteNode(imageNamed: "Obstacle \(i)")
            
            var name = "Obstacle"
            var scale = 0.3
            
            if i == 0 {
                name = "Cactus"
                scale = 0.2
            }
            
            obstable.name = name
            obstable.setScale(0.3)
            obstable.zPosition = 2
            obstable.setScale(scale)
            
            obstable.physicsBody = SKPhysicsBody(rectangleOf: obstable.size)
            obstable.physicsBody?.allowsRotation = false
            obstable.physicsBody?.isDynamic = false
            obstable.physicsBody?.restitution = 0
            obstable.physicsBody?.categoryBitMask = ColliderType.Obstacle
            
            obstacles.append(obstable)
        }
    }
    
    func spawnObstacles() {
        let index = Int.random(in: 0...(obstacles.count - 1))
        
        guard let obstacle = obstacles[index].copy() as? SKSpriteNode else { return }
        
        obstacle.position = CGPoint(x: (frame.width / 2) + obstacle.size.width,
                                    y: -(frame.size.height / 2) + groundMaxY + (obstacle.size.height / 2))
        
        let move = SKAction.moveTo(x: -(frame.size.width * 2), duration: 15)
        let remove = SKAction.removeFromParent()
        let sequence = SKAction.sequence([move, remove])
        
        obstacle.run(sequence)
        
        addChild(obstacle)
    }
    
    func checkPlayerBounds() {
        guard isAlive, let player = player else { return }

        if player.position.x < -(frame.size.width / 2) {
            playerDied()
        }
    }
    
    func getScoreLabel() {
        scoreLabel = childNode(withName: "ScoreLabel") as? SKLabelNode ?? SKLabelNode()
        scoreLabel.text = "0M"
    }
    
    func incrementScore() {
        score += 1
        scoreLabel.text = "\(score)M"
    }
    
    func createPausePanel() {
        
        setupTimer(valid: false)
        
        scene?.isPaused = true
        
        pausePanel = SKSpriteNode(imageNamed: "Pause Panel")
        pausePanel.position = CGPoint(x: 0, y: 0)
        pausePanel.zPosition = 10
        
        let resume = SKSpriteNode(imageNamed: "Play")
        resume.name = "Resume"
        resume.position = CGPoint(x: -155, y: 0)
        resume.zPosition = 9
        resume.setScale(0.75)
        
        let quit = SKSpriteNode(imageNamed: "Quit")
        quit.name = "Quit"
        quit.position = CGPoint(x: 155, y: 0)
        quit.zPosition = 9
        quit.setScale(0.75)
        
        pausePanel.addChild(resume)
        pausePanel.addChild(quit)
        
        addChild(pausePanel)
    }
    
    func playerDied() {
        
        if score > UserDefaults.standard.integer(forKey: "HighScore") {
            UserDefaults.standard.set(score, forKey: "HighScore")
        }
        
        player?.removeFromParent()
        
        for child in children {
            if child.name == "Obstacle" || child.name == "Cactus" {
                child.removeFromParent()
            }
        }
        
        setupTimer(valid: false)
        
        isAlive = false
        
        let restart = SKSpriteNode(imageNamed: "Restart")
        restart.name = "Restart"
        restart.position = CGPoint(x: -200, y: -80)
        restart.zPosition = 10
        restart.setScale(0)
        
        let quit = SKSpriteNode(imageNamed: "Quit")
        quit.name = "Quit"
        quit.position = CGPoint(x: 200, y: -80)
        quit.zPosition = 10
        quit.setScale(0)
        
        let scaleUp = SKAction.scale(to: 0.5, duration: 0.5)
        
        restart.run(scaleUp)
        quit.run(scaleUp)
        
        addChild(restart)
        addChild(quit)
    }
}

extension GameplayScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        var firstBody = SKPhysicsBody()
        var secondBody = SKPhysicsBody()
        
        if contact.bodyA.node?.name == "Player" {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if firstBody.node?.name == "Player" {
            if secondBody.node?.name == "Ground" {
                canJump = true
            } else if secondBody.node?.name == "Obstacle" {
                if !canJump {
                    movePlayer = true
                    playerOnObstacle = true
                }
            } else if secondBody.node?.name == "Cactus" {
                playerDied()
            }
        }
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        var firstBody = SKPhysicsBody()
        var secondBody = SKPhysicsBody()
        
        if contact.bodyA.node?.name == "Player" {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if firstBody.node?.name == "Player" {
            if secondBody.node?.name == "Ground" {
                
            } else if secondBody.node?.name == "Obstacle" {
                movePlayer = false
                playerOnObstacle = false
            } else if secondBody.node?.name == "Cactus" {
                
            }
        }
    }
}
