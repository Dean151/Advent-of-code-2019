
import Foundation

struct Day13: Day {
    static func run(input: String) {
        let instructions = [Int].parse(rawValue: input)
        let arcade = Arcade(instructions: instructions)
        print("There is \(arcade.numberOf(tiles: .block)) block tiles for Day 13-1")
        print("Score after perfect game for Day 13-2 is \(arcade.play())")
    }

    struct Arcade {
        enum Tile: Int, CustomStringConvertible {
            case empty = 0, wall, block, paddle, ball

            var description: String {
                switch self {
                case .empty:
                    return " "
                case .wall:
                    return "#"
                case .block:
                    return "="
                case .paddle:
                    return "_"
                case .ball:
                    return "*"
                }
            }
        }

        let instructions: [Int]

        func numberOf(tiles: Tile) -> Int {
            let output = IntCodeComputer(instructions: instructions).runned().outputs
            return output.enumerated()
                .filter({ $0.offset % 3 == 2 })
                .filter({ $0.element == tiles.rawValue })
                .count
        }

        func play() -> Int {
            enum State: Int {
                case left = -1
                case neutral = 0
                case right = 1
            }

            // Init the computer
            var computer = IntCodeComputer(instructions: instructions)
            // Introduce a quarter
            computer.memory[0] = 2
            var grid = [Vector2D: Tile]()
            var score = 0
            var state = State.neutral
            while true {
                computer.inputs.append(state.rawValue)
                computer.outputs = []
                computer.run()
                let (newTiles, newScore) = self.grid(for: computer.outputs)
                if let newScore = newScore {
                    score = newScore
                }
                for (pos, tile) in newTiles {
                    grid[pos] = tile
                }
                guard let paddle = grid.filter({ $0.value == .paddle }).first?.key,
                    let ball = grid.filter({ $0.value == .ball }).first?.key else {
                    fatalError("No ball or paddle")
                }
                if ball.x == paddle.x {
                    state = .neutral
                } else if ball.x < paddle.x {
                    state = .left
                } else {
                    state = .right
                }

                if grid.filter({ $0.value == .block }).count == 0 {
                    break
                }
            }
            return score
        }

        func grid(for output: [Int]) -> (grid: [Vector2D: Tile], score: Int?) {
            var grid = [Vector2D: Tile]()
            var score: Int?
            var i = 0
            while i < output.count {
                if let tile = Tile(rawValue: output[i+2]) {
                    grid.updateValue(tile, forKey: .init(x: output[i], y: output[i+1]))
                } else if output[i] == -1 && output[i+1] == 0 {
                    score = output[i+2]
                } else {
                    fatalError("Unknown tile \(output[i+2])")
                }
                i += 3
            }
            return (grid, score)
        }
    }
}
