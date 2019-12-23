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

extension Vector2D {
    enum Turn {
        case left, right
    }
    enum Direction {
        case up, left, right, down

        func turned(_ turn: Turn) -> Direction {
            switch self {
            case .up:
                return turn == .left ? .left : .right
            case .left:
                return turn == .left ? .down : .up
            case .down:
                return turn == .left ? .right : .left
            case .right:
                return turn == .left ? .up : .down
            }
        }
        mutating func turn(_ turn: Turn) {
            self = self.turned(turn)
        }
    }
    
    func moved(_ direction: Direction) -> Vector2D {
        switch direction {
        case .up:
            return Vector2D(x: x, y: y - 1)
        case .left:
            return Vector2D(x: x - 1, y: y)
        case .right:
            return Vector2D(x: x + 1, y: y)
        case .down:
            return Vector2D(x: x, y: y + 1)
        }
    }
    mutating func move(_ direction: Direction) {
        self = self.moved(direction)
    }
}