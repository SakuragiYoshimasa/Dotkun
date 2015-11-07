//
//  CreateIconViewController.swift
//  Dotkun
//
//  Created by 山口智生 on 2015/11/03.
//  Copyright © 2015年 SakuragiYoshimasa. All rights reserved.
//

import UIKit


class CreateIconViewController: TabBarSlaveViewController {
    
    var drawableView: DrawableView! = nil
    
    var undoButton: UIButton! = nil
    var saveButton: UIButton! = nil
    var clearButton: UIButton! = nil
    var loadButton: UIButton! = nil
    
    var lineWidthSlider: UISlider! = nil
    var setColorButton: UIButton! = nil
    
    override func viewWillAppear(animated: Bool) {
        self.lineWidthSlider?.value = Float(sqrt(self.drawableView.getLineWidth()))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let buttonWidth = self.view.bounds.width/4
        
        if drawableView == nil {
            drawableView = DrawableView(frame: CGRectMake(0, 100, self.view.bounds.width, self.view.bounds.width))
            drawableView.backgroundColor = UIColor.whiteColor()
            drawableView.delegate = self
            self.view.addSubview(drawableView)
        }
        
        if undoButton == nil {
            undoButton = UIButton(frame: CGRectMake(0, Util.getStatusBarHeight(), buttonWidth, 100))
            undoButton.backgroundColor = UIColor.yellowColor()
            undoButton.setTitle("undo", forState: .Normal)
            undoButton.setTitleColor(UIColor.brownColor(), forState: .Normal)
            undoButton.addTarget(drawableView, action: "undo", forControlEvents: .TouchUpInside)
            self.view.addSubview(undoButton)
        }
        
        if loadButton == nil {
            loadButton = UIButton(frame: CGRectMake(buttonWidth*1, Util.getStatusBarHeight(), buttonWidth, 100))
            loadButton.backgroundColor = UIColor.orangeColor()
            loadButton.setTitle("load", forState: .Normal)
            loadButton.setTitleColor(UIColor.brownColor(), forState: .Normal)
            loadButton.addTarget(self, action: "load", forControlEvents: .TouchUpInside)
            self.view.addSubview(loadButton)
        }
        
        if clearButton == nil {
            clearButton = UIButton(frame: CGRectMake(buttonWidth*2, Util.getStatusBarHeight(), buttonWidth, 100))
            clearButton.backgroundColor = UIColor.greenColor()
            clearButton.setTitle("clear", forState: .Normal)
            clearButton.setTitleColor(UIColor.brownColor(), forState: .Normal)
            clearButton.addTarget(drawableView, action: "clear", forControlEvents: .TouchUpInside)
            self.view.addSubview(clearButton)
        }
        
        if saveButton == nil {
            saveButton = UIButton(frame: CGRectMake(buttonWidth*3, Util.getStatusBarHeight(), buttonWidth, 100))
            saveButton.backgroundColor = UIColor.cyanColor()
            saveButton.setTitle("save", forState: .Normal)
            saveButton.setTitleColor(UIColor.brownColor(), forState: .Normal)
            saveButton.addTarget(drawableView, action: "save", forControlEvents: .TouchUpInside)
            self.view.addSubview(saveButton)
        }
        
        if lineWidthSlider == nil {
            lineWidthSlider = UISlider(frame: CGRectMake(20, self.view.bounds.height - 50 - 25, self.view.bounds.width - 20 - 100, 50))
            lineWidthSlider.minimumValue = 1.0
            lineWidthSlider.maximumValue = 10.0
            lineWidthSlider.addTarget(self, action: "lineWidthChanged:", forControlEvents: .ValueChanged)
            self.view.addSubview(lineWidthSlider)
        }
        
        if setColorButton == nil {
            setColorButton = UIButton(frame: CGRect(origin: CGPointZero, size: CGSizeMake(50, 50)))
            setColorButton.layer.position = CGPointMake(self.view.bounds.width - 50, self.view.bounds.height - 50)
            setColorButton.backgroundColor = UIColor.redColor()
            setColorButton.addTarget(self, action: "clickedColorButton:", forControlEvents: .TouchUpInside)
            self.view.addSubview(setColorButton)
        }
    }
    
    func clickedColorButton(sender: UIButton!) {
        let controller = ColorPickerViewController()
        controller.delegate = self
        self.presentPopver(controller, sourceView: sender)
    }
    
    func presentPopver(viewController: UIViewController!, sourceView: UIView!) {
        viewController.modalPresentationStyle = UIModalPresentationStyle.Popover
        viewController.preferredContentSize = CGSizeMake(300,400)
        
        let popoverController = viewController.popoverPresentationController
        popoverController?.delegate = self
        
        // 向き
        popoverController?.permittedArrowDirections = UIPopoverArrowDirection.Down
        // どこから出た感じにするか
        popoverController?.sourceView = sourceView
        popoverController?.sourceRect = sourceView.bounds
        
        self.presentViewController(viewController, animated: true, completion: nil)
    }
    
    func lineWidthChanged(sender: AnyObject?) {
        self.drawableView.setLineWidth(CGFloat(lineWidthSlider.value * lineWidthSlider.value))
    }
    
    func load() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary) {
            let ipc: UIImagePickerController = UIImagePickerController()
            ipc.delegate = self
            ipc.allowsEditing = true
            
            ipc.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            
            self.presentViewController(ipc, animated:true, completion:nil)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("memoryWarning")
        // Dispose of any resources that can be recreated.
    }
}

extension CreateIconViewController: DrawableViewDelegate {
    func onUpdateDrawableView() {
        
    }
    
    func onFinishSave() {
        /*let alertController = UIAlertController(title: "Saved!", message: "saved to camera roll.", preferredStyle: .Alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        self.presentViewController(alertController, animated: true, completion: {() -> Void in
        self.dismissViewControllerAnimated(true, completion: nil)
        })*/
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

extension CreateIconViewController: UIImagePickerControllerDelegate {
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        picker.dismissViewControllerAnimated(true, completion: nil)
        drawableView.setBackgroundImage(image)
    }
}

extension CreateIconViewController: UIPopoverPresentationControllerDelegate, UINavigationControllerDelegate {
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
}

extension CreateIconViewController: ColorPickerViewDelegate {
    func onColorChanged(newColor: UIColor) {
        self.setColorButton.backgroundColor = newColor
        drawableView.setLineColor(newColor.CGColor)
    }
}

