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
        case Main
        case ForDay
        case Default
    }
    
    lazy var collectionView:UICollectionView! = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .Vertical
        let cv = UICollectionView(frame: CGRectZero, collectionViewLayout: layout)
        cv.dataSource = self
        cv.delegate = self
        return cv
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView?.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: WeatherCell.Default.rawValue)
        self.collectionView.registerClass(WeatherCollectionViewCell.self, forCellWithReuseIdentifier: WeatherCell.Main.rawValue)
        self.collectionView.registerClass(WeatherForDayCollectionViewCell.self, forCellWithReuseIdentifier: WeatherCell.ForDay.rawValue)
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.setupView()
    }
    
    func setupView(){
        self.view.addSubview(collectionView)
        collectionView.backgroundView = UIImageView(image: UIImage(named: "background"))
        self.view.addConstraintsWithFormat("H:|[v0]|", views: collectionView)
        self.view.addConstraintsWithFormat("V:|[v0]|", views: collectionView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

@available(iOS 9.0, *)
extension WeatherViewController:UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell:UICollectionViewCell
        switch indexPath.item {
        case 0:
            cell = collectionView.dequeueReusableCellWithReuseIdentifier(WeatherCell.Main.rawValue, forIndexPath: indexPath)
            break
        case 1:
            cell = collectionView.dequeueReusableCellWithReuseIdentifier(WeatherCell.ForDay.rawValue, forIndexPath: indexPath)
            cell.backgroundColor = UIColor.greenColor()
            break
        default :
            cell = collectionView.dequeueReusableCellWithReuseIdentifier(WeatherCell.Default.rawValue, forIndexPath: indexPath)
            
            cell.backgroundColor = UIColor.yellowColor()
            cell.alpha = 0.4
        }
        
        return cell
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 8
    }
    
}
@available(iOS 9.0, *)
extension WeatherViewController :UICollectionViewDelegateFlowLayout {
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        var size = CGSizeZero
        if indexPath.item == 0 {
            size = (self.view.superview?.bounds.size)!
        }else {
            size = CGSize(width: self.view.bounds.width, height: 200)
        }
        return size
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 1
    }
}

