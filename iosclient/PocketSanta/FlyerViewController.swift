//
//  FlyerViewController.swift
//  PocketSanta
//
//  Created by hajime ito on 2019/12/19.
//  Copyright © 2019 hajime. All rights reserved.
//

import UIKit

class FlyerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var myTableview: UITableView!
    
    // FlyerData構造体をもつ配列を宣言
    var flyerdata: [FlyerData] = [FlyerData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        myTableview.dataSource = self
        myTableview.delegate = self
        // TEST用インスタンス
        flyerdata.append(FlyerData(title:"TEST", year: 0, month: 0, date:0,image: UIImage(named:"test")!, message: "TESTDESU", locationX: 0, locationY: 0))
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return flyerdata.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int { // sectionの数を決める
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: FlyerCellTableViewCell = tableView.dequeueReusableCell(withIdentifier: "FlyerCell", for: indexPath) as! FlyerCellTableViewCell
        // セルに表示する値を設定する
        // 角丸にした
        // 参考：https://i-app-tec.com/ios/corner-radius.html
        cell.myTextLabel?.text = flyerdata[indexPath.row].title
        cell.myImageView?.image = UIImage(named:"test")!
        cell.myImageView?.layer.cornerRadius = cell.myImageView.frame.size.width * 0.1
        cell.myImageView?.clipsToBounds = true
        // ImageViewのContentModeをAspectFillにしたら横も丸くなった
        // 参考：https://blog.fenrir-inc.com/jp/2011/05/uiviewcontentmode.html
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // Cellの高さを決める
        return 200
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 選択されたセル番目のflyerdatを渡す
        let data = flyerdata[indexPath.row]
        // セルの選択を解除
        tableView.deselectRow(at: indexPath, animated: true)
        // 別の画面に遷移
        performSegue(withIdentifier: "ToFlyerDetailView", sender: data)
    }
    
    //Segueの初期化を通知するメソッドをオーバーライドする。senderにはperformSegue()で渡した値が入る。
    // 参考：https://cha-shu00.hatenablog.com/entry/2017/04/16/135401
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToFlyerDetailView" {
            // ToFlyerDetailViewセグエの時
            // 遷移先のViewControllerを取得
            let secondViewController = segue.destination as! FlyerDetailViewController
            // 遷移先のflyerdataプロパティに引数sender(FlyerData型)を渡す
            secondViewController.flyerdata = sender as? FlyerData
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
