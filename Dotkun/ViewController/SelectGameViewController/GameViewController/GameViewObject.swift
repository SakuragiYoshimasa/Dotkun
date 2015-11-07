//
//  GameViewObject.swift
//  Dotkun
//
//  Created by SakuragiYoshimasa on 2015/11/07.
//  Copyright © 2015年 SakuragiYoshimasa. All rights reserved.
//

import Foundation
import UIKit

class GameViewObject {
    private var _isVisible: Bool = true
    var isVisible: Bool {
        set{
            _isVisible = newValue
        }
        get{
            return _isVisible
        }
    }
    
    func drawOnContext(context: CGContextRef){
        //抽象クラステーキナー
        fatalError("must be overridden")
    }
}