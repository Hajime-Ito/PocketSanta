//
//  FlyerDetailViewController.swift
//  PocketSanta
//
//  Created by hajime ito on 2019/12/23.
//  Copyright © 2019 hajime. All rights reserved.
//

import UIKit

protocol FlyerDetailViewControllerDelegate: class {
    func editViewControllerDidCancel(_ editViewController:FlyerDetailViewController)
    func editViewControllerDidFinish(_ editViewController:FlyerDetailViewController)
}

class FlyerDetailViewController: UIViewController,  UIAdaptivePresentationControllerDelegate {
    
    var flyerdata: FlyerData!
    var FlyerTableDatasourceDelegate: FlyerTableDatasourceDelegateController = FlyerTableDatasourceDelegateController()
    @IBOutlet weak var titlelabel: UILabel!
    @IBOutlet weak var datelabel: UILabel!
    @IBOutlet weak var timelabel: UILabel!
    @IBOutlet weak var locationlabel: UILabel!
    @IBOutlet weak var messagelabel: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titlelabel?.text = flyerdata.title
        datelabel?.text = "\(flyerdata.year)年\(flyerdata.month)月\(flyerdata.date)日"
        timelabel?.text = flyerdata.timeInfo
        locationlabel?.text = flyerdata.locationInfo
        messagelabel?.text = flyerdata.message
    }
    
    // MARK: - Delegate
       
       weak var delegate1: FlyerDetailViewControllerDelegate?
       
       func sendDidCancel() {
           delegate1?.editViewControllerDidCancel(self)
       }
       
       func sendDidFinish() {
           delegate1?.editViewControllerDidFinish(self)
       }
       
       func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
           print("HH")
           // The user pulled down with unsaved changes
           // Clarify the user's intent by asking whether they intended to cancel or save
           sendDidFinish()
       }
       
    
    
    @IBAction func Taplocationlabel(_ sender: Any) {
        performSegue(withIdentifier: "ToFlyerDetailMapView", sender: flyerdata)
    }
    
    @IBAction func TapAddFolderButton(_ sender: Any) {
        alert()
    }
    
    
    private func alert() {
        let alert: UIAlertController = UIAlertController(title: "お気に入りに追加するよ~", message: "追加しすぎに注意( ˘ω˘ )", preferredStyle:  UIAlertController.Style.alert)
        // OKボタン
        let defaultAction: UIAlertAction = UIAlertAction(title: "よろしく！", style: UIAlertAction.Style.default, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            self.FlyerTableDatasourceDelegate.addFavorite(key: self.flyerdata.FlyerKey)
        })
        // キャンセルボタン
        let cancelAction: UIAlertAction = UIAlertAction(title: "取り消し", style: UIAlertAction.Style.cancel, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            
        })
        
        // ③ UIAlertControllerにActionを追加
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        
        // ④ Alertを表示
        present(alert, animated: true, completion: nil)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToFlyerDetailMapView" {
            // ToFlyerDetailMapViewセグエの時
            // 遷移先のViewControllerを取得
            let FlyerDetailMapView = segue.destination as! FlyerDetailMapViewController
            FlyerDetailMapView.flyerdata = sender as? FlyerData
        } else { }
    }
}
