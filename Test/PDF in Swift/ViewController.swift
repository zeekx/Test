//
//  ViewController.swift
//  PDF in Swift
//
//  Created by Milo on 2017/9/21.
//  Copyright © 2017年 Zeek. All rights reserved.
//

import UIKit
import PDFKit

class ViewController: UIViewController {
    var pdfView: PDFView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.pdfView = PDFView(frame: CGRect.zero )
        self.view.addSubview(pdfView!)
//        pdfView!.autoresizingMask = UIViewAutoresizing(rawValue: UIViewAutoresizing.RawValue(UInt8(UIViewAutoresizing.flexibleHeight.rawValue) | UInt8(UIViewAutoresizing.flexibleHeight.rawValue)))
        if let url = Bundle.main.url(forResource: "textbook", withExtension: "pdf") {
            if let doc = PDFDocument(url: url) {
                pdfView?.document = doc
                pdfView?.autoScales = true
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        pdfView?.frame = self.view.frame
    }
    

}

