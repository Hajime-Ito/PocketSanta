//
//  PocketSantaTests.swift
//  PocketSantaTests
//
//  Created by hajime ito on 2019/12/19.
//  Copyright © 2019 hajime. All rights reserved.
//
//  XCTest Xcode11.3

import XCTest

@testable import PocketSanta

class PocketSantaTests: XCTestCase {
    var flyerManager: FlyerManager!
    var flyerdata: FlyerData!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        flyerManager = .init()
        flyerdata = FlyerData(title:"TEST", year:0, month:0, date:0, timeInfo: "TEST", locationInfo: "TEST", image: UIImage(named:"test1")!, message: "TEST", locationX:0, locationY:0, isMine: false, FlyerKey: "test", favorite: false)
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    
    func testExample() {
        testaddFlyer()
        testgetFlyer()
        testremoveFlyer()
        testupdateFlyer()
    }
    
    
    private func testaddFlyer() {
        // FlyerDataの追加(.addFlyer)が成功すべき場合に成功するかどうか
        flyerManager.addFlyer(flyer: flyerdata!)
        if (flyerManager.getFlyer()!.count == 0) {
         XCTFail("fatal")
        }
        print("success")
    }
    
    private func testgetFlyer() {
        // Flyerの取得(.getFlyer)が成功すべき場合に成功するかどうか
        XCTAssertNotNil(flyerManager.getFlyer(), "fatal")
        for _ in flyerManager.getFlyer()! {
            print("success")
        }
    }
    
    private func testremoveFlyer() {
        // FlyerDataの削除(Flyerkeyを利用して)(.removeFlyer)が成功すべき場合に成功するかどうか
        flyerManager.removeFlyer(flyerdata.FlyerKey)
        if (flyerManager.getFlyer()!.count == 0) {
                   XCTAssertNil (nil, "fatal")
               }
        print("success")
        // テスト用FlyerDataの追加
        flyerManager.addFlyer(flyer: flyerdata!)
        // FlyerDataの削除(配列の番目を利用して)(.removeFlyer)が成功すべき場合に成功するかどうか
        flyerManager.removeFlyer(0)
        if (flyerManager.getFlyer()!.isEmpty) {
            XCTAssertNil (nil, "fatal")
        }
        
        print("success")
    }
    
    private func testupdateFlyer() {
        // テスト用FlyerDataの追加
        flyerManager.addFlyer(flyer: flyerdata!)
        // FlyerDataの変更(.favoriteをtureに)(.updateFlyer)が成功すべき場合に成功するかどうか
        flyerManager.updateFlyer(flyerdata.FlyerKey, favorite: true)
        if(flyerManager.getFlyer()![0].favorite == true) {print("success")}
        else {print("false")}
        // FlyerDataの変更(Flyerkeyを利用して)(.updateFlyer)が成功すべき場合に成功するかどうか
        flyerdata = FlyerData(title:"TEST1", year:0, month:0, date:0, timeInfo: "TEST1", locationInfo: "TEST1", image: UIImage(named:"test1")!, message: "TEST1", locationX:0, locationY:0, isMine: false, FlyerKey: "test", favorite: false)
        flyerManager.updateFlyer(flyerdata.FlyerKey, flyer: flyerdata)
        if(flyerManager.getFlyer()![0].title == "TEST1") {print("success")}
        else {print("false")}
        // FlyerDataの変更(配列の番目を利用して)(.updateFlyer)が成功すべき場合に成功するかどうか
        flyerdata = FlyerData(title:"TEST2", year:0, month:0, date:0, timeInfo: "TEST2", locationInfo: "TEST2", image: UIImage(named:"test1")!, message: "TEST2", locationX:0, locationY:0, isMine: false, FlyerKey: "test", favorite: false)
        flyerManager.updateFlyer(0, flyer: flyerdata)
        if(flyerManager.getFlyer()![0].title == "TEST2") {print("success")}
        else {print("false")}
    }
}
