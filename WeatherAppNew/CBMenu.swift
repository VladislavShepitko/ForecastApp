//
//  CBMenu.swift
//  WheelView
//
//  Created by Vladyslav Shepitko on 7/23/17.
//  Copyright © 2017 Vladyslav Shepitko. All rights reserved.
//

import UIKit
typealias ToggleImages = (active:UIImage, unactive:UIImage)
typealias TapAction  = ((sender:UIButton)->())?

enum CBMenuError : ErrorType {
    case AnimatorNullPointer
}


protocol CBMenuDataSource:class {
    func numberOfSegments() -> Int
    func imageForSegment(at indexPath:NSIndexPath) -> ToggleImages
    func actionForSegment(at indexPath:NSIndexPath) -> TapAction
}

protocol CBMenuDelegate:class {
    func sizeForSegments() -> CGSize
    func sizeForMenuButton()->CGSize
    func imagesForMenuButtonStates() -> ToggleImages
}

@available(iOS 9.0, *)
class CBMenu: UIView {
    
    var dataSource:CBMenuDataSource?
    var delegate:CBMenuDelegate?
    var animator:CBMenuAnimatorDelegate?
    
    lazy var backgroundView:UIView! = {
        let view = UIView()
        return view
        }()
    
    lazy var showHideButton:CBMenuItem! = {
        var images = (active:UIImage(), unactive:UIImage())
        if let _delegate = self.delegate {
            images = _delegate.imagesForMenuButtonStates()
        }
        let btn = CBMenuItem(active: images.active, unactive: images.unactive, destenation: self.origin, onTap: self.onTapShowHideButton)
        return btn
        }()
    
    
    lazy private(set) var segmentCount:Int = {
        guard let _dataSource = self.dataSource else {
            return 0
        }
        return _dataSource.numberOfSegments()
        }()
    
    lazy private(set) var container:UIView = {
        let view = UIView(frame: self.bounds)
        view.backgroundColor = UIColor.clearColor()
        return view
    }()
    
    lazy private(set) var segments:[CBMenuItem] = {
        var _segments:[CBMenuItem] = []
        
        if let _dataSource = self.dataSource {
            //create segments
            for item in 0..<self.segmentCount {
                let indexPath = NSIndexPath(forItem: item, inSection: 0)
                let images = _dataSource.imageForSegment(at: indexPath)
                
                var destenationPosition = CGPointZero
                if let _animator = self.animator {
                    destenationPosition = _animator.destenationPositionForSegment(self, at:indexPath)
                }
                
                let newSegment = CBMenuItem(active: images.active, unactive: images.unactive, destenation: destenationPosition, onTap: self.onTapSegment)
                newSegment.tag = item
               
                newSegment.frame = CGRect(origin: self.buttonOrigin, size: self.segmentSize)
                
                
                let w = newSegment.widthAnchor.constraintEqualToConstant(self.segmentSize.width)
                let h = newSegment.heightAnchor.constraintEqualToConstant(self.segmentSize.height)
                newSegment.addConstraints([w,h])
                
                _segments.append(newSegment)
            }
            
        }
        return _segments
        }()
    
    
    //segments parameters
    lazy private(set) var segmentSize:CGSize =  {
        guard let _delegate = self.delegate else {
            return CGSizeZero
        }
        return _delegate.sizeForSegments()
        }()
    
    
    lazy var origin:CGPoint = {
        //Для того что бы расчитать корректный центр объекта не зависимо от анкор поинта нужно:
        //расчитать ориджин поинт на основании ширины высоты и анкор поинта,
        //но так как оно найдет только верхний угол обьекта то нужно еще отнять половину ширины и высоты
        let pos = CGPointMake(self.bounds.size.width * self.layer.anchorPoint.x - self.segmentSize.width / 2.0, self.bounds.size.height * self.layer.anchorPoint.y - self.segmentSize.height / 2.0)
        //Ну а в итоге конвертировать из своей системы координат в родительскую
        let convertedPos = self.convertPoint(pos, toView: self.superview!)
        print("origin: \(pos)")
        
        print("conv origin: \(convertedPos)")
        
        return convertedPos
        }()
    lazy var buttonOrigin:CGPoint = {
        //Для того что бы расчитать корректный центр объекта не зависимо от анкор поинта нужно:
        //расчитать ориджин поинт на основании ширины высоты и анкор поинта,
        //но так как оно найдет только верхний угол обьекта то нужно еще отнять половину ширины и высоты
        //но так как оно найдет только верхний угол обьекта то нужно еще отнять половину ширины и высоты
        /*let pos = CGPointMake(self.showHideButton.bounds.size.width * self.showHideButton.layer.anchorPoint.x - self.showHideButton.bounds.width / 2.0, self.showHideButton.bounds.size.height * self.showHideButton.layer.anchorPoint.y - self.showHideButton.bounds.height / 2.0)*/
        
        let pos = CGPointMake(self.showHideButton.center.x  - self.showHideButton.bounds.width / 2.0, self.showHideButton.center.y - self.showHideButton.bounds.height / 2.0)
        //Ну а в итоге конвертировать из своей системы координат в родительскую
        let convertedPos = self.convertPoint(pos, toView: self.superview!)
        print("origin: \(pos)")
        
        print("conv origin: \(convertedPos)")
        
        return convertedPos
        }()
    
    //MARK:- menu parameters
    var isMenuExpanded:Bool = false
    
    var halfSize:CGSize{
        return CGSize(width: self.bounds.size.width / 2, height: self.bounds.size.height / 2)
    }
    var hideAnimationDelay:NSTimeInterval = 0
    //MARK:- initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = UIColor.clearColor()
    }
    
    convenience init(withDataSource dataSource:CBMenuDataSource,delegate: CBMenuDelegate, animator:CBMenuAnimatorDelegate = CBMenuLinearAnimator(), frame: CGRect = CGRectZero){
        self.init(frame: frame)
        self.dataSource = dataSource
        self.delegate = delegate
        self.animator = animator
    }
    
    //Call this method when datasource delegate and frame already initialized, and it can correctly calculate segment's destenation positions
    func setupView(){
        self.layoutIfNeeded()
        //createSegments()
        initializeAdditionlViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initializeAdditionlViews(){

        //add button to view and make it's constraints
        self.addSubview(showHideButton)
        var sizeForMenuButton = CGSize(width: 32, height: 32)
        if let _delegate = self.delegate {
            sizeForMenuButton = _delegate.sizeForMenuButton()
        }
        //make button's constraint
        //let buttonCenter = targetToSelfCenter(showHideButton)
        let buttonCenterX = showHideButton.centerXAnchor.constraintEqualToAnchor(self.centerXAnchor)
        let buttonY = showHideButton.topAnchor.constraintEqualToAnchor(self.topAnchor, constant: 20)
        
        let buttonWidth = showHideButton.widthAnchor.constraintEqualToConstant(sizeForMenuButton.width)
        let buttonHeight = showHideButton.heightAnchor.constraintEqualToConstant(sizeForMenuButton.height)
        self.addConstraints([buttonCenterX,buttonY,buttonWidth,buttonHeight])
        backgroundView.layer.anchorPoint = CGPoint(x: 0.5, y: 0.2)
        //backgroundView.backgroundColor = UIColor.whiteColor()
        backgroundView.frame = CGRectMake(0, 0, self.bounds.width, 0)
        //add background view to view and make it's constraints
        self.insertSubview(backgroundView, belowSubview: showHideButton)
        self.insertSubview(container, belowSubview: showHideButton)

        
        print("frame \(self.frame)")
    }
    
    //MARK:- segment's tap handler
    func onTapSegment(sender:UIButton){
        self.hideAnimationDelay = 1
        
        executeMenuAction()
        //delegate function
        if let _dataSource = self.dataSource {
            let indexPath = NSIndexPath(forItem: sender.tag, inSection: 0)
            if let action = _dataSource.actionForSegment(at: indexPath){
                action(sender:sender)
            }
        }
        print("tap on segment button")
    }
    func executeMenuAction(){
        if self.isMenuExpanded {
            //hide
            do {
                try self.hideSegments()
            }catch {
                print(error)
            }
        }else {
            //show
            do {
                try self.showSegments()
            }catch {
                print(error)
            }
        }
        self.isMenuExpanded = !self.isMenuExpanded
        

    }
    
    func onTapShowHideButton(sender:UIButton){
        self.hideAnimationDelay = 0
        executeMenuAction()
        print("tap on menu button")
    }
    
    //MARK:-  animation functions
    func showSegments() throws {
        guard let _animator = self.animator else {
            throw CBMenuError.AnimatorNullPointer
        }
        if let willAnimate = _animator.wilShowBackground {
            willAnimate(self, background: self.backgroundView)
        }
        let dict = NSDictionary(dictionary: ["delay":self.hideAnimationDelay])
        //UIView.animateWithDuration(0.4, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: [.AllowUserInteraction,.CurveEaseOut], animations: { () -> Void in
            //Here call delegates function
            if let animateBackground = _animator.showBackground{
                animateBackground(self, background: self.backgroundView,params:dict)
            }
        
            for (index, segment) in self.segments.enumerate() {
                let indexPath = NSIndexPath(forItem: index, inSection: 0)
                _animator.willShowSegment(self, at: indexPath, segment: segment)
                //perform show animation for each segment
                _animator.showSegment(self, at: indexPath, segment: segment,params:nil)
                if let didShow = _animator.didShowSegment{
                    didShow(self, at: indexPath, segment: segment)
                }
            }
            /*}) { (_) -> Void in
                //after all animations is complete we can call comletion func
                if let didShow = _animator.didShowBackground {
                    didShow(self, background: self.backgroundView)
                }
            }*/
                
        }
        
        func hideSegments()throws {
            guard let _animator = self.animator else {
                throw CBMenuError.AnimatorNullPointer
            }
            if let willAnimate = _animator.wilHideBackground {
                willAnimate(self, background: self.backgroundView)
            }
            let dict = NSDictionary(dictionary: ["delay":self.hideAnimationDelay])
            //UIView.animateWithDuration(0.4, delay:self.hideAnimationDelay, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: [.AllowUserInteraction,.CurveEaseOut], animations:  { () -> Void in
                //Here call delegates function
                if let animateBackground = _animator.hideBackground{
                    animateBackground(self, background: self.backgroundView,params:dict)
                }
            
            
                for (index, segment) in self.segments.enumerate() {
                    let indexPath = NSIndexPath(forItem: index, inSection: 0)
                    if let willHide = _animator.willHideSegment{
                        willHide(self, at: indexPath, segment: segment)
                    }                    
                    _animator.hideSegment(self, at: indexPath, segment: segment, params:dict)
                    if let didHide = _animator.didHideSegment{
                        didHide(self, at: indexPath, segment: segment)
                    }
                }
                /*}) { (_) -> Void in
                    //after all animations is complete we can call comletion func
                    if let didHide = _animator.didHideBackground {
                        didHide(self, background: self.backgroundView)
                    }
            }*/
            
        }
        
        
}

