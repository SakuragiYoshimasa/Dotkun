//
//  SelectGameTableCell.swift
//  Dotkun
//
//  Created by 山口智生 on 2015/11/03.
//  Copyright © 2015年 SakuragiYoshimasa. All rights reserved.
//

import UIKit

class SelectGameTableCell: UITableViewCell {
    
    var label: UILabel! = nil
    
    func setup(title: String) {
        self.backgroundColor = UIColor.clearColor()
        if label == nil {
            label = UILabel()
            label.textAlignment = NSTextAlignment.Center
            label.textColor = UIColor.brownColor()
            label.backgroundColor = UIColor.orangeColor()
            label.layer.masksToBounds = true
            label.layer.cornerRadius = 15
            label.layer.borderColor = UIColor.brownColor().CGColor
            label.layer.borderWidth = 5
            self.addSubview(label)
        }
        let labelHeight: CGFloat = 80
        let labelWidth: CGFloat = self.bounds.width-50
        label.frame = CGRectMake((self.bounds.width-labelWidth)/2, (self.bounds.height - labelHeight)/2, labelWidth, labelHeight)
        label.text = title
    }
}