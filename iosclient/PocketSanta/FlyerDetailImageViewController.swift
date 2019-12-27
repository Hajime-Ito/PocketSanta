//
//  FlyerDetailImageViewController.swift
//  PocketSanta
//
//  Created by はじめ on 2019/12/28.
//  Copyright © 2019 hajime. All rights reserved.
//

import UIKit

class FlyerDetailImageViewController: UIViewController {
    
    var image: UIImage!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
    }
}
