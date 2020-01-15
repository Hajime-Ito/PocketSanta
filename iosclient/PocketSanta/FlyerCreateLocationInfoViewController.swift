//
//  FlyerCreateLocationInfoViewController.swift
//  PocketSanta
//
//  Created by hajime ito on 2020/01/12.
//  Copyright © 2020 hajime. All rights reserved.
//

import UIKit

class FlyerCreateLocationInfoViewController: UIViewController, UITextFieldDelegate {
    
    var flyerLocationInfo: String!
    @IBOutlet weak var LocationInfoField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LocationInfoField.delegate = self
        LocationInfoField.text = flyerLocationInfo
        // 編集中はクリアーボタンを表示する
        LocationInfoField.clearButtonMode = UITextField.ViewMode.whileEditing
        // 入力状態にする
        LocationInfoField.becomeFirstResponder()
    }
    
    // 参考：https://pg-happy.jp/swift-uitextfield.html
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        flyerLocationInfo = LocationInfoField.text
        LocationInfoField.resignFirstResponder()
        alert()
        return true
    }
    
    @IBAction func TapSaveButton(_ sender: Any) {
        flyerLocationInfo = LocationInfoField.text
        alert()
    }
    // Alert作成
    //　参考：https://qiita.com/funafuna/items/b76e62eb82fc8d788da5
    private func alert() {
        // ① UIAlertControllerクラスのインスタンスを生成
        // タイトル, メッセージ, Alertのスタイルを指定する
        // 第3引数のpreferredStyleでアラートの表示スタイルを指定する
        let alert: UIAlertController = UIAlertController(title: "保存してもいいですか~", message: "初めての人でも辿り着けるように書けたかな？", preferredStyle:  UIAlertController.Style.alert)
        // ② Actionの設定
        // Action初期化時にタイトル, スタイル, 押された時に実行されるハンドラを指定する
        // 第3引数のUIAlertActionStyleでボタンのスタイルを指定する
        // OKボタン
        let defaultAction: UIAlertAction = UIAlertAction(title: "オーケー！", style: UIAlertAction.Style.default, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            print("OK")
            // NavigationControllerの値受け渡し
            // 参考：https://teratail.com/questions/47140
            //Navigation Controllerを取得
            let nav = self.navigationController!
            //呼び出し元のView Controllerを遷移履歴から取得しパラメータを渡す
            let FlyerCreateTableVC = nav.viewControllers[nav.viewControllers.count-2] as! FlyerCreateTableViewController
            FlyerCreateTableVC.flyerdata?.locationInfo = self.flyerLocationInfo
            // １つ前の画面に戻る
            //　参考：https://capibara1969.com/203/
            self.navigationController?.popViewController(animated: true)
        })
        // キャンセルボタン
        let cancelAction: UIAlertAction = UIAlertAction(title: "取り消し", style: UIAlertAction.Style.cancel, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            print("Cancel")
            // １つ前の画面に戻る
            //　参考：https://capibara1969.com/203/
            self.navigationController?.popViewController(animated: true)
        })
        
        // ③ UIAlertControllerにActionを追加
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        
        // ④ Alertを表示
        present(alert, animated: true, completion: nil)
    }
}
