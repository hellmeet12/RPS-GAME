//
//  SKImageNode.swift
//  RPS Game
//
//  Created by Rizki Samudra on 22/05/23.
//

import Foundation
import SpriteKit

class SKImageNode: SKSpriteNode {
    
    enum SKImageNodeActionType: Int {
        case TouchUpInside = 1,
        TouchDown, TouchUp
    }
    
    var defaultTexture: SKTexture
    
    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    init(normalTexture defaultTexture: SKTexture!, name: String = "", _ size: CGSize = CGSize(width: 32, height: 32)) {
        
        self.defaultTexture = defaultTexture
        
        super.init(texture: defaultTexture, color: UIColor.white, size: size)

        isUserInteractionEnabled = true

        
        // Adding this node as an empty layer. Without it the touch functions are not being called
        // The reason for this is unknown when this was implemented...?
        let bugFixLayerNode = SKSpriteNode(texture: nil, color: UIColor.clear, size: size )
        bugFixLayerNode.position = self.position
        bugFixLayerNode.name = name
        addChild(bugFixLayerNode)
        
    }
    
   
    /**
     * Taking a target object and adding an action that is triggered by a button event.
     */
    func setImageAction(target: AnyObject, triggerEvent event:SKImageNodeActionType, action:Selector) {
        
        switch (event) {
        case .TouchUpInside:
            targetTouchUpInside = target
            actionTouchUpInside = action
        case .TouchDown:
            targetTouchDown = target
            actionTouchDown = action
        case .TouchUp:
            targetTouchUp = target
            actionTouchUp = action
        }
        
    }
    
    /*
    New function for setting text. Calling function multiple times does
    not create a ton of new labels, just updates existing label.
    You can set the title, font type and font size with this function
    */
 
    
    var disabledTexture: SKTexture?
    var actionTouchUpInside: Selector?
    var actionTouchUp: Selector?
    var actionTouchDown: Selector?
    weak var targetTouchUpInside: AnyObject?
    weak var targetTouchUp: AnyObject?
    weak var targetTouchDown: AnyObject?
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if (targetTouchDown != nil && targetTouchDown!.responds(to: actionTouchDown!))
        {
            UIApplication.shared.sendAction(actionTouchDown!, to: targetTouchDown, from: self, for: nil)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
       
        if (targetTouchUpInside != nil && targetTouchUpInside!.responds(to: actionTouchUpInside!)) {
            let touch  = touches.first
            let touchLocation = touch?.location(in: parent!)
            
            if (frame.contains(touchLocation!) ) {
                UIApplication.shared.sendAction(actionTouchUpInside!, to: targetTouchUpInside, from: self, for: nil)
            }
            
        }
        
        if (targetTouchUp != nil && targetTouchUp!.responds(to: actionTouchUp!)) {
            UIApplication.shared.sendAction(actionTouchUp!, to: targetTouchUp, from: self, for: nil)
        }
    }
    
}

