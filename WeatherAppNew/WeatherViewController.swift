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
        //setTitleForIndex(menuIndex)
    }
    
    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
    }
    enum Direction{
        case Up
        case Down
    }
    var touchStartPoint:CGPoint!
    @IBAction func pan(sender:UIPanGestureRecognizer){
        var direction:Direction = .Up
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
        let percent = offset.y / view.bounds.height
        print(percent)
        
        direction = offset.y < 0 ? .Down : .Up
        
        if direction == .Down {
            
        }
        
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

