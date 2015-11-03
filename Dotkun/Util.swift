//
//  Util.swift
//  Dotkun
//
//  Created by 山口智生 on 2015/11/03.
//  Copyright © 2015年 SakuragiYoshimasa. All rights reserved.
//

import UIKit

class TestUtil {
    static func randomColor() -> UIColor {
        return UIColor(red: Util.generateRandom(), green: Util.generateRandom(), blue: Util.generateRandom(), alpha: 1.0)
    }
    
    static func randomPoint(rect: CGRect) -> CGPoint {
        return CGPointMake(
            rect.minX + Util.generateRandom() * rect.width,
            rect.minY + Util.generateRandom() * rect.height
        )
    }
}

class Util {
    static func getStatusBarHeight() -> CGFloat {
        return UIApplication.sharedApplication().statusBarFrame.height
    }
    
    static func generateRandom() -> CGFloat {
        return CGFloat(rand())/CGFloat(RAND_MAX)
    }
}

extension UIColor {
    func colorFromRGB(rgb: String, alpha: CGFloat) -> UIColor {
        let scanner = NSScanner(string: rgb)
        var rgbInt: UInt32 = 0
        scanner.scanHexInt(&rgbInt)
        
        let r = CGFloat(((rgbInt & 0xFF0000) >> 16)) / 255.0
        let g = CGFloat(((rgbInt & 0x00FF00) >> 8)) / 255.0
        let b = CGFloat(rgbInt & 0x0000FF) / 255.0
        
        return UIColor(red: r, green: g, blue: b, alpha: alpha)
    }
}

extension CGPoint {
    mutating func move(x: CGFloat, y: CGFloat) {
        self.x += x
        self.y += y
    }
}