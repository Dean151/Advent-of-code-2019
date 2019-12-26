
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
        enum Color: Int, CustomStringConvertible {
            case black = 0, white

            var description: String {
                return self == .white ? "#" : " "
            }
        }

        var color: Color
        var panels: [Vector2D: Color] = [:]

        func currentColor(at pos: Vector2D) -> Color {
            return panels[pos] ?? color
        }

        var numberOfPanelsPaintedAtLeastOnce: Int {
            return panels.count
        }

        func print() {
            panels.print(placeholder: color.description)
        }
    }
}
