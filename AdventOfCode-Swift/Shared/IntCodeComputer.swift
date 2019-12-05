//
//  IntCodeComputer.swift
//  AdventOfCode-Swift
//
//  Created by Thomas DURAND on 05/12/2019.
//  Copyright © 2019 Thomas Durand. All rights reserved.
//

import Foundation

struct IntCodeComputer {

    let instructions: [Int]
    let inputs: [Int]

    init(instructions: [Int], inputs: [Int] = []) {
        self.instructions = instructions
        self.inputs = inputs
    }

    enum Operation {
        case add(immediateA: Bool, immediateB: Bool)
        case multiply(immediateA: Bool, immediateB: Bool)
        case input
        case output(immediateA: Bool)
        case jumpIfTrue(immediateA: Bool, immediateB: Bool)
        case jumpIfFalse(immediateA: Bool, immediateB: Bool)
        case lessThan(immediateA: Bool, immediateB: Bool)
        case equals(immediateA: Bool, immediateB: Bool)
        case exit

        static func from(opcode: Int) -> Operation {
            let immediateA = (opcode / 100) % 2 == 1
            let immediateB = (opcode / 1000) % 2 == 1
            switch opcode % 100 {
            case 1:
                return .add(immediateA: immediateA, immediateB: immediateB)
            case 2:
                return .multiply(immediateA: immediateA, immediateB: immediateB)
            case 3:
                return .input
            case 4:
                return .output(immediateA: immediateA)
            case 5:
                return jumpIfTrue(immediateA: immediateA, immediateB: immediateB)
            case 6:
                return jumpIfFalse(immediateA: immediateA, immediateB: immediateB)
            case 7:
                return lessThan(immediateA: immediateA, immediateB: immediateB)
            case 8:
                return equals(immediateA: immediateA, immediateB: immediateB)
            case 99:
                return .exit
            default:
                fatalError("Unknown operation found: \(opcode)")
            }
        }

        func perform(instructions: inout [Int], current: inout Int, inputs: inout [Int], output: inout [Int]) {
            switch self {
            case .add(immediateA: let immediateA, immediateB: let immediateB):
                let a = instructions[current + 1]
                let b = instructions[current + 2]
                let c = instructions[current + 3]
                instructions[c] = (immediateA ? a : instructions[a]) + (immediateB ? b : instructions[b])
                current += 4
            case .multiply(immediateA: let immediateA, immediateB: let immediateB):
                let a = instructions[current + 1]
                let b = instructions[current + 2]
                let c = instructions[current + 3]
                instructions[c] = (immediateA ? a : instructions[a]) * (immediateB ? b : instructions[b])
                current += 4
            case .input:
                guard !inputs.isEmpty else {
                    fatalError("Missing user input")
                }
                let a = instructions[current + 1]
                instructions[a] = inputs.removeFirst()
                current += 2
            case .output(immediateA: let immediateA):
                let a = instructions[current + 1]
                output.append(immediateA ? a : instructions[a])
                current += 2
            case .jumpIfTrue(immediateA: let immediateA, immediateB: let immediateB):
                let a = instructions[current + 1]
                let b = instructions[current + 2]
                if (immediateA ? a : instructions[a]) != 0 {
                    current = immediateB ? b : instructions[b]
                }
                else {
                    current += 3
                }
            case .jumpIfFalse(immediateA: let immediateA, immediateB: let immediateB):
                let a = instructions[current + 1]
                let b = instructions[current + 2]
                if (immediateA ? a : instructions[a]) == 0 {
                    current = immediateB ? b : instructions[b]
                }
                else {
                    current += 3
                }
            case .lessThan(immediateA: let immediateA, immediateB: let immediateB):
                let a = instructions[current + 1]
                let b = instructions[current + 2]
                let c = instructions[current + 3]
                instructions[c] = (immediateA ? a : instructions[a]) < (immediateB ? b : instructions[b]) ? 1 : 0
                current += 4
            case .equals(immediateA: let immediateA, immediateB: let immediateB):
                let a = instructions[current + 1]
                let b = instructions[current + 2]
                let c = instructions[current + 3]
                instructions[c] = (immediateA ? a : instructions[a]) == (immediateB ? b : instructions[b]) ? 1 : 0
                current += 4
            case .exit:
                fatalError("Calling 'perform' on exit opcode")
            }
        }
    }

    func run() -> (instructions: [Int], output: [Int]) {
        var instructions = self.instructions
        var inputs = self.inputs
        var output: [Int] = []
        var current = 0
        while true {
            let operation = Operation.from(opcode: instructions[current])
            if case Operation.exit = operation {
                break
            }
            operation.perform(instructions: &instructions, current: &current, inputs: &inputs, output: &output)
        }
        return (instructions, output)
    }
}
