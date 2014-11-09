//
//  DictionaryExtension.swift
//  Recall
//
//  Created by Sheldon Conaty on 14/10/2014.
//  Copyright (c) 2014 Sheldon Conaty. All rights reserved.
//

import Foundation

// Merges two dictionaries. For example:
//      var dict1 = ["a": "foo"]
//      var dict2 = ["a": "fee", "b": "foo"]
//
//      var dict3 = dict1 + dict2      // now ["a": "fee", "b": "foo"]
//
// Note, dict3 is a shallow copy of dict1
//
public func + <KeyType, ValueType> (left: Dictionary<KeyType, ValueType>, right: Dictionary<KeyType, ValueType>)
    -> Dictionary<KeyType, ValueType>
{
    var result = left
    result += right
    
    return result
}

// Merges two dictionaries. For example
//      var dict1 = ["a": "foo"]
//      var dict2 = ["a": "fee", "b": "foo"]
//
//      dict1 += dict2      // now ["a": "fee", "b": "foo"]
//
public func += <KeyType, ValueType> (inout left: Dictionary<KeyType, ValueType>, right: Dictionary<KeyType, ValueType>) {
    for (key, value) in right {
        left.updateValue(value, forKey: key)
    }
}