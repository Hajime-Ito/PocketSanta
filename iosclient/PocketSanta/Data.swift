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
        // 参考：https://stackoverflow.com/questions/29137488/how-do-i-resize-the-uiimage-to-reduce-upload-image-size
        // UIImagewのデータを小さく
        let Image = image.resized(image)
        // 参考：https://qiita.com/tomoyuki_HAYAKAWA/items/d9a2ccb5c76d9c276d1c
        self.image = Image.pngData() ?? UIImage(named: "test")!.pngData()!
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
        let Image = image.resized(image)
        self.image = Image.pngData()!
    }
    
    mutating func setfavorite(bool: Bool) {
        self.favorite = bool
    }
}

extension UIImage {
    
    func resized(_ image: UIImage) -> UIImage {
        var actualHeight = Float(image.size.height)
        var actualWidth = Float(image.size.width)
        let maxHeight: Float = 900.0
        let maxWidth: Float = 900.0
        var imgRatio: Float = actualWidth / actualHeight
        let maxRatio: Float = maxWidth / maxHeight
        let compressionQuality: Float = 0.4
        //40 percent compression
        if actualHeight > maxHeight || actualWidth > maxWidth {
            if imgRatio < maxRatio {
                //adjust width according to maxHeight
                imgRatio = maxHeight / actualHeight
                actualWidth = imgRatio * actualWidth
                actualHeight = maxHeight
            }
            else if imgRatio > maxRatio {
                //adjust height according to maxWidth
                imgRatio = maxWidth / actualWidth
                actualHeight = imgRatio * actualHeight
                actualWidth = maxWidth
            }
            else {
                actualHeight = maxHeight
                actualWidth = maxWidth
            }
        }
        let rect = CGRect(x: 0.0, y: 0.0, width: CGFloat(actualWidth), height: CGFloat(actualHeight))
        UIGraphicsBeginImageContext(rect.size)
        image.draw(in: rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        let imageData = img?.jpegData(compressionQuality: CGFloat(compressionQuality))
        UIGraphicsEndImageContext()
        return UIImage(data: imageData!) ?? UIImage()
    }
    
    func resized(withPercentage percentage: CGFloat) -> UIImage? {
        let canvas = CGSize(width: size.width * percentage, height: size.height * percentage)
        return UIGraphicsImageRenderer(size: canvas, format: imageRendererFormat).image {
            _ in draw(in: CGRect(origin: .zero, size: canvas))
        }
    }
    func resized(toWidth width: CGFloat) -> UIImage? {
        let canvas = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
        return UIGraphicsImageRenderer(size: canvas, format: imageRendererFormat).image {
            _ in draw(in: CGRect(origin: .zero, size: canvas))
        }
    }
}
