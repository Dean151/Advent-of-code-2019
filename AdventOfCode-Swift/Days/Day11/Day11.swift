
import Foundation

/// Depends on IntCodeComputer (ie days 2, 5 and 9)
struct Day11: Day {
    static func run(input: String) {

        var blackGrid = Grid(color: .black)
        var robot = PaintingRobot(computer: IntCodeComputer(instructions: .parse(rawValue: input)))
        robot.paint(on: &blackGrid)
        print("Number of panels painted at least once for Day 11-1 is \(blackGrid.numberOfPanelsPaintedAtLeastOnce)")

        var whiteGrid = Grid(color: .white)
        var robot2 = PaintingRobot(computer: IntCodeComputer(instructions: .parse(rawValue: input)))
        robot2.paint(on: &whiteGrid)
        whiteGrid.print()
        print("Day 11-2 finished running")
    }

    struct PaintingRobot {
        var computer: IntCodeComputer
        var position: Vector2D = .zero
        var direction: Vector2D.Direction = .up

        mutating func paint(on grid: inout Grid) {
            while true {
                computer.inputs.append(grid.currentColor(at: position).rawValue)
                computer.run()
                if computer.outputs.isEmpty {
                    break
                }
                let paintOutput = computer.outputs.removeFirst()
                let turnOutput = computer.outputs.removeFirst()
                grid.panels[position] = Grid.Color(rawValue: paintOutput)!
                switch turnOutput {
                case 0:
                    direction.turn(.left)
                case 1:
                    direction.turn(.right)
                default:
                    fatalError("Unknown turn instruction!")
                }
                position.move(direction)
            }
        }
    }

    struct Grid {
        enum Color: Int {
            case black = 0, white
        }

        var color: Color
        var panels: [Vector2D: Color] = [:]

        func currentColor(at pos: Vector2D) -> Color {
            return panels[pos] ?? color
        }

        var numberOfPanelsPaintedAtLeastOnce: Int {
            return panels.count
        }

        var bounds: (minX: Int, maxX: Int, minY: Int, maxY: Int) {
            if panels.isEmpty {
                fatalError("No bounds to find!")
            }
            var minX = Int.max, minY = Int.max, maxX = Int.min, maxY = Int.min
            for pos in panels.keys {
                minX = min(pos.x, minX)
                maxX = max(pos.x, maxX)
                minY = min(pos.y, minY)
                maxY = max(pos.y, maxY)
            }
            return (minX, maxX, minY, maxY)
        }

        func print() {
            let (minX, maxX, minY, maxY) = self.bounds
            for y in minY...maxY {
                for x in minX...maxX {
                    Swift.print(currentColor(at: Vector2D(x: x, y: y)) == .white ? "#" : ".", terminator: "")
                }
                Swift.print("") // Back to line
            }
        }
    }
}

// 1298 Too low
