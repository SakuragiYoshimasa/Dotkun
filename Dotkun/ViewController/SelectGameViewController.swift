//
//  SelectGameViewController.swift
//  Dotkun
//
//  Created by 山口智生 on 2015/11/03.
//  Copyright © 2015年 SakuragiYoshimasa. All rights reserved.
//

import UIKit

class SelectGameViewController: BaseViewController {
    
    var gameListTable: UITableView! = nil
    var gameList = ["ローカル", "オンライン", "あー", "いー", "うー"]
    var masterViewController: TabControllerMasterDelegate! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let statusBarHeight = Util.getStatusBarHeight()
        if gameListTable == nil {
            gameListTable = UITableView(frame: CGRectMake(0, statusBarHeight+100, self.view.bounds.width, self.view.bounds.height-statusBarHeight - masterViewController.getTabBarHeight() - 100))
            gameListTable.registerClass(SelectGameTableCell.self, forCellReuseIdentifier: "SelectGameTableCell")
            gameListTable.backgroundColor = UIColor.clearColor()
            gameListTable.dataSource = self
            gameListTable.delegate = self
            gameListTable.separatorColor = UIColor.clearColor()
            gameListTable.allowsSelection = true
            gameListTable.allowsMultipleSelection = false
            self.view.addSubview(gameListTable)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension SelectGameViewController: UITableViewDelegate, UITableViewDataSource {
    // セクション数
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    // セクションの行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gameList.count
    }
    // セクション高さ
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 120
    }
    // セル表示
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath:NSIndexPath) -> UITableViewCell {
        let cell: SelectGameTableCell = tableView.dequeueReusableCellWithIdentifier("SelectGameTableCell", forIndexPath: indexPath) as! SelectGameTableCell
        cell.setup(gameList[indexPath.row])
        return cell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.gameListTable.deselectRowAtIndexPath(indexPath, animated: false)
        print("select:\(gameList[indexPath.row])")
        //ここで画面遷移したい
        masterViewController.performSegue("startGame")
    }

}