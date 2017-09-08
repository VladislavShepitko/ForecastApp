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

    
    private var viewModel:WeatherViewModel?
    private var weatherService = WeatherServiceWrapper.shared
    
    //MARK:- view controller functions
    override func viewDidLoad() {
        super.viewDidLoad()
        if let layout = self.forecast.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.sectionHeadersPinToVisibleBounds = true
            //it doesn't working
            layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 0)
        }
        
        
        updateModel(weatherService.weatherModel)
        /*
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
        weatherService.updateWeather()*/
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
    
    //MARK:- collectionViewDalegateFlowLayout properties

    private  let minimumInteritemSpacingForSection: CGFloat = 0.0
    private  let minimumLineSpacingForSection: CGFloat = 0.0
   
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        self.forecast.collectionViewLayout.invalidateLayout()
    }
    
}

extension ForecastViewController : UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        var view = UICollectionReusableView()
        if kind == UICollectionElementKindSectionHeader{
            view = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "HeaderIdentifier", forIndexPath: indexPath)
        }
        return view
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ForecastCell", forIndexPath: indexPath)
        return cell
    }
    
    
}

extension ForecastViewController: UICollectionViewDelegateFlowLayout{
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: self.forecast.frame.width, height: self.forecast.frame.height)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return minimumLineSpacingForSection
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return minimumInteritemSpacingForSection
    }
}

