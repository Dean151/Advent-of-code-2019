
import Foundation

struct Day19: Day {
    static func run(input: String) {
        let computer = IntCodeComputer(instructions: .parse(rawValue: input))
        let beam = Beam(computer: computer)
        print("The number of tracted areas for Day 19-1 is \(beam.count(for: 50))")

        let point = beam.fitSquare(of: 100)
        print("Closest point of beam to fit the square for Day 19-2 is \(point) ; (Answer: \(point.x * 10_000 + point.y))")
    }

    struct Beam {
        let computer: IntCodeComputer

        func count(for size: Int) -> Int {
            var count = 0
            var pos = Vector2D.zero
            var firstColumn: Int?
            while pos.x < size && pos.y < size {
                guard let output = computer.withInput(pos.x, pos.y).runned().outputs.first else {
                    fatalError("No output")
                }
                switch output {
                case 0:
                    if firstColumn != nil {
                        pos.x = firstColumn!
                        pos.y += 1
                        firstColumn = nil
                    }
                case 1:
                    count += 1
                    if firstColumn == nil {
                        firstColumn = pos.x
                    }
                default:
                    fatalError("Unknown output")
                }
                pos.x += 1
                if pos.x >= size {
                    pos.x = firstColumn ?? 0
                    pos.y += 1
                    firstColumn = nil
                }
            }
            return count
        }

        func fitSquare(of targetSize: Int) -> Vector2D {
            func line(from: Vector2D, dimension: WritableKeyPath<Vector2D, Int>) -> (start: Vector2D, size: Int)? {
                var start: Vector2D?
                var size = 0
                var pos = from
                var safety = 0
                while safety < 100 {
                    guard let output = computer.withInput(pos.x, pos.y).runned().outputs.first else {
                        fatalError("No output")
                    }

                    switch output {
                    case 0:
                        if let start = start {
                            return (start, size)
                        } else {
                            safety += 1
                        }
                    case 1:
                        size += 1
                        if start == nil {
                            start = pos
                        }
                    default:
                        fatalError("Unknown output")
                    }
                    pos[keyPath: dimension] += 1
                }
                return nil
            }

            var potentialY = false
            var pos = Vector2D.zero
            var saveX = 0
            while true {
                guard let line = line(from: pos, dimension: potentialY ? \.y : \.x) else {
                    potentialY = false
                    pos.y += 1
                    continue
                }

                guard line.size >= targetSize else {
                    if potentialY {
                        pos.x = saveX
                    } else {
                        pos.x = line.start.x
                    }
                    potentialY = false
                    pos.y += 1
                    continue
                }

                if !potentialY {
                    // We have a potential Y
                    potentialY = true
                    saveX = line.start.x
                    pos.x = line.start.x + (line.size - targetSize)
                } else {
                    // We are go for launch :D
                    break
                }
            }
            return pos
        }
    }
}
