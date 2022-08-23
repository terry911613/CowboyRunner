//
//  GameplayScene.swift
//  CowboyRunner
//
//  Created by 李泰儀 on 2022/8/23.
//

import SpriteKit

class GameplayScene: SKScene {
    
    override func didMove(to view: SKView) {
        setup()
    }
    
    func setup() {
        setupBG()
        setupGrounds()
    }
    
    func setupBG() {
        for i in 0...2 {
            let bg = SKSpriteNode(imageNamed: "BG")
            bg.name = "BG"
            bg.position = CGPoint(x: CGFloat(i) * bg.size.width, y: 0)
            bg.zPosition = 0
            addChild(bg)
        }
    }
    
    func setupGrounds() {
        for i in 0...2 {
            let bg = SKSpriteNode(imageNamed: "Ground")
            bg.name = "Ground"
            bg.position = CGPoint(x: CGFloat(i) * bg.size.width, y: -(frame.size.height / 2))
            bg.zPosition = 3
            addChild(bg)
        }
    }
}
