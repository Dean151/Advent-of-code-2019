
import Foundation

/// Depends on IntCodeComputer (ie days 2, 5, 7)
struct Day09: Day {
    static func run(input: String) {
        // Part 1 requirements
        assert(IntCodeComputer(instructions: [109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99]).runned().outputs == [109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99])
        assert(IntCodeComputer(instructions: [1102,34915192,34915192,7,4,7,99,0]).runned().outputs.first.flatMap({ "\($0)" })?.count == 16)
        assert(IntCodeComputer(instructions: [104,1125899906842624,99]).runned().outputs == [1125899906842624])

        let instructions = [Int].parse(rawValue: input)
        var computer = IntCodeComputer(instructions: instructions, inputs: [1])
        computer.run()
        print("BOOST code for Day 9-1 is \(computer.outputs.last!)")
    }
}
