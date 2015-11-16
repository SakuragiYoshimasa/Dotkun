//
//  BattleIconCollectionCell.swift
//  Dotkun
//
//  Created by 山口智生 on 2015/11/05.
//  Copyright © 2015年 SakuragiYoshimasa. All rights reserved.
//

import UIKit


class BattleIconCollectionCell: UICollectionViewCell {
    var imageView: UIImageView! = nil
    var mesLabel: UILabel! = nil
    
    var battleIcon: BattleIcon! = nil
    
    func select() {
        self.backgroundColor = Constants.HILIGHTENED_COLOR
        self.mesLabel.text = "set?"
        mesLabel.hidden = false
    }
    
    func deselect() {
        self.backgroundColor = UIColor.clearColor()
        mesLabel.hidden = true
    }
    
    func setup(battleIcon: BattleIcon) {
        if imageView == nil {
            self.imageView = UIImageView(frame: CGRectMake(5, 5, self.bounds.width-10, self.bounds.height-10))
            self.imageView.backgroundColor = UIColor.whiteColor()
            self.addSubview(self.imageView)
        }
        
        if mesLabel == nil {
            self.mesLabel = UILabel(frame: CGRectMake(0,self.bounds.height/2-15,self.bounds.width, 30))
            self.mesLabel.textAlignment = NSTextAlignment.Center
            self.mesLabel.backgroundColor = UIColor(red: 0.7, green: 0.7, blue: 0.7, alpha: 0.3)
            self.addSubview(self.mesLabel)
        }
        
        deselect()
        
        self.imageView.image = battleIcon.image
        self.battleIcon = battleIcon
    }
}