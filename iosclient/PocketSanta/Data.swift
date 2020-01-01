//
//  Data.swift
//  PocketSanta
//
//  Created by hajime ito on 2019/12/23.
//  Copyright © 2019 hajime. All rights reserved.
//

import UIKit

struct FlyerData: Codable {
    var title: String
    var year: Int
    var month: Int
    var date: Int
    var timeInfo: String
    var locationInfo: String
    // Firebase CloudStorage メモリに画像を直接ダウンロードするのでUIImage型
    // 参考：https://firebase.google.com/docs/storage/ios/download-files?hl=ja
    var image: Data
    var message: String
    var locationX: Double
    var locationY: Double
    var isMine: Bool
    var FlyerKey: String
    var favorite: Bool
    
    init(title: String, year: Int, month: Int, date: Int, timeInfo: String, locationInfo: String, image: UIImage, message: String, locationX: Double, locationY: Double, isMine: Bool, FlyerKey: String, favorite: Bool) {
        self.title = title
        self.year = year
        self.month = month
        self.date = date
        self.timeInfo = timeInfo
        self.locationInfo = locationInfo
        // 参考：https://qiita.com/tomoyuki_HAYAKAWA/items/d9a2ccb5c76d9c276d1c
        self.image = image.pngData() ?? UIImage(named: "test")!.pngData()!
        self.message = message
        self.locationX = locationX
        self.locationY = locationY
        self.isMine = isMine
        self.FlyerKey = FlyerKey
        self.favorite = favorite
    }
    
    func getImage() -> UIImage {
        return UIImage(data: image)!
    }
    
    mutating func setImage(image: UIImage) {
        self.image = image.pngData()!
    }
    
    mutating func setfavorite(bool: Bool) {
        self.favorite = bool
    }
}
