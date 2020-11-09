//
//  OtherFunction.swift
//  SrimCalculator
//
//  Created by 최원석 on 2020/11/09.
//  Copyright © 2020 최원석. All rights reserved.
//

import Foundation


func roundToBillion(value: Int) -> String {
    let billionValue = value/100000000 * 100000000 + (value % 100000000)/50000000 * 100000000
    let str = String(billionValue)
    let endIndex = str.index(str.endIndex, offsetBy: -8)
    let remakeStr = str.substring(to: endIndex)
    return remakeStr
}
