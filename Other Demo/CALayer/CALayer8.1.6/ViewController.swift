//
//  ViewController.swift
//  CALayer8.1.6
//
//  Created by 51Talk_iGS on 2017/4/17.
//  Copyright © 2017年 Kingsoft. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let bezierPath = UIBezierPath()
        bezierPath .move(to: CGPoint(x:0, y:150))
        bezierPath .addCurve(to: CGPoint(x:300, y:150), controlPoint1: CGPoint(x:75, y:0), controlPoint2: CGPoint(x:225, y:300))
        //draw the path using a CAShapeLayer
        let pathLayer = CAShapeLayer()
        pathLayer.path = bezierPath.cgPath
        pathLayer.fillColor = UIColor.clear.cgColor
        pathLayer.strokeColor = UIColor.red.cgColor
        pathLayer.lineWidth = CGFloat(Float(3))
        self.view.layer .addSublayer(pathLayer)
        
        //add the ship
        let shipLayer = CALayer()
        shipLayer.frame = CGRect(x:0, y:0, width:64, height:64);
        shipLayer.position = CGPoint(x:0, y:150);
        shipLayer.contents = UIImage(named:"ship.png")?.cgImage
        self.view.layer .addSublayer(shipLayer)
        //create the keyframe animation
        let animation = CAKeyframeAnimation()
        animation.keyPath = "position";
        animation.duration = 4.0;
        animation.path = bezierPath.cgPath;
        shipLayer .add(animation, forKey: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

