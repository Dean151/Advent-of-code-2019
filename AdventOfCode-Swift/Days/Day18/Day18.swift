
import Foundation

struct Day18: Day {
    static func run(input: String) {

        // Part 1 requirements
        assert(Maze(input: "#########\n#b.A.@.a#\n#########").solved().solution == (8, "ab"))
        assert(Maze(input: "########################\n#f.D.E.e.C.b.A.@.a.B.c.#\n######################.#\n#d.....................#\n########################").solved().solution == (86, "abcdef"))
        assert(Maze(input: "########################\n#...............b.C.D.f#\n#.######################\n#.....@.a.B.c.d.A.e.F.g#\n########################").solved().solution == (132, "bacdfeg"))
        assert(Maze(input: "#################\n#i.G..c...e..H.p#\n########.########\n#j.A..b...f..D.o#\n########@########\n#k.E..a...g..B.n#\n########.########\n#l.F..d...h..C.m#\n#################").solved().solution == (136, "afbjgnhdloepcikm"))
        assert(Maze(input: "########################\n#@..............ac.GI.b#\n###d#e#f################\n###A#B#C################\n###g#h#i################\n########################").solved().solution == (81, "acfidgbeh"))

        let maze = Maze(input: input)
        let solution = maze.solved().solution
        print("Shortest path to collect all the key for Day 18-1 is \(solution.numberOfSteps) steps long")
    }

    struct Maze {
        enum Key: String {
            case a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z
        }
        enum Tile: CustomStringConvertible {
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

        var position: Vector2D
        var tiles: [Vector2D: Tile]
        var targetNumber: Int

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

        func findFetchableKeys() -> [(key: Key, position: Vector2D, distance: Int)] {
            // TODO: A*
            return []
        }

        func solve(solution: inout Maze?) {
            // Some recursive A* algorithm will be usefull here.
            // It's gonna be interesting ^^
            for (key, position, distance) in findFetchableKeys() {
                var maze = self
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
                for position in maze.tiles.filter({ $0.value.key != key }).keys {
                    maze.tiles.updateValue(.empty, forKey: position)
                }
                if maze.isSolved && maze._solution.numberOfSteps < solution?._solution.numberOfSteps ?? .max {
                    solution = maze
                } else {
                    maze.solve(solution: &solution)
                }
            }
        }

        func solved() -> Maze {
            var solution: Maze?
            solve(solution: &solution)
            return solution!
        }
    }
}
