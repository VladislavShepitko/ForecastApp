//
//  SettingSectionView.swift
//  NewMenu
//
//  Created by Vladyslav Shepitko on 8/13/17.
//  Copyright © 2017 Vladyslav Shepitko. All rights reserved.
//

import UIKit

class SettingSectionView: UIView {
    var settings:Item = {
        let btn = Item()
        btn.button.setImage(UIImage(named: "004-shuffle"), forState: .Normal)
        btn.title.text = "Settings"
        return btn
        }()
    var sendRespons:Item = {
        let btn = Item()
        btn.button.setImage(UIImage(named: "004-shuffle"), forState: .Normal)
        btn.title.text = "Send respons"
        return btn
        }()
    var likeApp:Item = {
        let btn = Item()
        btn.button.setImage(UIImage(named: "004-shuffle"), forState: .Normal)
        btn.title.text = "Like app"
        return btn
        }()
    var logo:UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        view.text = "SVApps \n All policy required"
        view.font = UIFont(name: "HelveticaNeue-Light", size: 13)
        view.textAlignment = .Center
        view.textColor = UIColor.whiteColor()
        return view
        }()

    
    
    var itemSize:CGSize! = CGSize(width: 50, height: 40)
    
    convenience init(withItemSize size:CGSize){
        self.init(frame:CGRectZero)
        //self.itemSize = size
    }
    override init(frame: CGRect) {
        super.init(frame:frame)
        addSubview(settings)
        addSubview(sendRespons)
        addSubview(likeApp)
        addSubview(logo)

        let startPos = CGPointZero
        settings.frame = CGRect(origin: startPos, size: self.itemSize)
        sendRespons.frame = CGRect(origin: CGPoint(x: settings.frame.origin.x, y: settings.frame.origin.y + self.itemSize.height), size: self.itemSize)
        likeApp.frame = CGRect(origin: CGPoint(x: sendRespons.frame.origin.x, y: sendRespons.frame.origin.y + self.itemSize.height), size: self.itemSize)
        
        logo.frame = CGRect(origin: CGPoint(x: likeApp.frame.origin.x, y: likeApp.frame.origin.y + self.itemSize.height), size: CGSize(width: 150, height: 30))
        
        addConstraintsWithFormat("V:|[v0(40)][v1(40)][v2(40)][v3]|", views: settings,sendRespons,likeApp,logo)
        addConstraintsWithFormat("H:|[v0(50)]", views: settings)
        addConstraintsWithFormat("H:|[v0(50)]", views: sendRespons)
        addConstraintsWithFormat("H:|[v0(50)]", views: likeApp)
        addConstraintsWithFormat("H:|[v0]|", views: logo)
        
        }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
