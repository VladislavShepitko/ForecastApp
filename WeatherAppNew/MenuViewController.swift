//
//  MenuViewController.swift
//  VCSlideDownAnimator
//
//  Created by Vladyslav Shepitko on 8/28/17.
//  Copyright © 2017 Vladyslav Shepitko. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    var menuItem = "menuCell"
    
    @IBOutlet weak var menu: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeMenu(){
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
}

extension MenuViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(menuItem, forIndexPath: indexPath)
        cell.imageView?.image = UIImage(named: "002-location")!
        cell.imageView?.contentMode = .ScaleAspectFit
        cell.textLabel?.text = "menu item"
        return cell
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
}
