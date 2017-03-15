//
//  circleButton.swift
//  SwiftCircleButton
//
//  Created by chenxingwang on 2017/3/14.
//  Copyright © 2017年 chenxingwang. All rights reserved.
//

import UIKit
import QuartzCore

@IBDesignable
class circleButton: UIButton {
    
    //属性值1 设置按键百分比
    @IBInspectable open var circlePercent:Float = 0.8 {
        didSet {
            //
            setUpCircleView()
        }
    }
    //属性值2 按键颜色
    @IBInspectable open var circleColor :UIColor = UIColor(white: 0.9,alpha: 1) {
        didSet{
            circleView.backgroundColor = circleColor
        }
    }
    //属性值3 按键背景颜色
    @IBInspectable open var circleButtonColor :UIColor = UIColor(white: 0.95,alpha: 1) {
        didSet{
            circleButtonView.backgroundColor = circleButtonColor
        }
    }
    //属性值4 按键圆角值
    @IBInspectable open var buttonCornerRadiua: Float = 0{
        didSet{
            layer.cornerRadius = CGFloat(buttonCornerRadiua)
        }
    }
    
    @IBInspectable open var circleOverBounds: Bool = false
    @IBInspectable open var shadowCircleRadius: Float = 1
    @IBInspectable open var shadowCircleEnable: Bool = true //圆环阴影开启
    @IBInspectable open var trackTouchLocation: Bool = false//点击跟随
    @IBInspectable open var touchUpAinimationTime: Double = 0.6
    
    //按键显示界面
    let circleView = UIView()
    //按键背景
    let circleButtonView = UIView()
    
    fileprivate var tempShadowRadius : CGFloat = 0
    fileprivate var tempShadowAlpha : Float = 0
    fileprivate var touchCenterLocation: CGPoint?
    
    fileprivate var circleViewMask : CAShapeLayer?{
        get{
            if !circleOverBounds {
                let maskLayer = CAShapeLayer()
                maskLayer.path = UIBezierPath(roundedRect: bounds,cornerRadius: layer.cornerRadius).cgPath
                return maskLayer
            }else{
                return nil
            }
        }
    }
    //默认frame 为0
    convenience init(){
        self.init(frame:CGRect.zero)
    }
    
    fileprivate override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    fileprivate func setup(){
    
        setUpCircleView()
        circleButtonView.backgroundColor = circleButtonColor
        circleButtonView.frame = frame
        circleButtonView.addSubview(circleView)
        circleButtonView.alpha = 0
        addSubview(circleButtonView)
        
        layer.shadowRadius = 0
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowColor = UIColor(white:0.0,alpha:0.5).cgColor
    }
    
    fileprivate func setUpCircleView() {
        let size : CGFloat = bounds.width * CGFloat(circlePercent)
        let x: CGFloat = (bounds.width / 2) - (size/2)
        let y: CGFloat = (bounds.height / 2) - (size/2)
        let corner:CGFloat = size / 2
        
        circleView.backgroundColor = circleColor
        circleView.frame = CGRect(x:x,y:y,width:size,height:size)
        circleView.layer.cornerRadius = corner
    }
    
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        if trackTouchLocation {
            touchCenterLocation = touch.location(in: self)
        }else{
            touchCenterLocation = nil
        }
        
        UIView.animate(withDuration: 0.1, delay: 0, options: .allowUserInteraction, animations: { 
            self.circleButtonView.alpha = 1.0
        }, completion: nil)
        
        circleView.transform = CGAffineTransform(scaleX:0.5,y:0.5)
        
        UIView.animate(withDuration: 0.7, delay: 0, options: [.curveEaseOut,.allowUserInteraction], animations: { 
            self.circleView.transform = CGAffineTransform.identity
        }, completion: nil)
        
        if shadowCircleEnable {
            tempShadowRadius = layer.shadowRadius
            tempShadowAlpha = layer.shadowOpacity
            
            let shadowAnimation = CABasicAnimation(keyPath:"shadowRadius")
            shadowAnimation.toValue = shadowCircleRadius
            let opacityAnimation = CABasicAnimation(keyPath:"shadowOpacity")
            opacityAnimation.toValue = 1
            
            let groupAnimation = CAAnimationGroup()
            
            groupAnimation.duration = 0.7
            groupAnimation.fillMode = kCAFillModeForwards
            groupAnimation.isRemovedOnCompletion = false
            groupAnimation.animations = [shadowAnimation,opacityAnimation]
            
            layer.add(groupAnimation, forKey: "shadow")
        }
        return super.beginTracking(touch, with: event)
    }
    
    override func cancelTracking(with event: UIEvent?) {
        super.cancelTracking(with: event)
        animationToNormal()
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        super.endTracking(touch, with: event)
        animationToNormal()
    }
    
    fileprivate func animationToNormal() {
    
        UIView.animate(withDuration: 0.1, delay: 0, options: .allowUserInteraction, animations: { 
            self.circleButtonView.alpha = 1
        }) { (success:Bool) -> () in
            UIView.animate(withDuration: self.touchUpAinimationTime, delay: 0, options: .allowUserInteraction, animations: { 
                self.circleButtonView.alpha = 0
            }, completion: nil)
        }
        
        UIView.animate(withDuration: 0.7, delay: 0, options: [.curveEaseOut,.beginFromCurrentState,.allowUserInteraction], animations: {
            
            self.circleView.transform = CGAffineTransform.identity
            
            let shadowAnim = CABasicAnimation(keyPath:"shadowRadius")
            shadowAnim.toValue = self.tempShadowRadius
            
            let opacityAnim = CABasicAnimation(keyPath:"shadowOpacity")
            opacityAnim.toValue = self.tempShadowAlpha
            
            let groupAnim = CAAnimationGroup()
            groupAnim.duration = 0.7
            groupAnim.fillMode = kCAFillModeForwards
            groupAnim.isRemovedOnCompletion = false
            groupAnim.animations = [shadowAnim, opacityAnim]
            
            self.layer.add(groupAnim, forKey:"shadowBack")
            
        }, completion: nil)
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        setUpCircleView()
        
        if let knownTouchCenterLocation = touchCenterLocation {
            circleView.center = knownTouchCenterLocation
        }
        
        circleButtonView.layer.frame = bounds
        circleButtonView.layer.mask = circleViewMask
    }
}
