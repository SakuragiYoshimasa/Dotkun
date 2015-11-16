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
    
    var currentBattleIcon: BattleIcon! {
        set{
            ModelManager.manager.currentBattleIcon = newValue
            currentBattleIconImageView?.image = ModelManager.manager.currentBattleIcon.image?.getResizedImage(CGSizeMake(32,32))
        }
        get{
            return ModelManager.manager.currentBattleIcon
        }
    }
    // 選択されたセルのindex
    private var selectedIndexPath = NSIndexPath(forRow: 0, inSection: 0)
    
    override func viewWillAppear(animated: Bool) {
        battleIconRepository.reload()
        if currentBattleIcon == nil {
            if let battleIcon = battleIconRepository.get(0) {
                currentBattleIcon = battleIcon
            }
        }
        
        currentBattleIconImageView?.image = currentBattleIcon?.image
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
            battleIconCollection.registerClass(UICollectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "empty")
            
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
        if let battleIcon = battleIconRepository.get(indexPath.row) {
            cell.setup(battleIcon)
        }
        
        if indexPath == selectedIndexPath {
            cell.select()
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, shouldShowMenuForItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func collectionView(collectionView: UICollectionView, canPerformAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        if action == "cut:" {
            // 選択中のやつは消せない
            if currentBattleIcon.id == (collectionView.cellForItemAtIndexPath(indexPath) as! BattleIconCollectionCell).battleIcon.id {
                return false
            } else {
                return true
            }
        }
        return false
    }
    
    func collectionView(collectionView: UICollectionView, performAction action: Selector, forItemAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) {
        if action == "cut:" {
            //let cell = self.battleIconCollection.cellForItemAtIndexPath(indexPath) as! BattleIconCollectionCell
            battleIconRepository.deleteObjectAtIndex(indexPath.row)
            collectionView.reloadData()
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let size: CGSize = CGSizeMake(90, 90)
        
        return size
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        print("select: \(indexPath.row)")
        if selectedIndexPath != indexPath {
            let oldIndexPath = selectedIndexPath
            selectedIndexPath = indexPath
            collectionView.reloadItemsAtIndexPaths([oldIndexPath, indexPath])
        } else {
            let cell = self.battleIconCollection.cellForItemAtIndexPath(indexPath) as! BattleIconCollectionCell
            currentBattleIcon = cell.battleIcon
        }
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
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionFooter {
            return collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionFooter, withReuseIdentifier: "empty", forIndexPath: indexPath)
        } else {
            return collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionFooter, withReuseIdentifier: "empty", forIndexPath: indexPath)
        }
    }
    
    //footerのサイズを返す
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewFlowLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSizeMake(collectionView.bounds.width, 50)
    }
}
