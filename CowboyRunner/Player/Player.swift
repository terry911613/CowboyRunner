//
//  Player.swift
//  CowboyRunner
//
//  Created by 李泰儀 on 2022/8/24.
//

import SpriteKit

class Player: SKSpriteNode {
    
    func setup() {
        
        var walk = [SKTexture]()
        
        for i in 1...11 {
            let name = "Player \(i)"
            walk.append(SKTexture(imageNamed: name))
        }
        
        let walkAnimation = SKAction.animate(with: walk, timePerFrame: 0.066, resize: true, restore: true)
        
        name = "Player"
        zPosition = 2
        setScale(0.3)
        
        physicsBody = SKPhysicsBody(rectangleOf: size)
        physicsBody?.affectedByGravity = true
        physicsBody?.allowsRotation = false
        physicsBody?.restitution = 0
        physicsBody?.categoryBitMask = ColliderType.Player
        physicsBody?.collisionBitMask = ColliderType.Ground | ColliderType.Obstacle
        physicsBody?.contactTestBitMask = ColliderType.Ground | ColliderType.Obstacle
        
        run(SKAction.repeatForever(walkAnimation))
    }
    
    func jump() {
        physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        physicsBody?.applyImpulse(CGVector(dx: 0, dy: 120))
    }
}
