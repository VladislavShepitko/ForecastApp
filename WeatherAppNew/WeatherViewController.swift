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
    
    private lazy var pageSize:CGSize = CGSize(width: self.pages.bounds.width, height: self.pages.bounds.height)
    
    //MARK:- view controller functions
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.barHideOnSwipeGestureRecognizer.addTarget(self, action: "updateFrame:")

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //NSNotificationCenter.defaultCenter().addObserverForName(, object: self, queue: <#T##NSOperationQueue?#>, usingBlock: <#T##(NSNotification) -> Void#>)
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    func updateFrame(sender:UIPanGestureRecognizer){
        print("current Size: \(pageSize)")
        print("bounds: \(self.view.frame)")
    }
}

extension WeatherViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("WeatherDescriptionCell", forIndexPath: indexPath)

        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return self.pageSize
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 1
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
}

