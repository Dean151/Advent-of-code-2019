
import Foundation

struct Day17: Day {
    static func run(input: String) {
        let computer = IntCodeComputer(instructions: .parse(rawValue: input))
        let printable = String(computer.runned().outputs.compactMap({ Unicode.Scalar($0).flatMap({ Character($0) }) }))
        let scaffold = Scaffold(printable: printable)
        print("Sum of alignments parameters for Day 17-1 is \(scaffold.aligmentParametersSum)")

        // Part 2
        print("Long path is \(scaffold.solvePath)")

        // Solved "a la mano"
        let function = "A,A,B,C,A,C,A,B,C,B"
        let a = "R,12,L,8,R,6"
        let b = "R,12,L,6,R,6,R,8,R,6"
        let c = "L,8,R,8,R,6,R,12"
        precondition(a.count <= 20 && b.count <= 20 && c.count <= 20)
        let asciiInput = [function, a, b, c, "n\n"].joined(separator: "\n").unicodeScalars.map {
            Int($0.value)
        }
        var runningComputer = IntCodeComputer(instructions: .parse(rawValue: input))
        runningComputer.memory[0] = 2
        runningComputer.inputs = asciiInput
        var output = runningComputer.runned().outputs
        let dust = output.popLast()!
        print("Robot Collected \(dust) amount of dust for Day 17-2")
    }

    struct Scaffold {
        let filled: Set<Vector2D>
        let start: Vector2D
        let end: Vector2D

        init(printable: String) {
            var filled = Set<Vector2D>()
            var start = Vector2D.zero
            var y = 0
            for line in printable.components(separatedBy: .newlines) {
                var x = 0
                for char in line {
                    if char != "." {
                        filled.insert(Vector2D(x: x, y: y))
                    }
                    if char == "^" {
                        start = Vector2D(x: x, y: y)
                    }
                    x += 1
                }
                y += 1
            }
            self.filled = filled
            self.start = start
            self.end = filled.first {
                $0 != start && $0.neighbours.filter({ filled.contains($0) }).count == 1
                } ?? .zero
        }

        var aligmentParametersSum: Int {
            let intersections = filled.filter { $0.neighbours.reduce(true) { $0 && filled.contains($1) } }
            let aligmentParameters = intersections.map { return $0.x * $0.y }
            return aligmentParameters.reduce(0, +)
        }

        var solvePath: String {
            var current = start
            var direction = Vector2D.Direction.right
            var path = ["R"]
            var amount = 0
            while current != end {
                let next = current.moved(direction)
                if filled.contains(next) {
                    current = next
                    amount += 1
                } else {
                    path.append("\(amount)")
                    amount = 0
                    // Find if we turn right or left
                    let nextRight = current.moved(direction.turned(.right))
                    let turnRight = filled.contains(nextRight)
                    direction.turn(turnRight ? .right : .left)
                    path.append(turnRight ? "R" : "L")
                }
            }
            return path.joined(separator: ",")
        }
    }
}
