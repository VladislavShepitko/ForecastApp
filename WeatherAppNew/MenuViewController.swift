//
//  MenuViewController.swift
//  VCSlideDownAnimator
//
//  Created by Vladyslav Shepitko on 8/28/17.
//  Copyright © 2017 Vladyslav Shepitko. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
<<<<<<< HEAD
    let menuItem = "menuCell"
    let preffrences = Preffrences.shared
=======
    var menuItem = "menuCell"
>>>>>>> dadada
    
    @IBOutlet weak var menu: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
<<<<<<< HEAD
        
        menu.layer.masksToBounds = false
        menu.layer.shadowOffset = CGSize(width: -1, height: 1)
        menu.layer.shadowRadius = 1
        menu.layer.shadowOpacity = 0.5
=======
        // Do any additional setup after loading the view, typically from a nib.
>>>>>>> dadada
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeMenu(){
        dismissViewControllerAnimated(true, completion: nil)
    }
    
<<<<<<< HEAD
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.menu.reloadData()
    }
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    @IBAction func onSettingsTap(sender: AnyObject) {
        performSegueWithIdentifier("showSettingsSeque", sender: self)
        //delay(0.2) { [unowned self] in
            if self.revealViewController() != nil {
                self.revealViewController().revealToggle(true)
            }
        //}
        
    }
    @IBAction func onRatingTap(sender: AnyObject) {
        if revealViewController() != nil {
            self.revealViewController().revealToggle(true)
        }
    }
    @IBAction func onMessageTap(sender: AnyObject) {
        if revealViewController() != nil {
            self.revealViewController().revealToggle(true)
        }
    }
    @IBAction func onAddCityTap(sender: AnyObject) {
        if revealViewController() != nil {
            self.revealViewController().revealToggle(true)
        }
        performSegueWithIdentifier("addCitySegue", sender: self)        
    }
=======
    
>>>>>>> dadada
}

extension MenuViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(menuItem, forIndexPath: indexPath)
<<<<<<< HEAD
        let city = preffrences.cities[indexPath.item]
        
        cell.imageView?.image = city.isCurrentLocation ? UIImage(named: "location")! : UIImage(named: "locationMark")! 
        cell.imageView?.contentMode = .ScaleAspectFit
        
        cell.textLabel?.text = city.name.uppercaseString
        return cell
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return preffrences.cities.count
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.preffrences.currentCityIndex = preffrences.cities[indexPath.item].id
        if revealViewController() != nil {
            WeatherServiceWrapper.shared.fetchWeatherForCity(withID: indexPath.item)
            self.revealViewController().revealToggle(true)
        }
=======
        cell.imageView?.image = UIImage(named: "002-location")!
        cell.imageView?.contentMode = .ScaleAspectFit
        cell.textLabel?.text = "menu item"
        return cell
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
>>>>>>> dadada
    }
}
