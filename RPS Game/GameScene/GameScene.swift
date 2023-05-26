//
//  GameScene.swift
//  RPS Game
//
//  Created by Rizki Samudra on 23/05/23.
//


import Foundation
import GameplayKit

class GameScene: BaseScene {
    
    private var width = CGFloat(0)
    private var height = CGFloat(0)
    private var isAdded = false
    private var boardView: SKShapeNode?
    private var blockView: SKShapeNode?
    private var resultGameView: SKShapeNode?
    private var selectedNode: SKNode?
    
    var label: SKLabelNode? = nil
    var button: SKButtonNode? = nil
    var backToHomeButton: SKButtonNode? = nil
    var playButton: SKButtonNode? = nil
    var helpImage: SKImageNode? = nil
    
    var card1: SKImageNode? = nil
    var card2: SKImageNode? = nil
    var card3: SKImageNode? = nil
    var card4: SKImageNode? = nil
    var card5: SKImageNode? = nil
    
    var cardE1: SKSpriteNode? = nil
    var cardE2: SKSpriteNode? = nil
    var cardE3: SKSpriteNode? = nil
    var cardE4: SKSpriteNode? = nil
    var cardE5: SKSpriteNode? = nil
    
    var card1OldPos: CGPoint = CGPoint(x: 0, y: 0)
    var card2OldPos: CGPoint = CGPoint(x: 0, y: 0)
    var card3OldPos: CGPoint = CGPoint(x: 0, y: 0)
    var card4OldPos: CGPoint = CGPoint(x: 0, y: 0)
    var card5OldPos: CGPoint = CGPoint(x: 0, y: 0)
    
    var cardE1OldPos: CGPoint = CGPoint(x: 0, y: 0)
    var cardE2OldPos: CGPoint = CGPoint(x: 0, y: 0)
    var cardE3OldPos: CGPoint = CGPoint(x: 0, y: 0)
    var cardE4OldPos: CGPoint = CGPoint(x: 0, y: 0)
    var cardE5OldPos: CGPoint = CGPoint(x: 0, y: 0)
    
    var placeholder1: SKSpriteNode? = nil
    var placeholder2: SKSpriteNode? = nil
    var placeholder3: SKSpriteNode? = nil
    var placeholder4: SKSpriteNode? = nil
    var placeholder5: SKSpriteNode? = nil
    
    var placeholderE1: SKSpriteNode? = nil
    var placeholderE2: SKSpriteNode? = nil
    var placeholderE3: SKSpriteNode? = nil
    var placeholderE4: SKSpriteNode? = nil
    var placeholderE5: SKSpriteNode? = nil
    
    
    var lifeE1: SKImageAltNode? = nil
    var lifeE2: SKImageAltNode? = nil
    
    var lifeP1: SKImageAltNode? = nil
    var lifeP2: SKImageAltNode? = nil
    
    var scoreLeft: SKLabelNode? = nil
    var scoreRight: SKLabelNode? = nil
    var scoreLeftCount: Int = 0
    var scoreRightCount: Int = 0
    var winPlayer: Int = 0
    var winEnemy: Int = 0
    
    private let kMovableNode = "movable"
    private var kLogEnabled = false
    private var winState = "NOT" // "LOSE" , // "WIN"
    var random: [Int] = [0,1,2,3,4]
    var cardEnemy: [SKSpriteNode] = []
    var cardEnemyBase: [SKSpriteNode] = []
    
    var isPos1Available = true
    var isPos2Available = true
    var isPos3Available = true
    var isPos4Available = true
    var isPos5Available = true
    
    var curSize = CGFloat(0)
    var isFighting = true
    var playerList = ["","","","",""]
    
    override func didMove(to view: SKView) {
        
        width = CGFloat(view.bounds.width)
        height = CGFloat(view.bounds.height)
        
        //        registMovableAction()
        prepareGameSet()
    }
    
    func defineBoard(){
        label = SKLabelNode(text: "Preparation Time")
        label?.numberOfLines = 2
        let scale = min(UIScreen.main.bounds.width / (label?.frame.width ?? 0) , UIScreen.main.bounds.height / (label?.frame.height ?? 0) )
        label?.fontSize *= scale
        label?.fontName = "SFToontimeBlotch"
        label?.zPosition = -1
        label?.position = CGPoint(x: 0 ,y: height / 2 + 64)
        addChild(label!)
        curSize = label?.fontSize ?? CGFloat(0)
        
        boardView = SKShapeNode(rectOf: CGSize(width: 600 - 32, height: 500 - 32),cornerRadius: 16)
        boardView?.fillColor = SKColor.darkGray
        boardView?.position = CGPoint(x: 0, y: 0)
        boardView?.zPosition = -1
        addChild(boardView!)
        
        helpImage = SKImageNode( normalTexture: SKTexture(imageNamed: "ic_help"))
        helpImage?.size.width = 44
        helpImage?.size.height = 44
        helpImage?.zPosition = 0
        helpImage?.position = CGPoint(x: CGFloat(width) / 2 + 64 , y: CGFloat(height) / 2 + 160)
        addChild(helpImage!)
        
        helpImage?.setImageAction(target: self, triggerEvent: .TouchUp, action:#selector(openHelp))
        
        let buttonTexture = SKTexture(imageNamed: "button1")
        let buttonPressedTexture = SKTexture(imageNamed: "button1_selected")
        button = SKButtonNode(normalTexture:buttonTexture, selectedTexture:buttonPressedTexture, disabledTexture:buttonPressedTexture, name: "btShowdown")
        button?.setButtonLabel(title: "Showdown!",font:  "SFToontimeBlotch" ,fontSize: 36)
        button?.zPosition = 0
        button?.size.width = 250
        button?.size.height += 16
        button?.position = CGPoint(x: 0 ,y: 0)
        button?.setButtonAction(target: self, triggerEvent: .TouchUp, action:#selector(goFight))
        
        addChild(button!)
    }
    
    func prepareGameSet(){
        defineBoard()
        defineScore()
        definePlaceholder()
        defineEnemyLife()
        definePlayerLife()
        defineEnemyCard()
        definePlayerCard()
    }
    
    
    func defineScore(){
        
        scoreLeft = SKLabelNode(text: "0")
        scoreLeft?.position = CGPoint(x: -200 ,y: -15)
        scoreLeft?.fontSize = 40
        scoreLeft?.zPosition = 1
        scoreLeft?.fontColor = .black
        scoreLeft?.fontName = "SFToontimeBlotch"
        
        addChild(scoreLeft!)
        
        scoreRight = SKLabelNode(text: "0")
        scoreRight?.position = CGPoint(x: 200 ,y: -15)
        scoreRight?.fontSize = 40
        scoreRight?.zPosition = 1
        scoreRight?.fontColor = .black
        scoreRight?.fontName = "SFToontimeBlotch"
        
        addChild(scoreRight!)
    }
    //    var tapGestureRecognizer:UITapGestureRecognizer!
    //    var panGestureRecognizer:UIPanGestureRecognizer!
    //    func registMovableAction(){
    //        self.tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(tapGestureRecognizer:)))
    //        self.panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePan(panGestureRecognizer:)))
    //        self.view!.addGestureRecognizer(tapGestureRecognizer)
    //        self.view!.addGestureRecognizer(panGestureRecognizer)
    //    }
    //
    //    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    //        if  self.panGestureRecognizer.state != .began ||
    //                self.panGestureRecognizer.state != .changed ||
    //                self.panGestureRecognizer.state != .ended {
    //            NSLog("\(#function)")
    //        }
    //    }
    
    @objc func handleTap(tapGestureRecognizer recognizer:UITapGestureRecognizer)
    {
        if recognizer.state == .ended {
            let touchLocationView = recognizer.location(in: recognizer.view)
            let touchLocationScene = self.convertPoint(fromView: touchLocationView)
            _ = self.touchedNode(touchLocationScene)
        }
    }
    
    func moveCardEnemy(){
        for i in 0 ..< 5 {
            DispatchQueue.main.asyncAfter(deadline: .now() + (0.5 * Double(i)) ){
                switch i {
                case 0:
                    self.moveCard(fromNode: self.cardE1!, toNode: self.placeholderE1!)
                    DispatchQueue.main.asyncAfter(deadline: .now() + (0.6) ){
                        self.cardE1?.position = self.placeholder1!.position
                    }
                case 1:
                    self.moveCard(fromNode: self.cardE2!, toNode: self.placeholderE2!)
                    DispatchQueue.main.asyncAfter(deadline: .now() + (0.6) ){
                        self.cardE2?.position = self.placeholder2!.position
                    }
                case 2:
                    self.moveCard(fromNode: self.cardE3!, toNode: self.placeholderE3!)
                    DispatchQueue.main.asyncAfter(deadline: .now() + (0.6) ){
                        self.cardE3?.position = self.placeholder3!.position
                    }
                case 3:
                    self.moveCard(fromNode: self.cardE4!, toNode: self.placeholderE4!)
                    DispatchQueue.main.asyncAfter(deadline: .now() + (0.6) ){
                        self.cardE4?.position = self.placeholder4!.position
                    }
                case 4:
                    self.moveCard(fromNode: self.cardE5!, toNode: self.placeholderE5!)
                    DispatchQueue.main.asyncAfter(deadline: .now() + (0.6) ){
                        self.cardE5?.position = self.placeholder5!.position
                    }
                default: break
                }
            }
        }
    }
    
    
    func moveCardEnemyRandomly(){
        let array = [placeholderE1, placeholderE2, placeholderE3, placeholderE4, placeholderE5]
        let cardList = ["paper_fcard","scissors_fcard","rock_fcard","spock_fcard","lizards_fcard"]
        enemyList = cardList
        cardEnemy = cardEnemyBase
        random.shuffle()
        print("random: \(random)")
        for i in 0 ..< random.count {
            DispatchQueue.main.asyncAfter(deadline: .now() + (0.5 * Double(i)) ){
                
                print("position: \(self.random[i])")
                
                switch i {
                case 0:
                    self.moveCard(fromNode: self.cardE1!, toNode: array[self.random[i]]!)
                    DispatchQueue.main.asyncAfter(deadline: .now() + (0.6) ){
                        self.cardE1?.position = array[self.random[i]]!.position
                    }
                    
                case 1:
                    self.moveCard(fromNode: self.cardE2!, toNode: array[self.random[i]]!)
                    DispatchQueue.main.asyncAfter(deadline: .now() + (0.6) ){
                        self.cardE2?.position = array[self.random[i]]!.position
                    }
                case 2:
                    self.moveCard(fromNode: self.cardE3!, toNode: array[self.random[i]]!)
                    DispatchQueue.main.asyncAfter(deadline: .now() + (0.6) ){
                        self.cardE3?.position = array[self.random[i]]!.position
                    }
                case 3:
                    self.moveCard(fromNode: self.cardE4!, toNode: array[self.random[i]]!)
                    DispatchQueue.main.asyncAfter(deadline: .now() + (0.6) ){
                        self.cardE4?.position = array[self.random[i]]!.position
                    }
                case 4:
                    self.moveCard(fromNode: self.cardE5!, toNode: array[self.random[i]]!)
                    DispatchQueue.main.asyncAfter(deadline: .now() + (0.6) ){
                        self.cardE5?.position = array[self.random[i]]!.position
                    }
                    
                    for i in 0 ..< self.random.count {
                        self.cardEnemy[self.random[i]] = (self.cardEnemyBase[i])
                        self.enemyList[self.random[i]] = cardList[i]
        
                    }
                    
                    self.isFighting = false
                    print("EnemyList: \(self.enemyList)")
                    print("EnemyList: \(self.cardEnemy)")
                    
                default: break
                }
            }
        }
        
    }
    
    func moveCardEnemyBase(){
        
        for i in 0 ..< 5 {
            DispatchQueue.main.asyncAfter(deadline: .now() + (0.5 * Double(i)) ){
                switch i {
                case 0:
                    self.moveCard(fromNode: self.cardE1!, toPos: self.cardE1OldPos)
                    DispatchQueue.main.asyncAfter(deadline: .now() + (0.6) ){
                        self.cardE1?.position = self.cardE1OldPos
                    }
                case 1:
                    self.moveCard(fromNode: self.cardE2!, toPos: self.cardE2OldPos)
                    DispatchQueue.main.asyncAfter(deadline: .now() + (0.6) ){
                        self.cardE2?.position = self.cardE2OldPos
                    }
                case 2:
                    self.moveCard(fromNode: self.cardE3!, toPos: self.cardE3OldPos)
                    DispatchQueue.main.asyncAfter(deadline: .now() + (0.6) ){
                        self.cardE3?.position = self.cardE3OldPos
                    }
                case 3:
                    self.moveCard(fromNode: self.cardE4!, toPos: self.cardE4OldPos)
                    DispatchQueue.main.asyncAfter(deadline: .now() + (0.6) ){
                        self.cardE4?.position = self.cardE4OldPos
                    }
                case 4:
                    self.moveCard(fromNode: self.cardE5!, toPos: self.cardE5OldPos)
                    DispatchQueue.main.asyncAfter(deadline: .now() + (0.6) ){
                        self.cardE5?.position = self.cardE5OldPos
                    }
                default: break
                }
            }
        }
    }
    
    
    func moveCardPlayerBase(){
        for i in 0 ..< 5 {
            DispatchQueue.main.asyncAfter(deadline: .now() + (0.5 * Double(i)) ){
                switch i {
                case 0:
                    self.moveCard(fromNode: self.card1!, toPos: self.card1OldPos)
                    DispatchQueue.main.asyncAfter(deadline: .now() + (0.6) ){
                        self.card1?.position = self.card1OldPos
                    }
                case 1:
                    self.moveCard(fromNode: self.card2!, toPos: self.card2OldPos)
                    DispatchQueue.main.asyncAfter(deadline: .now() + (0.6) ){
                        self.card2?.position = self.card2OldPos
                    }
                case 2:
                    self.moveCard(fromNode: self.card3!, toPos: self.card3OldPos)
                    DispatchQueue.main.asyncAfter(deadline: .now() + (0.6) ){
                        self.card3?.position = self.card3OldPos
                    }
                case 3:
                    self.moveCard(fromNode: self.card4!, toPos: self.card4OldPos)
                    DispatchQueue.main.asyncAfter(deadline: .now() + (0.6) ){
                        self.card4?.position = self.card4OldPos
                    }
                case 4:
                    self.moveCard(fromNode: self.card5!, toPos: self.card5OldPos)
                    DispatchQueue.main.asyncAfter(deadline: .now() + (0.6) ){
                        self.card5?.position = self.card5OldPos
                    }
                default: break
                }
            }
        }
    }
    
    
    func moveCardPlayer(){
        for i in 0 ..< 5 {
            DispatchQueue.main.asyncAfter(deadline: .now() + (0.5 * Double(i)) ){
                switch i {
                case 0:
                    self.moveCard(fromNode: self.card1!, toNode: self.placeholder1!)
                case 1:
                    self.moveCard(fromNode: self.card2!, toNode: self.placeholder2!)
                case 2:
                    self.moveCard(fromNode: self.card3!, toNode: self.placeholder3!)
                case 3:
                    self.moveCard(fromNode: self.card4!, toNode: self.placeholder4!)
                case 4:
                    self.moveCard(fromNode: self.card5!, toNode: self.placeholder5!)
                default: break
                }
            }
        }
    }
    
    func moveCard(fromNode: SKNode, toNode: SKNode){
        if fromNode.hasActions() { fromNode.removeAllActions() }
        let newX: CGFloat = toNode.position.x
        let newY: CGFloat = toNode.position.y
        let oldX: CGFloat = fromNode.position.x
        let oldY: CGFloat = fromNode.position.y
        fromNode.run(.moveBy(x: newX - oldX, y:  newY - oldY , duration: 0.5))
    }
    
    func moveCard(fromNode: SKNode, toPos: CGPoint){
        if fromNode.hasActions() { fromNode.removeAllActions() }
        let newX: CGFloat = toPos.x
        let newY: CGFloat = toPos.y
        let oldX: CGFloat = fromNode.position.x
        let oldY: CGFloat = fromNode.position.y
        fromNode.run(.moveBy(x: newX - oldX, y:  newY - oldY , duration: 0.5))
    }
    
    
    func createPlaceholder(_ name: String = "") -> SKSpriteNode {
        //        let placeholder = SKImageAltNode( normalTexture: SKTexture(imageNamed: "placeholder_card"))
        //
        //        placeholder.zPosition = -1
        //        placeholder.size.width = 100
        //        placeholder.size.height = 140
        //        let card = SKImageAltNode( normalTexture: SKTexture(imageNamed: cardName), nodeName,size)
        
        let size = CGSize(width: 100, height: 140)
        let placeholder = SKSpriteNode(texture: SKTexture(imageNamed: "placeholder_card"), color: UIColor.clear, size: size )
        if(!name.isEmpty){
            placeholder.name = name
        }
        placeholder.zPosition = -1
        
        
        return placeholder
    }
    
    func definePlaceholder(){
        placeholder1 = createPlaceholder("placeholder1")
        placeholder2 = createPlaceholder("placeholder2")
        placeholder3 = createPlaceholder("placeholder3")
        placeholder4 = createPlaceholder("placeholder4")
        placeholder5 = createPlaceholder("placeholder5")
        
        
        placeholder1?.position = CGPoint(x: -220, y: -150)
        placeholder2?.position = CGPoint(x: -110, y: -150)
        placeholder3?.position = CGPoint(x: 0, y: -150)
        placeholder4?.position = CGPoint(x: 110, y: -150)
        placeholder5?.position = CGPoint(x: 220, y: -150)
        
        addChild(placeholder1!)
        addChild(placeholder2!)
        addChild(placeholder3!)
        addChild(placeholder4!)
        addChild(placeholder5!)
        
        placeholderE1 = createPlaceholder("placeholderE1")
        placeholderE2 = createPlaceholder("placeholderE2")
        placeholderE3 = createPlaceholder("placeholderE3")
        placeholderE4 = createPlaceholder("placeholderE4")
        placeholderE5 = createPlaceholder("placeholderE5")
        
        placeholderE1?.position = CGPoint(x: -220, y: 150)
        placeholderE2?.position = CGPoint(x: -110, y: 150)
        placeholderE3?.position = CGPoint(x: 0, y: 150)
        placeholderE4?.position = CGPoint(x: 110, y: 150)
        placeholderE5?.position = CGPoint(x: 220, y: 150)
        
        addChild(placeholderE1!)
        addChild(placeholderE2!)
        addChild(placeholderE3!)
        addChild(placeholderE4!)
        addChild(placeholderE5!)
        
    }
    
    func createLife() -> SKImageAltNode {
        let life = SKImageAltNode( normalTexture: SKTexture(imageNamed: "life_outline"))
        life.zPosition = 0
        life.isUserInteractionEnabled = false
        
        life.size.width = 30
        life.size.height = 30
        
        return life
    }
    
    func defineEnemyLife(){
        lifeE1 = createLife()
        lifeE2 = createLife()
        
        lifeE1?.position = CGPoint(x: 215, y: 425)
        lifeE2?.position = CGPoint(x: 260, y: 425)
        
        addChild(lifeE1!)
        addChild(lifeE2!)
    }
    
    func definePlayerLife(){
        
        lifeP1 = createLife()
        lifeP2 = createLife()
        
        lifeP1?.position = CGPoint(x: -260, y: 425)
        lifeP2?.position = CGPoint(x: -215, y: 425)
        
        addChild(lifeP1!)
        addChild(lifeP2!)
    }
    
    
    func createCard(_ cardName: String = "cover_image", _ nodeName: String = "") -> SKImageNode {
        let size = CGSize(width: 100, height: 140)
        
        let card = SKImageNode( normalTexture: SKTexture(imageNamed: cardName), name: nodeName, size)
        //        let card = SKSpriteNode(texture: SKTexture(imageNamed: cardName), color: UIColor.clear, size: size )
                card.name = nodeName
        card.zPosition = 1
        
        return card
    }
    
    func definePlayerCard(){
        
        card1 = createCard("paper_fcard", kMovableNode + "card1")
        card2 = createCard("scissors_fcard", kMovableNode + "card2")
        card3 = createCard("rock_fcard", kMovableNode + "card3")
        card4 = createCard("spock_fcard", kMovableNode + "card4")
        card5 = createCard("lizards_fcard", kMovableNode + "card5")
        
        
        card1OldPos = CGPoint(x: -230, y: -325)
        card1?.position = card1OldPos
        
        card2OldPos = CGPoint(x: -115, y: -325)
        card2?.position = card2OldPos
        
        card3OldPos = CGPoint(x: 0, y: -325)
        card3?.position = card3OldPos
        
        card4OldPos = CGPoint(x: 115, y: -325)
        card4?.position = card4OldPos
        
        card5OldPos = CGPoint(x: 230, y: -325)
        card5?.position = card5OldPos
        
        card1?.setImageAction(target: self, triggerEvent: .TouchUpInside, action: #selector(executeOnTouchCard1))
        card2?.setImageAction(target: self, triggerEvent: .TouchUpInside, action: #selector(executeOnTouchCard2))
        card3?.setImageAction(target: self, triggerEvent: .TouchUpInside, action: #selector(executeOnTouchCard3))
        card4?.setImageAction(target: self, triggerEvent: .TouchUpInside, action: #selector(executeOnTouchCard4))
        card5?.setImageAction(target: self, triggerEvent: .TouchUpInside, action: #selector(executeOnTouchCard5))
        
        addChild(card1!)
        addChild(card2!)
        addChild(card3!)
        addChild(card4!)
        addChild(card5!)
        
    }
    
    func handlePlayerCard(node: SKNode){
        
        switch node {
        case card1:
            var isMoved = false
            if(card1!.position != card1OldPos){
                isMoved = true
            }
            putCardonPlaceHolder(node: card1!, isMoved: isMoved, imageNamed:  "paper_fcard" )
            
            break
        case card2:
            var isMoved = false
            if(card2!.position != card2OldPos){
                isMoved = true
            }
            putCardonPlaceHolder(node: card2!, isMoved: isMoved,imageNamed:  "scissors_fcard" )
            
            break
        case card3:
            var isMoved = false
            if(card3!.position != card3OldPos){
                isMoved = true
            }
            putCardonPlaceHolder(node: card3!, isMoved: isMoved, imageNamed:  "rock_fcard" )
            
            break
        case card4:
            var isMoved = false
            if(card4!.position != card4OldPos){
                isMoved = true
            }
            putCardonPlaceHolder(node: card4!, isMoved: isMoved, imageNamed:  "spock_fcard" )
            
            break
        case card5:
            var isMoved = false
            if(card5!.position != card5OldPos){
                isMoved = true
            }
            putCardonPlaceHolder(node: card5!, isMoved: isMoved, imageNamed: "lizards_fcard")
            break
        default:
            print("default")
            break
        }
        
    }
    
    var isGettingMoved = false
    func putCardonPlaceHolder(node: SKImageNode,isMoved: Bool, imageNamed: String){
        if(isGettingMoved){
            return
        }
        isPos1Available = true
        isPos2Available = true
        isPos3Available = true
        isPos4Available = true
        isPos5Available = true
        
        let cardList = [card1!, card2!, card3!, card4!, card5!]
        let posList = [placeholder1?.position, placeholder2?.position, placeholder3?.position, placeholder4?.position, placeholder5?.position]
        for i in 0..<posList.count{
            
            if(
                i == 0 && (
                    posList[i] == card1!.position ||
                    posList[i] == card2!.position ||
                    posList[i] == card3!.position ||
                    posList[i] == card4!.position ||
                    posList[i] == card5!.position
                )
            ){
                isPos1Available = false
                
            } else  if(
                i == 1 && (
                    posList[i] == card1!.position ||
                    posList[i] == card2!.position ||
                    posList[i] == card3!.position ||
                    posList[i] == card4!.position ||
                    posList[i] == card5!.position
                )
            ){
                isPos2Available = false
                
            } else if(
                i == 2 && (
                    posList[i] == card1!.position ||
                    posList[i] == card2!.position ||
                    posList[i] == card3!.position ||
                    posList[i] == card4!.position ||
                    posList[i] == card5!.position
                )
            ){
                isPos3Available = false
                
            } else if(
                i == 3 && (
                    posList[i] == card1!.position ||
                    posList[i] == card2!.position ||
                    posList[i] == card3!.position ||
                    posList[i] == card4!.position ||
                    posList[i] == card5!.position
                )
            ){
                isPos4Available = false
                
            } else if(
                i == 4 && (
                    posList[i] == card1!.position ||
                    posList[i] == card2!.position ||
                    posList[i] == card3!.position ||
                    posList[i] == card4!.position ||
                    posList[i] == card5!.position
                )
            ){
                isPos5Available = false
            }
            
        }
        
        if(isMoved){
            if(node == card1){
                moveCard(fromNode: card1!, toPos: card1OldPos)
                DispatchQueue.main.asyncAfter(deadline: .now() + (0.6) ){
                    self.card1?.position = self.card1OldPos
                }
            }else if(node == card2){
                moveCard(fromNode: card2!, toPos: card2OldPos)
                DispatchQueue.main.asyncAfter(deadline: .now() + (0.6) ){
                    self.card2?.position = self.card2OldPos
                }
            }else if(node == card3){
                moveCard(fromNode: card3!, toPos: card3OldPos)
                DispatchQueue.main.asyncAfter(deadline: .now() + (0.6) ){
                    self.card3?.position = self.card3OldPos
                }
            }else if(node == card4){
                moveCard(fromNode: card4!, toPos: card4OldPos)
                DispatchQueue.main.asyncAfter(deadline: .now() + (0.6) ){
                    self.card4?.position = self.card4OldPos
                }
            }else if(node == card5){
                moveCard(fromNode: card5!, toPos: card5OldPos)
                DispatchQueue.main.asyncAfter(deadline: .now() + (0.6) ){
                    self.card5?.position = self.card5OldPos
                }
            }
        }else{
            if(isPos1Available){
                isGettingMoved = true
                playerList[0] = imageNamed
                moveCard(fromNode: node, toPos: placeholder1!.position)
                DispatchQueue.main.asyncAfter(deadline: .now() + (0.6) ){
                    node.position = self.placeholder1!.position
                    self.isGettingMoved = false
                }
            }else if(isPos2Available){
                isGettingMoved = true
                playerList[1] = imageNamed
                moveCard(fromNode: node, toPos: placeholder2!.position)
                DispatchQueue.main.asyncAfter(deadline: .now() + (0.6) ){
                    node.position = self.placeholder2!.position
                    self.isGettingMoved = false
                }
            }else if(isPos3Available){
                isGettingMoved = true
                playerList[2] =  imageNamed
                moveCard(fromNode: node, toPos: placeholder3!.position)
                DispatchQueue.main.asyncAfter(deadline: .now() + (0.6) ){
                    node.position = self.placeholder3!.position
                    self.isGettingMoved = false
                }
            }else if(isPos4Available){
                isGettingMoved = true
                playerList[3] = imageNamed
                moveCard(fromNode: node, toPos: placeholder4!.position)
                DispatchQueue.main.asyncAfter(deadline: .now() + (0.6) ){
                    node.position = self.placeholder4!.position
                    self.isGettingMoved = false
                }
            }else if(isPos5Available){
                isGettingMoved = true
                playerList[4] = imageNamed
                moveCard(fromNode: node, toPos: placeholder5!.position)
                DispatchQueue.main.asyncAfter(deadline: .now() + (0.6) ){
                    node.position = self.placeholder5!.position
                    self.isGettingMoved = false
                }
            }
        }
        
        
    }
    
    @objc func executeOnTouchCard1(){
        touchDown(atPoint: card1!.position)
        if(isFighting){
            return
        }
        handlePlayerCard(node: card1!)
    }
    @objc func executeOnTouchCard2(){
        touchDown(atPoint: card2!.position)
        if(isFighting){
            return
        }
        handlePlayerCard(node: card2!)
        
    }
    
    @objc func executeOnTouchCard3(){
        touchDown(atPoint: card3!.position)
        if(isFighting){
            return
        }
        handlePlayerCard(node: card3!)
        
    }
    
    @objc func executeOnTouchCard4(){
        touchDown(atPoint: card4!.position)
        if(isFighting){
            return
        }
        handlePlayerCard(node: card4!)
        
    }
    
    @objc func executeOnTouchCard5(){
        touchDown(atPoint: card5!.position)
        if(isFighting){
            return
        }
        handlePlayerCard(node: card5!)
        
    }
    
    func defineEnemyCard(){
        cardE1 = createCard("paper_fcard", "cardE1")
        cardE2 = createCard("scissors_fcard", "cardE2")
        cardE3 = createCard("rock_fcard", "cardE3")
        cardE4 = createCard("spock_fcard", "cardE4")
        cardE5 = createCard("lizards_fcard", "cardE5")
        
        cardE1OldPos = CGPoint(x: -230, y: 325)
        cardE1?.position = cardE1OldPos
        
        cardE2OldPos = CGPoint(x: -115, y: 325)
        cardE2?.position = cardE2OldPos
        
        cardE3OldPos = CGPoint(x: 0, y: 325)
        cardE3?.position = cardE3OldPos
        
        cardE4OldPos = CGPoint(x: 115, y: 325)
        cardE4?.position = cardE4OldPos
        
        cardE5OldPos = CGPoint(x: 230, y: 325)
        cardE5?.position = cardE5OldPos
        
        addChild(cardE1!)
        addChild(cardE2!)
        addChild(cardE3!)
        addChild(cardE4!)
        addChild(cardE5!)
        
        cardEnemy = [cardE1!,cardE2!,cardE3!,cardE4!,cardE5!]
        cardEnemyBase = [cardE1!,cardE2!,cardE3!,cardE4!,cardE5!]
        prepareEnemy()
    }
    
    var enemyList: [String] = ["paper_fcard","scissors_fcard","rock_fcard","spock_fcard","lizards_fcard"]
    func randomList()-> [String]{
        var strings = ["paper_fcard","scissors_fcard","rock_fcard","spock_fcard","lizards_fcard"]
        strings.shuffle()
        return strings
    }
    
    func flipTile(node : SKSpriteNode, image: String){
        let flip = SKAction.scaleX(to: -1, duration: 0.5)
        let flipImage = SKAction.scaleX(to: 1, duration: 0)
        
        node.setScale(1.0)
        
        let changeColor = SKAction.run( { node.texture = SKTexture(imageNamed: image)})
        let action = SKAction.sequence([flip, changeColor, flipImage] )
        
        
        node.run(action)
        
    }
    
    func resetCard(node : SKSpriteNode){
        
        let flip = SKAction.scaleX(to: -1, duration: 0.5)
        let flipImage = SKAction.scaleX(to: 1, duration: 0)
        
        node.setScale(1.0)
        
        let changeColor = SKAction.run( { node.texture = SKTexture(imageNamed: "cover_image")})
        let action = SKAction.sequence([flip, changeColor, flipImage] )
        
        node.run(action)
        
    }
    
    func resetGame(){
        
        isPos1Available = true
        isPos2Available = true
        isPos3Available = true
        isPos4Available = true
        isPos5Available = true
        playerList = ["","","","",""]
        if(winState != "NOT"){
            return
        }
        //        resetCard(node: card1!)
        //        resetCard(node: card2!)
        //        resetCard(node: card3!)
        //        resetCard(node: card4!)
        //        resetCard(node: card5!)
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + (1)){
            self.moveCardEnemyBase()
            self.moveCardPlayerBase()
            self.label?.text = "Preparation Time"
            self.label?.fontSize = CGFloat(self.curSize)
            
            self.scoreLeftCount = 0
            self.scoreRightCount = 0
            
            self.scoreLeft?.text = String(self.scoreLeftCount)
            self.scoreRight?.text = String(self.scoreRightCount)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + (3)){
                self.prepareEnemy()
            }
        }
        
        
    }
    
    func prepareEnemy(){
        cardEnemy = [cardE1!, cardE2! ,cardE3! , cardE4! ,cardE5!]
        DispatchQueue.main.asyncAfter(deadline: .now() + (1)){
            for i in 0 ..< 5 {
                DispatchQueue.main.asyncAfter(deadline: .now() + (0.6 * Double(i)) ){

                    self.flipTile(node: self.cardEnemy[i], image: "cover_image")
                }
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + (4)){
            //            for i in 0 ..< 5 {
            //                DispatchQueue.main.asyncAfter(deadline: .now() + (0.6 * Double(i)) ){
            //
            //                    self.flipTile(node: self.cardEnemy[i], image: self.enemyList[i])
            //
            //                }
            //            }
            
            //            print("check \(self.enemyList)")
            //            print("check \(self.cardEnemy)")
            self.moveCardEnemyRandomly()
        }
    }
    
    @objc func goFight() {

        if(isFighting){
            return
        }
        if (playerList.contains("")){
            print("please return")
            return
        }
        isFighting = true
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + (1) ){
            self.label?.text = "Fight"
            
            for i in 0 ..< 5 {
                DispatchQueue.main.asyncAfter(deadline: .now() + (0.6 * Double(i)) ){
                    print("cardEnemy: \(self.cardEnemy[i].name) , \(self.enemyList[i])")
                    self.flipTile(node: self.cardEnemy[i], image: self.enemyList[i])
                    self.fightThis(string: self.playerList[i], string2: self.enemyList[i])
                }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.calculateTotalMatch()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.75) {
                    self.resetGame()
                }
            }
        }
        
    }
    
    
    @objc func fightThis(string: String, string2: String) {
        if(string == "scissors_fcard" && (string2 == "paper_fcard" || string2 == "lizards_fcard")){
            scoreLeftCount += 1
        } else if(string == "paper_fcard" && (string2 == "rock_fcard" || string2 == "spock_fcard")){
            scoreLeftCount += 1
        } else if(string == "rock_fcard" && (string2 == "scissors_fcard" || string2 == "lizards_fcard")){
            scoreLeftCount += 1
        } else if(string == "spock_fcard" && (string2 == "rock_fcard" || string2 == "scissors_fcard")){
            scoreLeftCount += 1
        } else if(string == "lizards_fcard" && (string2 == "spock_fcard" || string2 == "paper_fcard")){
            scoreLeftCount += 1
        }
        
        if(string2 == "scissors_fcard" && (string == "paper_fcard" || string == "lizards_fcard")){
            scoreRightCount += 1
        } else if(string2 == "paper_fcard" && (string == "rock_fcard" || string == "spock_fcard")){
            scoreRightCount += 1
        } else if(string2 == "rock_fcard" && (string == "scissors_fcard" || string == "lizards_fcard")){
            scoreRightCount += 1
        } else if(string2 == "spock_fcard" && (string == "rock_fcard" || string == "scissors_fcard")){
            scoreRightCount += 1
        } else if(string2 == "lizards_fcard" && (string == "spock_fcard" || string == "paper_fcard")){
            scoreRightCount += 1
        }
        
        
        scoreLeft?.text = String(scoreLeftCount)
        scoreRight?.text = String(scoreRightCount)
        
    }
    
    func calculateTotalMatch(){
        if(scoreLeftCount > scoreRightCount){
            winPlayer += 1
        } else  if(scoreLeftCount < scoreRightCount){
            winEnemy += 1
        }
        
        if(winPlayer == 1){
            self.label?.text = "You Won this Round"
            self.label?.fontSize -= 8
            changeToWinLight(node: lifeP1!)
        } else if(winPlayer == 2){
            self.label?.text = "You Won"
            winState = "WIN"
            changeToWinLight(node: lifeP2!)
            //showDialogWin
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                
                self.resultGameView = self.resultView()
                self.addChild(self.resultGameView!)
            }
        }
        
        if(winEnemy == 1){
            self.label?.text = "You Lose this Round"
            self.label?.fontSize -= 8
            changeToWinLight(node: lifeE2!)
        } else if(winEnemy == 2){
            self.label?.text = "You Lose"
            self.label?.fontSize -= 8
            changeToWinLight(node: lifeE1!)
            //showDialogLose
            winState = "LOSE"
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.resultGameView = self.resultView()
                self.addChild(self.resultGameView!
                )
            }
        }
    }
    
    func changeToWinLight(node: SKSpriteNode){
        
        let changeColor = SKAction.run( { node.texture = SKTexture(imageNamed: "life_full")})
        let action = SKAction.sequence([changeColor] )
        
        
        node.run(action)
    }
    
    @objc func openHelp() {
        if(winState != "NOT"){
            return
        }
        if(!isAdded){
            isAdded = true
            //view help
            blockView = addView()
            addChild(blockView!)
        }
    }
    
    
    @objc func openResult() {
        
        if(!isAdded){
            isAdded = true
            //view help
            resultGameView = resultView()
            addChild(resultGameView!)
        }
    }
    
    
    func addView() -> SKShapeNode{
        let blockView = SKShapeNode(rectOf: CGSize(width: 600 - 32, height: 1250 - 32),cornerRadius: 16)
        blockView.fillColor = SKColor.darkGray
        blockView.position = CGPoint(x: 0, y: 0)
        blockView.zPosition = 2
        
        let closeImage = SKImageNode( normalTexture: SKTexture(imageNamed: "ic_close"))
        blockView.addChild(closeImage)
        closeImage.size.width = 44
        closeImage.size.height = 44
        closeImage.zPosition = 3
        
        closeImage.position = CGPoint(x: (blockView.frame.width / 2) - 32, y: (blockView.frame.height / 2 ) - 32)
        closeImage.setImageAction(target: self, triggerEvent: .TouchUp, action:#selector(closeBlockView))
        
        let textImage = SKImageAltNode( normalTexture: SKTexture(imageNamed: "help_text1"))
        textImage.size.width = blockView.frame.width
        textImage.size.height = blockView.frame.height
        textImage.zPosition = 2
        
        textImage.position = CGPoint(x: blockView.frame.midX , y: blockView.frame.midY )
        blockView.addChild(textImage)
        
        
        return blockView
    }
    
    
    
    func resultView() -> SKShapeNode{
        
        resultGameView = SKShapeNode(rectOf: CGSize(width: 600 - 32, height: 600 - 32),cornerRadius: 16)
        resultGameView?.fillColor = SKColor.darkGray
        resultGameView?.position = CGPoint(x: 0, y: 0)
        resultGameView?.zPosition = 2
        
        let sampleLabel = SKLabelNode(text: "0")
        sampleLabel.numberOfLines = 2
        
        sampleLabel.position = CGPoint(x: 0 ,y: 175)
        sampleLabel.fontSize = 40
        sampleLabel.zPosition = 1
        sampleLabel.fontColor = .black
        sampleLabel.fontName = "SFToontimeBlotch"
        resultGameView?.addChild(sampleLabel)
        
        let buttonTexture = SKTexture(imageNamed: "button1")
        let buttonPressedTexture = SKTexture(imageNamed: "button1_selected")
        playButton = SKButtonNode(normalTexture:buttonTexture, selectedTexture:buttonPressedTexture, disabledTexture:buttonPressedTexture)
        playButton?.setButtonLabel(title: "Play Again!",font:  "SFToontimeBlotch" ,fontSize: 36)
        playButton?.zPosition = 3
        playButton?.size.width = 275
        playButton?.size.height += 24
        playButton?.position = CGPoint(x: 0 ,y: -50)
        
        let buttonTexture2 = SKTexture(imageNamed: "button1")
        let buttonPressedTexture2 = SKTexture(imageNamed: "button1_selected")
        backToHomeButton = SKButtonNode(normalTexture:buttonTexture2, selectedTexture:buttonPressedTexture2, disabledTexture:buttonPressedTexture2)
        backToHomeButton?.setButtonLabel(title: "Back to Home",font:  "SFToontimeBlotch" ,fontSize: 36)
        backToHomeButton?.zPosition = 3
        backToHomeButton?.size.width = 275
        backToHomeButton?.size.height += 24
        backToHomeButton?.position = CGPoint(x: 0 ,y: -150)
        
        playButton?.setButtonAction(target: self, triggerEvent: .TouchUp, action:#selector(playAgain))
        backToHomeButton?.setButtonAction(target: self, triggerEvent: .TouchUp, action:#selector(backToHome))
        playButton?.setButtonAction(target: self, triggerEvent: .TouchUp, action:#selector(playAgain))
        backToHomeButton?.setButtonAction(target: self, triggerEvent: .TouchUp, action:#selector(backToHome))
        resultGameView?.addChild(backToHomeButton!)
        resultGameView?.addChild(playButton!)
        var image = "win_image"
        
        var text = "YOU WIN! \nAll hail to The king"
        if(winState == "LOSE"){
            image = "lose_image"
            text = "YOU LOSE! \nBetter luck next time"
        }
        let attrString = NSMutableAttributedString(string: text)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let range = NSRange(location: 0, length: text.count)
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: range)
        attrString.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.black, NSAttributedString.Key.font : UIFont.init(name: "SFToontimeBlotch", size: 36)!], range: range)
        sampleLabel.attributedText = attrString
        
        let textImage = SKImageAltNode( normalTexture: SKTexture(imageNamed: image))
        textImage.size.width = 150
        textImage.size.height = 150
        textImage.zPosition = 3
        
        textImage.position = CGPoint(x: (resultGameView?.frame.midX ?? 0), y: (resultGameView?.frame.midY ?? 0) + 100 )
        resultGameView?.addChild(textImage)
        
        return resultGameView!
    }
    
    
    @objc func closeBlockView() {
        isAdded = false
        removeChildren(in: [blockView!])
    }
    
    @objc func playAgain() {
        removeChildren(in: [resultGameView!])
        //reset game
        gameDelegate?.updateScene(sceneName: "GameScene")
    }
    
    @objc func backToHome() {
        gameDelegate?.updateScene(sceneName: "WelcomeScene")
        
    }
    
    @objc func handlePan(panGestureRecognizer recognizer:UIPanGestureRecognizer) {
        
        let touchLocationView = recognizer.location(in: recognizer.view)
        let touchLocationScene = self.convertPoint(fromView: touchLocationView)
        
        switch recognizer.state {
        case .began:
            let canditateNode = self.touchedNode(touchLocationScene)
            if let name = canditateNode.name, name.contains(kMovableNode) {
                self.selectedNode = canditateNode
            }
            
        case .changed:
            let translation = recognizer.translation(in: recognizer.view)
            if let position = self.selectedNode?.position {
                self.selectedNode?.position = CGPoint(x: position.x + translation.x, y: position.y - translation.y)
                recognizer.setTranslation(CGPoint.zero, in: recognizer.view)
            }
            
        case .ended:
            self.selectedNode?.physicsBody?.isDynamic = true;
            let velocity = recognizer.velocity(in: recognizer.view)
            self.selectedNode?.physicsBody?.applyImpulse(CGVector(dx: velocity.x, dy: -velocity.y))
            //            print("\(selectedNode?.position.x), \(selectedNode?.position.x)")
            self.selectedNode = nil
            
        default:
            break
        }
    }
    
    //    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    //        if let touch = touches.first {
    //            let touchLocationScene = touch.location(in: self)
    //            let canditateNode = self.touchedNode(touchLocationScene)
    //            if let name = canditateNode.name, name.contains(kMovableNode) {
    //                self.selectedNode = canditateNode
    //                self.selectedNode?.physicsBody?.isDynamic = false
    //            }
    //
    //            if let name2 = canditateNode.name, name2.contains("btShowDown") {
    //                goFight()
    //            }
    //        }
    //    }
    //
    func touchedNode(_ touchLocationInScene:CGPoint) -> SKNode {
        let node = self.atPoint(touchLocationInScene)

        if (node.name == "btShowDown" ){
            goFight()
        }
        return node
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
