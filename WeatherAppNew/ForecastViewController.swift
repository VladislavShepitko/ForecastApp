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
    
    private weak var cell:UICollectionViewCell?
    
    private var refreshControl:UIRefreshControl!
    private weak var refreshDelegate:RefreshControl!
    
    
    //MARK:- view controller functions
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //customize UI
        subscribeToSwipe()
        /*if let layout = self.forecast.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.sectionHeadersPinToVisibleBounds = true
        }*/
        
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
        //weatherService.updateWeather()
    }
    
    func loadRefreshControl(){
        //init refresh control
        let width:CGFloat = self.view.bounds.width
        let height:CGFloat = 100
        let refreshFrame = CGRect(x: 0, y: -height, width: width, height: height)
        self.refreshControl = UIRefreshControl(frame: refreshFrame)
        self.forecast.addSubview(refreshControl)
        
        let refreshContents = NSBundle.mainBundle().loadNibNamed(String(RefreshControl.self), owner: self, options: nil)
        self.refreshDelegate = refreshContents[0] as! RefreshControl
        refreshControl.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 150)
        self.refreshDelegate.frame = refreshControl.bounds
        self.refreshControl.addSubview(self.refreshDelegate)
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
    
    func subscribeToSwipe(){
        if revealViewController() != nil {
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {        
        //update refresh control
        let pullDistance = max(0.0, -self.refreshControl.frame.origin.y);
        self.refreshDelegate.updateProgress(self.refreshControl.bounds,pullDistance: pullDistance)
    }
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        //self.refreshControl.endRefreshing()
    }
    
    
    
    //MARK:- collectionViewDalegateFlowLayout properties
    private  let minimumInteritemSpacingForSection: CGFloat = 0.0
    private  let minimumLineSpacingForSection: CGFloat = 100.0
    
    
}

extension ForecastViewController {
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    override func prefersStatusBarHidden() -> Bool {
        return true
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
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ForecastCell", forIndexPath: indexPath)
        cell.alpha = 1
        self.cell = cell
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

