//
//  Data.swift
//  PocketSanta
//
//  Created by hajime ito on 2019/12/23.
//  Copyright © 2019 hajime. All rights reserved.
//

import UIKit

struct FlyerData {
    var title: String
    var year: Int
    var month: Int
    var date: Int
    var timeInfo: String
    var locationInfo: String
    // Firebase CloudStorage メモリに画像を直接ダウンロードするのでUIImage型
    // 参考：https://firebase.google.com/docs/storage/ios/download-files?hl=ja
    var image: UIImage
    var message: String
    var locationX: Double
    var locationY: Double
    var isMine: Bool
    var FlyerKey: String
    var favorite: Bool?
}

