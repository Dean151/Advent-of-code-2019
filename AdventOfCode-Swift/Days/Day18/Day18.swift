
import Foundation

struct Day18: Day {
    static func run(input: String) {

        // Part 1 requirements
        assert(Maze(input: "#########\n#b.A.@.a#\n#########").solve() == (8, "ab"))
        assert(Maze(input: "########################\n#f.D.E.e.C.b.A.@.a.B.c.#\n######################.#\n#d.....................#\n########################").solve() == (86, "abcdef"))
        assert(Maze(input: "########################\n#...............b.C.D.f#\n#.######################\n#.....@.a.B.c.d.A.e.F.g#\n########################").solve() == (132, "bacdfeg"))
        assert(Maze(input: "#################\n#i.G..c...e..H.p#\n########.########\n#j.A..b...f..D.o#\n########@########\n#k.E..a...g..B.n#\n########.########\n#l.F..d...h..C.m#\n#################").solve() == (136, "afbjgnhdloepcikm"))
        assert(Maze(input: "########################\n#@..............ac.GI.b#\n###d#e#f################\n###A#B#C################\n###g#h#i################\n########################").solve() == (81, "acfidgbeh"))

        let maze = Maze(input: input)
        let solution = maze.solve()
        print("Shortest path to collect all the key for Day 18-1 is \(solution.numberOfSteps) steps long")
    }

    struct Maze {
        enum Key: String {
            case a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z
        }
        enum Tile: CustomStringConvertible {
            case start, empty, wall
            case key(key: Key)
            case door(key: Key)

            var description: String {
                switch self {
                case .start:
                    return "@"
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
                case "@":
                    self = .start
                case ".":
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
        }

        var tiles: [Vector2D: Tile]

        init(input: String) {
            var tiles = [Vector2D: Tile]()
            for (y, line) in input.components(separatedBy: .newlines).enumerated() {
                for (x, char) in line.enumerated() {
                    guard let tile = Tile(from: char) else {
                        fatalError("Unknown tile!")
                    }
                    tiles.updateValue(tile, forKey: .init(x: x, y: y))
                }
            }
            self.tiles = tiles
        }

        func solve() -> (numberOfSteps: Int, order: String) {
            // Some recursive A* algorithm will be usefull here.
            // It's gonna be interesting ^^
            return (0, "") // TODO
        }
    }
}
