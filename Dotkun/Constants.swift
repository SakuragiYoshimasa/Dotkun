//
//  Constants.swift
//  Dotkun
//
//  Created by 山口智生 on 2015/11/02.
//  Copyright © 2015年 SakuragiYoshimasa. All rights reserved.
//

import UIKit

class Constants {
    static let APPNAME = "Dotkun"
    
    static let DEBUG: Bool = true
    
    //-------------------------------------
    // GameSetting
    //-------------------------------------
    static let GAME_FPS = 60.0
    
    
    //-------------------------------------
    // ColorSettings
    //-------------------------------------
    static let MAINCOLOR = UIColor(red: 0.4, green: 0.8, blue: 0.8, alpha: 1.0)
    static let BACKCOLOR = UIColor(red: 1.0, green: 0.5, blue: 0.5, alpha: 1.0)
    static let TEXTCOLOR = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    static let TOUCH_CIRCLE_COLOR = UIColor(red: 0, green: 1.0, blue: 1.0, alpha: 0.2)
    
    //-------------------------------------
    // Message
    //-------------------------------------
    enum Message {
        case StartGame
        case CreateIcon
    }
}
