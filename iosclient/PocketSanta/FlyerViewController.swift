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
        flyerdata.append(FlyerData(title:"クリスマスファンタジー", year: 2019, month: 12, date:24, time: "10時から20時まで", locationInfo: "金森赤煉瓦倉庫", image: UIImage(named:"test1")!, message: "毎年開催している函館クリスマスファンタジーも今年で35回目！今年は歌手のLamdaさんを呼んで、演奏をしてもらいます！クリスマススープも600円で提供。今年もたくさんの種類のスープが出ていますよ〜！", locationX: 41.7661584, locationY: 140.71655989))
        flyerdata.append(FlyerData(title:"JAZZ in Hakodate", year: 2019, month: 12, date:23, time: "21時から23時まで", locationInfo: "はこだてジャズ会館", image: UIImage(named:"test2")!, message: "JAZZでクリスマスを飾ろう！函館ジャズといえば、JAZZ in Hakodate。明治から続くイカしたジャズライブを今年も盛り上げよう！ご好評につき、今年もジャズコーラを振る舞います。", locationX: 41.79161729, locationY: 140.75155576))
        flyerdata.append(FlyerData(title:"道民コーラス・イン函館", year: 2019, month: 12, date:21, time: "18時から20時まで", locationInfo: "函館アリーナ３階ホールA", image: UIImage(named:"test3")!, message: "北海道は函館のクリスマス合唱といえば、道民コーラス・イン函館！今年は、はこだて未来大学の合唱サークル「歌とロボと秘密のAI姫」さんをお招きして、独自のパフォーマンスを披露してもらいます。", locationX: 41.78188055, locationY: 140.782793))
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
        cell.myImageView?.image = flyerdata[indexPath.row].image
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
            let FlyerDetailPageViewController = segue.destination as! FlyerDetailPageViewController
            //let FlyerDetailViewController = segue.destination as! FlyerDetailViewController
            //let FlyerDetailMapViewController = segue.destination as! FlyerDetailMapViewController
            // 遷移先のflyerdataプロパティに引数sender(FlyerData型)を渡す
            //FlyerDetailViewController.flyerdata = sender as? FlyerData
            //FlyerDetailMapViewController.flyerdata = sender as? FlyerData
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
