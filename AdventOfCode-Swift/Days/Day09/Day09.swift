
import Foundation

struct Day09: Day {
    static func run(input: String) {
        // Part 1 requirements
        assert(IntCodeComputer(instructions: [109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99]).run().output == [109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99])
        assert(IntCodeComputer(instructions: [1102,34915192,34915192,7,4,7,99,0]).run().output.first.flatMap({ "\($0)" })?.count == 16)
        assert(IntCodeComputer(instructions: [104,1125899906842624,99]).run().output == [1125899906842624])

        // TODO: Implement Day 9
        print("Day 9 is not yet implemented")
    }
}
