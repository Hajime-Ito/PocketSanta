//
//  FlyerCreateTableViewController.swift
//  PocketSanta
//
//  Created by はじめ on 2019/12/27.
//  Copyright © 2019 hajime. All rights reserved.
//

import UIKit

class FlyerCreateTableViewController: UITableViewController {
    
    var flyerdata: FlyerData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        setSwipeBack()
        let Todate = Date()
        let calendar = Calendar.current
        let year = calendar.component(.year, from: Todate)
        let month = calendar.component(.month, from: Todate)
        let date = calendar.component(.day, from: Todate)
        flyerdata = FlyerData(title:"", year: year, month: month, date: date, time: "", locationInfo: "", image: UIImage(named:"test")!, message: "", locationX: 0, locationY: 0, isMine: true)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // セクションの数を返します
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // それぞれのセクション毎に何行のセルがあるかを返します
        switch section {
        case 0: // 「設定」のセクション
            return 5
        case 1 :
            return 1
        default: // ここが実行されることはないはず
            return 0
        }
    }
}

extension UIViewController {
    // 参考：https://qiita.com/son_s/items/cb35bcff9d133cfa1f5d
    func setSwipeBack() {
        let target = self.navigationController?.value(forKey: "_cachedInteractionController")
        let recognizer = UIPanGestureRecognizer(target: target, action: Selector(("handleNavigationTransition:")))
        self.view.addGestureRecognizer(recognizer)
    }
}

/*override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
 // year, month, date
 // time
 // locationmessage
 // locationX, locationY
 // message
 return 5
 }*/
/*
 override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
 
 switch indexPath.row {
 case 0:
 let cell: FlyerCreate1TableViewCell = tableView.dequeueReusableCell(withIdentifier: "FlyerCreate1Cell", for: indexPath) as! FlyerCreate1TableViewCell
 cell.titleTextLabel?.text = "タイトル"
 cell.inputImageView?.image = flyerdata?.image
 return cell
 
 case 1:
 let cell: FlyerCreate2345TableViewCell = tableView.dequeueReusableCell(withIdentifier: "FlyerCreate2345Cell", for: indexPath) as! FlyerCreate2345TableViewCell
 cell.titleTextLabel?.text = "開催日"
 cell.inputTextLabel?.text = "\(flyerdata?.year ?? 2020)年\(flyerdata?.month ?? 12)月\(flyerdata?.date ?? 24)日"
 return cell
 
 case 2:
 let cell: FlyerCreate2345TableViewCell = tableView.dequeueReusableCell(withIdentifier: "FlyerCreate2345Cell", for: indexPath) as! FlyerCreate2345TableViewCell
 cell.titleTextLabel?.text = "開催時間"
 cell.inputTextLabel?.text = flyerdata?.time
 return cell
 
 case 3:
 let cell: FlyerCreate2345TableViewCell = tableView.dequeueReusableCell(withIdentifier: "FlyerCreate2345Cell", for: indexPath) as! FlyerCreate2345TableViewCell
 cell.titleTextLabel?.text = "開催場所情報"
 cell.inputTextLabel?.text = flyerdata?.locationInfo
 return cell
 
 case 4:
 let cell: FlyerCreate2345TableViewCell = tableView.dequeueReusableCell(withIdentifier: "FlyerCreate2345Cell", for: indexPath) as! FlyerCreate2345TableViewCell
 cell.titleTextLabel?.text = "メッセージ"
 cell.inputTextLabel?.text = flyerdata?.message
 return cell
 
 default:
 let cell: FlyerCreate2345TableViewCell = tableView.dequeueReusableCell(withIdentifier: "FlyerCreate2345Cell", for: indexPath) as! FlyerCreate2345TableViewCell
 cell.titleTextLabel?.text = "開催位置"
 cell.inputTextLabel?.text = ""
 return cell
 }
 }
 
 
 override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
 // Cellの高さを決める
 switch indexPath.row {
 case 0:
 return 90
 default:
 return 40
 }
 }
 
 }
 
 
 class FlyerCreate1TableViewCell: UITableViewCell {
 
 @IBOutlet weak var inputImageView: UIImageView!
 @IBOutlet weak var titleTextLabel: UILabel!
 
 override func awakeFromNib() {
 super.awakeFromNib()
 // Initialization code
 }
 
 override func setSelected(_ selected: Bool, animated: Bool) {
 super.setSelected(selected, animated: animated)
 // Configure the view for the selected state
 }
 
 }
 
 class FlyerCreate2345TableViewCell: UITableViewCell {
 
 @IBOutlet weak var titleTextLabel: UILabel!
 @IBOutlet weak var inputTextLabel: UILabel!
 
 override func awakeFromNib() {
 super.awakeFromNib()
 // Initialization code
 }
 
 override func setSelected(_ selected: Bool, animated: Bool) {
 super.setSelected(selected, animated: animated)
 // Configure the view for the selected state
 }
 
 }*/
