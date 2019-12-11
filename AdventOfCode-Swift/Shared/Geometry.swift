//
//  Geometry.swift
//  AdventOfCode-Swift
//
//  Created by Thomas DURAND on 03/12/2019.
//  Copyright © 2019 Thomas Durand. All rights reserved.
//

import Foundation

struct Vector2D: Hashable {
    static var zero = Vector2D(x: 0, y: 0)

    var x: Int
    var y: Int

    var manatthanDistance: Int {
        return abs(x) + abs(y)
    }

    var norm: Double {
        return sqrt(Double(x * x + y * y))
    }
    var argument: Double {
        if y == 0 && x == 0 {
            fatalError("Oupsie")
        }
        return atan2(Double(y), Double(x))
    }
}

extension Vector2D: CustomStringConvertible {
    var description: String {
        return "(\(x),\(y))"
    }
}
