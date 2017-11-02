//
//  ViewController.swift
//  CALayer7.5
//
//  Created by Milo on 2017/10/27.
//  Copyright © 2017年 Kingsoft. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func handleTouchUpInside(_ sender: UIButton) {
        
        print("action OUTSIDE :\(String(describing: self.view.layer.action(forKey: "backgroundColor")))")
        
        UIView.animate(withDuration: 0.25) {
            print("action INSIDE :\(String(describing: self.view.layer.action(forKey: "backgroundColor")))")
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

