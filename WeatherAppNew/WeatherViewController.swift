//
//  ViewController.swift
//  WeatherAppNew
//
//  Created by Vladyslav Shepitko on 8/4/17.
//  Copyright © 2017 Vladyslav Shepitko. All rights reserved.
//

import UIKit

@available(iOS 9.0, *)
class WeatherViewController: UICollectionViewController {
    let cellIdentifier = String(self)
    
    var backgroundView:UIView = {
        let view = UIImageView()
        view.image = UIImage(named: "background")
        return view
        }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //let layout = self.collectionView?.collectionViewLayout as! UICollectionViewFlowLayout
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView?.backgroundView = self.backgroundView
        self.collectionView?.registerClass(WeatherViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        self.view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        
        let menuButton =  UIButton(type: .System)
        menuButton.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
        menuButton.setImage(UIImage(named: "004-shuffle")!, forState: .Normal)
        menuButton.addTarget(self, action: "tap", forControlEvents: .TouchUpInside)
        
        self.navigationItem.leftBarButtonItem?.customView = menuButton
        
        self.navigationItem.title = "Kharkiv"
    }
    
    func tap(){
    
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.setupView()
    }
    
    func setupView(){
        self.view.addConstraintsWithFormat("H:|[v0]|", views: backgroundView)
        self.view.addConstraintsWithFormat("V:|[v0]|", views: backgroundView)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension WeatherViewController : UICollectionViewDelegateFlowLayout {
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
     override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath)
        cell.backgroundColor = UIColor.redColor()
        return cell
    }
    /*
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: self.view.frame.height - ((self.navigationController?.navigationBar.frame.height)! + 20))
    }*/
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    
}
