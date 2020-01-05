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
    //　参考：https://qiita.com/xa_un/items/814a5cd4472674640f58
    private let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate //AppDelegateのインスタンスを取得
    
    func getflyerdata() {
        guard let flyer = appDelegate.flyerManager.getFlyer() else {
            return
        }
        flyerdata = flyer
    }
    
    func updateshownflyerdata(isMine: Bool) {
        getflyerdata()
        if(isMine){
            shownflyerdata = []
            for data in flyerdata {
                if(data.isMine == true) {shownflyerdata.append(data)}
            }
        }
        else{
            shownflyerdata = []
            for data in flyerdata {
                if(data.isMine == false && data.favorite == false) {shownflyerdata.append(data)}
            }
        }
    }
    
    func updateshownflyerdata() {
        getflyerdata()
        shownflyerdata = []
        for data in flyerdata {
            //guard let _ = data.favorite else{return}
            if(data.favorite == true) {
                print(flyerdata)
                shownflyerdata.append(data)
            }
        }
    }
    
    func addFavorite(key: String) {
        appDelegate.flyerManager.updateFlyer(key, favorite: true)
        //FlyerViewController.viewLoad()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 // 1つのセクションに1つのセル
    }
    
    func numberOfSections(in tableView: UITableView) -> Int { // sectionの数を決める
        return shownflyerdata.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: FlyerCellTableViewCell = tableView.dequeueReusableCell(withIdentifier: "FlyerCell", for: indexPath) as! FlyerCellTableViewCell
        // セルに表示する値を設定する
        // 角丸にした
        // 参考：https://i-app-tec.com/ios/corner-radius.html
        // 1つのセクションに1つのセルなので、セクション番目にアクセスすれば良い
        cell.myTextLabel?.text = shownflyerdata[indexPath.section].title
        cell.myImageView?.image = shownflyerdata[indexPath.section].getImage()
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
        // 選択されたセクション番目のflyerdatを渡す
        let data = shownflyerdata[indexPath.section]
        // セルの選択を解除
        tableView.deselectRow(at: indexPath, animated: true)
        // 別の画面に遷移
        FlyerViewController.performSegue(withIdentifier: "ToFlyerDetailView", sender: data)
    }
    
    // headerのカスタム
    // 参考；https://teratail.com/questions/65533
    // このやり方ではできなかった。
    /*func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
     // HeaderのViewを作成してViewを返す
     let headerView = UIView()
     let label = UILabel()
     label.text = "\(shownflyerdata[section].year)年\(shownflyerdata[section].month)月\(shownflyerdata[section].date)日"
     //label.textColor = UIColor.white
     headerView.addSubview(label)
     return headerView
     }*/
    
    // Sectionheaderカスタム
    // 参考:https://blog.cheekpouch.com/403/
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "\(shownflyerdata[section].year)年\(shownflyerdata[section].month)月\(shownflyerdata[section].date)日"
    }
    
    // Section Header Height
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        // ヘッダーViewの高さを返す
        return 20
    }
    
    //セルの編集許可
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        /*if shownflyerdata[indexPath.section].isMine == true {
         // 自分が作成したものに関しては削除ボタンは表示しない。
         return false
         }else{
         return true
         }*/
        return true
    }
    
    //スワイプしたセル(セクション)を削除
    // 参考：https://kichie-com.hatenablog.com/entry/table-section-delete
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            // クロージャ（結構めんどくさい実装だったけど他にも使えそう）
            alert( Closure: { isOK in
                if(isOK) {
                    if(self.FlyerViewController.mysegmentControl.selectedSegmentIndex != 2) {
                        self.appDelegate.flyerManager.removeFlyer(self.shownflyerdata[indexPath.section].FlyerKey)
                    } else {
                        self.appDelegate.flyerManager.updateFlyer(self.shownflyerdata[indexPath.section].FlyerKey, favorite: false)
                    }
                    
                    for i in 0..<self.flyerdata.count {
                        if(self.flyerdata[i].FlyerKey == self.shownflyerdata[indexPath.section].FlyerKey) {
                            self.flyerdata.remove(at: i)
                            break // ここでbreakを呼び出さないと、flyerdataが1つ減った状態で、削除前の数だけアクセスされるのでOut of Indexになってしまう。
                        }
                    }
                    self.shownflyerdata.remove(at: indexPath.section)
                    let indexSet = NSMutableIndexSet()
                    indexSet.add(indexPath.section)
                    tableView.deleteSections(indexSet as IndexSet, with: UITableView.RowAnimation.automatic)
                }
            })
            
        } else if editingStyle == UITableViewCell.EditingStyle.insert {}
    }
    
    private func alert(Closure: @escaping ((Bool) -> Void)) {
        var isOK = false
        
        var alerttitle = ""
        var alertmessage = ""
        var Oktitle = ""
        var CancelTitle = ""
        
        if(self.FlyerViewController.mysegmentControl.selectedSegmentIndex == 0) {
            alerttitle = "本当にフライヤーを削除しますか？"
            alertmessage = "復元はできないぜ(；ω；)"
            Oktitle = "します！"
            CancelTitle =  "しません"
        } else if(self.FlyerViewController.mysegmentControl.selectedSegmentIndex == 1) {
            alerttitle = "本当にフライヤーを削除しますか？"
            alertmessage = "今後このフライヤーは配信されなくなるぜ(；ω；)"
            Oktitle = "します！"
            CancelTitle =  "しません"
        } else if(self.FlyerViewController.mysegmentControl.selectedSegmentIndex == 2) {
            alerttitle = "フライヤーをお気に入りリストから外しますか？"
            alertmessage = "データは残るから安心しな( ˘ω˘ )"
            Oktitle = "オーケー！"
            CancelTitle =  "取り消し"
        }
        
        let alert: UIAlertController = UIAlertController(title: alerttitle, message: alertmessage, preferredStyle:  UIAlertController.Style.alert)
        // OKボタン
        let defaultAction: UIAlertAction = UIAlertAction(title: Oktitle, style: UIAlertAction.Style.default, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            isOK = true
            Closure(isOK)
        })
        // キャンセルボタン
        let cancelAction: UIAlertAction = UIAlertAction(title: CancelTitle, style: UIAlertAction.Style.cancel, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            isOK = false
            Closure(isOK)
        })
        
        // ③ UIAlertControllerにActionを追加
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        
        // ④ Alertを表示
        FlyerViewController.present(alert, animated: true, completion: nil)
    }
}
