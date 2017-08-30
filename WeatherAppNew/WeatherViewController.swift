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
    @IBOutlet weak var weatherRefreshView: UpdateWeatherBar!
    
    
    //MARK:- view controller functions
    override func viewDidLoad() {
        super.viewDidLoad()
        menu.host = self
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
        //menu?.scrollToItemAtIndexPath(indexPath, atScrollPosition: .None, animated: true)
    }
    /*
    var isFinger:Bool = false
    var halfSize:CGRect{
        let size = CGSize(width: pages.bounds.width / 4.0, height: pages.bounds.height / 4.0)
        return CGRect(origin: pages.bounds.origin, size: size)
    }
    var isRefresh = false
    @IBAction func pan(sender:UIPanGestureRecognizer){
        let progress = MenuHelper.calculateProcess(sender.translationInView(view), viewBounds: halfSize, direction: .Down )
        print("progress: \(progress)")
        switch sender.state{
        case .Began:
            isFinger = true
        case .Ended:
            isFinger = false
        case .Cancelled:
            isFinger = false
        default:
            break
        }
        
        print("is finger touched \(isFinger)")
        if progress > 0.15 && isFinger{
            let _progress = 1 - progress
            self.weatherRefreshView.alpha = _progress
            print("progress: \(_progress)")
            if _progress == 0 {
                isRefresh = true
                
            }
            
        }
        if !isFinger && !isRefresh {
            UIView.animateWithDuration(0.7, animations: { () -> Void in
                self.weatherRefreshView.alpha = 1
            })
        }
    }
    */
}



extension WeatherViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell:UICollectionViewCell!
        if indexPath.item == 2 {
            cell = collectionView.dequeueReusableCellWithReuseIdentifier("WeatherForecastCell", forIndexPath: indexPath)
        }else {
            cell = collectionView.dequeueReusableCellWithReuseIdentifier("WeatherDescriptionCell", forIndexPath: indexPath)
        }
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: self.pages.frame.width, height: self.pages.frame.height)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    
}

