#  Understanding SCNCameraController

## Background
I want to use SceneKit's camera controller to drive my scene's camera. The reason I want to subclass it is that my camera is on a rig where I apply rotation to the rig and translation to the camera. I do that because I animate the camera, and applying both translation and rotation to the camera node doesn't create the animation I want. 

## Setting up
1. Instantiate my own `SCNCameraController`
2. Set its `pointofView` to my scene's `pointOfView` (or its parent node I guess)

## Using the camera controller
We now want the new camera controller to drive the scene. 

1. When interactions begin (e.g. `mouseDown`), call `beginInteraction(_ location: CGPoint, withViewport viewport: CGSize)`
2. When interactions update and end call the corresponding functions on the camera controller

## Actual behavior
It works when I begin/update/end interactions from mouse down events. 
It ignores any other event types, like magnification, scrollwheel, which work in e.g. the SceneKit Editor in Xcode. See `MySCNView.swift` in the repo for a demo. 
By overriding the camera controller's `rotate` function, I can see that it is called with deltas. This is great.  
But when I override `translateInCameraSpaceBy` my print statements don't appear and the scene doesn't translate.

## Expected behavior
I expected SCNCameraController to also apply translations and rolls to the `pointOfView` by inspecting the `currentEvent` and figuring out what to do. 

I'm inclined to think that I'm supposed to call `translateInCameraSpaceBy` myself, but that seems inconsistent with how `Begin/Continue/End interaction` seems to call `rotate`.

 

# Appendix: Header file
Posting the header file for `SCNCameraController` here as it contains more documentation than the online docs. 


```

//
//  SCNCameraController.h
//  SceneKit
//
//  Copyright © 2017-2021 Apple Inc. All rights reserved.
//

// SCNInteractionMode specify the behavior of the camera relative to
// screen space interactions.
@available(macOS 10.13, *)
public enum SCNInteractionMode : Int, @unchecked Sendable {

    
    // Relative to up vector.
    case fly = 0

    case orbitTurntable = 1 // rotate around target with absolute orientation from angles accumulation.

    // Up vector not taken into account.
    case orbitAngleMapping = 2 // rotate around target by mapping 2D screen coordinates to spherical coordinates.

    case orbitCenteredArcball = 3

    case orbitArcball = 4 // rotate around target by mapping 2D screen coordinates to an half sphere.

    case pan = 5 // camera space translation on X/Y

    case truck = 6 // camera space translation on X/Z
}

@available(macOS 10.13, *)
public protocol SCNCameraControllerDelegate : NSObjectProtocol {

    
    optional func cameraInertiaWillStart(for cameraController: SCNCameraController)

    optional func cameraInertiaDidEnd(for cameraController: SCNCameraController)
}

@available(macOS 10.13, *)
open class SCNCameraController : NSObject {

    
    unowned(unsafe) open var delegate: SCNCameraControllerDelegate?

    
    open var pointOfView: SCNNode?

    open var interactionMode: SCNInteractionMode

    
    // The camera target in world space for orbit rotation.
    open var target: SCNVector3

    
    // Automatically update the target in beginInteraction
    // Defaults to NO
    open var automaticTarget: Bool

    
    // The up vector in world space used as reference for SCNInteractionModeFly and SCNInteractionModeOrbitTurntable camera modes.
    // Defaults to (0, 1, 0).
    open var worldUp: SCNVector3

    
    // Set to YES to enable inertia on endInteraction.
    // Defaults to NO.
    open var inertiaEnabled: Bool

    
    // The friction coefficient applied to the inertia.
    // Defaults to 0.05.
    open var inertiaFriction: Float

    
    // Returns YES if inertia is running.
    open var isInertiaRunning: Bool { get }

    
    // Minimum and maximum vertical view angles in degrees for SCNInteractionModeFly and SCNInteractionModeOrbitTurntable.
    // The angle constraints is not enforced if both vertical angle properties values are set to 0.
    // The angle constraints will not be enforced if the initial orientation is outside the given range.
    // The minimum angle must be inferior to the maximum angle.
    // Angles are in world space and within the range [-90, 90].
    // Defaults to 0.0.
    // For example: set to minimum to 0 and maximum to 90 to only allow orbit around the top hemisphere.
    open var minimumVerticalAngle: Float

    open var maximumVerticalAngle: Float

    
    // Minimum and maximum horizontal view angles in degrees for SCNInteractionModeFly and SCNInteractionModeOrbitTurntable.
    // The angle constraints is not enforced if both horizontal angle properties values are set to 0.
    // The angle constraints will not be enforced if the initial orientation is outside the given range.
    // The minimum angle must be inferior to the maximum angle.
    // Angles are in world space and within the range [-180, 180].
    // Defaults to 0.0.
    open var minimumHorizontalAngle: Float

    open var maximumHorizontalAngle: Float

    
    // Translate the camera along the local X/Y/Z axis.
    open func translateInCameraSpaceBy(x deltaX: Float, y deltaY: Float, z deltaZ: Float)

    
    // Move the camera to a position where the bounding sphere of all nodes is fully visible.
    // Also set the camera target as the center of the bounding sphere.
    open func frameNodes(_ nodes: [SCNNode])

    
    // Rotate delta is in degrees.
    open func rotateBy(x deltaX: Float, y deltaY: Float)

    
    // Rotate the camera around the given screen space point. Delta is in degrees.
    open func roll(by delta: Float, aroundScreenPoint point: CGPoint, viewport: CGSize)

    
    // Zoom by moving the camera along the axis by a screen space point.
    open func dolly(by delta: Float, onScreenPoint point: CGPoint, viewport: CGSize)

    
    // Rotate the camera around the axis from the camera position to the target.
    // Delta is in degrees.
    open func rollAroundTarget(_ delta: Float)

    
    // Zoom by moving the camera along the axis from the camera position to the target.
    open func dolly(toTarget delta: Float)

    
    // clear the camera roll if any
    open func clearRoll()

    
    // Stop current inertia.
    open func stopInertia()

    
    // Begin/Continue/End interaction using an input location relative to viewport.
    // The behavior depends on the current interactionMode.
    open func beginInteraction(_ location: CGPoint, withViewport viewport: CGSize)

    open func continueInteraction(_ location: CGPoint, withViewport viewport: CGSize, sensitivity: CGFloat)

    open func endInteraction(_ location: CGPoint, withViewport viewport: CGSize, velocity: CGPoint)
}

```
