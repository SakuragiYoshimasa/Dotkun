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
    
    func select() {
        self.backgroundColor = UIColor.yellowColor()
    }
    
    func deselect() {
        self.backgroundColor = UIColor.clearColor()
    }
    
    func setup(battleIcon: BattleIcon!) {
        deselect()
        
        if imageView == nil {
            self.imageView = UIImageView(frame: CGRectMake(5, 5, self.bounds.width-10, self.bounds.height-10))
            self.imageView.backgroundColor = UIColor.whiteColor()
            self.addSubview(self.imageView)
        }
        
        self.imageView.image = battleIcon?.image
    }
}