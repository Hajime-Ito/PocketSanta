//
//  FlyerFloatingPanelViewController.swift
//  PocketSanta
//
//  Created by hajime ito on 2020/01/13.
//  Copyright © 2020 hajime. All rights reserved.
//

import UIKit
import FloatingPanel

protocol FlyerSemiDelegate {
    func removePanel()
}

class FlyerSemiModalViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    private let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    var flyerdata: FlyerData!
    var tableview: UITableView!
    var Texts: texts!
    var delegate: FlyerSemiDelegate?
    
    struct texts {
        var flyerdata: FlyerData
        var favoriteText: String
        var favoriteImage: UIImage
        var postText: String
        var postImage: UIImage
        var blockText: String
        var blockImage: UIImage
        var isMine: Bool
        var favorite: Bool
        
        init(flyerdata: FlyerData) {
            self.flyerdata = flyerdata
            if(flyerdata.favorite == true) {
                favoriteImage = UIImage(systemName: "lock.icloud.fill")!
                favoriteText = "お気に入りに追加済み"
            } else {
                favoriteImage = UIImage(systemName: "lock.icloud")!
                favoriteText = "お気に入りに追加する"
            }
            if(flyerdata.isMine == false) {
                postImage = UIImage(systemName: "icloud.and.arrow.up")!
                postText = "配信する"
            } else {
                postImage = UIImage(systemName: "icloud.and.arrow.up.fill")!
                postText = "配信しています"
            }
            blockImage = UIImage(systemName: "xmark.seal")!
            blockText = "ブロックする"
            self.isMine = flyerdata.isMine
            self.favorite = flyerdata.favorite
        }
        
        mutating func favorited(_ bool: Bool) {
            self.favorite = bool
            if(bool == true) {
                favoriteImage = UIImage(systemName: "lock.icloud.fill")!
                favoriteText = "お気に入りに追加済み"
            } else {
                favoriteImage = UIImage(systemName: "lock.icloud")!
                favoriteText = "お気に入りに追加する"
            }
        }
        
        mutating func posted(_ bool: Bool) {
            self.isMine = bool
            if(bool == false) {
                postImage = UIImage(systemName: "icloud.and.arrow.up")!
                postText = "配信する"
            } else {
                postImage = UIImage(systemName: "icloud.and.arrow.up.fill")!
                postText = "配信しています"
            }
        }
        
        mutating func blocked(blocked: Bool) {
            if(blocked) {
                blockImage = UIImage(systemName: "xmark.seal.fill")!
                blockText = "ブロックしました"
            } else {
                blockImage = UIImage(systemName: "xmark.seal")!
                blockText = "ブロックする"
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview = UITableView()
        tableview.frame = CGRect(x:0, y:0, width:UIScreen.main.bounds.size.width, height:UIScreen.main.bounds.size.height)
        tableview.delegate = self
        tableview.dataSource = self
        tableview.isScrollEnabled = false
        tableview.tableFooterView = UIView()
        tableview.register(UITableViewCell.self,forCellReuseIdentifier: "setting")
        self.view.addSubview(tableview)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Texts = .init(flyerdata: flyerdata)
        tableview.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "setting",for: indexPath as IndexPath)
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = flyerdata.title
            cell.textLabel?.textAlignment = NSTextAlignment.center
        case 1:
            cell.imageView?.image = Texts.favoriteImage
            cell.textLabel?.text = Texts.favoriteText
        case 2:
            cell.imageView?.image = Texts.postImage
            cell.textLabel?.text = Texts.postText
        case 3:
            cell.imageView?.image = Texts.blockImage
            cell.textLabel?.text = Texts.blockText
        case 4:
            cell.textLabel?.text = "閉じる"
            cell.textLabel?.textAlignment = NSTextAlignment.center
        default:
            cell.textLabel?.text = "何もありません。"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0:
            self.tableview.reloadData()
        case 1:
            if(Texts.favorite) {
                appDelegate.flyerManager.updateFlyer(flyerdata.FlyerKey, favorite: false)
                self.Texts.favorited(false)
            } else {
                appDelegate.flyerManager.updateFlyer(flyerdata.FlyerKey, favorite: true)
                self.Texts.favorited(true)
            }
            self.tableview.reloadData()
        case 2:
            if(Texts.isMine) {
                appDelegate.flyerManager.updateFlyer(flyerdata.FlyerKey, isMine: false)
                self.Texts.posted(false)
            } else {
                appDelegate.flyerManager.updateFlyer(flyerdata.FlyerKey, isMine: true)
                self.Texts.posted(true)
            }
            self.tableview.reloadData()
        case 3:
            alert(indexPath)
        case 4:
            self.tableview.reloadData()
            guard let _ = delegate else {
                break
            }
            delegate!.removePanel()
        default:
            break
        }
    }
    
    private func alert(_ indexPath: IndexPath) {
        let alert: UIAlertController = UIAlertController(title: "配信者をブロックしますか？", message: "このフライヤーを配った奴からはもう受け取らないようにしとくぜ( ˘ω˘ )", preferredStyle:  UIAlertController.Style.alert)
        // OKボタン
        let defaultAction: UIAlertAction = UIAlertAction(title: "頼んだ！", style: UIAlertAction.Style.default, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            self.Texts.blocked(blocked: true)
            let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.flyerManager.removeFlyer(self.flyerdata.FlyerKey)
            self.tableview.reloadData()
            self.delegate!.removePanel()
        })
        // キャンセルボタン
        let cancelAction: UIAlertAction = UIAlertAction(title: "取り消し", style: UIAlertAction.Style.cancel, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            self.Texts.blocked(blocked: false)
            self.tableview.reloadData()
        })
        
        // ③ UIAlertControllerにActionを追加
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        
        // ④ Alertを表示
        present(alert, animated: true, completion: nil)
    }
    
}

class FlyerCustomFloatingPanelLayout: FloatingPanelLayout {
    
    // セミモーダルビューの初期位置
    var initialPosition: FloatingPanelPosition {
        return .tip
    }
    
    var topInteractionBuffer: CGFloat { return 0.0 }
    var bottomInteractionBuffer: CGFloat { return 0.0 }
    
    // セミモーダルビューの各表示パターンの高さを決定するためのInset
    func insetFor(position: FloatingPanelPosition) -> CGFloat? {
        switch position {
        case .full: return 56.0
        case .half: return 262.0
        case .tip: return 230.0
        case .hidden:
            return nil
        }
    }
    
    // セミモーダルビューの背景Viewの透明度
    func backdropAlphaFor(position: FloatingPanelPosition) -> CGFloat {
        return 0.3
    }
    
}

