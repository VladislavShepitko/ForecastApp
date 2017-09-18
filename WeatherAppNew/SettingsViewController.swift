//
//  SettingsViewController.swift
//  WeatherAppNew
//
//  Created by Vladyslav Shepitko on 8/4/17.
//  Copyright © 2017 Vladyslav Shepitko. All rights reserved.
//

import UIKit
enum SettingsID:String{
    case NotificationCell
    
    case NotificationFromTitleCell
    case NotificationFromCell
    
    case NotificationToTitleCell
    case NotificationToCell
    
    case TemperatureTitleCell
    case TemperatureCell
    
    case WindTitleCell
    case WindCell
    
    case LanguageTitleCell
    case LanguageCell
}


class SettingsViewController: UITableViewController {
    
    private weak var viewModel:SettingsViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel = WeatherServiceWrapper.shared.settings.model
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dissmisVC(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    /*
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        super.tableView(tableView, didSelectRowAtIndexPath: indexPath)
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        return cell
    }*/
    
    
}

