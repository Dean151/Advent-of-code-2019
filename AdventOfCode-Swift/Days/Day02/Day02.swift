
import Foundation

struct Day02: Day {
    static func run(input: String) {
        
        // Part 1 requirements
        assert(IntCodeComputer(instructions: [1,0,0,0,99]).runned().finalState.memory == [2,0,0,0,99])
        assert(IntCodeComputer(instructions: [2,3,0,3,99]).runned().finalState.memory == [2,3,0,6,99])
        assert(IntCodeComputer(instructions: [2,4,4,5,99,0]).runned().finalState.memory == [2,4,4,5,99,9801])
        assert(IntCodeComputer(instructions: [1,1,1,4,99,5,6,0,99]).runned().finalState.memory == [30,1,1,4,2,5,6,0,99])
        assert(IntCodeComputer(instructions: [1,9,10,3,2,3,11,0,99,30,40,50]).runned().finalState.memory == [3500,9,10,70,2,3,11,0,99,30,40,50])

        let instructions = [Int].parse(rawValue: input)
        var computer = IntCodeComputer(instructions: instructions)
        // Needed substitution specified in the daily instructions
        computer.memory[1] = 12
        computer.memory[2] = 2
        computer.run()
        print("First instruction after program runned for Day 2-1 is \(computer.memory[0]!)")

        let (noun, verb) = findNounVerbs(with: instructions, target: 19690720)
        print("100 * noun + verb for Day 2-2 is \(100 * noun + verb)")
    }
    
    static func findNounVerbs(with instructions: [Int], target: Int) -> (noun: Int, verb: Int) {
        var computer = IntCodeComputer(instructions: instructions)
        for noun in 0...99 {
            for verb in 0...99 {
                computer.memory[1] = noun
                computer.memory[2] = verb
                if computer.runned().memory[0] == target {
                    return (noun, verb)
                }
            }
        }
        fatalError("Noun & Verb are not findable")
    }
}
