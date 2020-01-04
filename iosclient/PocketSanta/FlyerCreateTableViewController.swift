//
//  FlyerCreateTableViewController.swift
//  PocketSanta
//
//  Created by はじめ on 2019/12/27.
//  Copyright © 2019 hajime. All rights reserved.
//

import UIKit
import Photos

// UIImagePickerについての参考：https://swiswiswift.com/2019-01-11/

class FlyerCreateTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var flyerdata: FlyerData?
    private let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate //AppDelegateのインスタンスを取得
    
    @IBOutlet weak var ImageCell: FlyerCreateImageCell!
    @IBOutlet weak var TitleCell: UITableViewCell!
    @IBOutlet weak var DateCell: UITableViewCell!
    @IBOutlet weak var TimeInfoCell: UITableViewCell!
    @IBOutlet weak var LocationMapCell: UITableViewCell!
    @IBOutlet weak var LocationInfoCell: UITableViewCell!
    @IBOutlet weak var MessageCell: UITableViewCell!
    @IBOutlet weak var CreateCell: UITableViewCell!
    
    var picker: UIImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 次のページのBackボタンの文字だけ削除
        // 参考：https://mt312.com/643
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        //　空のセルを非表示
        tableView.tableFooterView = UIView()
        //setSwipeBack()
        /*
         { (引数名:引数の型) -> 戻り値の型 in
         処理
         }
         **/
        let Todate = Date()
        let calendar = Calendar.current
        let year = calendar.component(.year, from: Todate)
        let month = calendar.component(.month, from: Todate)
        let date = calendar.component(.day, from: Todate)
        flyerdata = FlyerData(title:"", year: year, month: month, date: date, timeInfo: "", locationInfo: "", image: UIImage(named:"test")!, message: "", locationX: 0, locationY: 0, isMine: true, FlyerKey: {()->String in
            let base = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
            var randomString: String = ""
            let characters = base.map { String($0) }
            for _ in 0..<20 {
                let rand = Int(arc4random_uniform(UInt32(base.count)))
                randomString += "\(characters[rand])"
            }
            return randomString}(), favorite: false)
        ImageCell.title.text = "フライヤー画像"
        TitleCell.textLabel?.text = "タイトル"
        DateCell.textLabel?.text = "開催日"
        TimeInfoCell.textLabel?.text = "開催時間"
        LocationMapCell.textLabel?.text = "開催位置"
        LocationInfoCell.textLabel?.text = "詳細位置情報"
        MessageCell.textLabel?.text = "メッセージ"
        CreateCell.textLabel?.text = "フライヤーを配る"
        flyerdataSettingCell()
        picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = UIImagePickerController.SourceType.photoLibrary
        picker.allowsEditing = false // Whether to make it possible to edit the size etc after selecting the image
        // set picker's navigationBar appearance
    }
    
    // Backしてきた時に再読み込み
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        flyerdataSettingCell()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // セクションの数を返します
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // それぞれのセクション毎に何行のセルがあるかを返します
        switch section {
        case 0: // 「設定」のセクション
            return 7
        case 1:
            return 1
        default: // ここが実行されることはないはず
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                checkPermission()
                present(picker, animated: true, completion: nil)
            case 1:
                break
            case 2:
                break
            case 3:
                break
            case 4:
                break
            case 5:
                break
            case 6:
                break
            default:
                break
            }
        case 1:
            switch indexPath.row {
            case 0:
                appDelegate.flyerManager.addFlyer(flyer: flyerdata!)// test用
                self.navigationController?.popViewController(animated: true)
            default:
                break
            }
            break
        default:
            break
        }
    }
    
    private func flyerdataSettingCell() {
        if let _ = flyerdata?.getImage() {
            ImageCell.Flyerimage.image = flyerdata!.getImage()
        }
        
        if let _ = flyerdata?.date, let _ = flyerdata?.month, let _ = flyerdata?.year {
            DateCell.detailTextLabel?.text = "\(flyerdata!.year)年\(flyerdata!.month)月\(flyerdata!.date)日"
        }
        
        if let _ = flyerdata?.title {
            TitleCell.detailTextLabel?.text = flyerdata!.title
        }
        
        if let _ = flyerdata?.timeInfo {
            TimeInfoCell.detailTextLabel?.text = flyerdata!.timeInfo
        }
        
        if let _ = flyerdata?.locationX, let _ = flyerdata?.locationY {
            LocationMapCell.detailTextLabel?.text = "\(flyerdata!.locationX)"
        }
        
        if let _ = flyerdata?.locationInfo {
            LocationInfoCell.detailTextLabel?.text = flyerdata!.locationInfo
        }
        
        if let _ = flyerdata?.message {
            MessageCell.detailTextLabel?.text = flyerdata!.message
        }
        
    }
    
    // アルバム(Photo liblary)の閲覧権限の確認をするメソッド
    // 参考：https://qiita.com/Ren-Toyokawa/items/1b2e0b9893c7ea925057
    private func checkPermission(){
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        
        switch photoAuthorizationStatus {
        case .authorized:
            print("auth")
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({
                (newStatus) in
                print("status is \(newStatus)")
                if newStatus ==  PHAuthorizationStatus.authorized {
                    /* do stuff here */
                    print("success")
                }
            })
            print("not Determined")
        case .restricted:
            print("restricted")
        case .denied:
            print("denied")
        @unknown default:
            fatalError()
        }
    }
    
    // MARK: ImageVicker Delegate Methods
    // called when image picked
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        guard let Image = image else {
            return
        }
        flyerdata?.setImage(image: Image)
        ImageCell.Flyerimage.image = flyerdata?.getImage()
        
        dismiss(animated: true, completion: nil)
    }
    // called when cancel select image
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // close picker modal
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToFlyerCreateTitleView" {
            let FlyerCreateTitleViewController = segue.destination as! FlyerCreateTitleViewController
            FlyerCreateTitleViewController.flyerTitle = flyerdata?.title
        }
        else if segue.identifier == "ToFlyerCreateDateView" {
            let FlyerCreateDateViewController = segue.destination as! FlyerCreateDateViewController
            if let _ = flyerdata?.date, let _ = flyerdata?.month, let _ = flyerdata?.year {
                FlyerCreateDateViewController.flyerdate  = "\(flyerdata!.year)年\(flyerdata!.month)月\(flyerdata!.date)日"
            }
        }
    }
}

class FlyerCreateImageCell: UITableViewCell {
    @IBOutlet weak var Flyerimage: UIImageView!
    @IBOutlet weak var title : UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}


extension UIViewController {
    // 参考：https://qiita.com/son_s/items/cb35bcff9d133cfa1f5d
    func setSwipeBack() {
        let target = self.navigationController?.value(forKey: "_cachedInteractionController")
        let recognizer = UIPanGestureRecognizer(target: target, action: Selector(("handleNavigationTransition:")))
        self.view.addGestureRecognizer(recognizer)
    }
}

/*override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
 // year, month, date
 // time
 // locationmessage
 // locationX, locationY
 // message
 return 5
 }*/
/*
 override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
 
 switch indexPath.row {
 case 0:
 let cell: FlyerCreate1TableViewCell = tableView.dequeueReusableCell(withIdentifier: "FlyerCreate1Cell", for: indexPath) as! FlyerCreate1TableViewCell
 cell.titleTextLabel?.text = "タイトル"
 cell.inputImageView?.image = flyerdata?.image
 return cell
 
 case 1:
 let cell: FlyerCreate2345TableViewCell = tableView.dequeueReusableCell(withIdentifier: "FlyerCreate2345Cell", for: indexPath) as! FlyerCreate2345TableViewCell
 cell.titleTextLabel?.text = "開催日"
 cell.inputTextLabel?.text = "\(flyerdata?.year ?? 2020)年\(flyerdata?.month ?? 12)月\(flyerdata?.date ?? 24)日"
 return cell
 
 case 2:
 let cell: FlyerCreate2345TableViewCell = tableView.dequeueReusableCell(withIdentifier: "FlyerCreate2345Cell", for: indexPath) as! FlyerCreate2345TableViewCell
 cell.titleTextLabel?.text = "開催時間"
 cell.inputTextLabel?.text = flyerdata?.time
 return cell
 
 case 3:
 let cell: FlyerCreate2345TableViewCell = tableView.dequeueReusableCell(withIdentifier: "FlyerCreate2345Cell", for: indexPath) as! FlyerCreate2345TableViewCell
 cell.titleTextLabel?.text = "開催場所情報"
 cell.inputTextLabel?.text = flyerdata?.locationInfo
 return cell
 
 case 4:
 let cell: FlyerCreate2345TableViewCell = tableView.dequeueReusableCell(withIdentifier: "FlyerCreate2345Cell", for: indexPath) as! FlyerCreate2345TableViewCell
 cell.titleTextLabel?.text = "メッセージ"
 cell.inputTextLabel?.text = flyerdata?.message
 return cell
 
 default:
 let cell: FlyerCreate2345TableViewCell = tableView.dequeueReusableCell(withIdentifier: "FlyerCreate2345Cell", for: indexPath) as! FlyerCreate2345TableViewCell
 cell.titleTextLabel?.text = "開催位置"
 cell.inputTextLabel?.text = ""
 return cell
 }
 }
 
 
 override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
 // Cellの高さを決める
 switch indexPath.row {
 case 0:
 return 90
 default:
 return 40
 }
 }
 
 }
 
 
 class FlyerCreate1TableViewCell: UITableViewCell {
 
 @IBOutlet weak var inputImageView: UIImageView!
 @IBOutlet weak var titleTextLabel: UILabel!
 
 override func awakeFromNib() {
 super.awakeFromNib()
 // Initialization code
 }
 
 override func setSelected(_ selected: Bool, animated: Bool) {
 super.setSelected(selected, animated: animated)
 // Configure the view for the selected state
 }
 
 }
 
 class FlyerCreate2345TableViewCell: UITableViewCell {
 
 @IBOutlet weak var titleTextLabel: UILabel!
 @IBOutlet weak var inputTextLabel: UILabel!
 
 override func awakeFromNib() {
 super.awakeFromNib()
 // Initialization code
 }
 
 override func setSelected(_ selected: Bool, animated: Bool) {
 super.setSelected(selected, animated: animated)
 // Configure the view for the selected state
 }
 
 }*/
