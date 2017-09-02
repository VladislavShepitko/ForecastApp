//
//  MenuBar.swift
//  YouTube
//
//  Created by Vladyslav Shepitko on 4/11/17.
//  Copyright © 2017 Vladyslav Shepitko. All rights reserved.
//

import UIKit

class MenuBar: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    lazy var collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.clearColor()
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    let cellIdentifier = "cellIdentifier"
    let numberOfSections = 3
    let imageNames = ["TODAY", "TOMOROW","10 DAYS"]
    weak var host:WeatherViewController?
    var horizontalBarLeftAnchorConstraint:NSLayoutConstraint?
    
    
    override func awakeFromNib(){
        super.awakeFromNib()
        setupView()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
    }
    func setupView()
    {
        addSubview(collectionView)
        addConstraintsWithFormat("H:|[v0]|", views: collectionView)
        addConstraintsWithFormat("V:|[v0]|", views: collectionView)
        collectionView.registerClass(MenuCellView.self, forCellWithReuseIdentifier: cellIdentifier)
        let indexPath = NSIndexPath(forItem: 0, inSection: 0)
        collectionView.selectItemAtIndexPath(indexPath, animated: false, scrollPosition: .None)
        setupHorizontalBar()
    }
    
    func setupHorizontalBar(){
        let horizontal = UIView()
        horizontal.backgroundColor = UIColor(white: 0.9, alpha: 1)
        horizontal.translatesAutoresizingMaskIntoConstraints = false
        addSubview(horizontal)
        
        horizontalBarLeftAnchorConstraint = horizontal.leftAnchor.constraintEqualToAnchor(self.leftAnchor)
        horizontalBarLeftAnchorConstraint?.active = true
        
        horizontal.bottomAnchor.constraintEqualToAnchor(self.bottomAnchor).active = true
        horizontal.widthAnchor.constraintEqualToAnchor(self.widthAnchor, multiplier: 1/CGFloat(self.numberOfSections)).active = true
        horizontal.heightAnchor.constraintEqualToConstant(4).active = true
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {        
        scrollTo(indexPath:indexPath)
        self.host?.scrollToMenuIndex(indexPath.item)
    }
    func scrollTo(indexPath indexPath:NSIndexPath){
        let x  = CGFloat(indexPath.item) * (frame.width / CGFloat(self.numberOfSections))
        print(indexPath.item)
        
        horizontalBarLeftAnchorConstraint?.constant = x
        UIView.animateWithDuration(0.75, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .CurveEaseOut, animations: { () -> Void in
            self.layoutIfNeeded()
            }, completion: nil)
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath) as! MenuCellView
        cell.title.text = imageNames[indexPath.row]
        cell.tintColor = UIColor.rgbColor(91, green: 14, blue: 13)
        return cell
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Int(numberOfSections)
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(frame.width / CGFloat(numberOfSections), self.frame.height)
    }
    
}

class MenuCellView: UICollectionViewCell {
    let title:UILabel = {
        let iv = UILabel()
        iv.tintColor = UIColor.rgbColor(91, green: 14, blue: 13)
        iv.font = UIFont(name: "Helvetica Neue", size: 16)
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    override var highlighted:Bool {
        didSet{
            title.tintColor = highlighted ? UIColor.whiteColor() : UIColor.rgbColor(91, green: 14, blue: 13)
        }
    }
    override var selected:Bool {
        didSet{
            title.tintColor = selected ? UIColor.whiteColor() : UIColor.rgbColor(91, green: 14, blue: 13)
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(){
        addSubview(title)
        
        addConstraint(NSLayoutConstraint(item: title, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: title, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1, constant: 0))
        
    }
}
