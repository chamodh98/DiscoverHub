//
//  CacheManager.swift
//  DiscoverHub
//
//  Created by Chamod Hettiarachchi on 2025-12-16.
//

import Foundation

final class CacheManager {
    static let shared = CacheManager()
    
    private let cache = NSCache<NSString, AnyObject>()
    
    func set(_ object: AnyObject, forKey key: String) {
        cache.setObject(object, forKey: key as NSString)
    }
    
    func get(forKey key: String) -> AnyObject? {
        cache.object(forKey: key as NSString)
    }
}
