//
//  ViewController.swift
//  codepath-canvas
//
//  Created by Ernest on 11/13/16.
//  Copyright © 2016 Purpleblue Pty Ltd. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var trayView: UIView!
    
    var trayOriginalCenter: CGPoint!
    var trayDownOffset: CGFloat!
    var trayUp: CGPoint!
    var trayDown: CGPoint!
    
    var newlyCreatedFace: UIImageView!
    var originalFaceCenter: CGPoint!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        trayDownOffset = 240
        trayUp = trayView.center
        trayDown = CGPoint(x: trayView.center.x ,y: trayView.center.y + trayDownOffset)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Tray slide up and down with down bounce
    // Ref: https://guides.codepath.com/ios/Using-Gesture-Recognizers
    @IBAction func onTrayPanGesture(_ sender: UIPanGestureRecognizer) {
        let location = sender.location(in: view)
        print("onTrayPanGesture.location = \(location)")
        
        // Tell which way a user is panning by looking at the gesture property
        // Like translation, velocity has a value for both x and y components
        // If the y component of the velocity is a positive value, the user is panning down. 
        // If the y component is negative, the user is panning up.
        let velocity = sender.velocity(in: view)
        print("onTrayPanGesture.velocity = \(velocity)")
        
        // This will tell us how far our finger has moved from the original "touch-down" point as we drag.
        let translation = sender.translation(in: view)
        print("onTrayPanGesture.translation = \(translation)")
        
        if sender.state == .began {
            print("onTrayPanGesture.Gesture began")
            
            trayOriginalCenter = trayView.center
            
        } else if sender.state == .changed {
            print("onTrayPanGesture.Gesture is changing")
            
            // Ignore the x translation because we only want the tray to move up and down hence translation.y
            trayView.center = CGPoint(x: trayOriginalCenter.x, y: trayOriginalCenter.y + translation.y)
            
        } else if sender.state == .ended {
            print("onTrayPanGesture.Gesture ended")
            
            // Ref: https://guides.codepath.com/ios/Animating-View-Properties
            // Ref2: https://guides.codepath.com/ios/Animating-View-Properties#spring-animation
            if velocity.y > 0 {
                UIView.animate(withDuration:0.4, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options:[] ,
                               animations: { () -> Void in
                                self.trayView.center = self.trayDown
                }, completion: nil)
            } else {
                UIView.animate(withDuration: 0.3) {
                    self.trayView.center = self.trayUp
                }
            }
        }
    }
    
    // Clicking on Excited face creates another face
    @IBAction func onFaceGesture(_ sender: UIPanGestureRecognizer) {
        let location = sender.location(in: view)
        print("onFaceGesture.location = \(location)")
        
        // Tell which way a user is panning by looking at the gesture property
        // Like translation, velocity has a value for both x and y components
        // If the y component of the velocity is a positive value, the user is panning down.
        // If the y component is negative, the user is panning up.
        let velocity = sender.velocity(in: view)
        print("onFaceGesture.velocity = \(velocity)")
        
        // This will tell us how far our finger has moved from the original "touch-down" point as we drag.
        let translation = sender.translation(in: view)
        print("onFaceGesture.translation = \(translation)")
        
        if sender.state == .began {
            print("onExcitedGesture.Gesture began")
            
            // Gesture recognizers know the view they are attached to
            let imageView = sender.view as! UIImageView
            
            // Create a new image view that has the same image as the one currently panning
            newlyCreatedFace = UIImageView(image: imageView.image)
            
            // Enable user interaction on the programatically created imageView so it can react when we apply Pan to it further down
            newlyCreatedFace.isUserInteractionEnabled = true
            
            // Newly created face can be panned now by scaling the face
            let panGesture = UIPanGestureRecognizer(target: self, action: #selector(onFaceScalePanGesture))
            newlyCreatedFace.addGestureRecognizer(panGesture)
            
            // Add the new face to the tray's parent view.
            view.addSubview(newlyCreatedFace)
            
            // Initialize the position of the new face.
            newlyCreatedFace.center = imageView.center
            
            // Since the original face is in the tray, but the new face is in the
            // main view, you have to offset the coordinates
            newlyCreatedFace.center.y += trayView.frame.origin.y
            
            originalFaceCenter = newlyCreatedFace.center
            
        } else if sender.state == .changed {
            print("onExcitedGesture.Gesture is changing")
            
            // Moves the element by x & y (ref translation)
            newlyCreatedFace.center = CGPoint(x: originalFaceCenter.x + translation.x, y: originalFaceCenter.y + translation.y)
            
        } else if sender.state == .ended {
            print("onExcitedGesture.Gesture ended")
            
        }
    }
    
    // Ref: http://guides.codepath.com/ios/Using-Gesture-Recognizers#programmatically-add-and-configure-a-gesture-recognizer
    func onFaceScalePanGesture(sender: UIPanGestureRecognizer) {
        if sender.state == UIGestureRecognizerState.began {
            print("onFacePan.Gesture began")
            
            UIView.animate(withDuration: 0.2, animations: {
                sender.view?.transform = CGAffineTransform(scaleX: 3, y: 3)
            })
        } else if sender.state == UIGestureRecognizerState.ended {
            print("onFacePan.Gesture ended")
            
            UIView.animate(withDuration: 0.2, animations: {
                sender.view?.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
        }
    }

}

