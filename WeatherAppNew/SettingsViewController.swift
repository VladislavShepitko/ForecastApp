//
//  SettingsViewController.swift
//  WeatherAppNew
//
//  Created by Vladyslav Shepitko on 8/4/17.
//  Copyright © 2017 Vladyslav Shepitko. All rights reserved.
//

import UIKit
enum SettingsID:String {
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
    
    //private weak var viewModel:SettingsViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.viewModel = WeatherServiceWrapper.shared.settings.model
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func dissmisVC(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func clearCacheAction(){
        cleanCache()
    }
    func cleanCache(){
        let action = UIAlertController(title: "", message: "Do you really want to claen cache?", preferredStyle: .Alert)
        let yesAction = UIAlertAction(title: "YES", style: .Default) { _ in
            Preffrences.shared.cleanCache()
        }
        let noAction = UIAlertAction(title: "NO", style: .Cancel, handler: nil)
        action.addAction(yesAction)
        action.addAction(noAction)
        self.presentViewController(action, animated: true, completion: nil)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.section == 2 && indexPath.row == 0 {
           cleanCache()
        }
        
    }
    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
        
        return cell
    }*/
    /*
    override func prefersStatusBarHidden() -> Bool {
        return true
    }*/
    
}

