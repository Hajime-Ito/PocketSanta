//
//  FlyerDetailPageViewController.swift
//  PocketSanta
//
//  Created by hajime ito on 2019/12/25.
//  Copyright © 2019 hajime. All rights reserved.
//

import UIKit

class FlyerDetailPageViewController: UIPageViewController {
    
    var flyerdata: FlyerData!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setViewControllers([getFirst()], direction: .forward, animated: true, completion: nil)
        self.dataSource = self
        
    }
    
    func getFirst() -> FlyerDetailViewController {
        return storyboard!.instantiateViewController(withIdentifier: "FlyerDetailInfoView") as!FlyerDetailViewController
    }
    func getSecond() -> FlyerDetailMapViewController {
        return storyboard!.instantiateViewController(withIdentifier: "FlyerDetailMapView") as! FlyerDetailMapViewController
    }
    
}

extension FlyerDetailPageViewController : UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if viewController.isKind(of: FlyerDetailMapViewController.self) {
            // 2 -> 1
            return getFirst()
        }else{
            // 1 -> end of the road
            return nil
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if viewController.isKind(of: FlyerDetailViewController.self) {
            // 1 -> 2
            return getSecond()
        }else{
            // 2 -> end of the road
            return nil
        }
    }
    
}
