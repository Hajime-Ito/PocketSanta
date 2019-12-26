//
//  FlyerViewDatasourceDelegateControroller.swift
//  PocketSanta
//
//  Created by hajime ito on 2019/12/26.
//  Copyright © 2019 hajime. All rights reserved.
//

import UIKit

typealias FlyerTableViewDD = UITableViewDelegate & UITableViewDataSource

class FlyerTableDatasourceDelegateController: UITableView, FlyerTableViewDD {
    
    // FlyerData構造体をもつ配列を宣言
    var flyerdata: [FlyerData] = [FlyerData]()
    var shownflyerdata: [FlyerData] = [FlyerData]()
    var FlyerViewController: FlyerViewController!
    
    func initflyerdata() {
        self.flyerdata.append(FlyerData(title:"クリスマスファンタジー", year: 2019, month: 12, date:24, time: "10時から20時まで", locationInfo: "金森赤煉瓦倉庫", image: UIImage(named:"test1")!, message: "毎年開催している函館クリスマスファンタジーも今年で35回目！今年は歌手のLamdaさんを呼んで、演奏をしてもらいます！クリスマススープも600円で提供。今年もたくさんの種類のスープが出ていますよ〜！", locationX: 41.7661584, locationY: 140.71655989, isMine: false))
        self.flyerdata.append(FlyerData(title:"JAZZ in Hakodate", year: 2019, month: 12, date:23, time: "21時から23時まで", locationInfo: "はこだてジャズ会館", image: UIImage(named:"test2")!, message: "JAZZでクリスマスを飾ろう！函館ジャズといえば、JAZZ in Hakodate。明治から続くイカしたジャズライブを今年も盛り上げよう！ご好評につき、今年もジャズコーラを振る舞います。", locationX: 41.79161729, locationY: 140.75155576, isMine: true))
        self.flyerdata.append(FlyerData(title:"道民コーラス・イン函館", year: 2019, month: 12, date:21, time: "18時から20時まで", locationInfo: "函館アリーナ３階ホールA", image: UIImage(named:"test3")!, message: "北海道は函館のクリスマス合唱といえば、道民コーラス・イン函館！今年は、はこだて未来大学の合唱サークル「歌とロボと秘密のAI姫」さんをお招きして、独自のパフォーマンスを披露してもらいます。", locationX: 41.78188055, locationY: 140.782793, isMine: false))
        updateshownflyerdata(isMine: false)
    }
    
    func updateshownflyerdata(isMine: Bool) {
        if(isMine){
            shownflyerdata = []
            for data in flyerdata {
                if(data.isMine == true) {shownflyerdata.append(data)}
            }
        }
        else{
            shownflyerdata = []
            for data in flyerdata {
                if(data.isMine == false) {shownflyerdata.append(data)}
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shownflyerdata.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int { // sectionの数を決める
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: FlyerCellTableViewCell = tableView.dequeueReusableCell(withIdentifier: "FlyerCell", for: indexPath) as! FlyerCellTableViewCell
        // セルに表示する値を設定する
        // 角丸にした
        // 参考：https://i-app-tec.com/ios/corner-radius.html
        cell.myTextLabel?.text = shownflyerdata[indexPath.row].title
        cell.myImageView?.image = shownflyerdata[indexPath.row].image
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
        let data = shownflyerdata[indexPath.row]
        // セルの選択を解除
        tableView.deselectRow(at: indexPath, animated: true)
        // 別の画面に遷移
        FlyerViewController.performSegue(withIdentifier: "ToFlyerDetailView", sender: data)
    }
    
}
