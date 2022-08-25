//
//  MenuScene.swift
//  CowboyRunner
//
//  Created by 李泰儀 on 2022/8/26.
//

import SpriteKit

class MenuScene: SKScene {
    
    var playButton = SKSpriteNode()
    var scoreButton = SKSpriteNode()
    var title = SKLabelNode()
    
    let bgCount = 3
    
    override func didMove(to view: SKView) {
        setup()
    }
    
    override func update(_ currentTime: TimeInterval) {
        moveBGAndGround()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            if atPoint(location) == playButton {
                guard let gameplay = GameplayScene(fileNamed: "GameplayScene") else { return }
                gameplay.scaleMode = .aspectFill
                view?.presentScene(gameplay, transition: SKTransition.doorway(withDuration: 1.5))
            } else if atPoint(location) == scoreButton {
                
            }
        }
    }
    
    func setup() {
        setupBG()
        setupGrounds()
        getButton()
        getLabel()
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
    
    func setupGrounds() {
        for i in 0..<bgCount {
            let ground = SKSpriteNode(imageNamed: "Ground")
            let scale = 0.5
            ground.setScale(scale)
            ground.name = "Ground"
            let x = -((frame.width / 2) - (ground.frame.width / 2))
            ground.position = CGPoint(x: CGFloat(i) * ground.size.width + x, y: -(frame.size.height / 2))
            ground.zPosition = 3
            
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
    
    func getButton() {
        playButton = childNode(withName: "Play") as? SKSpriteNode ?? SKSpriteNode()
        scoreButton = childNode(withName: "Score") as? SKSpriteNode ?? SKSpriteNode()
        
    }
    
    func getLabel() {
        title = childNode(withName: "Title") as? SKLabelNode ?? SKLabelNode()
        
        title.fontName = "RosewoodStd-Regular"
        title.fontSize = 120
        title.text = "Cowboy Runner"
        title.zPosition = 5
        
        let moveUp = SKAction.moveTo(y: title.position.y + 50, duration: 1.3)
        let moveDown = SKAction.moveTo(y: title.position.y - 50, duration: 1.3)
        let sequence = SKAction.repeatForever(SKAction.sequence([moveUp, moveDown]))
        
        title.run(sequence)
    }
}
