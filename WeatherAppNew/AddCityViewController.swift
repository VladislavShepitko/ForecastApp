//
//  AddCityViewController.swift
//  WeatherAppNew
//
//  Created by Vladyslav Shepitko on 8/19/17.
//  Copyright © 2017 Vladyslav Shepitko. All rights reserved.
//

import UIKit

class AddCityViewController: UIViewController {
    var searchBarView:UISearchBar = {
        let sb = UISearchBar()
        return sb
        }()
    var resultView:UITableView = {
        let tb = UITableView(frame: CGRectZero, style: UITableViewStyle.Plain)
        return tb
        }()
    
    private var isSearchingForCity:Bool = false
    private(set) var cityIsLoaded = false
    private weak var weatherService = AppDelegate.sharedApplication.weatherService
    
    private var result:[City] = []
    
    override func viewDidLoad() {
        addUIElements()
        super.viewDidLoad()
        if !(weatherService!.areCitiesLoaded){
            weatherService!.loadAllCities { (res) -> Void in
                if let _ = res {
                    self.cityIsLoaded = true
                }
                print("all cities are loaded")
            }
        }
        searchBarView.delegate = self
        resultView.delegate = self
        resultView.dataSource = self
        resultView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cityCell")
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleKeyboardAppear:", name: UIKeyboardDidShowNotification, object: nil)
    }
    
    func addUIElements(){
        self.view.backgroundColor = UIColor.whiteColor()
        
        self.view.addSubview(searchBarView)
        self.view.addSubview(resultView)
        
        self.view.addConstraintsWithFormat("V:|-70-[v0(30)][v1]|", views: searchBarView, resultView)
        self.view.addConstraintsWithFormat("H:|[v0]|", views: searchBarView)
        self.view.addConstraintsWithFormat("H:|[v0]|", views: resultView)
    }
    func handleKeyboardAppear(notification:NSNotification){
        if let userInfo = notification.userInfo {
            if let endFrame = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue {
                let frame = endFrame.CGRectValue()
                print(frame)
                let edgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: frame.height + 40, right: 0)
                resultView.contentInset = edgeInsets
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        weatherService?.allCities = nil
    }
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}
extension AddCityViewController: UISearchBarDelegate {
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String)
    {
        if !searchText.isEmpty && searchText.characters.count >= 2 {
            isSearchingForCity = true
            weatherService?.filterCitiestForRequest(forName: searchText, completion: { (res) -> Void in
                if let result = res {
                    self.result = result
                }else {
                    self.result = []
                }
                self.resultView.reloadData()
            })
            
        }else if self.result.count > 0 {
            self.result = []
            self.resultView.reloadData()
            //isSearchingForCity = false
        }
    }
    
}
extension AddCityViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete{
            weatherService?.removeCity(withIndex: indexPath.row)
            self.resultView.reloadData()
        }
    }
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return  true
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if isSearchingForCity {
            let resultCity = result[indexPath.row]
            searchBarView.resignFirstResponder()
            
            weatherService?.addCity(resultCity)
            navigationController?.popToRootViewControllerAnimated(true)
            print("close all")
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cityCell", forIndexPath: indexPath)
        if !isSearchingForCity {
            cell.textLabel?.text = weatherService?.cities[indexPath.row].name
        }else {
            cell.textLabel?.text = result[indexPath.row].name
        }
        
        return cell
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return !isSearchingForCity ? (weatherService?.cities.count)! :result.count
    }
}

