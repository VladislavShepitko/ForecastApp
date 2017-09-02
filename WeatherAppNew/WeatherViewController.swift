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
    @IBOutlet weak var updateWeatherView: UpdateWeatherView!
    
    var model:WeatherViewModel?
    let interactor = Interactor()
    
    //MARK:- view controller functions
    override func viewDidLoad() {
        super.viewDidLoad()
        menu.host = self
        
        model = WeatherViewModel()
        
        model?.currentWeaher?.subscribe({ [weak self] newWeather in
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                self?.pages.reloadData()
            })
        })
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
        
    }
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let index = Int(round(scrollView.contentOffset.x / self.view.frame.width))
        let indexPath = NSIndexPath(forItem: index, inSection: 0)
        menu?.scrollTo(indexPath:indexPath)
    }
    @IBAction func updateWeather(sender: UIBarButtonItem) {
        updateWeatherView.show()
        UIView.animateWithDuration(0.6) { () -> Void in
            self.pages.collectionViewLayout.invalidateLayout()
        }
    }
    @IBAction func showMenuAction(sender: AnyObject) {
        performSegueWithIdentifier("showMenu", sender: nil)
    }
    @IBAction func edgePanGesture(sender:UIScreenEdgePanGestureRecognizer){
        let translation = sender.translationInView(view)
        
        
        let progress = MenuHelper.calculateProcess(translation, viewBounds: view.bounds, direction: .Right)
        
        MenuHelper.mapGestureStateToInteractor(sender.state, progress: progress, interactor: interactor) { () -> Void in
            self.performSegueWithIdentifier("showMenu", sender: nil)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let destenationVC = segue.destinationViewController as? MenuViewController{
            destenationVC.transitioningDelegate = self
            destenationVC.interactor = interactor
        }
    }
}

extension WeatherViewController:UIViewControllerTransitioningDelegate {
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return PresentMenuAnimator()
    }
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DismissMenuAnimator()
    }
    
    func interactionControllerForDismissal(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor.hasStarted ? interactor: nil
    }
    
    func interactionControllerForPresentation(animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor.hasStarted ? interactor: nil
    }
}
extension WeatherViewController : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if indexPath.item == 2 {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("WeatherForecastCell", forIndexPath: indexPath)
            return cell
        }else {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("WeatherDescriptionCell", forIndexPath: indexPath) as! DetailedWeatherCollectionViewCell
            cell.weather = self.model?.currentWeaher?.value?.main
            
            return cell
        }
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

