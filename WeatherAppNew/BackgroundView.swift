//
//  BackgroundView.swift
//  WheelView
//
//  Created by Vladyslav Shepitko on 7/24/17.
//  Copyright © 2017 Vladyslav Shepitko. All rights reserved.
//

import UIKit

typealias ConstraintTurple = (width:NSLayoutConstraint, height:NSLayoutConstraint)?
class BackgroundView: UIView {
    private(set) var expandedConstraints:ConstraintTurple
    private(set) var collapsedConstrains:ConstraintTurple
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    convenience init(withSuperView newView:UIView?){
        self.init(frame:CGRectZero)
        if let _newView = newView {
            print(_newView.subviews)
            if let firstView = _newView.subviews.first {
                _newView.insertSubview(self, belowSubview: firstView)
            }else {
                _newView.insertSubview(self, atIndex: 1)
            }
            self.translatesAutoresizingMaskIntoConstraints = false
            //self.layer.cornerRadius = _newView.frame.width / 2
            self.backgroundColor = UIColor.yellowColor()
            self.layer.masksToBounds = true

            let collWConst = self.widthAnchor.constraintEqualToAnchor(_newView.widthAnchor, multiplier: 0.1)
            let collHConst = self.heightAnchor.constraintEqualToAnchor(_newView.heightAnchor, multiplier: 0.1)
            self.collapsedConstrains = (width:collWConst, height:collHConst)
            
            let expWConst = self.widthAnchor.constraintEqualToAnchor(_newView.heightAnchor, multiplier: 1)
            let expHConst = self.heightAnchor.constraintEqualToAnchor(_newView.heightAnchor, multiplier: 1)
            self.expandedConstraints = (width:expWConst, height:expHConst)
            /*
            _newView.addConstraints([self.collapsedConstrains!.width,self.collapsedConstrains!.height])*/
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
    func collapse(){
        superview!.removeConstraints([self.expandedConstraints!.width,self.expandedConstraints!.height])
        superview!.addConstraints([self.collapsedConstrains!.width,self.collapsedConstrains!.height])
        superview!.layoutIfNeeded()
    }
    
    func expand(){
        superview!.removeConstraints([self.collapsedConstrains!.width,self.collapsedConstrains!.height])
        superview!.addConstraints([self.expandedConstraints!.width,self.expandedConstraints!.height])
        superview!.layoutIfNeeded()
    }
}
