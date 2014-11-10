//
//  DictionaryExtension.swift
//  BDDExample
//
//  Created by Sheldon Conaty on 14/10/2014.
//

import Foundation

/**
Merges two dictionaries. For example:
```
    var dict1 = ["a": "foo"]
    var dict2 = ["a": "fee", "b": "foo"]

    var dict3 = dict1 + dict2       // now ["a": "fee", "b": "foo"]
```
Note, dict3 is a shallow copy of dict1

:param: left    Master dictionary which is to be base for the newly returned dictionary
:param: right   Update dictionary which is used to update/add entries to the return dictionary

:returns: The merged dictionary
*/
public func + <KeyType, ValueType> (left: Dictionary<KeyType, ValueType>, right: Dictionary<KeyType, ValueType>)
    -> Dictionary<KeyType, ValueType>
{
    var result = left
    result += right
    
    return result
}

/**
Merges two dictionaries. For example:
```
    var dict1 = ["a": "foo"]
    var dict2 = ["a": "fee", "b": "foo"]

    dict1 += dict2          // now ["a": "fee", "b": "foo"]
```
:param: left    Master dictionary which is to be updated in-place
:param: right   Update dictionary which is used to update/add entries to the master dictionary

:returns: Nothing. Master dictioanary is updated in-place
*/
public func += <KeyType, ValueType> (inout left: Dictionary<KeyType, ValueType>, right: Dictionary<KeyType, ValueType>) {
    for (key, value) in right {
        left.updateValue(value, forKey: key)
    }
}