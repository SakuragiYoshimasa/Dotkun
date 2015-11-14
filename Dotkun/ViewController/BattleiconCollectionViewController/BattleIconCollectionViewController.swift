//
//  IconCollectionViewController.swift
//  Dotkun
//
//  Created by 山口智生 on 2015/11/03.
//  Copyright © 2015年 SakuragiYoshimasa. All rights reserved.
//


import UIKit

class BattleIconCollectionViewController: TabBarSlaveViewController {
    
    var createButton: UIButton! = nil
    
    var battleIconCollection: UICollectionView! = nil
    
    let battleIconRepository = BattleIconRepository()
    
    var currentBattleIconImageView: UIImageView! = nil
    
    private var selectedId = 0 {
        didSet{
            currentBattleIconImageView?.image = battleIconRepository.get(selectedId).image
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        battleIconRepository.reload()
        self.battleIconCollection.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tabBarHeight = self.getTabBarHeight()
        
        if battleIconCollection == nil {
            battleIconCollection = UICollectionView(frame:
                CGRectMake(10, 150, self.view.bounds.width-20, self.view.bounds.height - tabBarHeight - 150),
                collectionViewLayout: UICollectionViewFlowLayout()
            )
            battleIconCollection.backgroundColor = UIColor.clearColor()
            battleIconCollection.delegate = self
            battleIconCollection.dataSource = self
            battleIconCollection.registerClass(BattleIconCollectionCell.self, forCellWithReuseIdentifier: "BattleIconCollectionCell")
            self.view.addSubview(battleIconCollection)
        }
        
        if currentBattleIconImageView == nil {
            currentBattleIconImageView = UIImageView(frame: CGRectMake(0, 0, 64, 64))
            //currentBattleIconImageView.image = ModelManager.manager.battleIcon.image
            currentBattleIconImageView.layer.position = CGPointMake(self.view.bounds.midX, Util.getStatusBarHeight() + 80)
            currentBattleIconImageView.backgroundColor = UIColor.whiteColor()
            self.view.addSubview(currentBattleIconImageView)
        }
        
        if createButton == nil {
            createButton = UIButton(frame: CGRectMake(self.view.bounds.width-80,self.view.bounds.height - tabBarHeight - 70,60,60))
            createButton.layer.cornerRadius = 30
            createButton.backgroundColor = UIColor.brownColor()
            createButton.titleLabel?.font = UIFont.systemFontOfSize(40)
            createButton.setTitle("+", forState: .Normal)
            createButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            createButton.addTarget(self, action: "createIcon", forControlEvents: .TouchUpInside)
            self.view.addSubview(createButton)
        }
    }
    
    func createIcon() {
        self.sendMesasgeToMaster(Constants.Message.CreateIcon)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension BattleIconCollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("BattleIconCollectionCell", forIndexPath: indexPath) as! BattleIconCollectionCell
        cell.setup(battleIconRepository.get(indexPath.row))
        if indexPath.row == selectedId {
            cell.select()
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let size: CGSize = CGSizeMake(90, 90)
        
        return size
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        print("select: \(indexPath.row)")
        let oldSelectedId = selectedId
        selectedId = indexPath.row
        collectionView.reloadItemsAtIndexPaths([NSIndexPath(forRow: oldSelectedId, inSection: 0), indexPath])
    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        print("deselect: \(indexPath.row)")
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return battleIconRepository.getBattleIconCount()
    }
}
