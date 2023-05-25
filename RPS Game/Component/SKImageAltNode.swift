//
//  SKImageAltNode.swift
//  RPS Game
//
//  Created by Rizki Samudra on 24/05/23.
//

import Foundation
import SpriteKit

class SKImageAltNode: SKSpriteNode {
    
    
    var defaultTexture: SKTexture
    
    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    init(normalTexture defaultTexture: SKTexture!, name: String = "", _ size: CGSize = CGSize(width: 32, height: 32)) {
        
        self.defaultTexture = defaultTexture
        super.init(texture: defaultTexture, color: UIColor.white, size: size)

        // Adding this node as an empty layer. Without it the touch functions are not being called
        // The reason for this is unknown when this was implemented...?
        let bugFixLayerNode = SKSpriteNode(texture: nil, color: UIColor.clear, size: size )
        bugFixLayerNode.position = self.position
        bugFixLayerNode.name = name
        addChild(bugFixLayerNode)
        
    }
    
}

