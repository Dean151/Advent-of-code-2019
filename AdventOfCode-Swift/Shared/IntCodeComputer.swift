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
            case 99:
                return .exit
            default:
                fatalError("Unknown operation found: \(opcode)")
            }
        }

        var increment: Int? {
            switch self {
            case .add, .multiply:
                return 4
            case .input, .output:
                return 2
            case .exit:
                return nil
            }
        }

        func perform(instructions: inout [Int], current: Int, inputs: inout [Int], output: inout [Int]) {
            switch self {
            case .add(immediateA: let immediateA, immediateB: let immediateB):
                let a = instructions[current + 1]
                let b = instructions[current + 2]
                let c = instructions[current + 3]
                instructions[c] = (immediateA ? a : instructions[a]) + (immediateB ? b : instructions[b])
            case .multiply(immediateA: let immediateA, immediateB: let immediateB):
                let a = instructions[current + 1]
                let b = instructions[current + 2]
                let c = instructions[current + 3]
                instructions[c] = (immediateA ? a : instructions[a]) * (immediateB ? b : instructions[b])
            case .input:
                guard !inputs.isEmpty else {
                    fatalError("Missing user input")
                }
                let a = instructions[current + 1]
                instructions[a] = inputs.removeFirst()
            case .output(immediateA: let immediateA):
                let a = instructions[current + 1]
                output.append(immediateA ? a : instructions[a])
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
            guard let increment = operation.increment else {
                break
            }
            operation.perform(instructions: &instructions, current: current, inputs: &inputs, output: &output)
            current += increment
        }
        return (instructions, output)
    }
}
