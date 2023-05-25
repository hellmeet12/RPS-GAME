//
//  BaseScene.swift
//  RPS Game
//
//  Created by Rizki Samudra on 22/05/23.
//

import Foundation

import SpriteKit
import GameplayKit

class BaseScene: SKScene {
    
    var gameDelegate: GameDelegate? = nil

    override func didMove(to view: SKView) {
        
    }
   
    func touchDown(atPoint pos : CGPoint) {
        let singleRippleDuration = 1.0
        let ripleEndScale = CGFloat(2.0)
        let timeBetweenRipples = 0.3
        let numberOfRipples = 2
        let scaleUpAction = SKAction.scale(to: ripleEndScale, duration: singleRippleDuration)
        let fadeOutAction = SKAction.fadeOut(withDuration: singleRippleDuration)
        let rippleAction = SKAction.group([scaleUpAction, fadeOutAction])
        
        let createRipple = SKAction.run({
            let rippleNode = SKShapeNode(circleOfRadius: 100)
            rippleNode.position = pos
            rippleNode.setScale(0)
            rippleNode.zPosition = 2
            rippleNode.run(rippleAction)
            self.addChild(rippleNode)
        })
        
        let wait = SKAction.wait(forDuration: timeBetweenRipples)
        run(SKAction.repeat(SKAction.sequence([createRipple, wait]), count: numberOfRipples))
    }
    
    func touchMoved(toPoint pos : CGPoint) {
      
    }
    
    func touchUp(atPoint pos : CGPoint) {
    
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {

    }
    
}
