//
//  PickerData.swift
//  fourspoon
//
//  Created by Ryan Kotzebue on 11/3/17.
//  Copyright © 2017 Ryan Kotzebue. All rights reserved.
//

import Foundation

struct PickerData {
    var display : String!
    var id : String!
}


let queryArray : [PickerData] = [
    PickerData(display: "☕️", id: "coffee"),
    PickerData(display: "🍻", id: "beers"),
    PickerData(display: "🌮", id: "mexican"),
    PickerData(display: "🍽", id: "dinner"),
    PickerData(display: "🍦", id: "ice cream"),
    PickerData(display: "🍕", id: "pizza"),
    PickerData(display: "🍸", id: "drinks")
    
]

let radiusArray : [PickerData] = [
    PickerData(display: "<5min🚶", id: "420"),
    PickerData(display: "<10min🚶", id: "900"),
    PickerData(display: "<20min🚶", id: "1700"),
    PickerData(display: "🚗", id: "3200")
]

let priceArray : [PickerData] = [
    PickerData(display: "Any", id: "1,2,3,4"),
    PickerData(display: "$", id: "1"),
    PickerData(display: "$$", id: "2"),
    PickerData(display: "$$$", id: "3"),
    PickerData(display: "$$$$", id: "4")
]
