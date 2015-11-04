//
//  hogeViewController.swift
//  Dotkun
//
//  Created by SakuragiYoshimasa on 2015/11/04.
//  Copyright © 2015年 SakuragiYoshimasa. All rights reserved.
//



import UIKit


class hogeController: BaseViewController {
    
    private var viewIdentifer: String = "";
    
    private var home: TabControllerMasterDelegate! = nil
    
    func sendMesasge(){
        if home != nil {
            home.performSegue(viewIdentifer);
        }
    }
    
    func setHome(h: TabControllerMasterDelegate){
        home = h;
    }
    
    func setIdentifer(id: String){
        viewIdentifer = id
    }
}