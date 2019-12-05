
import Foundation

struct Day05: Day {
    static func run(input: String) {

        // Part 1 requirements
        assert(IntCodeComputer.run(with: [3,0,4,0,99], firstInput: 151) == [151,0,4,0,99])
        assert(IntCodeComputer.run(with: [1002,4,3,4,33]) == [1002,4,3,4,99])
        assert(IntCodeComputer.run(with: [1101,100,-1,4,0]) == [1101,100,-1,4,99])

        let instructions = [Int].parse(rawValue: input)
        _ = IntCodeComputer.run(with: instructions, firstInput: 1)
        print("Day 5-1 Finished running")
    }
}

// Too high: 668351603
