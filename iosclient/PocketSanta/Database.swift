//
//  Database.swift
//  PocketSanta
//
//  Created by はじめ on 2020/01/01.
//  Copyright © 2020 hajime. All rights reserved.
//

import Foundation

/* 参考：https://qiita.com/KokiEnomoto/items/c79c7f3793a244246fcf */

protocol KeyNamespaceable {
    func namespaced<T: RawRepresentable>(_ key: T) -> String
}

extension KeyNamespaceable {
    
    func namespaced<T: RawRepresentable>(_ key: T) -> String {
        return "\(Self.self).\(key.rawValue)"
    }
}

protocol StringDefaultSettable : KeyNamespaceable {
    associatedtype StringKey : RawRepresentable
}

extension StringDefaultSettable where StringKey.RawValue == String {
    
    func set(_ value: String, forKey key: StringKey) {
        let key = namespaced(key)
        UserDefaults.standard.set(value, forKey: key)
    }
    
    func set(_ value: [FlyerData], forKey key: StringKey) {
        let key = namespaced(key)
        //UserDefaults.standard.set(value, forKey: key)
        let data = value.map { try? JSONEncoder().encode($0) }
        UserDefaults.standard.set(data, forKey: key)
    }
    
    @discardableResult
    func string(forKey key: StringKey) -> String? {
        let key = namespaced(key)
        return UserDefaults.standard.string(forKey: key)
    }
    
    @discardableResult
    func flyerdata(forkey key: StringKey) -> [FlyerData]? {
        let key = namespaced(key)
        guard let encodedData = UserDefaults.standard.array(forKey: key) as? [Data] else {
            return []
        }
        
        return encodedData.map { try! JSONDecoder().decode(FlyerData.self, from: $0) }
        
    }
}

extension UserDefaults : StringDefaultSettable {
    enum StringKey : String {
        case flyerdata
    }
}
