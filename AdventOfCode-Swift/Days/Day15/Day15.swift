
import Foundation

struct Day15: Day {
    static func run(input: String) {
        let computer = IntCodeComputer(instructions: [Int].parse(rawValue: input))
        let area = Area(with: computer)
        print("Minimum number of moves required for Day 15-1 is \(area.minDistanceFromSource)")
        print("Time to fill the area with oxygen for Day 15-2 is \(area.timeToFillWholeArea)")
    }

    struct Area {
        enum Move: Int, CaseIterable {
            case north = 1
            case south = 2
            case west = 3
            case east = 4

            var direction: Vector2D.Direction {
                switch self {
                case .north:
                    return .up
                case .south:
                    return .down
                case .west:
                    return .left
                case .east:
                    return .right
                }
            }

            static func from(direction: Vector2D.Direction) -> Move {
                switch direction {
                case .up:
                    return .north
                case .down:
                    return .south
                case .left:
                    return .west
                case .right:
                    return .east
                }
            }
        }
        
        enum Tile: Int, CustomStringConvertible {
            case start = -1
            case wall = 0
            case empty = 1
            case oxygen = 2

            var description: String {
                switch self {
                case .start:
                    return "*"
                case .wall:
                    return "#"
                case .empty:
                    return "."
                case .oxygen:
                    return "$"
                }
            }
        }

        var map: [Vector2D: Tile]
        var moveMap: [Vector2D: Int]

        init(with computer: IntCodeComputer) {
            var map: [Vector2D: Tile] = [.zero: .start]
            var moveMap: [Vector2D: Int] = [.zero: 0]
            var queue: [Vector2D: IntCodeComputer] = [.zero: computer]
            while let (position, computer) = queue.popFirst() {
                Move.allCases.forEach { move in
                    let newPosition = position.moved(move.direction)
                    var newComputer = computer.withInput(move.rawValue).runned()
                    newComputer.finished = false
                    guard let output = newComputer.outputs.popLast(), let tile = Tile(rawValue: output) else {
                        fatalError("Unknown tile")
                    }
                    if tile != .wall && map[newPosition] == nil && queue[newPosition] == nil {
                        // We add the non-already-made positions in the queue
                        queue.updateValue(newComputer, forKey: newPosition)
                    }
                    if map[newPosition] == nil {
                        map.updateValue(tile, forKey: newPosition)
                    }
                    if moveMap[newPosition] == nil && tile != .wall {
                        moveMap.updateValue(moveMap[position]! + 1, forKey: newPosition)
                    }
                }
            }
            self.map = map
            self.moveMap = moveMap
        }

        var minDistanceFromSource: Int {
            let position = map.first(where: { $0.value == .oxygen })?.key
            precondition(position != nil)
            return moveMap[position ?? .zero] ?? 0
        }

        var timeToFillWholeArea: Int {
            let position = map.first(where: { $0.value == .oxygen })?.key
            precondition(position != nil)
            var queue: [Vector2D] = [position!]
            var toFill = Set(map.filter({ $0.value != .wall && $0.value != .oxygen }).keys)
            var timeElapsed = 0
            while !toFill.isEmpty {
                // Fill the neighboors
                for position in queue {
                    position.neighbours.forEach { neighbour in
                        if toFill.contains(neighbour) {
                            queue.append(neighbour)
                            toFill.remove(neighbour)
                        }
                    }
                }
                timeElapsed += 1
            }
            return timeElapsed
        }
    }
}
