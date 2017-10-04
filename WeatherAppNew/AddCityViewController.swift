//
//  AddCityViewController.swift
//  WeatherAppNew
//
//  Created by Vladyslav Shepitko on 8/19/17.
//  Copyright © 2017 Vladyslav Shepitko. All rights reserved.
//

import UIKit

class AddCityViewController: UIViewController {
 
    @IBOutlet weak var searchBarView: UISearchBar!
    @IBOutlet weak var resultView: UITableView!
    
    private var isSearchingForCity:Bool = false
    private weak var weatherService = WeatherServiceWrapper.shared
    
    @IBOutlet weak var updateIndicator: UIActivityIndicatorView!
    private lazy var citiesService:CitiesService = {
        let service = CitiesService()
        service.delegate = self
        return service
        }()
    
    override func viewDidLoad() {
        //addUIElements()
        super.viewDidLoad()
        
        if !citiesService.areLoaded {
            self.citiesService.loadSities()
        }
        updateIndicator.hidden = true
        resultView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cityCell")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       // weatherService?.allCities = nil
    }
    
    @IBAction func dissmisVC(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
extension AddCityViewController{
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleKeyboardAppear:", name: UIKeyboardDidShowNotification, object: nil)
        updateIndicator.startAnimating()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
        self.citiesService.CleanAll()
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
}

extension AddCityViewController : CitiesServiceDelegate {
    func citiesDidLoad(citiesService:CitiesService?, cities:[City]?)
    {
        print("cities are loaded")
        resetUpdateAnimator()
    }
    func citiesDidFetched(citiesService:CitiesService?, cities:[City]?, forName name:String)
    {
        //print("for:\(name) result:  \(cities)")
        //stop indicator animatin
        updateIndicator.stopAnimating()
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            self.resultView.reloadData()
        }
    }
    func resetUpdateAnimator(){
        
        updateIndicator.stopAnimating()
        updateIndicator.hidden = true
    }
}


extension AddCityViewController: UISearchBarDelegate {
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String)
    {
        if !searchText.isEmpty && searchText.characters.count >= 2 {
            isSearchingForCity = true
            citiesService.filterCityByName(cityName: searchText)
            if !updateIndicator.isAnimating() {
                updateIndicator.tintColor = UIColor.grayColor()
                updateIndicator.startAnimating()
                
            }
            //start indicator animation
         }else if searchText.isEmpty {
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                self.citiesService.CleanFiltered()
                self.resultView.reloadData()
                self.isSearchingForCity = false
                self.searchBarView.endEditing(true)
            }
        }
    }
    
}

extension AddCityViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete{
            Preffrences.shared.cities.removeAtIndex(indexPath.row)
            self.resultView.reloadData()
        }
    }
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return  true
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if isSearchingForCity {
            let resultCity = citiesService.filteredCities?[indexPath.row]
            searchBarView.resignFirstResponder()
            
            Preffrences.shared.cities.append(resultCity!)
            self.isSearchingForCity = false
            self.citiesService.CleanFiltered()
            self.resultView.reloadData()
            resetUpdateAnimator()
            print("close all")
        }
        self.searchBarView.text = ""
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cityCell", forIndexPath: indexPath)
        if !isSearchingForCity {
            cell.textLabel?.text = Preffrences.shared.cities[indexPath.row].name
        }else {
            cell.textLabel?.text = citiesService.filteredCities?[indexPath.row].name
        }
        
        return cell
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return !isSearchingForCity ? Preffrences.shared.cities.count : citiesService.filteredCities?.count ?? 0
    }
}
