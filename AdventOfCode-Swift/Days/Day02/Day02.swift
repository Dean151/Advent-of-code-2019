
import Foundation

class Day02: Day {
    static func run(input: String) {
        
        // Part 1 requirements
        assert(performProgram(with: [1,0,0,0,99]) == [2,0,0,0,99])
        assert(performProgram(with: [2,3,0,3,99]) == [2,3,0,6,99])
        assert(performProgram(with: [2,4,4,5,99,0]) == [2,4,4,5,99,9801])
        assert(performProgram(with: [1,1,1,4,99,5,6,0,99]) == [30,1,1,4,2,5,6,0,99])
        assert(performProgram(with: [1,9,10,3,2,3,11,0,99,30,40,50]) == [3500,9,10,70,2,3,11,0,99,30,40,50])
        
        var instructions = input.components(separatedBy: CharacterSet.decimalDigits.inverted).compactMap { Int($0) }
        // Needed substitution specified in the daily instructions
        instructions[1] = 12
        instructions[2] = 2
        let result = performProgram(with: instructions)
        print("First instruction after program runned for Day 2-1 is \(result[0])")
        
        let (noun, verb) = findNounVerbs(with: instructions)
        print("100 * noun + verb for Day 2-2 is \(100 * noun + verb)")
    }
    
    enum Operation: Int {
        case add = 1
        case multiply = 2
        case exit = 99
        
        func perform(a: Int, b: Int) -> Int {
            switch self {
            case .add:
                return a + b
            case .multiply:
                return a * b
            case .exit:
                fatalError("Calling perform on exit instruction...")
            }
        }
    }
    
    static func performProgram(with instructions: [Int]) -> [Int] {
        var instructions = instructions
        var current = 0
        while true {
            guard let operation = Operation(rawValue: instructions[current]) else {
                fatalError("Unknown operation found: \(instructions[current])")
            }
            if operation == .exit {
                break
            }
            let a = instructions[instructions[current + 1]]
            let b = instructions[instructions[current + 2]]
            instructions[instructions[current + 3]] = operation.perform(a: a, b: b)
            current += 4
        }
        return instructions
    }
    
    static func findNounVerbs(with instructions: [Int]) -> (noun: Int, verb: Int) {
        let toFind = 19690720
        for noun in 0...99 {
            for verb in 0...99 {
                var instructions = instructions
                instructions[1] = noun
                instructions[2] = verb
                if performProgram(with: instructions)[0] == toFind {
                    return (noun, verb)
                }
            }
        }
        fatalError("Noun & Verb are not findable")
    }
}
