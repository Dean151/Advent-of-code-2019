
import Foundation

/// Depends on IntCodeComputer (ie days 2, 5)
struct Day07: Day {
    static func run(input: String) {

        // Part 1 requirements
        assert(outputSignal(input: "3,15,3,16,1002,16,10,16,1,16,15,15,4,15,99,0,0", phaseSettings: [4,3,2,1,0]) == 43210)
        assert(outputSignal(input: "3,23,3,24,1002,24,10,24,1002,23,-1,23,101,5,23,23,1,24,23,23,4,23,99,0,0", phaseSettings: [0,1,2,3,4]) == 54321)
        assert(outputSignal(input: "3,31,3,32,1002,32,10,32,1001,31,-2,31,1007,31,0,33,1002,33,7,33,1,33,31,31,1,32,31,31,4,31,99,0,0,0", phaseSettings: [1,0,4,3,2]) == 65210)

        assert(largestOutputSignal(input: "3,15,3,16,1002,16,10,16,1,16,15,15,4,15,99,0,0") == 43210)
        assert(largestOutputSignal(input: "3,23,3,24,1002,24,10,24,1002,23,-1,23,101,5,23,23,1,24,23,23,4,23,99,0,0") == 54321)
        assert(largestOutputSignal(input: "3,31,3,32,1002,32,10,32,1001,31,-2,31,1007,31,0,33,1002,33,7,33,1,33,31,31,1,32,31,31,4,31,99,0,0,0") == 65210)

        let result = largestOutputSignal(input: input)
        print("Largest output signal that could be getted for Day 7-1 is \(result)")

        // Part 2 requirements
        assert(outputSignal(input: "3,26,1001,26,-4,26,3,27,1002,27,2,27,1,27,26,27,4,27,1001,28,-1,28,1005,28,6,99,0,0,5", phaseSettings: [9,8,7,6,5]) == 139629729)
        assert(outputSignal(input: "3,52,1001,52,-5,52,3,53,1,52,56,54,1007,54,5,55,1005,55,26,1001,54,-5,54,1105,1,12,1,53,54,53,1008,54,0,55,1001,55,1,55,2,53,55,53,4,53,1001,56,-1,56,1005,56,6,99,0,0,0,0,10", phaseSettings: [9,7,8,5,6]) == 18216)

        let feedbackResult = largestOutputSignal(input: input, feedbackMode: true)
        print("Largest output signal with feedback loop for Day 7-2 is \(feedbackResult)")
    }

    static func largestOutputSignal(input: String, feedbackMode: Bool = false) -> Int {
        var max = Int.min
        heapPermutation(feedbackMode ? [5,6,7,8,9] : [0,1,2,3,4]) { phases in
            let result = outputSignal(input: input, phaseSettings: phases, feedbackMode: true)
            if result > max {
                max = result
            }
        }
        return max
    }

    static func outputSignal(input: String, phaseSettings: [Int], feedbackMode: Bool = false) -> Int {
        let instructions = [Int].parse(rawValue: input)
        var computers = phaseSettings.map { IntCodeComputer(instructions: instructions, inputs: [$0]) }
        var current = 0, output = 0
        while true {
            computers[current].inputs.append(output)
            computers[current].run()
            if !computers[current].outputs.isEmpty {
                output = computers[current].outputs.removeFirst()
            } else {
                fatalError("Seems impossible")
            }
            if current == computers.count - 1 && (!feedbackMode || !computers[0].waitingForInput) {
                break
            }
            current = (current + 1) % 5
        }
        return output
    }
}

func heapPermutation<T>(_ data: Array<T>, output: (Array<T>) -> Void) {
    var data = data
    generate(n: data.count, data: &data, output: output)
}

func generate<T>(n: Int, data: inout Array<T>, output: (Array<T>) -> Void) {
    if n == 1 {
        output(data)
    } else {
        for i in 0 ..< n {
            generate(n: n - 1, data: &data, output: output)
            if n % 2 == 0 {
                data.swapAt(i, n - 1)
            } else {
                data.swapAt(0, n - 1)
            }
        }
    }
}
