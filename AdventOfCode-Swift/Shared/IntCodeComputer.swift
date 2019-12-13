//
//  IntCodeComputer.swift
//  AdventOfCode-Swift
//
//  Created by Thomas DURAND on 05/12/2019.
//  Copyright © 2019 Thomas Durand. All rights reserved.
//

import Foundation

struct IntCodeComputer {
    var memory: [Int: Int]
    var inputs: [Int]

    var current: Int = 0
    var outputs: [Int] = []

    var pending = false
    var finished = false

    init(instructions: [Int], inputs: [Int] = []) {
        var memory: [Int: Int] = [:]
        for (offset, instruction) in instructions.enumerated() {
            memory[Int(offset)] = instruction
        }
        self.memory = memory
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

        var numberOfParameters: Int {
            switch self {
            case .add, .multiply, .lessThan, .equals:
                return 3
            case .jumpIfTrue, .jumpIfFalse:
                return 2
            case .input, .output:
                return 1
            case .exit:
                fatalError("Calling 'numberOfParameters' on exit opcode")
            }
        }

        func perform(on computer: inout IntCodeComputer, with parameters: [Int]) {
            switch self {
            case .add(immediateA: let immediateA, immediateB: let immediateB):
                let a = parameters[0], b = parameters[1], c = parameters[2]
                computer.memory[c] = (immediateA ? a : computer.memory[a]!) + (immediateB ? b : computer.memory[b]!)
                computer.current += 4
            case .multiply(immediateA: let immediateA, immediateB: let immediateB):
                let a = parameters[0], b = parameters[1], c = parameters[2]
                computer.memory[c] = (immediateA ? a : computer.memory[a]!) * (immediateB ? b : computer.memory[b]!)
                computer.current += 4
            case .input:
                guard !computer.inputs.isEmpty else {
                    computer.pending = true
                    return
                }
                let a = parameters[0]
                computer.memory[a] = computer.inputs.removeFirst()
                computer.current += 2
            case .output(immediateA: let immediateA):
                let a = parameters[0]
                computer.outputs.append(immediateA ? a : computer.memory[a]!)
                computer.current += 2
            case .jumpIfTrue(immediateA: let immediateA, immediateB: let immediateB):
                let a = parameters[0], b = parameters[1]
                if (immediateA ? a : computer.memory[a]!) != 0 {
                    computer.current = immediateB ? b : computer.memory[b]!
                }
                else {
                    computer.current += 3
                }
            case .jumpIfFalse(immediateA: let immediateA, immediateB: let immediateB):
                let a = parameters[0], b = parameters[1]
                if (immediateA ? a : computer.memory[a]) == 0 {
                    computer.current = immediateB ? b : computer.memory[b]!
                }
                else {
                    computer.current += 3
                }
            case .lessThan(immediateA: let immediateA, immediateB: let immediateB):
                let a = parameters[0], b = parameters[1], c = parameters[2]
                computer.memory[c] = (immediateA ? a : computer.memory[a]!) < (immediateB ? b : computer.memory[b]!) ? 1 : 0
                computer.current += 4
            case .equals(immediateA: let immediateA, immediateB: let immediateB):
                let a = parameters[0], b = parameters[1], c = parameters[2]
                computer.memory[c] = (immediateA ? a : computer.memory[a]!) == (immediateB ? b : computer.memory[b]!) ? 1 : 0
                computer.current += 4
            case .exit:
                fatalError("Calling 'perform' on exit opcode")
            }
        }
    }

    mutating func run() {
        if finished {
            return
        }
        pending = false
        while true {
            let operation = Operation.from(opcode: memory[current]!)
            if case Operation.exit = operation {
                finished = true
                break
            }
            var parameters: [Int] = []
            for index in 1...operation.numberOfParameters {
                parameters.append(memory[current + index]!)
            }
            operation.perform(on: &self, with: parameters)
            if pending {
                break
            }
        }
    }

    func runned() -> IntCodeComputer {
        var computer = self
        computer.run()
        return computer
    }

    var finalState: (memory: [Int], output: [Int]) {
        let max = memory.keys.max() ?? 0
        var memory = [Int](repeating: 0, count: max+1)
        for (offset, value) in self.memory {
            memory[offset] = value
        }
        return (memory, outputs)
    }
}
