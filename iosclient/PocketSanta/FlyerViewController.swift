//
//  FlyerViewController.swift
//  PocketSanta
//
//  Created by hajime ito on 2019/12/19.
//  Copyright © 2019 hajime. All rights reserved.
//

import UIKit

class FlyerViewController: UIViewController {
    
    @IBOutlet weak var myTableview: UITableView!
    @IBOutlet weak var mysegmentControl: UISegmentedControl!
    
    var FlyerTableDatasourceDelegate: FlyerTableDatasourceDelegateController = FlyerTableDatasourceDelegateController()
    var FlyerDetailVC = FlyerDetailViewController()
    fileprivate let refreshCtl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FlyerTableDatasourceDelegate.getflyerdata()
        FlyerTableDatasourceDelegate.updateshownflyerdata(isMine: false)
        FlyerTableDatasourceDelegate.FlyerViewController = self
        myTableview.dataSource = FlyerTableDatasourceDelegate
        myTableview.delegate = FlyerTableDatasourceDelegate
        // 次のページのBackボタンの文字だけ削除
        // 参考：https://mt312.com/643
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        // 下にスワイプすると更新するリフレッシュを実装
        // 参考：https://qiita.com/ryo-ta/items/7e2fbedb6e8dc8eb217f
        myTableview.refreshControl = refreshCtl
        refreshCtl.addTarget(self, action: #selector(FlyerViewController.refresh(sender:)), for: .valueChanged)
    }
    
    @objc func refresh(sender: UIRefreshControl) {
        // ここが引っ張られるたびに呼び出される
        if(mysegmentControl.selectedSegmentIndex == 0) {
             FlyerTableDatasourceDelegate.updateshownflyerdata(isMine: false)
        } else if(mysegmentControl.selectedSegmentIndex == 1) {
             FlyerTableDatasourceDelegate.updateshownflyerdata(isMine: true)
        } else if(mysegmentControl.selectedSegmentIndex == 2) {
             FlyerTableDatasourceDelegate.updateshownflyerdata()
        }
         myTableview.reloadData()
        // 通信終了後、endRefreshingを実行することでロードインジケーター（くるくる）が終了
        sender.endRefreshing()
    }
    
    @IBAction func FlyerDataSegmentedControl(sender: UISegmentedControl) {
        //セグメント番号で条件分岐させる
        switch sender.selectedSegmentIndex {
        case 0:
            // 受け取り済み(isMine == false)
            FlyerTableDatasourceDelegate.updateshownflyerdata(isMine: false)
            myTableview.reloadData()
        case 1:
            // 作成済み(isMine == true)
            FlyerTableDatasourceDelegate.updateshownflyerdata(isMine: true)
            myTableview.reloadData()
        case 2:
            FlyerTableDatasourceDelegate.updateshownflyerdata()
            myTableview.reloadData()
        default:
            FlyerTableDatasourceDelegate.updateshownflyerdata(isMine: false)
            myTableview.reloadData()
        }
    }
    
    //Segueの初期化を通知するメソッドをオーバーライドする。senderにはperformSegue()で渡した値が入る。
    // 参考：https://cha-shu00.hatenablog.com/entry/2017/04/16/135401
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToFlyerDetailView" {
            // ToFlyerDetailViewセグエの時
            // 遷移先のViewControllerを取得
            let FlyerDetailPageViewController = segue.destination as! FlyerDetailPageViewController
            FlyerDetailPageViewController.flyerdata = sender as? FlyerData
        }
    }
}


class FlyerCellTableViewCell: UITableViewCell {
    
    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var myTextLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
