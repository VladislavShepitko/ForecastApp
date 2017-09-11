//
//  ViewController.swift
//  WeatherAppNew
//
//  Created by Vladyslav Shepitko on 8/4/17.
//  Copyright © 2017 Vladyslav Shepitko. All rights reserved.
//

import UIKit

class ForecastViewController: UIViewController {
    
    @IBOutlet weak var forecast: UICollectionView!
    
    //model parameters
    private var viewModel:WeatherViewModel?
    private var weatherService = WeatherServiceWrapper.shared
    
    private var refreshControl:RefreshControl!
    
    
    //MARK:- view controller functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //customize UI
        if revealViewController() != nil {
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        //register header for  collection view
        let nib = UINib(nibName: String(ForecastHeader.self), bundle: nil)
        self.forecast.registerNib(nib, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "HeaderIdentifier")
        
        //customize refresh control
        loadRefreshControl()
        
        //setup viewmodel
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
    
    func loadRefreshControl(){
        //init refresh control
        self.refreshControl = NSBundle.mainBundle().loadNibNamed(String(RefreshControl.self), owner: self, options: nil).first as! RefreshControl
        self.refreshControl.delegate = self
        self.forecast.addSubview(refreshControl)
    }
    
    func updateModel(newModel:WeatherViewModel?){
        self.viewModel = newModel
        /*viewModel?.city.subscribe { value in
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
        self.cityView.text = value
        })
        
        }
        viewModel?.updateTime.subscribe { value in
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
        self.timeView.text = value
        })
        }
        print("model updated")*/
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        //this is magic
        var offsetY = scrollView.contentOffset.y / (self.forecast.bounds.height)
        
        let index:Int = Int(offsetY)
        offsetY = -(CGFloat(index) - offsetY)
        offsetY = (1 - min( max(offsetY, 0.0), self.forecast.bounds.height)) - 0.25
        
        //if offsetY >= 0.9 {offsetY = 1}
        let indexPath = NSIndexPath(forItem: index, inSection: 0)
        if let cell = self.forecast.cellForItemAtIndexPath(indexPath) {
            cell.alpha = offsetY
        }
        self.updateHeader(offsetY + 0.25, forIndex:indexPath)
        
        //update refresh control
        if self.refreshControl.frame.origin.y <= 0 {
            let pullDistance = max(0.0, -self.refreshControl.frame.origin.y);
            self.refreshControl.updateProgress(pullDistance)
        }else {
            if self.refreshControl.refreshing {
                UIView.animateWithDuration(0.2, animations: {[unowned self] () -> Void in
                    self.refreshControl.endRefreshing()
                    })
            }
        }
        
    }
    var dates = ["now","today evening","midnight","tomorrow morning","wensterday","thurstday","suturday","sunday","monday","other day","other day","other day","other day"]
    
    lazy var header:ForecastHeader = {
        return self.forecast.supplementaryViewForElementKind(UICollectionElementKindSectionHeader, atIndexPath: NSIndexPath(forItem: 0, inSection: 0)) as! ForecastHeader
        }()
    
    func updateHeader(progress:CGFloat, forIndex index:NSIndexPath){
        print("offset:\(progress) for index: \(index.item)")
        
        header.updateTodayView(progress,data:dates[index.item])
 
    
    }
    
    //MARK:- collectionViewDalegateFlowLayout properties
    private let minimumInteritemSpacingForSection: CGFloat = 0.0
    private let minimumLineSpacingForSection: CGFloat = 100.0
    
}

extension ForecastViewController : RefreshDelegate
{
    func startUpdating(refreshControl: RefreshControl) {
        
        let delayInSeconds = 4.0;
        delay(delayInSeconds) { [unowned self] in
            self.refreshControl.stopRefreshing("Just now")
        }
        
    }
}

extension ForecastViewController {
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.forecast.collectionViewLayout.invalidateLayout()
    }
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        self.forecast.collectionViewLayout.invalidateLayout()
    }
}

extension ForecastViewController : UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        if let forecastCell = cell as? ForecastCell{
            forecastCell.detailsHeight.constant = ForecastCell.height
            forecastCell.detailsView.alpha = ForecastCell.alpha
        }
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let view = UICollectionReusableView()
        if kind == UICollectionElementKindSectionHeader{
            let view = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "HeaderIdentifier", forIndexPath: indexPath) as! ForecastHeader
            
            
            if revealViewController() != nil {
                view.menuButton.addTarget(self.revealViewController(), action: "revealToggle:", forControlEvents: .TouchUpInside)
            }
            return view
        }
        return view
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ForecastCell", forIndexPath: indexPath) as! ForecastCell
        
        //cell.alpha = 1
        
        return cell
    }
    
    
}

extension ForecastViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: self.forecast.frame.width, height: self.forecast.frame.height - 100)
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 100)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return minimumLineSpacingForSection
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return minimumInteritemSpacingForSection
    }
    
}

