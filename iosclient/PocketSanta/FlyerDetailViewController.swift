//
//  FlyerDetailViewController.swift
//  PocketSanta
//
//  Created by hajime ito on 2019/12/23.
//  Copyright © 2019 hajime. All rights reserved.
//

import UIKit

class FlyerDetailViewController: UIViewController {
    
    var flyerdata: FlyerData!
    @IBOutlet weak var titlelabel: UILabel!
    @IBOutlet weak var datelabel: UILabel!
    @IBOutlet weak var timelabel: UILabel!
    @IBOutlet weak var locationlabel: UILabel!
    @IBOutlet weak var messagelabel: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titlelabel?.text = flyerdata.title
        datelabel?.text = "\(flyerdata.year)年\(flyerdata.month)月\(flyerdata.date)日"
        timelabel?.text = flyerdata.time
        locationlabel?.text = flyerdata.locationInfo
        messagelabel?.text = flyerdata.message
    }
}
