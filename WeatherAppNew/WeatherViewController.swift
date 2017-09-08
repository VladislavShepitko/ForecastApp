//
//  ViewController.swift
//  WeatherAppNew
//
//  Created by Vladyslav Shepitko on 8/4/17.
//  Copyright © 2017 Vladyslav Shepitko. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var pages: UICollectionView!
    @IBOutlet weak var menu: MenuBar!
    @IBOutlet weak var updateWeatherView: UpdateWeatherView!
    
    @IBOutlet weak var menuBtn: UIBarButtonItem!
    
    @IBOutlet weak var cityView: UILabel!
    @IBOutlet weak var timeView: UILabel!
    
    private var viewModel:WeatherViewModel?
    private var weatherService = WeatherServiceWrapper.shared
    
    //MARK:- view controller functions
    override func viewDidLoad() {
        super.viewDidLoad()
        addMenu()
        menu.host = self
        
        updateModel(weatherService.weatherModel)
        //handle service errors
        weatherService.error.subscribe {[unowned self] error in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                let vc = UIAlertController(title: "Error", message: error!, preferredStyle: .Alert)
                let closeAction = UIAlertAction(title: "Close", style: UIAlertActionStyle.Cancel, handler: nil)
                vc.addAction(closeAction)
                self.presentViewController(vc, animated: true, completion: nil)
            })
        }
        
        print("view did load")
        weatherService.updateWeather()
    }
    func updateModel(newModel:WeatherViewModel?){
        self.viewModel = newModel
        viewModel?.city.subscribe { value in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.cityView.text = value
            })
            
        }
        viewModel?.updateTime.subscribe { value in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
            self.timeView.text = value
            })
        }
        print("model updated")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.pages.collectionViewLayout.invalidateLayout()
    }
    func scrollToMenuIndex(menuIndex:Int){
        let indexPath = NSIndexPath(forItem: menuIndex, inSection: 0)
        pages?.scrollToItemAtIndexPath(indexPath, atScrollPosition: .None, animated: true)
        
    }
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let index = Int(round(scrollView.contentOffset.x / self.view.frame.width))
        let indexPath = NSIndexPath(forItem: index, inSection: 0)
        menu?.scrollTo(indexPath:indexPath)
    }
    @IBAction func updateWeather(sender: UIBarButtonItem) {
        updateWeatherView.show(){
            
        }
        
    }
    
    func addMenu(){
        if revealViewController() != nil {
            menuBtn.target = self.revealViewController()
            menuBtn.action = "revealToggle:"
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())

        }
    }
    
    //MARK:- collectionViewDalegateFlowLayout properties

    private  let minimumInteritemSpacingForSection: CGFloat = 0.0
    private  let minimumLineSpacingForSection: CGFloat = 0.0
   
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        self.pages.collectionViewLayout.invalidateLayout()
    }
    
}

extension WeatherViewController : UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if indexPath.item == 2 {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("WeatherForecastCell", forIndexPath: indexPath)
            return cell
        }else {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("WeatherDescriptionCell", forIndexPath: indexPath) as! DetailedWeatherCollectionViewCell
            cell.model = self.viewModel
            return cell
        }
    }
    
    
}

extension WeatherViewController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: self.pages.frame.width, height: self.pages.frame.height)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return minimumLineSpacingForSection
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return minimumInteritemSpacingForSection
        
    }
}

