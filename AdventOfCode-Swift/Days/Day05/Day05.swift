
import Foundation

/// Depends on IntCodeComputer (ie day 2)
struct Day05: Day {
    static func run(input: String) {

        // Part 1 requirements
        assert(IntCodeComputer(instructions: [3,0,4,0,99], inputs: [151]).runned().finalState == ([151,0,4,0,99], [151]))
        assert(IntCodeComputer(instructions: [1002,4,3,4,33]).runned().finalState.memory == [1002,4,3,4,99])
        assert(IntCodeComputer(instructions: [1101,100,-1,4,0]).runned().finalState.memory == [1101,100,-1,4,99])

        // Additionnal tests for Part 1
        assert(IntCodeComputer(instructions: [101,151,4,4,-52]).runned().finalState.memory == [101,151,4,4,99])
        assert(IntCodeComputer(instructions: [102,-33,4,4,-3]).runned().finalState.memory == [102,-33,4,4,99])
        assert(IntCodeComputer(instructions: [104,0,99]).runned().finalState.memory == [104,0,99])
        assert(IntCodeComputer(instructions: [1001,4,3,4,96]).runned().finalState.memory == [1001,4,3,4,99])
        assert(IntCodeComputer(instructions: [1001,4,-3,4,102]).runned().finalState.memory == [1001,4,-3,4,99])
        assert(IntCodeComputer(instructions: [1102,-3,-33,4,0]).runned().finalState.memory == [1102,-3,-33,4,99])

        let instructions = [Int].parse(rawValue: input)
        var output = IntCodeComputer(instructions: instructions, inputs: [1]).runned().outputs
        let result = output.removeLast()
        assert(output.reduce(true, { $0 && $1 == 0 })) // All values should be 0 after removing diagnostic code
        print("Day 5-1 cooling diagnostic code is \(result)")

        // Part 2 requirements
        assert(IntCodeComputer(instructions: [3,9,8,9,10,9,4,9,99,-1,8], inputs: [8]).runned().outputs[0] == 1)
        assert(IntCodeComputer(instructions: [3,9,8,9,10,9,4,9,99,-1,8], inputs: [151]).runned().outputs[0] == 0)
        assert(IntCodeComputer(instructions: [3,9,7,9,10,9,4,9,99,-1,8], inputs: [5]).runned().outputs[0] == 1)
        assert(IntCodeComputer(instructions: [3,9,7,9,10,9,4,9,99,-1,8], inputs: [8]).runned().outputs[0] == 0)
        assert(IntCodeComputer(instructions: [3,9,7,9,10,9,4,9,99,-1,8], inputs: [151]).runned().outputs[0] == 0)
        assert(IntCodeComputer(instructions: [3,3,1108,-1,8,3,4,3,99], inputs: [8]).runned().outputs[0] == 1)
        assert(IntCodeComputer(instructions: [3,3,1108,-1,8,3,4,3,99], inputs: [151]).runned().outputs[0] == 0)
        assert(IntCodeComputer(instructions: [3,3,1107,-1,8,3,4,3,99], inputs: [5]).runned().outputs[0] == 1)
        assert(IntCodeComputer(instructions: [3,3,1107,-1,8,3,4,3,99], inputs: [8]).runned().outputs[0] == 0)
        assert(IntCodeComputer(instructions: [3,3,1107,-1,8,3,4,3,99], inputs: [151]).runned().outputs[0] == 0)
        assert(IntCodeComputer(instructions: [3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9], inputs: [0]).runned().outputs[0] == 0)
        assert(IntCodeComputer(instructions: [3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9], inputs: [151]).runned().outputs[0] == 1)
        assert(IntCodeComputer(instructions: [3,3,1105,-1,9,1101,0,0,12,4,12,99,1], inputs: [0]).runned().outputs[0] == 0)
        assert(IntCodeComputer(instructions: [3,3,1105,-1,9,1101,0,0,12,4,12,99,1], inputs: [151]).runned().outputs[0] == 1)
        assert(IntCodeComputer(instructions: [3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99], inputs: [7]).runned().outputs[0] == 999)
        assert(IntCodeComputer(instructions: [3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99], inputs: [8]).runned().outputs[0] == 1000)
        assert(IntCodeComputer(instructions: [3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99], inputs: [9]).runned().outputs[0] == 1001)

        var output2 = IntCodeComputer(instructions: instructions, inputs: [5]).runned().outputs
        let result2 = output2.removeLast()
        assert(output2.reduce(true, { $0 && $1 == 0 })) // All values should be 0 after removing diagnostic code
        print("Day 5-2 thermal diagnostic code is \(result2)")
    }
}

// Too high: 668351603
// Too low: 212
