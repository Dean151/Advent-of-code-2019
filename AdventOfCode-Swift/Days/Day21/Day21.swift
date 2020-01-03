
import Foundation

struct Day21: Day {
    static func run(input: String) {
        let computer = IntCodeComputer(instructions: .parse(rawValue: input))

        let part1 = [
            "NOT C J",
            "AND D J",
            "NOT A T",
            "OR T J",
            "WALK\n",
        ].joined(separator: "\n").unicodeScalars.map {
            Int($0.value)
        }

        let output = computer.withInput(part1).runned().outputs
        print("Amount of damage for Day 21-1 is \(output.last!)")

        let part2 = [
            "NOT C J",
            "AND D J",
            "AND H J",
            "NOT B T",
            "AND D T",
            "OR T J",
            "NOT A T",
            "OR T J",
            "RUN\n",
        ].joined(separator: "\n").unicodeScalars.map {
            Int($0.value)
        }

        let output2 = computer.withInput(part2).runned().outputs
        print("Amount of damage for Day 21-2 is \(output2.last!)")
    }
}
