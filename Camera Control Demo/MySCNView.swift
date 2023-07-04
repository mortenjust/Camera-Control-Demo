//
//  MySCNView.swift
//  Camera Control Demo
//
//  Created by Morten Just on 7/4/23.
//

import Foundation
import SceneKit

class MySCNView: SCNView {
    let cameraController = CameraController()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        cameraController.inertiaEnabled = true
        cameraController.inertiaFriction = 0.1
        cameraController.interactionMode = .orbitAngleMapping
        
        let drag = NSPanGestureRecognizer(target: self, action: #selector(self.handleDrag(_:)))
        self.addGestureRecognizer(drag)
        
        let magnify = NSMagnificationGestureRecognizer(target: self, action: #selector(self.handleMag(_:)))
        addGestureRecognizer(magnify)
    }
    
    // (not shown: handle rotation, 2d scroll)
    
    @objc func handleMag(_ mag: NSMagnificationGestureRecognizer) {
        let viewport = bounds.size
        let location = mag.location(in: self)
        
        switch mag.state {
        case .began:
            print("mag began") // confirmed in console, but interactions do nothing
            cameraController.beginInteraction(location, withViewport: viewport)
        case .changed:
            cameraController.continueInteraction(location, withViewport: viewport, sensitivity: 1)
        case .ended:
            cameraController.endInteraction(location, withViewport: bounds.size, velocity: .zero)
        default:
            break
        }
    }
    
    
    // Rotation. These work.
    @objc func handleDrag(_ drag: NSPanGestureRecognizer) {
        let viewport = bounds.size
        let location = drag.location(in: self)
        
        switch drag.state {
        case .began:
            cameraController.beginInteraction(location, withViewport: viewport)
        case .changed:
            cameraController.continueInteraction(location, withViewport: viewport, sensitivity: 1)
        case .ended:
            cameraController.endInteraction(location, withViewport: viewport, velocity: drag.velocity(in: self))
        default:
            break
        }
    }
    
    
    
    // alternative way that also works, but not inertia
    
//    override func mouseDown(with event: NSEvent) {
//        let location = event.locationInWindow
//        cameraController.beginInteraction(location, withViewport: bounds.size)
//    }
//
//    override func mouseDragged(with event: NSEvent) {
//        let location = event.locationInWindow
//        let sensitivity: CGFloat = 1.0
//        cameraController.continueInteraction(location, withViewport: bounds.size, sensitivity: sensitivity)
//    }
//
//    override func mouseUp(with event: NSEvent) {
//        let location = event.locationInWindow
////        let velocity = CGPoint(x: event.deltaX, y: event.deltaY)
//
//        cameraController.endInteraction(location, withViewport: bounds.size, velocity: velocity)
//    }
    
    

    
    
}
