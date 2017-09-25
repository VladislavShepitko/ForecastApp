//
//  ViewController.swift
//  WeatherAppNew
//
//  Created by Vladyslav Shepitko on 8/4/17.
//  Copyright © 2017 Vladyslav Shepitko. All rights reserved.
//

import UIKit
import CoreLocation
import PullToRefresh

class ForecastViewController: UIViewController {
    
    @IBOutlet weak var forecast: UICollectionView!
    @IBOutlet weak var cityBackgroundView: UIImageView!
    
    
    //model parameters
    private weak var viewModel:WeatherViewModel?
    private var weatherService = WeatherServiceWrapper.shared
    private var refreshControl:PullToRefresh!
    private var atFirstTime = true
    
    //MARK:- view controller functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //customize UI
        if revealViewController() != nil {
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        //register header for collection view
        let nib = UINib(nibName: String(ForecastHeader.self), bundle: nil)
        self.forecast.registerNib(nib, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "HeaderIdentifier")
    
        //customize refresh control
        loadRefreshControl()
        
        //setup viewmodel
        weatherService.viewModel.subscribe { [unowned self] model in
            dispatch_async(dispatch_get_main_queue(), { _ in
                self.viewModel = model!
                if let _ = self.viewModel{
                    
                    //self.refreshControl.endRefreshing()
                    self.forecast.endRefreshing(at: .Top)
                    self.forecast.reloadData()
                    print("model is updated")
                }else {
                    self.showErrorView()
                }
            })
        }
        
        //handle service errors
        weatherService.error.subscribe {[unowned self] error in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                let vc = UIAlertController(title: "Error", message: error!, preferredStyle: .Alert)
                let closeAction = UIAlertAction(title: "Close", style: UIAlertActionStyle.Cancel, handler: nil)
                vc.addAction(closeAction)
                self.forecast.endRefreshing(at: .Top)
                self.presentViewController(vc, animated: true, completion: nil)
            })
        }
        
    }
    func showErrorView(){
        print("error")
    }
    
    func loadRefreshControl(){
        //init refresh control
        /*
        self.refreshControl = NSBundle.mainBundle().loadNibNamed(String(RefreshControl.self), owner: self, options: nil).first as! RefreshControl
        self.refreshControl.delegate = self*/
        refreshControl = PullToRefresh()
        self.forecast.addPullToRefresh(refreshControl) { () -> () in
            self.weatherService.updateWeatherWithLocation()
        }
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
            var alpha = offsetY
            if (offsetY + 0.25) == 1 {
                alpha = 1
            }
            cell.alpha = alpha
        }
        /*
        //update refresh control
        if self.refreshControl.frame.origin.y <= 0 {
            let pullDistance = max(0.0, -self.refreshControl.frame.origin.y);
            self.refreshControl.updateProgress(pullDistance)
        }else {
            if self.refreshControl.refreshing {
                self.refreshControl.stopRefreshing()                
            }
        }
        */
    }
    
    private weak var header:ForecastHeader?
    //MARK:- collectionViewDalegateFlowLayout properties
    private let minimumInteritemSpacingForSection: CGFloat = 0.0
    private let minimumLineSpacingForSection: CGFloat = 100.0
    
}
/*
extension ForecastViewController : RefreshDelegate
{
    
    func startUpdating(refreshControl: RefreshControl) {
        refreshControl.updateText(viewModel?.updateTime ?? "")
        /*weatherService.updateWeather(){[unowned refreshControl, unowned self] in
            refreshControl.stopRefreshing(self.viewModel?.updateTime ?? "")
        }*/
        //weatherService.updateWeatherWithLocation()
    }
    
    private func animateRefreshControl(){
        self.refreshControl.refreshManually()
        weatherService.updateWeatherWithLocation()
    }
    
}
*/
extension ForecastViewController {
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        updateRefreshControl()
    }
    
    func updateRefreshControl(){
        if atFirstTime || Preffrences.shared.needUpdate {
            forecast.startRefreshing(at: .Top)
            self.atFirstTime = false
            Preffrences.shared.needUpdate = false
        }
    }
    
    //when view will appear we start update weather
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.forecast.removePullToRefresh(refreshControl)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.forecast.collectionViewLayout.invalidateLayout()
    } 
}

extension ForecastViewController : UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let model = self.viewModel{
            return model.forecastForToday.count
        } else {
            return 0
        }
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
            self.header = view
            return view
        }
        return view
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ForecastCell", forIndexPath: indexPath) as! ForecastCell
        //update header
        let model = self.viewModel!
        let forecastData = model.forecastForToday[indexPath.item]
        
        if let header = self.header {
            header.cityView.text = model.cityName
            header.locationIcon.image = model.isCurrentLocation ? UIImage(named: "location"): nil
            header.todayView.text = forecastData.today
            header.dateView.text = forecastData.date
        }
        //update View
        cell.model = forecastData
        
        return cell
    }
    
    
}

extension ForecastViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: self.forecast.frame.width, height: self.forecast.frame.height - minimumLineSpacingForSection)
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.view.frame.width, height: minimumLineSpacingForSection)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return minimumLineSpacingForSection
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return minimumInteritemSpacingForSection
    }
    
}

