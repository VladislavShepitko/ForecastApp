//
//  SettingsViewController.swift
//  WeatherAppNew
//
//  Created by Vladyslav Shepitko on 8/4/17.
//  Copyright © 2017 Vladyslav Shepitko. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.grayColor()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func dissmisVC(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}
