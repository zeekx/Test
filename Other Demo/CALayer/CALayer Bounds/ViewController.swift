//
//  ViewController.swift
//  CALayer Bounds
//
//  Created by Milo on 2017/10/26.
//  Copyright © 2017年 Kingsoft. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var blueLayer: CALayer = {
        let layer = CALayer()
        layer.backgroundColor = UIColor.blue.cgColor
        return layer
    }()
    
    var anchorPointTextField: UITextField = {
        let tf = UITextField(frame: CGRect(origin: CGPoint.zero,  size:CGSize(width: 100, height: 50) ))
        tf.text = "0.5, 0,5"
        tf.backgroundColor = UIColor.gray
        return tf
    }()
    
    var button: UIButton = {
        let btn = UIButton(type: UIButtonType.system)
        btn.frame = CGRect(origin: CGPoint.zero, size:CGSize(width: 150, height:62))
        btn.setTitle("ChangeAnchorPoint", for: .normal)
        btn.addTarget(self, action: #selector(handleAnchorPointChange(_:)), for: .touchUpInside)
        return btn
    }()
    
    override func loadView() {
        view = GridView()
    }
    
    var gridView: GridView = {
        let v = GridView()
        return v
    }()
    
    @objc func handleAnchorPointChange(_ sender: UIButton) {
        let point = CGPointFromString("{\(anchorPointTextField.text ?? "{0,0}"))}")
        print("\(NSStringFromCGPoint(CGPoint.zero))")
        #if true
            print("-position\(blueLayer.position)\n anchorPoint\(blueLayer.anchorPoint)\n frame\(blueLayer.frame)")
            self.blueLayer.anchorPoint = point
            print("+position\(blueLayer.position)\n anchorPoint\(blueLayer.anchorPoint)\n frame\(blueLayer.frame)")
        #elseif false
            print("-position\(blueLayer.position)\n anchorPoint\(blueLayer.anchorPoint)\n frame\(blueLayer.frame)")
            let oldFrame = blueLayer.frame
            self.blueLayer.anchorPoint = point
            blueLayer.frame = oldFrame
            print("+position\(blueLayer.position)\n anchorPoint\(blueLayer.anchorPoint)\n frame\(blueLayer.frame)")
        #endif
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.view.layer.addSublayer(blueLayer)
        blueLayer.frame = CGRect(origin: CGPoint(x: 50, y: 50), size: CGSize(width: 100, height: 100))
        self.view.addSubview(button)
        self.view.addSubview(anchorPointTextField)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        gridView.backgroundColor = UIColor.yellow
        button.center = self.view.center
        anchorPointTextField.center = CGPoint(x: view.center.x, y: view.center.y - 100)
    }
    
}

