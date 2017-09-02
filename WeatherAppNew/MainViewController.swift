//
//  ViewController.swift
//  VCSlideDownAnimator
//
//  Created by Vladyslav Shepitko on 8/3/17.
//  Copyright © 2017 Vladyslav Shepitko. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    let interactor = Interactor()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func openMenu(sender:AnyObject){
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
extension MainViewController:UIViewControllerTransitioningDelegate {
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
