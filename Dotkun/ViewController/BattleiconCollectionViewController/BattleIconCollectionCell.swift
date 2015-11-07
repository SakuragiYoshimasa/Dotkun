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
    
    func setup(battleIcon: BattleIcon!) {
        self.backgroundColor = UIColor.whiteColor()
        
        if imageView == nil {
            self.imageView = UIImageView(frame: self.bounds)
            self.addSubview(self.imageView)
        }
        
        self.imageView.image = battleIcon?.image
    }
}