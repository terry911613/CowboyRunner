//
//  Player.swift
//  CowboyRunner
//
//  Created by 李泰儀 on 2022/8/24.
//

import SpriteKit

class Player: SKSpriteNode {
    
    func setup() {
        name = "Player"
        zPosition = 2
        setScale(0.3)
        
        physicsBody = SKPhysicsBody(rectangleOf: size)
        physicsBody?.affectedByGravity = true
        physicsBody?.allowsRotation = false
        physicsBody?.categoryBitMask = ColliderType.Player
        physicsBody?.collisionBitMask = ColliderType.Ground | ColliderType.Obstacle
        physicsBody?.contactTestBitMask = ColliderType.Ground | ColliderType.Obstacle
    }
    
    func jump() {
        physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        physicsBody?.applyImpulse(CGVector(dx: 0, dy: 100))
    }
}
