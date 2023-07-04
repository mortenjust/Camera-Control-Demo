//
//  ViewController.swift
//  Camera Control Demo
//
//  Created by Morten Just on 7/4/23.
//

import Cocoa
import SceneKit

class ViewController: NSViewController {
    @IBOutlet weak var scnView: MySCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        let scene = SCNScene()
        scnView.scene = scene
        scnView.autoenablesDefaultLighting = true
        
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position.z = 30
        scnView.scene?.rootNode.addChildNode(cameraNode)
        
        scnView.pointOfView = cameraNode
        scnView.cameraController.pointOfView = cameraNode
        scnView.cameraController.inertiaEnabled = true 
        
        let boxNode = SCNNode(geometry: SCNBox(width: 10, height: 10, length: 10, chamferRadius: 1))
        scene.rootNode.addChildNode(boxNode)
        

    }


}


