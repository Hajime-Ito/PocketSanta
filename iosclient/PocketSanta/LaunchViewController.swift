//
//  LaunchViewController.swift
//  PocketSanta
//
//  Created by はじめ on 2019/12/28.
//  Copyright © 2019 hajime. All rights reserved.
//

import UIKit
import SwiftGifOrigin

// スプラッシュ画面
class LaunchViewController: UIViewController {
    
    @IBOutlet weak var santaimage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //image = UIImage.gif(name: "santawalk")
        santaimage.loadGif(name: "santa_walk")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        sleep(2)
        // 参考：https://qiita.com/saka-shin/items/07615083a244be1e5751
        performSegue(withIdentifier: "FromLaunch", sender: nil)
    }
}
