//
//  GameplayScene.swift
//  CowboyRunner
//
//  Created by 李泰儀 on 2022/8/23.
//

import SpriteKit

class GameplayScene: SKScene {
    
    let bgCount = 3
    var bgWidth: CGFloat {
        SKSpriteNode(imageNamed: "BG").frame.width
    }
    
    override func didMove(to view: SKView) {
        setup()
    }
    
    override func update(_ currentTime: TimeInterval) {
        moveBGAndGround()
    }
    
    func setup() {
        setupBG()
        setupGrounds()
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
            ground.setScale(0.5)
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
}
