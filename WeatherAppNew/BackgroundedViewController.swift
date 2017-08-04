//
//  BackgroundedViewController.swift
//  WeatherAppNew
//
//  Created by Vladyslav Shepitko on 8/4/17.
//  Copyright © 2017 Vladyslav Shepitko. All rights reserved.
//

import UIKit

class BackgroundedViewController: UIViewController {
    let backgroundImageView:UIImageView = {
        let imgView = UIImageView()
        
        return imgView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        /*self.view.addSubview(self.backgroundImageView)
        self.view.addConstraintsWithFormat("H:|[V0]|", views: backgroundImageView)
        self.view.addConstraintsWithFormat("V:|[V0]|", views: backgroundImageView)*/
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
