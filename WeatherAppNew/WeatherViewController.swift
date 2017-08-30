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
    @IBOutlet weak var updateView: UpdateWeatherBar!
    
    
    //MARK:- view controller functions
    override func viewDidLoad() {
        super.viewDidLoad()
        menu.host = self
        updateView.anotherHeight = menu.getConstraint(with: "height")
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
        //setTitleForIndex(menuIndex)
    }
    
    func scrollViewDidScrollToTop(scrollView: UIScrollView) {
        print("asdasd")
    }
    
    @IBAction func pan(sender:UIPanGestureRecognizer){
        /*var direction:Direction = .Up
        var offset:CGPoint = CGPointZero
        switch sender.state {
        case .Began:
            touchStartPoint = sender.locationInView(view)
        case .Changed:
            let current = sender.locationInView(view)
            offset = CGPoint(x: abs(touchStartPoint.x - current.x), y: abs(touchStartPoint.y - current.y))
        default:
            break
        }
        print("start at: \(touchStartPoint)")
        print("now at: \(offset)")
        
        let percent = offset.y / pages.bounds.height
        
        print("percent: \(percent)")
        
        direction = offset.y < 0 ? .Down : .Up

        if direction == .Down {
            
        }*/
        //let progress = MenuHelper.calculateProcess(sender.translationInView(view), viewBounds: pages.bounds, direction: .Down)
        //updateView.progressView(progress) { () -> Void in
            
        //}
        //print("progress: \(progress)")
        //print("distance: \(progress * pages.bounds.height)")
        
    }
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

