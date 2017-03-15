//
//  ViewController.swift
//  SwiftCircleButton
//
//  Created by chenxingwang on 2017/3/14.
//  Copyright © 2017年 chenxingwang. All rights reserved.
//

import UIKit
let kScreenHeight = UIScreen.main.bounds.size.height
let kScreenWidth = UIScreen.main.bounds.size.width

class ViewController: UIViewController {
    @IBOutlet weak var showViewAction: circleButton!
    var popView = UIView()
    var isShow:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showViewAction.layer.cornerRadius = 4
        showViewAction.layer.masksToBounds = true
        // Do any additional setup after loading the view, typically from a nib.
        
    }

    @IBAction func showView(_ sender: Any) {
        if self.isShow == false{
            if self.popView.frame.size.width != 0 {
                self.popView.removeFromSuperview()
            }
            setUpPopView()
            showPopView()
            self.isShow = !isShow
        }else{
            dismissPopView()
            self.isShow = !isShow
        }
        
    }
    
    fileprivate func setUpPopView(){
        self.popView = UIView(frame:CGRect(x:60,y:300,width:kScreenWidth - 120,height:kScreenWidth/20))
        self.popView.backgroundColor = UIColor.cyan
        self.popView.layer.cornerRadius = 5
        self.popView.layer.masksToBounds = true
        self.view.addSubview(self.popView)
    }
    
    fileprivate func showPopView(){
        UIView.animate(withDuration: 0.25, delay: 0.05, options: UIViewAnimationOptions.curveEaseInOut, animations: { () -> Void in
            
            self.popView.frame = CGRect.init(origin: CGPoint.init(x: 60, y: 100), size: CGSize.init(width: kScreenWidth - 120, height: kScreenWidth/3*2))
            
        }) { (Bool) in
        }
    }
    
    fileprivate func dismissPopView(){
        
        print("dismiss")
        UIView.animate(withDuration: 0.25, delay: 0, options: UIViewAnimationOptions.curveEaseInOut, animations: { () -> Void in
            
            self.popView.frame = CGRect.init(origin: CGPoint.init(x: 60, y: 300), size: CGSize.init(width: kScreenWidth - 120, height: kScreenWidth/20))
                        
        }) { (Bool) in
            self.popView.removeFromSuperview()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

