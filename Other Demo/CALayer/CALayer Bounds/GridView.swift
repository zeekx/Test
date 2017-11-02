//
//  GridView.swift
//  CALayer Bounds
//
//  Created by Milo on 2017/10/26.
//  Copyright © 2017年 Kingsoft. All rights reserved.
//

import UIKit

class GridView: UIView {

    var gridSpacing: CGFloat = 50
    var lineMargin: CGFloat = 50
    let gridLineWidth = CGFloat(1)
    let gridColor = UIColor.gray
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        //设置颜色
        context.setFillColor(UIColor.white.cgColor)
        context.setStrokeColor(UIColor.lightGray.cgColor)

        //为了颜色更好区分，对矩形描边
        context.fill(rect)
        context.stroke(rect)
        //实际line和point的代码
        

        context.setStrokeColor(UIColor.red.cgColor)
        context.setLineWidth(0.5)
        context.setLineCap(CGLineCap.round)
        context.setLineJoin(CGLineJoin.round)

        context.move(to: CGPoint(x: 0, y:0))
        
        var xPos:CGFloat = 0//lineMargin - pixelAdjustOffset;
        var yPos:CGFloat  = 0//lineMargin - pixelAdjustOffset;
        while (xPos < self.bounds.size.width) {
            context.move(to: CGPoint(x: xPos, y: 0))
            context.addLine(to: CGPoint(x: xPos, y: self.bounds.size.height))
            xPos += lineMargin
        }
        
        while (yPos < self.bounds.size.height) {
            context.move(to: CGPoint(x: 0, y: yPos))
            context.addLine(to: CGPoint(x: self.bounds.size.width, y: yPos))
            yPos += lineMargin;
        }
        
        
        context.strokePath()
//        context.translateBy(x: 0, y: self.bounds.height)
//        context.scaleBy(x: 1, y: -1.0)
        /*
        let context = UIGraphicsGetCurrentContext()
        context.translateBy(x: 1, y: -1.0)
        
        context.beginPath()
        
        let lineMargin = self.gridSpacing
        
        /**
         *  https://developer.apple.com/library/ios/documentation/2DDrawing/Conceptual/DrawingPrintingiOS/GraphicsDrawingOverview/GraphicsDrawingOverview.html
         * 仅当要绘制的线宽为奇数像素时，绘制位置需要调整
         */
        var pixelAdjustOffset = CGFloat(0)
        let SINGLE_LINE_ADJUST_OFFSET = CGFloat(0)
        if Int((self.gridLineWidth * UIScreen.main.scale) + 1) % 2 == 0 {
            pixelAdjustOffset = SINGLE_LINE_ADJUST_OFFSET;
        }
        

        
        context.setLineWidth(self.gridLineWidth)
        context.setStrokeColor(self.gridColor.cgColor)
        context.strokePath()
 */
    }

}
