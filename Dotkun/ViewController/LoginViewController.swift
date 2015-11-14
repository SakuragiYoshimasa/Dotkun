//
//  LoginViewController.swift
//  Dotkun
//
//  Created by 山口智生 on 2015/11/03.
//  Copyright © 2015年 SakuragiYoshimasa. All rights reserved.
//

import UIKit
import TwitterKit

class LoginViewController: UIViewController {
    
    //logo
    let logoLabel = UILabel()
    
    let indicator = UIActivityIndicatorView(frame: CGRectMake(0,0,50,50))
    
    let logInButton = UIButton()
    
    override func viewWillAppear(animated: Bool) {
        tryLogin()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // logo
        logoLabel.frame = CGRectMake(50, 50, self.view.frame.width-100, 100)
        logoLabel.text = "LOGO"
        logoLabel.font = UIFont.systemFontOfSize(80)
        logoLabel.textAlignment = NSTextAlignment.Center
        logoLabel.textColor = UIColor.blackColor()
        self.view.addSubview(logoLabel)
        
        logInButton.frame = CGRect(origin: CGPoint.zero, size: CGSizeMake(100,50))
        logInButton.backgroundColor = UIColor.cyanColor()
        logInButton.center = self.view.center
        logInButton.addTarget(self, action: "tryLogin", forControlEvents: .TouchUpInside)
        self.view.addSubview(logInButton)
        logInButton.hidden = true
        
        indicator.hidesWhenStopped = true
        indicator.activityIndicatorViewStyle = .Gray
        indicator.layer.position = self.view.center
        self.view.addSubview(indicator)
        
    }
    
    func tryLogin() {
        indicator.startAnimating()
        logInButton.userInteractionEnabled = false
        
        
        let loginCompletion: TWTRLogInCompletion = { (session, error) in
            if let s = session {
                print(s.userName)
                self.onLoggedIn(s.userID)
            } else {
                if Constants.DEBUG {
                    ModelManager.manager.setAccount(User())
                    self.performSegueWithIdentifier("loggedIn", sender: nil)
                } else {
                    NSLog("Login error: %@", error!.localizedDescription)
                    self.indicator.stopAnimating()
                    self.logInButton.hidden = false
                    self.logInButton.userInteractionEnabled = true
                }
            }
        }
        
        // すでにtokenとかが存在
        if let session = Twitter.sharedInstance().sessionStore.session() {
            Twitter.sharedInstance().logInWithExistingAuthToken(session.authToken, authTokenSecret: session.authTokenSecret, completion: loginCompletion)
        // tokenなし
        } else {
            Twitter.sharedInstance().logInWithCompletion(loginCompletion)
        }
    }
    
    func onLoggedIn(userId: String) {
        let client = TWTRAPIClient(userID: userId)
        
        print("client: \(client.userID)")

        client.loadUserWithID(userId) { user, error in
            self.indicator.stopAnimating()
            if let u = user {
                print(u.profileImageURL)
                ModelManager.manager.setAccount(User(tUser: u))
                self.performSegueWithIdentifier("loggedIn", sender: nil)
            } else {
                print("login Error!")
                self.logInButton.hidden = false
                self.logInButton.userInteractionEnabled = true
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}