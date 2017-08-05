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
        
        self.collectionView?.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.setupView()
    }
    
    func setupView(){
        self.view.addSubview(collectionView)
        //collectionView.backgroundColor = UIColor.whiteColor()
        collectionView.backgroundView = UIImageView(image: UIImage(named: "4"))
        self.view.addConstraintsWithFormat("H:|[V0]|", views: collectionView)
        self.view.addConstraintsWithFormat("V:|[V0]|", views: collectionView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

@available(iOS 9.0, *)
extension WeatherViewController:UICollectionViewDelegate,UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath)
        
        cell.backgroundColor = UIColor.yellowColor()
        cell.alpha = 0.4
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

