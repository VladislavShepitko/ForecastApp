//
//  MenuNavigationViewController.swift
//  WeatherAppNew
//
//  Created by Vladyslav Shepitko on 8/5/17.
//  Copyright © 2017 Vladyslav Shepitko. All rights reserved.
//

import UIKit

@available(iOS 9.0, *)
class MenuNavigationViewController: UINavigationController {

    let imageSet:[(ToggleImages,TapAction)] = {
        var arr:[(ToggleImages,TapAction)] = []
        arr.append((ToggleImages(UIImage(named: "004-shuffle-1")!,UIImage(named: "005-shuffle")!), {(sender)in print("shuffle")}))
        arr.append((ToggleImages(UIImage(named: "001-repeat-1")!,UIImage(named: "006-repeat")!), {(sender)in print("repeat")}))
        arr.append((ToggleImages(UIImage(named: "003-like-1")!,UIImage(named: "007-like")!), {(sender)in print("like")}))
        return arr
        }()
    
    lazy var menu:CBMenu = {
        let m = CBMenu(withDataSource: self, delegate: self)
        return m
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let rootView = self.view {
            rootView.addSubview(menu)
            rootView.addConstraintsWithFormat("V:|[V0(200)]", views: menu)
            rootView.addConstraintsWithFormat("H:|[V0(50)]", views: menu)
           
        }
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
         self.menu.setupView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
@available(iOS 9.0, *)
extension MenuNavigationViewController : CBMenuDataSource,CBMenuDelegate {
    func actionForSegment(at indexPath: NSIndexPath) -> TapAction {
        return imageSet[indexPath.item].1
    }
    func sizeForSegments() -> CGSize {
        return CGSize(width: 32, height: 32)
    }
    func sizeForMenuButton()->CGSize
    {
        return CGSize(width: 32, height: 32)
    }
    func imagesForMenuButtonStates() -> ToggleImages
    {
        return (UIImage(named: "008-mark-1")!,UIImage(named: "002-mark")!)
    }
    
    func numberOfSegments() -> Int
    {
        return imageSet.count
    }
    func imageForSegment(at indexPath:NSIndexPath) -> ToggleImages
    {
        return imageSet[indexPath.item].0
    }
}

