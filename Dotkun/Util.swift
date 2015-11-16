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

extension UIImage {
    func getResizedImage(size: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(size)
        self.drawInRect(CGRect(origin: CGPoint.zero, size: size))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage
    }
    
    func getColor(pos: CGPoint) -> UIColor {
        let pixelDataByteSize = 4
        let imageData = CGDataProviderCopyData(CGImageGetDataProvider(self.CGImage))
        let data : UnsafePointer = CFDataGetBytePtr(imageData)
        var address : Int = Int(32 * pos.y + pos.x)  * pixelDataByteSize
        
        
        //通常が3
        //描いた奴は8194
        let r: CGFloat
        let g: CGFloat
        let b: CGFloat
        let a: CGFloat
        let alphaInfo = CGImageGetAlphaInfo(self.CGImage)
        
        switch(alphaInfo) {
        case .First:
            a = CGFloat(data[address])/CGFloat(255.0)
            address += pixelDataByteSize
            break
        case .Only:
            a = CGFloat(data[address])/CGFloat(255.0)
            address += pixelDataByteSize
            break
        default:
            a = CGFloat(data[address+3])/CGFloat(255.0)
        }
        
        let info = CGImageGetBitmapInfo(self.CGImage).rawValue
        if ((info & CGBitmapInfo.ByteOrder32Little.rawValue) > 0) || ((info & CGBitmapInfo.ByteOrder16Little.rawValue) > 0) {
            r = CGFloat(data[address+2])/CGFloat(255.0)
            g = CGFloat(data[address+1])/CGFloat(255.0)
            b = CGFloat(data[address])/CGFloat(255.0)
        } else {
            r = CGFloat(data[address])/CGFloat(255.0)
            g = CGFloat(data[address+1])/CGFloat(255.0)
            b = CGFloat(data[address+2])/CGFloat(255.0)
        }
        
        /*
        // 通常が3、描いたやつは2
        print(CGImageAlphaInfo.Last.rawValue)//3
        print(CGImageAlphaInfo.None.rawValue)//0
        print(CGImageAlphaInfo.NoneSkipFirst.rawValue)//6
        print(CGImageAlphaInfo.NoneSkipLast.rawValue)//5
        print(CGImageAlphaInfo.First.rawValue)//4
        print(CGImageAlphaInfo.Only.rawValue)//7
        */

        /*
        // 通常が3、描いたやつは8194
        print(CGBitmapInfo.AlphaInfoMask.rawValue)//31
        print(CGBitmapInfo.ByteOrder16Big.rawValue)//12288
        print(CGBitmapInfo.ByteOrder16Little.rawValue)//4096
        print(CGBitmapInfo.ByteOrder32Big.rawValue)//16384
        print(CGBitmapInfo.ByteOrder32Little.rawValue)//8192
        print(CGBitmapInfo.ByteOrderDefault.rawValue)//0
        print(CGBitmapInfo.ByteOrderMask.rawValue)//28672
        */
        
        
        //print(UIColor(red: r, green: g, blue: b, alpha: a))
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
}