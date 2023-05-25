//
//  SampleScene.swift
//  RPS Game
//
//  Created by Rizki Samudra on 22/05/23.
//

import Foundation

import SpriteKit
import GameplayKit

class SampleScene: BaseScene {
    
    
    override func didMove(to view: SKView) {
//        let width = CGFloat(view.bounds.width)
//        let height = CGFloat(view.bounds.height)
        let label = SKLabelNode(text: "Sample Text")
        label.fontSize = 48
        label.fontName = "AvenirNext-SemiBold"
        
        label.position = CGPoint(x: 0 ,y: 0)
        addChild(label)
    }
    
    override func touchDown(atPoint pos : CGPoint) {
        super.touchDown(atPoint: pos)
    }
    
    override func touchMoved(toPoint pos : CGPoint) {
        super.touchMoved(toPoint: pos)
    }
    
    override func touchUp(atPoint pos : CGPoint) {
        super.touchUp(atPoint: pos)
        
    }
    
}
