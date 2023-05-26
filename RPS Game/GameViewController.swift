//
//  GameViewController.swift
//  RPS Game
//
//  Created by Rizki Samudra on 17/05/23.
//

import UIKit
import SpriteKit
import GameplayKit
import GameKit

class GameViewController: UIViewController ,GKGameCenterControllerDelegate, GameDelegate{
    
    @IBOutlet var skView: SKView!
    var gcEnabled = Bool() // Stores if the user has Game Center enabled
    var gcDefaultLeaderBoard = String()
    
    override func viewDidAppear(_ animated: Bool) {
//        authenticateLocalPlayer()
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Load the SKScene from 'GameScene.sks'
//        setGameScene(string: "GameScene")
        setGameScene(string: "WelcomeScene")
        
    }
    
    
    func setGameScene(string: String){
        print("Game Selected :\(string)")
//        let scene = GameScene()
//        scene.scaleMode = .aspectFill

        let scene = SKScene(fileNamed: string) as! BaseScene          // Set the scale mode to scale to fit the window
        scene.scaleMode = .aspectFill
        // Present the scene
        scene.gameDelegate = self
        skView.presentScene(scene)
      
        
        skView.ignoresSiblingOrder = true
        
        skView.showsFPS = true
        skView.showsNodeCount = true
    }
    
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func authenticateLocalPlayer() {
        let localPlayer: GKLocalPlayer = GKLocalPlayer.local
        
        localPlayer.authenticateHandler = {(ViewController, error) -> Void in
            if((ViewController) != nil) {
                // 1 Show login if player is not logged in
                self.present(ViewController!, animated: true, completion: nil)
            } else if (localPlayer.isAuthenticated) {
                // 2 Player is already euthenticated & logged in, load game center
                self.gcEnabled = true
                
                // Get the default leaderboard ID
                localPlayer.loadDefaultLeaderboardIdentifier(completionHandler: { (leaderboardIdentifer: String?, error: NSError?) -> Void in
                    if let error = error {
                        print(error)
                    } else {
                        self.gcDefaultLeaderBoard = leaderboardIdentifer!
                    }
                } as? (String?, Error?) -> Void)
                
                
            } else {
                // 3 Game center is not enabled on the users device
                self.gcEnabled = false
                print("Local player could not be authenticated, disabling game center")
            }
        }
    }
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func showLeaderboard(_ sender: UIButton) {
        if !gcEnabled {
            authenticateLocalPlayer()
        }
        let gcVC: GKGameCenterViewController = GKGameCenterViewController()
        gcVC.gameCenterDelegate = self
        gcVC.viewState = GKGameCenterViewControllerState.leaderboards
        gcVC.leaderboardIdentifier = "LeaderboardID_GAME"
        self.present(gcVC, animated: true, completion: nil)
    }
    
    func updateScene(sceneName: String) {
        setGameScene(string: sceneName)
    }
}
