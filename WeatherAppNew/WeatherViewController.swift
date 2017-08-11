//
//  ViewController.swift
//  WeatherAppNew
//
//  Created by Vladyslav Shepitko on 8/4/17.
//  Copyright © 2017 Vladyslav Shepitko. All rights reserved.
//

import UIKit

@available(iOS 9.0, *)
class WeatherViewController: UIViewController {
    enum WeatherCell:String {
        case Header
        case Main
        case ForDay
        case Default
        case ForWeak
        case DetailedForToday
    }
    
    lazy var collectionView:UICollectionView! = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .Vertical
        layout.sectionHeadersPinToVisibleBounds = true
        let cv = UICollectionView(frame: CGRectZero, collectionViewLayout: layout)
        cv.showsVerticalScrollIndicator = false
        cv.dataSource = self
        cv.delegate = self
        return cv
        }()
    
    weak var headerView:UICollectionReusableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.registerClass(WeatherHeaderSectionReusableView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: WeatherCell.Header.rawValue)
        
        self.collectionView?.registerClass(BaseWeatherCollectionViewCell.self, forCellWithReuseIdentifier: WeatherCell.Default.rawValue)
        self.collectionView.registerClass(WeatherCollectionViewCell.self, forCellWithReuseIdentifier: WeatherCell.Main.rawValue)
        self.collectionView.registerClass(WeatherForDayCollectionViewCell.self, forCellWithReuseIdentifier: WeatherCell.ForDay.rawValue)
        self.collectionView.registerClass(WeatherForWeakCollectionViewCell.self, forCellWithReuseIdentifier: WeatherCell.ForWeak.rawValue)
        self.collectionView.registerClass(DetailedWeatherCollectionViewCell.self, forCellWithReuseIdentifier: WeatherCell.DetailedForToday.rawValue)
        
        
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.setupView()
    }
    
    func setupView(){
        self.view.addSubview(collectionView)
        collectionView.backgroundView = UIImageView(image: UIImage(named: "background"))
       
        //visualEffectView.frame = (AppDelegate.sharedApplication.window?.bounds)!
        //collectionView.backgroundView?.addSubview(visualEffectView)
        
        self.view.addConstraintsWithFormat("H:|[v0]|", views: collectionView)
        self.view.addConstraintsWithFormat("V:|[v0]|", views: collectionView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

@available(iOS 9.0, *)
extension WeatherViewController:UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell:UICollectionViewCell
        switch indexPath.item {
        case 0:
            cell = collectionView.dequeueReusableCellWithReuseIdentifier(WeatherCell.Main.rawValue, forIndexPath: indexPath)
            break
        case 1:
            cell = collectionView.dequeueReusableCellWithReuseIdentifier(WeatherCell.ForDay.rawValue, forIndexPath: indexPath)
            break
        case 2:
            cell = collectionView.dequeueReusableCellWithReuseIdentifier(WeatherCell.ForWeak.rawValue, forIndexPath: indexPath)
            break
        case 3:
            cell = collectionView.dequeueReusableCellWithReuseIdentifier(WeatherCell.DetailedForToday.rawValue, forIndexPath: indexPath)
            break
        default :
            cell = collectionView.dequeueReusableCellWithReuseIdentifier(WeatherCell.Default.rawValue, forIndexPath: indexPath)
            
        }
        
        return cell
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        var view = UICollectionReusableView()
        if indexPath.item == 0 {
            if kind == UICollectionElementKindSectionHeader {
                view = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: WeatherCell.Header.rawValue, forIndexPath: indexPath)
                self.headerView = view
            }
        }
        return view
    }
    
    
}

@available(iOS 9.0, *)
extension WeatherViewController :UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        var size = CGSizeZero
        if indexPath.item == 0 {
            size =  CGSize(width: self.view.bounds.width, height: self.view.bounds.height - 50)
        }else {
            size = CGSize(width: self.view.bounds.width - 5, height: 200)
        }
        return size
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.view.bounds.width, height: 50)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 2.5
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let offset = Double(scrollView.contentOffset.y / self.view.bounds.height)
        let opacity = CGFloat(offset.clamp(0, maxValue: 1))
        //self.visualEffectView.alpha = opacity
        self.headerView.backgroundColor = UIColor(white: 0.1, alpha: opacity)
        //collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "header", forIndexPath: NSIndexPath(forItem: 0, inSection: 0))
        //AppDelegate.sharedApplication.navigationVC.topMenu.alpha = opacity
        //print("offset: \(offset.clamp(0, maxValue: 1))")
    }
}

