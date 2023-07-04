//
//  CameraController.swift
//  Camera Control Demo
//
//  Created by Morten Just on 7/4/23.
//

import Foundation
import SceneKit

class CameraController : SCNCameraController {
    override init() {
        super.init()
    }
    
    
    override func rotateBy(x deltaX: Float, y deltaY: Float) {
        super.rotateBy(x: deltaX, y: deltaY)
    }
    
    
    
}
