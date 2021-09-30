//
//  ImageCache.swift
//  OpenMarket
//
//  Created by James on 2021/09/17.
//

import Foundation

final class ImageCache<Key: Hashable, Value> {
    private let wrappedKeyAndEntry = NSCache<WrappedKey, Entry>()
    
    init(totalCostLimit: Int) {
        self.wrappedKeyAndEntry.totalCostLimit = totalCostLimit
    }
    
    func insert(_ value: Value, forkey key: Key) {
        let entry = Entry(value: value)
        wrappedKeyAndEntry.setObject(entry, forKey: WrappedKey(key))
        
    }
    
    func value(forkey key: Key) -> Value? {
        let entry = wrappedKeyAndEntry.object(forKey: WrappedKey(key))
        return entry?.value
    }
    
    func removeValue(forKey key: Key) {
        wrappedKeyAndEntry.removeObject(forKey: WrappedKey(key))
    }
    
    func removeAllObjects() {
        wrappedKeyAndEntry.removeAllObjects()
    }
}
private extension ImageCache {
    final class WrappedKey: NSObject {
        let key: Key
        
        init(_ key: Key) {
            self.key = key
        }
        
        override var hash: Int {
            return key.hashValue
        }
        
        override func isEqual(_ object: Any?) -> Bool {
            guard let wrappedKey = object as? WrappedKey else {
                return false
            }
            return wrappedKey.key == key
        }
    }
}
private extension ImageCache {
    final class Entry {
        let value: Value
        
        init(value: Value) {
            self.value = value
        }
    }
}
extension ImageCache {
    subscript(key: Key) -> Value? {
        get {
            return value(forkey: key)
        }
        set {
            guard let value = newValue else {
                removeValue(forKey: key)
                return
            }
            insert(value, forkey: key)
        }
    }
}
