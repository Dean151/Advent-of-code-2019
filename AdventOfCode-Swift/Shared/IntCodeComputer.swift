//
//  IntCodeComputer.swift
//  AdventOfCode-Swift
//
//  Created by Thomas DURAND on 05/12/2019.
//  Copyright © 2019 Thomas Durand. All rights reserved.
//

import Foundation

struct IntCodeComputer {

    static var pendingInput: [Int] = []

    enum Operation {
        case add(pointerA: Bool, pointerB: Bool)
        case multiply(pointerA: Bool, pointerB: Bool)
        case input
        case output(pointerA: Bool)
        case exit

        static func from(opcode: Int) -> Operation? {
            switch opcode {
            case 1:
                return .add(pointerA: true, pointerB: true)
            case 2:
                return .multiply(pointerA: true, pointerB: true)
            case 3:
                return .input
            case 4:
                return .output(pointerA: true)
            case 99:
                return .exit
            case 101:
                return .add(pointerA: false, pointerB: true)
            case 102:
                return .multiply(pointerA: false, pointerB: true)
            case 104:
                return .output(pointerA: false)
            case 1001:
                return .add(pointerA: true, pointerB: false)
            case 1002:
                return .multiply(pointerA: true, pointerB: false)
            case 1101:
                return .add(pointerA: false, pointerB: false)
            case 1102:
                return .multiply(pointerA: false, pointerB: false)
            default:
                return nil
            }
        }

        func perform(instructions: inout [Int], current: Int) -> Int {
            switch self {
            case .add(pointerA: let pointerA, pointerB: let pointerB):
                let a = instructions[current + 1]
                let b = instructions[current + 2]
                instructions[instructions[current + 3]] = (pointerA ? instructions[a] : a) + (pointerB ? instructions[b] : b)
                return 4
            case .multiply(pointerA: let pointerA, pointerB: let pointerB):
                let a = instructions[current + 1]
                let b = instructions[current + 2]
                instructions[instructions[current + 3]] = (pointerA ? instructions[a] : a) * (pointerB ? instructions[b] : b)
                return 4
            case .input:
                let a = instructions[current + 1]
                var input = IntCodeComputer.pendingInput.popLast()
                while input == nil {
                    print("USER INPUT EXPECTED:")
                    input = Int(readLine() ?? "")
                }
                instructions[a] = input!
                return 2
            case .output(pointerA: let pointerA):
                let a = instructions[current + 1]
                let output = pointerA ? instructions[a] : a
                print("OUTPUT: \(output)")
                return 2
            case .exit:
                return 0
            }
        }
    }

    static func run(with instructions: [Int], firstInput: Int? = nil) -> [Int] {
        if let input = firstInput {
            IntCodeComputer.pendingInput.append(input)
        }
        var instructions = instructions
        var current = 0
        while true {
            guard let operation = Operation.from(opcode: instructions[current]) else {
                fatalError("Unknown operation found: \(instructions[current])")
            }
            let increment = operation.perform(instructions: &instructions, current: current)
            if increment == 0 {
                break
            }
            current += increment
        }
        return instructions
    }
}
