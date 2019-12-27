//
//  FlyerCreateViewController.swift
//  PocketSanta
//
//  Created by はじめ on 2019/12/27.
//  Copyright © 2019 hajime. All rights reserved.
//

import UIKit

class FlyerCreateViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
         setSwipeBack()
    }
}

extension UIViewController {
    // スワイプで戻れるように設定
    // 参考：https://qiita.com/son_s/items/cb35bcff9d133cfa1f5d
    func setSwipeBack() {
        let target = self.navigationController?.value(forKey: "_cachedInteractionController")
        let recognizer = UIPanGestureRecognizer(target: target, action: Selector(("handleNavigationTransition:")))
        self.view.addGestureRecognizer(recognizer)
    }
}
