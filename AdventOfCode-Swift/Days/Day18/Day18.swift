
import Foundation

struct Day18: Day {
    static func run(input: String) {

        // Part 1 requirements
        assert(Maze(input: "#########\n#b.A.@.a#\n#########").solved().solution == (8, "ab"))
        assert(Maze(input: "########################\n#f.D.E.e.C.b.A.@.a.B.c.#\n######################.#\n#d.....................#\n########################").solved().solution == (86, "abcdef"))
        assert(Maze(input: "########################\n#...............b.C.D.f#\n#.######################\n#.....@.a.B.c.d.A.e.F.g#\n########################").solved().solution == (132, "bacdfeg"))
        assert(Maze(input: "#################\n#i.G..c...e..H.p#\n########.########\n#j.A..b...f..D.o#\n########@########\n#k.E..a...g..B.n#\n########.########\n#l.F..d...h..C.m#\n#################").solved().solution.numberOfSteps == 136)
        assert(Maze(input: "########################\n#@..............ac.GI.b#\n###d#e#f################\n###A#B#C################\n###g#h#i################\n########################").solved().solution == (81, "acfidgbeh"))

        let maze = Maze(input: input)
        let solution = maze.solved().solution
        print("Shortest path to collect all the key for Day 18-1 is \(solution.numberOfSteps) steps long")
        // 3242 Too high
    }

    struct Maze {
        enum Tile: CustomStringConvertible {
            enum Key: String {
                case a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z
            }
            case empty, wall
            case key(key: Key)
            case door(key: Key)

            var description: String {
                switch self {
                case .empty:
                    return "."
                case .wall:
                    return "#"
                case .key(key: let key):
                    return key.rawValue
                case .door(key: let key):
                    return key.rawValue.uppercased()
                }
            }

            init?(from character: Character) {
                // Trivial case
                switch character {
                case "@", ".":
                    self = .empty
                case "#":
                    self = .wall
                default:
                    guard let key = Key(rawValue: character.lowercased()) else {
                        return nil
                    }
                    self = character.isUppercase ? .door(key: key) : .key(key: key)
                }
            }

            var isKey: Bool {
                switch self {
                case .key:
                    return true
                default:
                    return false
                }
            }

            var key: Key? {
                switch self {
                case .key(key: let key):
                    return key
                case .door(key: let key):
                    return key
                default:
                    return nil
                }
            }
        }

        private var tiles: [Vector2D: Tile]
        private var position: Vector2D
        private var targetNumber: Int

        private var _solution: (numberOfSteps: Int, order: String) = (0, "")
        var isSolved: Bool {
            return _solution.order.count == targetNumber
        }
        var solution: (numberOfSteps: Int, order: String) {
            guard isSolved else {
                fatalError("solution beeing called before solving the maze!")
            }
            return _solution
        }

        init(input: String) {
            var tiles = [Vector2D: Tile]()
            var start: Vector2D?
            for (y, line) in input.components(separatedBy: .newlines).enumerated() {
                for (x, char) in line.enumerated() {
                    guard let tile = Tile(from: char) else {
                        fatalError("Unknown tile!")
                    }
                    let position = Vector2D(x: x, y: y)
                    tiles.updateValue(tile, forKey: position)
                    if char == "@" {
                        start = position
                    }
                }
            }
            self.tiles = tiles
            self.position = start!
            self.targetNumber = tiles.filter({ $0.value.isKey }).count
        }

        func printTiles() {
            tiles.print()
        }

        func findFetchableKeys() -> [Tile.Key: (position: Vector2D, distance: Int)] {
            var keys: [Tile.Key: (position: Vector2D, distance: Int)] = [:]
            var visited: [Vector2D: Int] = [:]
            var toVisit: [Vector2D: Int] = [position: 0]
            while let (position, distance) = toVisit.popFirst() {
                for neighbour in position.neighbours {
                    switch tiles[neighbour] {
                    case .key(key: let key):
                        if keys[key]?.distance ?? .max > distance + 1 {
                            keys[key] = (neighbour, distance + 1)
                        }
                    case .wall, .door:
                        continue
                    default:
                        if visited[neighbour] ?? .max > distance + 1 && toVisit[neighbour] ?? .max > distance + 1 {
                            toVisit[neighbour] = distance + 1
                        }
                    }
                }
                if visited[position] ?? .max > distance {
                    visited[position] = distance
                }
            }
            return keys
        }

        func solved() -> Maze {
            func solve(maze: Maze, solution: inout Maze?) {
                var keys = maze.findFetchableKeys()
                while let (key, (position, distance)) = keys.min(by: { $0.value.distance < $1.value.distance }) {
                    keys.removeValue(forKey: key)
                    var maze = maze
                    // Update partial solution
                    maze._solution.numberOfSteps += distance
                    if solution?._solution.numberOfSteps ?? .max < maze._solution.numberOfSteps {
                        // We are already above an existing solution, drop this one
                        continue
                    }
                    maze._solution.order.append(key.rawValue)
                    // Update position
                    maze.position = position
                    // Update tiles
                    for position in maze.tiles.filter({ $0.value.key == key }).keys {
                        maze.tiles.updateValue(.empty, forKey: position)
                    }
                    if maze.isSolved && maze._solution.numberOfSteps < solution?._solution.numberOfSteps ?? .max {
                        solution = maze
                        print(maze.solution)
                    } else {
                        solve(maze: maze, solution: &solution)
                    }
                }
            }

            var solution: Maze?
            solve(maze: self, solution: &solution)
            return solution!
        }
    }
}
