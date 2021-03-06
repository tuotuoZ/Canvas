//
//  CanvasViewController.swift
//  Canvas
//
//  Created by Tony Zhang on 11/5/18.
//  Copyright © 2018 Tony. All rights reserved.
//

import UIKit

class CanvasViewController: UIViewController {

    @IBOutlet weak var trayView: UIView!
    var trayOriginalCenter: CGPoint!
    
    let trayDownOffset: CGFloat! = 240
    var trayUp: CGPoint!
    var trayDown: CGPoint!
    
    var newlyCreatedFace: UIImageView!
    var newlyCreatedFaceOriginalCenter: CGPoint!


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        trayUp = trayView.center // The initial position of the tray
        trayDown = CGPoint(x: trayView.center.x ,y: trayView.center.y + trayDownOffset) // The position of the tray transposed down
    }
    
    // Drag the tray around
    @IBAction func didPanTray(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        var velocity = sender.velocity(in: view)

        if sender.state == .began{
            trayOriginalCenter = trayView.center
        }
        else if sender.state == .changed{
            trayView.center = CGPoint(x: trayOriginalCenter.x, y: trayOriginalCenter.y + translation.y)
        }
        else if sender.state == .ended{
            
            if velocity.y > 0{
                UIView.animate(withDuration: 0.2) {
                    self.trayView.center = self.trayDown
                }
            }
            else{
                UIView.animate(withDuration: 0.2) {
                    self.trayView.center = self.trayUp
                }
            }
        }
    }
    
    // Drag a emoji from the tray and assign it to the new property
    @IBAction func dragEmoji(_ sender: UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)

        if sender.state == .began{
            var imageView = sender.view as! UIImageView
            newlyCreatedFace = UIImageView(image: imageView.image)
            view.addSubview(newlyCreatedFace)
            newlyCreatedFace.center = imageView.center
            newlyCreatedFace.center.y += trayView.frame.origin.y
            
            newlyCreatedFaceOriginalCenter = newlyCreatedFace.center
            newlyCreatedFace.isUserInteractionEnabled = true

            let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(moveEmoji(sender:)))
            newlyCreatedFace.addGestureRecognizer(panGestureRecognizer)
            
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(deleteEmoji(sender:)))
            tapGestureRecognizer.numberOfTapsRequired = 2
            newlyCreatedFace.addGestureRecognizer(tapGestureRecognizer)
            
            UIView.animate(withDuration:0.1, delay: 0.0,
                           options: [],
                           animations: { () -> Void in
                            self.newlyCreatedFace.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            }, completion: nil)
            
            
        }
        else if sender.state == .changed{
            newlyCreatedFace.center = CGPoint(x: newlyCreatedFaceOriginalCenter.x + translation.x, y: newlyCreatedFaceOriginalCenter.y + translation.y)
        }
        else if sender.state == .ended{
            UIView.animate(withDuration:0.1, delay: 0.0,
                           options: [],
                           animations: { () -> Void in
                            self.newlyCreatedFace.transform = CGAffineTransform(scaleX: 1, y: 1)
            }, completion: nil)
        }
    }
    
    // Delete a emoji if a user double tapped it
    @objc func deleteEmoji(sender: UITapGestureRecognizer){
        let imageView = sender.view
        imageView?.removeFromSuperview()
    }
    
    // Move a existing emoji
    @objc func moveEmoji(sender: UIPanGestureRecognizer){
        let translation = sender.translation(in: view)

        if sender.state == .began{
            
            newlyCreatedFace = sender.view as! UIImageView
            newlyCreatedFaceOriginalCenter = newlyCreatedFace.center
            UIView.animate(withDuration:0.1, delay: 0.0,
                           options: [],
                           animations: { () -> Void in
                            self.newlyCreatedFace.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            }, completion: nil)
            
        }
        else if sender.state == .changed{
            newlyCreatedFace.center = CGPoint(x: newlyCreatedFaceOriginalCenter.x + translation.x, y: newlyCreatedFaceOriginalCenter.y + translation.y)
            print(translation.x)
            print(translation.y)
            
        }
        else if sender.state == .ended{
            if (newlyCreatedFaceOriginalCenter.y + translation.y) > CGFloat(500){
                newlyCreatedFace.center = newlyCreatedFaceOriginalCenter
                
                
            }
            UIView.animate(withDuration:0.1, delay: 0.0,
                           options: [],
                           animations: { () -> Void in
                            self.newlyCreatedFace.transform = CGAffineTransform(scaleX: 1, y: 1)
            }, completion: nil)

        }
  
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
