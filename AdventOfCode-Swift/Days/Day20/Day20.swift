
import Foundation

struct Day20: Day {
    static func run(input: String) {

        // Part 1 requirements
        assert(Maze(input: "         A\n         A\n  #######.#########\n  #######.........#\n  #######.#######.#\n  #######.#######.#\n  #######.#######.#\n  #####  B    ###.#\nBC...##  C    ###.#\n  ##.##       ###.#\n  ##...DE  F  ###.#\n  #####    G  ###.#\n  #########.#####.#\nDE..#######...###.#\n  #.#########.###.#\nFG..#########.....#\n  ###########.#####\n             Z\n             Z       ").solved() == 23)
        assert(Maze(input: "                   A\n                   A\n  #################.#############\n  #.#...#...................#.#.#\n  #.#.#.###.###.###.#########.#.#\n  #.#.#.......#...#.....#.#.#...#\n  #.#########.###.#####.#.#.###.#\n  #.............#.#.....#.......#\n  ###.###########.###.#####.#.#.#\n  #.....#        A   C    #.#.#.#\n  #######        S   P    #####.#\n  #.#...#                 #......VT\n  #.#.#.#                 #.#####\n  #...#.#               YN....#.#\n  #.###.#                 #####.#\nDI....#.#                 #.....#\n  #####.#                 #.###.#\nZZ......#               QG....#..AS\n  ###.###                 #######\nJO..#.#.#                 #.....#\n  #.#.#.#                 ###.#.#\n  #...#..DI             BU....#..LF\n  #####.#                 #.#####\nYN......#               VT..#....QG\n  #.###.#                 #.###.#\n  #.#...#                 #.....#\n  ###.###    J L     J    #.#.###\n  #.....#    O F     P    #.#...#\n  #.###.#####.#.#####.#####.###.#\n  #...#.#.#...#.....#.....#.#...#\n  #.#####.###.###.#.#.#########.#\n  #...#.#.....#...#.#.#.#.....#.#\n  #.###.#####.###.###.#.#.#######\n  #.#.........#...#.............#\n  #########.###.###.#############\n           B   J   C\n           U   P   P               ").solved() == 58)

        let maze = Maze(input: input)
        print("Quickest path threw the maze is \(maze.solved()!) steps long for Day 20-1")

        // Part 2 requirements
        assert(Maze(input: "         A\n         A\n  #######.#########\n  #######.........#\n  #######.#######.#\n  #######.#######.#\n  #######.#######.#\n  #####  B    ###.#\nBC...##  C    ###.#\n  ##.##       ###.#\n  ##...DE  F  ###.#\n  #####    G  ###.#\n  #########.#####.#\nDE..#######...###.#\n  #.#########.###.#\nFG..#########.....#\n  ###########.#####\n             Z\n             Z       ").solved(outermostMode: true) == 26)
        assert(Maze(input: "                   A\n                   A\n  #################.#############\n  #.#...#...................#.#.#\n  #.#.#.###.###.###.#########.#.#\n  #.#.#.......#...#.....#.#.#...#\n  #.#########.###.#####.#.#.###.#\n  #.............#.#.....#.......#\n  ###.###########.###.#####.#.#.#\n  #.....#        A   C    #.#.#.#\n  #######        S   P    #####.#\n  #.#...#                 #......VT\n  #.#.#.#                 #.#####\n  #...#.#               YN....#.#\n  #.###.#                 #####.#\nDI....#.#                 #.....#\n  #####.#                 #.###.#\nZZ......#               QG....#..AS\n  ###.###                 #######\nJO..#.#.#                 #.....#\n  #.#.#.#                 ###.#.#\n  #...#..DI             BU....#..LF\n  #####.#                 #.#####\nYN......#               VT..#....QG\n  #.###.#                 #.###.#\n  #.#...#                 #.....#\n  ###.###    J L     J    #.#.###\n  #.....#    O F     P    #.#...#\n  #.###.#####.#.#####.#####.###.#\n  #...#.#.#...#.....#.....#.#...#\n  #.#####.###.###.#.#.#########.#\n  #...#.#.....#...#.#.#.#.....#.#\n  #.###.#####.###.###.#.#.#######\n  #.#.........#...#.............#\n  #########.###.###.#############\n           B   J   C\n           U   P   P               ").solved(outermostMode: true) == nil)
        assert(Maze(input: "             Z L X W       C\n             Z P Q B       K\n  ###########.#.#.#.#######.###############\n  #...#.......#.#.......#.#.......#.#.#...#\n  ###.#.#.#.#.#.#.#.###.#.#.#######.#.#.###\n  #.#...#.#.#...#.#.#...#...#...#.#.......#\n  #.###.#######.###.###.#.###.###.#.#######\n  #...#.......#.#...#...#.............#...#\n  #.#########.#######.#.#######.#######.###\n  #...#.#    F       R I       Z    #.#.#.#\n  #.###.#    D       E C       H    #.#.#.#\n  #.#...#                           #...#.#\n  #.###.#                           #.###.#\n  #.#....OA                       WB..#.#..ZH\n  #.###.#                           #.#.#.#\nCJ......#                           #.....#\n  #######                           #######\n  #.#....CK                         #......IC\n  #.###.#                           #.###.#\n  #.....#                           #...#.#\n  ###.###                           #.#.#.#\nXF....#.#                         RF..#.#.#\n  #####.#                           #######\n  #......CJ                       NM..#...#\n  ###.#.#                           #.###.#\nRE....#.#                           #......RF\n  ###.###        X   X       L      #.#.#.#\n  #.....#        F   Q       P      #.#.#.#\n  ###.###########.###.#######.#########.###\n  #.....#...#.....#.......#...#.....#.#...#\n  #####.#.###.#######.#######.###.###.#.#.#\n  #.......#.......#.#.#.#.#...#...#...#.#.#\n  #####.###.#####.#.#.#.#.###.###.#.###.###\n  #.......#.....#.#...#...............#...#\n  #############.#.#.###.###################\n               A O F   N\n               A A D   M                     ").solved(outermostMode: true) == 396)

        print("Quickest path threw the outermost maze is \(maze.solved(outermostMode: true)!) steps long for Day 20-2")
    }

    struct Maze {
        enum Tile: CustomStringConvertible {
            case empty
            case wall
            case portal(outer: Bool, target: Vector2D)

            var description: String {
                switch self {
                case .empty:
                    return "."
                case .wall:
                    return "#"
                case .portal:
                    return "@"
                }
            }

            init?(from char: Character) {
                switch char {
                case ".":
                    self = .empty
                case "#":
                    self = .wall
                default:
                    return nil
                }
            }
        }

        let start: Vector2D
        let end: Vector2D
        let tiles: [Vector2D: Tile]

        init(input: String) {
            var start: Vector2D?
            var end: Vector2D?
            // Create the maze, skipping the "portals"
            var tiles: [Vector2D: Tile] = [:]
            var portals: [Vector2D: Character] = [:]
            for (y, line) in input.components(separatedBy: .newlines).enumerated() {
                for (x, char) in line.enumerated() {
                    let position = Vector2D(x: x, y: y)
                    guard let tile = Tile(from: char) else {
                        if char.isLetter {
                            portals[position] = char
                        }
                        continue
                    }
                    tiles[position] = tile
                }
            }
            // Resolve the portals
            var toPairPortals: [String: (portalPos: Vector2D, sidePos: Vector2D, outer: Bool)] = [:]
            while let (posA,charA) = portals.popFirst() {
                guard let (posB, charB) = posA.neighbours.compactMap({ portals[$0] != nil ? ($0,portals[$0]!) : nil }).first else {
                    fatalError("Weird portal")
                }
                portals.removeValue(forKey: posB)
                // Resolve the portal identifier
                let identifier: String
                if posA.x < posB.x || posA.y < posB.y {
                    identifier = "\(charA)\(charB)"
                } else {
                    identifier = "\(charB)\(charA)"
                }
                // Also resolve the portal side case
                let sidePos: Vector2D
                let portalPos: Vector2D
                if let pos = posA.neighbours.filter({ tiles[$0] != nil }).first {
                    sidePos = pos
                    portalPos = posA
                } else if let pos = posB.neighbours.filter({ tiles[$0] != nil }).first {
                    sidePos = pos
                    portalPos = posB
                } else {
                    fatalError("Weird portal")
                }
                if identifier == "AA" {
                    start = sidePos
                    continue
                } else if identifier == "ZZ" {
                    end = sidePos
                    continue
                }

                // Make sure the bounds are correct for this portal
                tiles[portalPos] = .empty
                let bounds = tiles.bounds
                let outer = portalPos.x == bounds.minX || portalPos.x == bounds.maxX || portalPos.y == bounds.minY || portalPos.y == bounds.maxY

                guard let otherPortal = toPairPortals[identifier] else {
                    toPairPortals[identifier] = (portalPos, sidePos, outer)
                    continue
                }

                // Create the link
                tiles[portalPos] = .portal(outer: outer, target: otherPortal.sidePos)
                tiles[otherPortal.portalPos] = .portal(outer: otherPortal.outer, target: sidePos)
            }

            self.start = start!
            self.end = end!
            self.tiles = tiles
        }

        func solved(outermostMode: Bool = false) -> Int? {
            var visited: [Vector3D: Int] = [:]
            var toVisit: [Vector3D: Int] = [Vector3D(x: start.x, y: start.y, z: 0): 0]
            while let (position, distance) = toVisit.min(by: { $0.value < $1.value }) {
                toVisit.removeValue(forKey: position)
                let pos2D = Vector2D(x: position.x, y: position.y)
                if pos2D == end && position.z == 0 {
                    return distance
                }
                if visited[position] ?? .max > distance {
                    visited[position] = distance
                }
                for neighbour in pos2D.neighbours.map({ Vector3D(x: $0.x, y: $0.y, z: position.z) }) {
                    switch tiles[Vector2D(x: neighbour.x, y: neighbour.y)] {
                    case .portal(outer: let outer, target: let newPos):
                        if outermostMode && (neighbour.z == 0 && outer) {
                            continue
                        }
                        let newLevel = neighbour.z + (outermostMode ? (outer ? -1 : 1) : 0)
                        if newLevel > 1_000 {
                            // Recursion security
                            return nil
                        }
                        let newPos3D = Vector3D(x: newPos.x, y: newPos.y, z: newLevel)
                        if visited[newPos3D] ?? .max > distance + 1 && toVisit[newPos3D] ?? .max > distance + 1 {
                            toVisit[newPos3D] = distance + 1
                        }
                    case .empty:
                        if visited[neighbour] ?? .max > distance + 1 && toVisit[neighbour] ?? .max > distance + 1 {
                            toVisit[neighbour] = distance + 1
                        }
                    default:
                        continue
                    }
                }
            }
            fatalError("No solution found...")
        }
    }
}
