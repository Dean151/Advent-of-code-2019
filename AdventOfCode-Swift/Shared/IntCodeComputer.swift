//
//  IntCodeComputer.swift
//  AdventOfCode-Swift
//
//  Created by Thomas DURAND on 05/12/2019.
//  Copyright © 2019 Thomas Durand. All rights reserved.
//

import Foundation

struct IntCodeComputer {

    enum Operation: Int {
        case add = 1
        case multiply = 2
        case exit = 99

        func perform(instructions: inout [Int], current: Int) {
            let a = instructions[current + 1]
            let b = instructions[current + 2]
            let c = instructions[current + 3]
            switch self {
            case .add:
                instructions[c] = instructions[a] + instructions[b]
            case .multiply:
                instructions[c] = instructions[a] * instructions[b]
            case .exit:
                fatalError("Calling perform on exit instruction...")
            }
        }
    }

    static func run(with instructions: [Int]) -> [Int] {
        var instructions = instructions
        var current = 0
        while true {
            guard let operation = Operation(rawValue: instructions[current]) else {
                fatalError("Unknown operation found: \(instructions[current])")
            }
            if operation == .exit {
                break
            }
            operation.perform(instructions: &instructions, current: current)
            current += 4
        }
        return instructions
    }
}
