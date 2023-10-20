//
//  StorageManager.swift
//  Greedy Kings
//
//  Created by Suren Poghosyan on 27.09.23.
//

import Foundation

final class StorageManager {
//    Storage manager takes data and saves it to choosed storage
    
    private let userDefaults = UserDefaults.standard
        
    func set(key: String, value: Any, storageType: StorageType){
        switch storageType {
            case .userdefaults:
                userDefaults.set(value, forKey: key)
        }
    }
    
    func get(key: String, storageType: StorageType) -> Any? {
        var data: Any?
        
        switch storageType {
            case .userdefaults:
            data = userDefaults.object(forKey: key)
        }

        return data
    }
    
    func remove(key: String, storageType: StorageType){
        switch storageType {
            case .userdefaults:
            userDefaults.removeObject(forKey: key)
        }
    }
    
    deinit {
        print("storage manager deinit")
    }

}





extension StorageManager {

    //  implement those functions as generics in extension for StorageManager to avoid code duplication in project at storage value read/write
    //    func encode(){
    //
    //    }
    //
    //    func decode(){
    //
    //    }
}
