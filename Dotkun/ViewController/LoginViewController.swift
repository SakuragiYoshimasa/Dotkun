//
//  LoginViewController.swift
//  Dotkun
//
//  Created by 山口智生 on 2015/11/03.
//  Copyright © 2015年 SakuragiYoshimasa. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    // 設定項目
    let borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
    let boxOffsetY: CGFloat = 200
    let boxOffsetY2: CGFloat = 330
    
    //logo
    let logoLabel = UILabel()
    
    // for pattern1
    let borderView: UIView = UIView()
    let idField = UITextField()
    let passField = UITextField()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ModelManager.manager.setAccount(User())
        
        
        let boxWidth = self.view.frame.width - 50
        let boxHeight: CGFloat = 50
        
        
        pattern1(boxWidth, boxHeight: boxHeight)
        
        // tapGesture
        let gestureTap = UITapGestureRecognizer(target: self, action: "resignFirstResponderAll")
        self.view.addGestureRecognizer(gestureTap)
        
        // logo
        logoLabel.frame = CGRectMake(50, boxOffsetY-130, self.view.frame.width-100, 100)
        logoLabel.text = "LOGO"
        logoLabel.font = UIFont.systemFontOfSize(80)
        logoLabel.textAlignment = NSTextAlignment.Center
        logoLabel.textColor = UIColor.blackColor()
        self.view.addSubview(logoLabel)
    }
    
    func pattern1(boxWidth: CGFloat, boxHeight: CGFloat) {
        borderView.frame = CGRectMake((self.view.frame.width - boxWidth)/2, boxOffsetY, boxWidth, boxHeight * 2)
        borderView.layer.borderColor = borderColor.CGColor
        borderView.layer.borderWidth = 1.0
        borderView.layer.cornerRadius = 5.0
        borderView.layer.masksToBounds = true
        //中央線
        UIGraphicsBeginImageContextWithOptions(borderView.frame.size, false, 0)
        let path = UIBezierPath()
        path.moveToPoint(CGPointMake(0, boxHeight));
        path.addLineToPoint(CGPointMake(boxWidth, boxHeight))
        borderColor.setStroke()
        path.lineWidth = 1.0
        path.stroke()
        borderView.layer.contents = UIGraphicsGetImageFromCurrentImageContext().CGImage
        UIGraphicsEndImageContext()
        self.view.addSubview(borderView)
        
        idField.frame = CGRectMake(7, 0, boxWidth-10, boxHeight)
        idField.placeholder = "ユーザーID"
        idField.borderStyle = UITextBorderStyle.None
        idField.returnKeyType = UIReturnKeyType.Done
        idField.delegate = self
        borderView.addSubview(idField)
        
        passField.frame = CGRectMake(7, boxHeight, boxWidth-10, boxHeight)
        passField.placeholder = "パスワード"
        passField.borderStyle = UITextBorderStyle.None
        passField.returnKeyType = UIReturnKeyType.Done
        passField.secureTextEntry = true
        passField.delegate = self
        borderView.addSubview(passField)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // ここで閉じるとかっこいい
    override func viewWillDisappear(animated: Bool) {
        resignFirstResponderAll()
    }
    
    func resignFirstResponderAll() {
        idField.resignFirstResponder()
        passField.resignFirstResponder()
    }
    
}