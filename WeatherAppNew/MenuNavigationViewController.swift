//
//  MenuNavigationViewController.swift
//  WeatherAppNew
//
//  Created by Vladyslav Shepitko on 8/5/17.
//  Copyright © 2017 Vladyslav Shepitko. All rights reserved.
//

import UIKit

@available(iOS 9.0, *)
class MenuNavigationViewController: UINavigationController {
/*
    var topMenu:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.0, alpha: 0.9)
        return view
        }()*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
/*
        if let rootView = self.view {
            rootView.addSubview(topMenu)
            rootView.addConstraintsWithFormat("V:|[v0(55)]", views: topMenu)
            rootView.addConstraintsWithFormat("H:|[v0]|", views: topMenu)
        }*/
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
