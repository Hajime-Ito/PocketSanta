//
//  FlyerDetailPageViewController.swift
//  PocketSanta
//
//  Created by hajime ito on 2019/12/25.
//  Copyright © 2019 hajime. All rights reserved.
//

import UIKit

class FlyerDetailPageViewController: UIPageViewController  {
    
    var flyerdata: FlyerData!
    var FlyerDetailPageViewDataSource =  FlyerDetailPageViewDataSourceController()
    var FlyerVC: FlyerViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FlyerDetailPageViewDataSource.FlyerDetailPageView = self
        self.setViewControllers([getFirst()], direction: .forward, animated: true, completion: nil)
        self.dataSource =  FlyerDetailPageViewDataSource
    }
    
    func getFirst() -> FlyerDetailViewController {
        let next = storyboard!.instantiateViewController(withIdentifier: "FlyerDetailInfoView") as!FlyerDetailViewController
        next.delegate1 = FlyerVC
        next.flyerdata = self.flyerdata
        return next
    }
    
    func getSecond() -> FlyerDetailMapViewController {
        let next = storyboard!.instantiateViewController(withIdentifier: "FlyerDetailMapView") as! FlyerDetailMapViewController
        next.flyerdata = self.flyerdata
        return next
    }
    
    func getThird() -> FlyerDetailImageViewController {
        let next = storyboard!.instantiateViewController(withIdentifier: "FlyerDetailImageView") as! FlyerDetailImageViewController
        next.image = self.flyerdata.getImage()
        return next
    }
    
}


class FlyerDetailPageViewDataSourceController : NSObject, UIPageViewControllerDataSource {
    
    var FlyerDetailPageView: FlyerDetailPageViewController!
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if viewController.isKind(of: FlyerDetailImageViewController.self) {
            // 3 -> 2
            return FlyerDetailPageView.getSecond()
        }else if viewController.isKind(of: FlyerDetailMapViewController.self) {
            // 2 -> 1
            return FlyerDetailPageView.getFirst()
        }else {
            // 1 -> end of the road
            return nil
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if viewController.isKind(of: FlyerDetailViewController.self) {
            // 1 -> 2
            return FlyerDetailPageView.getSecond()
        }else if  viewController.isKind(of: FlyerDetailMapViewController.self){
            // 2 -> 3
            return FlyerDetailPageView.getThird()
        } else {
            // 3 -> end of the road
            return nil
        }
    }
    
}
