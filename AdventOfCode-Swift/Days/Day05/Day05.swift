
import Foundation

struct Day05: Day {
    static func run(input: String) {

        // Part 1 requirements
        assert(IntCodeComputer.run(with: [3,0,4,0,99], firstInput: 0) == [0,0,4,0,99])
        assert(IntCodeComputer.run(with: [1002,4,3,4,33]) == [1002,4,3,4,99])
        assert(IntCodeComputer.run(with: [1101,100,-1,4,0]) == [1101,100,-1,4,99])

        // Additionnal tests for Part 1
        assert(IntCodeComputer.run(with: [101,151,4,4,-52]) == [101,151,4,4,99])
        assert(IntCodeComputer.run(with: [102,-33,4,4,-3]) == [102,-33,4,4,99])
        assert(IntCodeComputer.run(with: [104,0,99]) == [104,0,99])
        assert(IntCodeComputer.run(with: [1001,4,3,4,96]) == [1001,4,3,4,99])
        assert(IntCodeComputer.run(with: [1001,4,-3,4,102]) == [1001,4,-3,4,99])
        assert(IntCodeComputer.run(with: [1102,-3,-33,4,0]) == [1102,-3,-33,4,99])

        let instructions = [Int].parse(rawValue: input)
        _ = IntCodeComputer.run(with: instructions, firstInput: 1)
        print("Day 5-1 Finished running")
    }
}

// Too high: 668351603
// Too low: 212
