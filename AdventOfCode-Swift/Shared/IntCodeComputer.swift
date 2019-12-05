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
        case add(pointerA: Bool, pointerB: Bool)
        case multiply(pointerA: Bool, pointerB: Bool)
        case input
        case output(pointerA: Bool)
        case exit

        static func from(opcode: Int) -> Operation {
            let pointerA = (opcode / 100) % 2 == 0
            let pointerB = (opcode / 1000) % 2 == 0
            switch opcode % 100 {
            case 1:
                return .add(pointerA: pointerA, pointerB: pointerB)
            case 2:
                return .multiply(pointerA: pointerA, pointerB: pointerB)
            case 3:
                return .input
            case 4:
                return .output(pointerA: pointerA)
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
            case .add(pointerA: let pointerA, pointerB: let pointerB):
                let a = instructions[current + 1]
                let b = instructions[current + 2]
                instructions[instructions[current + 3]] = (pointerA ? instructions[a] : a) + (pointerB ? instructions[b] : b)
            case .multiply(pointerA: let pointerA, pointerB: let pointerB):
                let a = instructions[current + 1]
                let b = instructions[current + 2]
                instructions[instructions[current + 3]] = (pointerA ? instructions[a] : a) * (pointerB ? instructions[b] : b)
            case .input:
                guard !inputs.isEmpty else {
                    fatalError("Missing user input")
                }
                instructions[instructions[current + 1]] = inputs.removeFirst()
            case .output(pointerA: let pointerA):
                let a = instructions[current + 1]
                output.append(pointerA ? instructions[a] : a)
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
