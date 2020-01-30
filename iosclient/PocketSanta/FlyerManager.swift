//
//  FlyerManager.swift
//  PocketSanta
//
//  Created by はじめ on 2020/01/01.
//  Copyright © 2020 hajime. All rights reserved.
//

import UIKit

struct FlyerManager {
    var FlyerArray: [FlyerData] = [FlyerData]()
    
    init () {
        //この関数はWebAPIクライアントの方で呼び出した方がいいかも
        mergeFlyer(Flyer: getFlyerFromServer())
    }
    
    mutating private func mergeFlyer(Flyer: [FlyerData]) {
        // サーバから送られてきたデータが既に持っているものだったら、追加しない。持っていなかったら追加する
        var flyerArray = [FlyerData]()
        self.FlyerArray = UserDefaults.standard.flyerdata(forkey: .flyerdata) ?? []
        for flyer in Flyer {
            flyerArray.append(flyer)
            for flyer1 in self.FlyerArray {
                if(flyer.FlyerKey == flyer1.FlyerKey) {
                    //一度でもキーが被ったら
                    print(flyer)
                    flyerArray.remove(at: flyerArray.count - 1)
                    break
                }
            }
        }
        self.FlyerArray += flyerArray
        saveFlyer()
    }
    
    private func saveFlyer() {
        UserDefaults.standard.set(FlyerArray, forKey: .flyerdata)
    }
    
    func getFlyer() -> [FlyerData]? {
        return FlyerArray
    }
    
    mutating func addFlyer(flyer: FlyerData) {
        self.FlyerArray.append(flyer)
        saveFlyer()
    }
    
    mutating func removeFlyer(_ key: String) {
        for i in 0..<FlyerArray.count {
            if(FlyerArray[i].FlyerKey == key) {
                FlyerArray.remove(at: i)
                break
            }
        }
        saveFlyer()
        // WEBAPI REMOVE CALL
    }
    
    mutating func removeFlyer(_ index: Int) {
        FlyerArray.remove(at: index)
        saveFlyer()
    }
    
    mutating private func removeFlyerFromArray(_ index: Int) {
        FlyerArray.remove(at: index)
    }
    
    mutating private func removeFlyerFromArray(_ key: String) {
        for i in 0..<FlyerArray.count {
            if(FlyerArray[i].FlyerKey == key) {
                FlyerArray.remove(at: i)
                break
            }
        }
    }
    
    func indexOfFlyer(key: String)->Int?{
        for i in 0..<FlyerArray.count {
            if(FlyerArray[i].FlyerKey == key) {
                return i
            }
        }
        return nil
    }
    
    mutating func updateFlyer(_ key: String, flyer: FlyerData) {
        removeFlyerFromArray(key)
        FlyerArray.append(flyer)
        saveFlyer()
    }
    
    mutating func updateFlyer(_ index: Int, flyer: FlyerData) {
        removeFlyerFromArray(index)
        FlyerArray.append(flyer)
        saveFlyer()
    }
    
    mutating func updateFlyer(_ key: String, favorite: Bool) {
        guard let index = indexOfFlyer(key: key) else {
            return
        }
        FlyerArray[index].setfavorite(bool: favorite)
        saveFlyer()
    }
    
    mutating func updateFlyer(_ key: String, isMine: Bool) {
        guard let index = indexOfFlyer(key: key) else {
            return
        }
        FlyerArray[index].setisMine(bool: isMine)
        saveFlyer()
    }
    
    mutating func getFlyerFromServer() -> [FlyerData] {
        var flyerArray = [FlyerData]()
        flyerArray.append(FlyerData(title:"クリスマスファンタジー", year: 2019, month: 12, date:24, timeInfo: "10時から20時まで", locationInfo: "金森赤煉瓦倉庫", image: UIImage(named:"test1")!, message: "毎年開催している函館クリスマスファンタジーも今年で35回目！今年は歌手のLamdaさんを呼んで、演奏をしてもらいます！クリスマススープも600円で提供。今年もたくさんの種類のスープが出ていますよ〜！", locationX: 41.7661584, locationY: 140.71655989, isMine: false, FlyerKey: "aaa", favorite: true))
        flyerArray.append(FlyerData(title:"JAZZ in Hakodate", year: 2019, month: 12, date:23, timeInfo: "21時から23時まで", locationInfo: "はこだてジャズ会館", image: UIImage(named:"test2")!, message: "JAZZでクリスマスを飾ろう！函館ジャズといえば、JAZZ in Hakodate。明治から続くイカしたジャズライブを今年も盛り上げよう！ご好評につき、今年もジャズコーラを振る舞います。", locationX: 41.79161729, locationY: 140.75155576, isMine: true, FlyerKey: "aab", favorite: false))
        
        flyerArray.append(FlyerData(title:"道民コーラス・イン函館", year: 2019, month: 12, date:21, timeInfo: "18時から20時まで", locationInfo: "函館アリーナ３階ホールA", image: UIImage(named:"test3")!, message: "北海道は函館のクリスマス合唱といえば、道民コーラス・イン函館！今年は、はこだて未来大学の合唱サークル「歌とロボと秘密のAI姫」さんをお招きして、独自のパフォーマンスを披露してもらいます。", locationX: 41.78188055, locationY: 140.782793, isMine: false, FlyerKey: "abii", favorite: false))
        return flyerArray
    }
    
}
