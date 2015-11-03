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
    var gameList = ["ローカル", "オンライン"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let statusBarHeight = Util.getStatusBarHeight()
        gameListTable = UITableView(frame: CGRectMake(0, statusBarHeight+200, self.view.bounds.width, self.view.bounds.height-statusBarHeight))
        gameListTable.registerClass(SelectGameTableCell.self, forCellReuseIdentifier: "SelectGameTableCell")
        gameListTable.backgroundColor = UIColor.clearColor()
        gameListTable.dataSource = self
        gameListTable.delegate = self
        gameListTable.separatorColor = UIColor.clearColor()
        gameListTable.allowsSelection = true
        gameListTable.allowsMultipleSelection = false
        self.view.addSubview(gameListTable)
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
        //cell deque
        let myCell: SelectGameTableCell = tableView.dequeueReusableCellWithIdentifier("SelectGameTableCell", forIndexPath: indexPath) as! SelectGameTableCell
        myCell.setup(gameList[indexPath.row])
        return myCell
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.gameListTable.deselectRowAtIndexPath(indexPath, animated: false)
        print("select:\(gameList[indexPath.row])")
        //ここで画面遷移したい
    }

}