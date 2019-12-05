
import Foundation

struct Day05: Day {
    static func run(input: String) {

        // Part 1 requirements
        assert(IntCodeComputer(instructions: [3,0,4,0,99], inputs: [151]).run() == ([151,0,4,0,99], [151]))
        assert(IntCodeComputer(instructions: [1002,4,3,4,33]).run().instructions == [1002,4,3,4,99])
        assert(IntCodeComputer(instructions: [1101,100,-1,4,0]).run().instructions == [1101,100,-1,4,99])

        // Additionnal tests for Part 1
        assert(IntCodeComputer(instructions: [101,151,4,4,-52]).run().instructions == [101,151,4,4,99])
        assert(IntCodeComputer(instructions: [102,-33,4,4,-3]).run().instructions == [102,-33,4,4,99])
        assert(IntCodeComputer(instructions: [104,0,99]).run().instructions == [104,0,99])
        assert(IntCodeComputer(instructions: [1001,4,3,4,96]).run().instructions == [1001,4,3,4,99])
        assert(IntCodeComputer(instructions: [1001,4,-3,4,102]).run().instructions == [1001,4,-3,4,99])
        assert(IntCodeComputer(instructions: [1102,-3,-33,4,0]).run().instructions == [1102,-3,-33,4,99])

        let instructions = [Int].parse(rawValue: input)
        var output = IntCodeComputer(instructions: instructions, inputs: [1]).run().output
        let result = output.removeLast()
        assert(output.reduce(true, { $0 && $1 == 0 })) // All values should be 0 after removing diagnostic code
        print("Day 5-1 cooling diagnostic code is \(result)")

        // Part 2 requirements
        // TODO!

        output = IntCodeComputer(instructions: instructions, inputs: [5]).run().output
        let result2 = output.removeLast()
        assert(output.reduce(true, { $0 && $1 == 0 })) // All values should be 0 after removing diagnostic code
        print("Day 5-2 thermal diagnostic code is \(result2)")
    }
}

// Too high: 668351603
// Too low: 212
