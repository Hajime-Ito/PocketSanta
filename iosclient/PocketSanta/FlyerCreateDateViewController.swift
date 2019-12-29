//
//  FlyerCreateDateViewController.swift
//  PocketSanta
//
//  Created by はじめ on 2019/12/29.
//  Copyright © 2019 hajime. All rights reserved.
//

import UIKit

class FlyerCreateDateViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var flyerdate: String!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dataPicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //　空のセルを非表示
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        let dt : Date = dateFromString(flyerdate, "yyyy年MM月dd日")
        dataPicker.date = dt
        dataPicker.becomeFirstResponder()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int { // sectionの数を決める
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "FlyerCreateDateCell", for: indexPath)
        cell.detailTextLabel?.text = flyerdate
        return cell
    }
    
    // 参考：https://qiita.com/ktaguchi/items/b7491362f5855a4db41f
    @IBAction private func didValueChangedDatePicker(_ sender: UIDatePicker) {
        // UIDatePickerが変更されたら呼び出される
        flyerdate = stringFromDate(date: sender.date, format: "yyyy年MM月dd日")
        tableView.reloadData()
        //Navigation Controllerを取得
        let nav = self.navigationController!
        //呼び出し元のView Controllerを遷移履歴から取得しパラメータを渡す
        let FlyerCreateTableVC = nav.viewControllers[nav.viewControllers.count-2] as! FlyerCreateTableViewController
        FlyerCreateTableVC.flyerdata?.year = Int(stringFromDate(date: sender.date, format: "yyyy"))!
        FlyerCreateTableVC.flyerdata?.month = Int(stringFromDate(date: sender.date, format: "MM"))!
        FlyerCreateTableVC.flyerdata?.date = Int(stringFromDate(date: sender.date, format: "dd"))!
    }
    
    // 参考：https://swift.hiros-dot.net/?p=870
    func dateFromString(_ dateSting : String, _ format : String) -> Date {
        // DateFormatter のインスタンスを作成
        let formatter: DateFormatter = DateFormatter()
        // 日付の書式を文字列に合わせて設定
        formatter.dateFormat = format
        // 日時文字列からDate型の日付を生成する
        let dt = formatter.date(from: dateSting)
        return dt!
    }
    
    //　参考：https://qiita.com/k-yamada-github/items/8b6411959579fd6cd995
    func stringFromDate(date: Date, format: String) -> String {
        let formatter: DateFormatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
    
}
