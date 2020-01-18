//
//  FlyerViewController.swift
//  PocketSanta
//
//  Created by hajime ito on 2019/12/19.
//  Copyright © 2019 hajime. All rights reserved.
//

import UIKit
import FloatingPanel
import SwiftGifOrigin

class FlyerViewController: UIViewController, FlyerSemiDelegate /*FlyerDetailViewControllerDelegate*/ {
    
    @IBOutlet weak var myTableview: UITableView!
    @IBOutlet weak var mysegmentControl: UISegmentedControl!
    
    var floatingPanelController: FloatingPanelController!
    var FlyerTableDatasourceDelegate: FlyerTableDatasourceDelegateController = FlyerTableDatasourceDelegateController()
    var FlyerDetailVC = FlyerDetailViewController()
    var FlyerSemiVC: FlyerSemiModalViewController!
    
    var myHeaderView: UIView!
    var displayWidth: CGFloat!
    var displayHeight: CGFloat!
    
    private var isFloatingViewShown = false //FloatingViewが出たかどうか
    
    fileprivate let refreshCtl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FlyerSemiVC = FlyerSemiModalViewController()
        FlyerSemiVC.delegate = self
        FlyerTableDatasourceDelegate.getflyerdata()
        FlyerTableDatasourceDelegate.updateshownflyerdata(isMine: false)
        FlyerTableDatasourceDelegate.FlyerViewController = self
        myTableview.dataSource = FlyerTableDatasourceDelegate
        myTableview.delegate = FlyerTableDatasourceDelegate
        myTableview.contentInset.top = 30 //ヘッダーの分下げる
        // 次のページのBackボタンの文字だけ削除
        // 参考：https://mt312.com/643
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        // 下にスワイプすると更新するリフレッシュを実装
        // 参考：https://qiita.com/ryo-ta/items/7e2fbedb6e8dc8eb217f
        myTableview.refreshControl = refreshCtl
        refreshCtl.tintColor = UIColor.clear
        refreshCtl.addTarget(self, action: #selector(FlyerViewController.refresh(sender:)), for: .valueChanged)
        
        createHeaderView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // セミモーダルビューを非表示にする
        if(isFloatingViewShown) {
            // セミモーダルを１回も表示しないで呼び出されると落ちる
            floatingPanelController.removePanelFromParent(animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.reloading()
    }
    
    private func reloading() {
        if(mysegmentControl.selectedSegmentIndex == 0) {
            FlyerTableDatasourceDelegate.updateshownflyerdata(isMine: false)
        } else if(mysegmentControl.selectedSegmentIndex == 1) {
            FlyerTableDatasourceDelegate.updateshownflyerdata(isMine: true)
        } else if(mysegmentControl.selectedSegmentIndex == 2) {
            FlyerTableDatasourceDelegate.updateshownflyerdata()
        }
        myTableview.reloadData()
    }
    
    @objc func refresh(sender: UIRefreshControl) {
        // ここが引っ張られるたびに呼び出される
        //updateHeaderView(mysegmentControl.selectedSegmentIndex)
        /*
         let image = UIImageView(frame: CGRect(x: (displayWidth-100)/2, y: 100, width: 100, height: 100))
                image.loadGif(name: "test")
                myHeaderView.addSubview(image)
         */
        self.reloading()
        // 通信終了後、endRefreshingを実行することでロードインジケーター（くるくる）が終了
        sender.endRefreshing()
        //sleep(1)
    }
    
    @IBAction func TouchSyosaiButton(_ sender: UIButton) {
        isFloatingViewShown = true
        // セミモーダルビュー表示設定
        // 参考：https://qiita.com/dotrikun/items/369f5c0730f444d97cf1
        //floatingPanelController.delegate = self
        // セミモーダルビューとなるViewControllerを生成し、contentViewControllerとしてセットする
        FlyerSemiVC!.flyerdata = FlyerTableDatasourceDelegate.shownflyerdata[sender.tag]
        floatingPanelController = FloatingPanelController()
        floatingPanelController.delegate = self
        floatingPanelController.surfaceView.cornerRadius = 24.0
        floatingPanelController.set(contentViewController: FlyerSemiVC)
        // セミモーダルビューを表示する
        floatingPanelController.addPanel(toParent: self, belowView: nil, animated: true)
    }
    
    
    @IBAction func FlyerDataSegmentedControl(sender: UISegmentedControl) {
        //セグメント番号で条件分岐させる
        switch sender.selectedSegmentIndex {
        case 0:
            // 受け取り済み(isMine == false)
            FlyerTableDatasourceDelegate.updateshownflyerdata(isMine: false)
            updateHeaderView(0)
            myTableview.reloadData()
        case 1:
            // 作成済み(isMine == true)
            FlyerTableDatasourceDelegate.updateshownflyerdata(isMine: true)
            updateHeaderView(1)
            myTableview.reloadData()
        case 2:
            FlyerTableDatasourceDelegate.updateshownflyerdata()
            updateHeaderView(2)
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
            FlyerDetailPageViewController.FlyerVC = self
        }
    }
    
    func removePanel() {
        floatingPanelController.removePanelFromParent(animated: true)
        self.reloading()
        myTableview.reloadData()
        updateHeaderView(mysegmentControl.selectedSegmentIndex)
    }
    
    func floatingPanelDidEndDragging(_ vc: FloatingPanelController, withVelocity velocity: CGPoint, targetPosition: FloatingPanelPosition) {
        //if targetPosition != .tip {
        self.reloading()
        myTableview.reloadData()
        updateHeaderView(mysegmentControl.selectedSegmentIndex)
        // }
    }
}

// FloatingPanelControllerDelegate を実装してカスタマイズしたレイアウトを返す
extension FlyerViewController: FloatingPanelControllerDelegate {
    func floatingPanel(_ vc: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout? {
        return FlyerCustomFloatingPanelLayout()
    }
}

// Header
// 参考：https://qiita.com/mochizukikotaro/items/f48559630a639e7d467b
extension FlyerViewController {
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        // 下に引っ張ったときは、ヘッダー位置を計算して動かないようにする（★ここがポイント..）
        if scrollView.contentOffset.y < -30 {
            self.myHeaderView.frame = CGRect(x: 0, y: scrollView.contentOffset.y, width: self.displayWidth, height: 30)
        }
    }
    
    private func createHeaderView() {
        displayWidth = self.view.frame.width
        displayHeight = self.view.frame.height
        // 上に余裕を持たせている（後々アニメーションなど追加するため）
        myHeaderView = UIView(frame: CGRect(x: 0, y: -230, width: displayHeight, height: 230)) //（★..コンテンツの上にヘッダーを配置）
        //myHeaderView.backgroundColor = UIColor.systemGray4
        myHeaderView.alpha = 1
        myTableview.addSubview(myHeaderView)
        let myLabel = UILabel(frame: CGRect(x: 0, y: 200, width: displayWidth, height: 30))
        myLabel.text = "受け取ったフライヤー(\(FlyerTableDatasourceDelegate.shownflyerdata.count)枚)"
        myLabel.font = UIFont.systemFont(ofSize: 12)
        myLabel.textAlignment = .center
        myLabel.backgroundColor = UIColor.systemGray4
        myLabel.alpha = 0.5
        myHeaderView.addSubview(myLabel)
        let image = UIImageView(frame: CGRect(x: (displayWidth-100)/2, y: 100, width: 100, height: 100))
        image.loadGif(name: "test")
        myHeaderView.addSubview(image)
    }
    
    func updateHeaderView(_ selection: Int) {
        deleteHeaderView()
        let myLabel = UILabel(frame: CGRect(x: 0, y: 200, width: displayWidth, height: 30))
        if(selection == 0) {
            myLabel.text = "受け取ったフライヤー(\(FlyerTableDatasourceDelegate.shownflyerdata.count)枚)"
        } else if(selection == 1) {
            myLabel.text = "配信しているフライヤー(\(FlyerTableDatasourceDelegate.shownflyerdata.count)枚)"
        } else if(selection == 2) {
            myLabel.text = "お気に入りのフライヤー(\(FlyerTableDatasourceDelegate.shownflyerdata.count)枚)"
        }
        myLabel.font = UIFont.systemFont(ofSize: 12)
        myLabel.textAlignment = .center
        myLabel.backgroundColor = UIColor.systemGray4
        myLabel.alpha = 0.5
        myHeaderView.addSubview(myLabel)
        let image = UIImageView(frame: CGRect(x: (displayWidth-100)/2, y: 100, width: 100, height: 100))
        image.loadGif(name: "test")
        myHeaderView.addSubview(image)
    }
    
    func deleteHeaderView() {
        let subviews = myHeaderView.subviews
        for subview in subviews {
            subview.removeFromSuperview()
        }
    }
}


class FlyerCellTableViewCell: UITableViewCell {
    
    @IBOutlet weak var myImageView: UIImageView!
    @IBOutlet weak var myTextLabel: UILabel!
    @IBOutlet weak var syosaiButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}

