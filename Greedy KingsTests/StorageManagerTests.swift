//
//  StorageManagerTests.swift
//  Greedy KingsTests
//
//  Created by Suren Poghosyan on 20.10.23.
//

import XCTest
@testable import Greedy_Kings

final class StorageManagerTests: XCTestCase {
    var storageManager: StorageManager!
    
    
    override func setUpWithError() throws {
        storageManager = StorageManager()
    }

    override func tearDownWithError() throws {
        storageManager = nil
    }

    func testStorageManagerInitialization() throws {
        if storageManager == nil {
            XCTFail("Failed to initialize storage manager")
        }
    }

    func testSetAndGetValues() throws {
        let keyString = "stringKey"
        let stringValue = "testStringValue"

        let keyInt = "intKey"
        let intValue = 42

        let keyDouble = "doubleKey"
        let doubleValue = 3.14159

        let keyBool = "boolKey"
        let boolValue = true

        storageManager.set(key: keyString, value: stringValue, storageType: .userdefaults)
        if let storedString = storageManager.get(key: keyString, storageType: .userdefaults) as? String {
            XCTAssertEqual(storedString, stringValue)
        } else {
            XCTFail("Failed to get saved string data.")
        }

        // integer
        storageManager.set(key: keyInt, value: intValue, storageType: .userdefaults)
        if let storedInt = storageManager.get(key: keyInt, storageType: .userdefaults) as? Int {
            XCTAssertEqual(storedInt, intValue)
        } else {
            XCTFail("Failed to get saved integer data.")
        }

        // double
        storageManager.set(key: keyDouble, value: doubleValue, storageType: .userdefaults)
        if let storedDouble = storageManager.get(key: keyDouble, storageType: .userdefaults) as? Double {
            XCTAssertEqual(storedDouble, doubleValue, accuracy: 0.0001)
        } else {
            XCTFail("Failed to get saved double data.")
        }

        // boolean
        storageManager.set(key: keyBool, value: boolValue, storageType: .userdefaults)
        if let storedBool = storageManager.get(key: keyBool, storageType: .userdefaults) as? Bool {
            XCTAssertEqual(storedBool, boolValue)
        } else {
            XCTFail("Failed to get saved boolean data.")
        }
        
    }

   
    
    func testRemoveValue() throws {
        let key = "testSetValueKey"
        let value = "testSetValue"
        
        storageManager.set(key: key, value: value, storageType: .userdefaults)
        
        storageManager.remove(key: key, storageType: .userdefaults)
        
        XCTAssertNil(storageManager.get(key: key, storageType: .userdefaults))
    }


    
    
}
