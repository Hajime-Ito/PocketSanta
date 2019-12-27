//
//  Data.swift
//  PocketSanta
//
//  Created by hajime ito on 2019/12/23.
//  Copyright © 2019 hajime. All rights reserved.
//

import UIKit

struct FlyerData {
    let title: String
    let year: Int
    let month: Int
    let date: Int
    let timeInfo: String
    let locationInfo: String
    // Firebase CloudStorage メモリに画像を直接ダウンロードするのでUIImage型
    // 参考：https://firebase.google.com/docs/storage/ios/download-files?hl=ja
    let image: UIImage
    let message: String
    let locationX: Double
    let locationY: Double
    let isMine: Bool
}

