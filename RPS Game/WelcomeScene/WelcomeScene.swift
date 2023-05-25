//
//  WelcomeScene.swift
//  RPS Game
//
//  Created by Rizki Samudra on 17/05/23.
//

import SpriteKit
import GameplayKit

class WelcomeScene: BaseScene {
    
    private var label : SKLabelNode?
    private var helpImage : SKImageNode?
    private var helpImage2 : SKImageNode?
    private var button: SKButtonNode?
    private var scale: Double = 0.0
    var isAdded = false
    private var blockView: SKShapeNode?
    var width: CGFloat = CGFloat(0)
    var height: CGFloat = CGFloat(0)
    private var clicked = false
    
    
    override func didMove(to view: SKView) {
        print("sample Move")

        // Get label node from scene and store it for use later
        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
        
        if let label = self.label {
            label.numberOfLines = 2
            
            label.text = "Welcome to RPS \nand Friends"
            scale = min(UIScreen.main.bounds.width / label.frame.width, UIScreen.main.bounds.height / label.frame.height)
            // Change the fontSize.
            label.fontSize *= scale
            label.fontName = "SFToontimeBlotch"
            // Optionally move the SKLabelNode to the center of the rectangle.
            label.position = CGPoint(x: 0, y: (UIScreen.main.bounds.height / 2 ) + (200 * scale))
            label.zPosition = -1
            label.alpha = 0.0
            label.run(SKAction.fadeIn(withDuration: 2.0))
        }
        
        width = CGFloat(view.bounds.width) / 2 + 64
        height = CGFloat(view.bounds.height) / 2 + 160
        
        let buttonTexture = SKTexture(imageNamed: "button1")
        let buttonPressedTexture = SKTexture(imageNamed: "button1_selected")
        button = SKButtonNode(normalTexture:buttonTexture, selectedTexture:buttonPressedTexture, disabledTexture:buttonPressedTexture)
        button?.setButtonLabel(title: "Play",font:  "SFToontimeBlotch" ,fontSize: 40)
        //        button?.position = CGPointMake(self.frame.size.width/2, self.frame.size.height/2)
        button?.zPosition = 0
        button?.size.width += 16
        button?.size.height += 16
        button?.position = CGPoint(x: 0 ,y: 0)
        addChild(button!)
      

        button?.setButtonAction(target: self, triggerEvent: .TouchDown, action:#selector(play))

        helpImage = SKImageNode( normalTexture: SKTexture(imageNamed: "ic_help"))
        helpImage?.size.width = 44
        helpImage?.size.height = 44
        helpImage?.zPosition = 0
        helpImage?.position = CGPoint(x: width , y: height)
        addChild(helpImage!)
       
        helpImage?.setImageAction(target: self, triggerEvent: .TouchUp, action:#selector(openHelp))
        
//        let helpImage2 = SKImageNode( normalTexture: SKTexture(imageNamed: "ic_help"))
//        helpImage2.position = CGPoint(x: -width , y: -height)
//        addChild(helpImage2)
        
    }
    
    @objc func openHelp() {
        print("sample help")
        touchDown(atPoint: helpImage?.position ?? CGPoint(x: 0, y: 0))
//        gameDelegate?.updateScene(sceneName: "SampleScene")
        
        if(!isAdded){
            isAdded = true
            //view help
            blockView = addView()
            addChild(blockView!)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        print("sample touch")
    }
    
    func addView() -> SKShapeNode{
        let blockView = SKShapeNode(rectOf: CGSize(width: 600 - 32, height: 1250 - 32),cornerRadius: 16)
        blockView.fillColor = SKColor.darkGray
        blockView.position = CGPoint(x: 0, y: 0)
        blockView.zPosition = 1
        
        let closeImage = SKImageNode( normalTexture: SKTexture(imageNamed: "ic_close"))
        blockView.addChild(closeImage)
        closeImage.size.width = 44
        closeImage.size.height = 44
        closeImage.zPosition = 2

        closeImage.position = CGPoint(x: (blockView.frame.width / 2) - 32, y: (blockView.frame.height / 2 ) - 32)
        closeImage.setImageAction(target: self, triggerEvent: .TouchUp, action:#selector(closeBlockView))
        
//        var label = SKLabelNode(text: "Sample Text it should cover all up here and there, this sample text is random and I don't know what to text anymore, anyway its should be long enough")
//        blockView.addChild(label)
//        label.fontSize = 24
//        label.fontColor = SKColor.red
//
////        label.frame = CGSize(width: ( width * 1.5) - 16, height: (height * 1.5) - 16)
//        label.zPosition = 2
//        label.position = CGPoint(x: blockView.frame.midX / 2, y: blockView.frame.height / 2  )
//        label.numberOfLines = 3
        
        let textImage = SKSpriteNode(texture: SKTexture(imageNamed: "help_text1"), color: UIColor.clear, size: CGSize(width: (blockView.frame.width / 1), height: (blockView.frame.height / 1)) )

        textImage.zPosition = 1

        textImage.position = CGPoint(x: blockView.frame.midX , y: blockView.frame.midY )
        blockView.addChild(textImage)
        

        
        
        return blockView
    }
    
    
    
    @objc func closeBlockView() {
        isAdded = false
        removeChildren(in: [blockView!])
        touchDown(atPoint: button?.position ?? CGPoint(x: 0, y: 0))
    }
    
    
    @objc func play() {
        print("sample button")
        touchDown(atPoint: button?.position ?? CGPoint(x: 0, y: 0))
        if(!clicked){
            clicked = true
            
        }else{
            return
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.clicked = false
            self.gameDelegate?.updateScene(sceneName: "GameScene")
            
        }

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
