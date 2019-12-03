//
//  Geometry.swift
//  AdventOfCode-Swift
//
//  Created by Thomas DURAND on 03/12/2019.
//  Copyright © 2019 Thomas Durand. All rights reserved.
//

import Foundation

struct Vector2D: Hashable {
    let x: Int
    let y: Int

    var manatthanDistance: Int {
        return abs(x) + abs(y)
    }
}
