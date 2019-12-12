
import Foundation

struct Day02: Day {
    static func run(input: String) {
        
        // Part 1 requirements
        assert(IntCodeComputer(instructions: [1,0,0,0,99]).runned().finalState.memory == [2,0,0,0,99])
        assert(IntCodeComputer(instructions: [2,3,0,3,99]).runned().finalState.memory == [2,3,0,6,99])
        assert(IntCodeComputer(instructions: [2,4,4,5,99,0]).runned().finalState.memory == [2,4,4,5,99,9801])
        assert(IntCodeComputer(instructions: [1,1,1,4,99,5,6,0,99]).runned().finalState.memory == [30,1,1,4,2,5,6,0,99])
        assert(IntCodeComputer(instructions: [1,9,10,3,2,3,11,0,99,30,40,50]).runned().finalState.memory == [3500,9,10,70,2,3,11,0,99,30,40,50])
        
        var instructions = [Int].parse(rawValue: input)
        // Needed substitution specified in the daily instructions
        instructions[1] = 12
        instructions[2] = 2
        let result = IntCodeComputer(instructions: instructions).runned().memory[0]!
        print("First instruction after program runned for Day 2-1 is \(result)")
        
        let (noun, verb) = findNounVerbs(with: instructions)
        print("100 * noun + verb for Day 2-2 is \(100 * noun + verb)")
    }
    
    static func findNounVerbs(with instructions: [Int]) -> (noun: Int, verb: Int) {
        let toFind = 19690720
        for noun in 0...99 {
            for verb in 0...99 {
                var instructions = instructions
                instructions[1] = noun
                instructions[2] = verb
                if IntCodeComputer(instructions: instructions).runned().memory[0] == toFind {
                    return (noun, verb)
                }
            }
        }
        fatalError("Noun & Verb are not findable")
    }
}
