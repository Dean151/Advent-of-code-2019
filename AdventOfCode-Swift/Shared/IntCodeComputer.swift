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
    var relativeBase: Int = 0
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
        enum ParameterMode: Int {
            case position = 0
            case immediate = 1
            case relative = 2

            func address(for parameter: Int, with computer: IntCodeComputer) -> Int {
                let address: Int
                switch self {
                case .position:
                    address = parameter
                case .relative:
                    address = computer.relativeBase + parameter
                case .immediate:
                    fatalError("Unvalid address!")
                }
                assert(address >= 0)
                return address
            }

            func value(for parameter: Int, with computer: IntCodeComputer) -> Int {
                if self == .immediate {
                    return parameter
                }
                return computer.memory[address(for: parameter, with: computer)] ?? 0
            }

            func set(value: Int, for parameter: Int, with computer: inout IntCodeComputer) {
                computer.memory[address(for: parameter, with: computer)] = value
            }
        }

        case add(modeA: ParameterMode, modeB: ParameterMode, modeC: ParameterMode)
        case multiply(modeA: ParameterMode, modeB: ParameterMode, modeC: ParameterMode)
        case input(modeA: ParameterMode)
        case output(modeA: ParameterMode)
        case jumpIfTrue(modeA: ParameterMode, modeB: ParameterMode)
        case jumpIfFalse(modeA: ParameterMode, modeB: ParameterMode)
        case lessThan(modeA: ParameterMode, modeB: ParameterMode, modeC: ParameterMode)
        case equals(modeA: ParameterMode, modeB: ParameterMode, modeC: ParameterMode)
        case adjustRelativeBase(modeA: ParameterMode)
        case exit

        static func from(opcode: Int) -> Operation {
            let modeA = ParameterMode(rawValue: (opcode / 100) % 10)!
            let modeB = ParameterMode(rawValue: (opcode / 1000) % 10)!
            let modeC = ParameterMode(rawValue: (opcode / 10000) % 10)!
            switch opcode % 100 {
            case 1:
                return .add(modeA: modeA, modeB: modeB, modeC: modeC)
            case 2:
                return .multiply(modeA: modeA, modeB: modeB, modeC: modeC)
            case 3:
                return .input(modeA: modeA)
            case 4:
                return .output(modeA: modeA)
            case 5:
                return jumpIfTrue(modeA: modeA, modeB: modeB)
            case 6:
                return jumpIfFalse(modeA: modeA, modeB: modeB)
            case 7:
                return lessThan(modeA: modeA, modeB: modeB, modeC: modeC)
            case 8:
                return equals(modeA: modeA, modeB: modeB, modeC: modeC)
            case 9:
                return adjustRelativeBase(modeA: modeA)
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
            case .input, .output, .adjustRelativeBase:
                return 1
            case .exit:
                fatalError("Calling 'numberOfParameters' on exit opcode")
            }
        }

        func perform(on computer: inout IntCodeComputer, with parameters: [Int]) {
            switch self {
            case .add(modeA: let modeA, modeB: let modeB, modeC: let modeC):
                let a = parameters[0], b = parameters[1], c = parameters[2]
                let value = modeA.value(for: a, with: computer) + modeB.value(for: b, with: computer)
                modeC.set(value: value, for: c, with: &computer)
                computer.current += 4
            case .multiply(modeA: let modeA, modeB: let modeB, modeC: let modeC):
                let a = parameters[0], b = parameters[1], c = parameters[2]
                let value = modeA.value(for: a, with: computer) * modeB.value(for: b, with: computer)
                modeC.set(value: value, for: c, with: &computer)
                computer.current += 4
            case .input(modeA: let modeA):
                guard !computer.inputs.isEmpty else {
                    computer.pending = true
                    return
                }
                let a = parameters[0]
                modeA.set(value: computer.inputs.removeFirst(), for: a, with: &computer)
                computer.current += 2
            case .output(modeA: let modeA):
                let a = parameters[0]
                computer.outputs.append(modeA.value(for: a, with: computer))
                computer.current += 2
            case .jumpIfTrue(modeA: let modeA, modeB: let modeB):
                let a = parameters[0], b = parameters[1]
                if modeA.value(for: a, with: computer) != 0 {
                    computer.current = modeB.value(for: b, with: computer)
                }
                else {
                    computer.current += 3
                }
            case .jumpIfFalse(modeA: let modeA, modeB: let modeB):
                let a = parameters[0], b = parameters[1]
                if modeA.value(for: a, with: computer) == 0 {
                    computer.current = modeB.value(for: b, with: computer)
                }
                else {
                    computer.current += 3
                }
            case .lessThan(modeA: let modeA, modeB: let modeB, modeC: let modeC):
                let a = parameters[0], b = parameters[1], c = parameters[2]
                let value = modeA.value(for: a, with: computer) < modeB.value(for: b, with: computer) ? 1 : 0
                modeC.set(value: value, for: c, with: &computer)
                computer.current += 4
            case .equals(modeA: let modeA, modeB: let modeB, modeC: let modeC):
                let a = parameters[0], b = parameters[1], c = parameters[2]
                let value = modeA.value(for: a, with: computer) == modeB.value(for: b, with: computer) ? 1 : 0
                modeC.set(value: value, for: c, with: &computer)
                computer.current += 4
            case .adjustRelativeBase(modeA: let modeA):
                let a = parameters[0]
                computer.relativeBase += modeA.value(for: a, with: computer)
                computer.current += 2
            case .exit:
                fatalError("Calling 'perform' on exit opcode")
            }
        }
    }

    mutating func run() {
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

    func withInput(_ inputs: Int...) -> IntCodeComputer {
        return withInput(inputs)
    }

    func withInput(_ inputs: [Int]) -> IntCodeComputer {
        var computer = self
        computer.inputs = inputs
        return computer
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
