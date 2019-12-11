
import Foundation

struct Day03: Day {
    static func run(input: String) {
        
        // Part 1 requirements
        assert(FrontPanel(input: "R8,U5,L5,D3\nU7,R6,D4,L4").minIntersectDistance == 6)
        assert(FrontPanel(input: "R75,D30,R83,U83,L12,D49,R71,U7,L72\nU62,R66,U55,R34,D71,R55,D58,R83").minIntersectDistance == 159)
        assert(FrontPanel(input: "R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51\nU98,R91,D20,R16,D67,R40,U7,R15,U6,R7").minIntersectDistance == 135)
        
        let panel = FrontPanel(input: input)
        print("Minimum distanced intersection for day 3-1 is \(panel.minIntersectDistance)")

        // Part 2 requirements
        assert(FrontPanel(input: "R8,U5,L5,D3\nU7,R6,D4,L4").minIntersectDelay == 30)
        assert(FrontPanel(input: "R75,D30,R83,U83,L12,D49,R71,U7,L72\nU62,R66,U55,R34,D71,R55,D58,R83").minIntersectDelay == 610)
        assert(FrontPanel(input: "R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51\nU98,R91,D20,R16,D67,R40,U7,R15,U6,R7").minIntersectDelay == 410)

        print("Minimum delayed intersection for day 3-2 is \(panel.minIntersectDelay)")
    }

    struct FrontPanel {
        struct Wire {
            struct Definition {
                let direction: Direction
                let distance: Int

                init?(rawValue: String) {
                    guard let dir = rawValue.first.flatMap({ String($0) }), let direction = Direction(rawValue: dir) else {
                        return nil
                    }
                    var dist = rawValue
                    dist.removeFirst()
                    guard let distance = Int(dist) else {
                        return nil
                    }
                    self.direction = direction
                    self.distance = distance
                }
            }

            enum Direction: String {
                case up = "U"
                case left = "L"
                case right = "R"
                case down = "D"

                func follow(from pos: Vector2D) -> Vector2D {
                    switch self {
                    case .up:
                        return Vector2D(x: pos.x, y: pos.y - 1)
                    case .left:
                        return Vector2D(x: pos.x - 1, y: pos.y)
                    case .right:
                        return Vector2D(x: pos.x + 1, y: pos.y)
                    case .down:
                        return Vector2D(x: pos.x, y: pos.y + 1)
                    }
                }
            }

            let positions: [Vector2D: Int]

            init(definitions: [Definition]) {
                var positions = [Vector2D: Int](minimumCapacity: definitions.count)
                var pos = Vector2D.zero
                var step = 1
                for definition in definitions {
                    for _ in 0..<definition.distance {
                        pos = definition.direction.follow(from: pos)
                        positions.updateValue(step, forKey: pos)
                        step += 1
                    }
                }
                self.positions = positions
            }
        }

        let firstWire: Wire
        let secondWire: Wire
        
        init(input: String) {
            let wiresDef = input.components(separatedBy: .newlines).map({
                return $0.components(separatedBy: .punctuationCharacters).compactMap { rawDef in
                    return Wire.Definition(rawValue: rawDef)
                }
            }).filter({ !$0.isEmpty })

            guard wiresDef.count == 2 else {
                fatalError("Front panel can only have exactly 2 wires")
            }

            firstWire = Wire(definitions: wiresDef[0])
            secondWire = Wire(definitions: wiresDef[1])
        }

        var intersections: Set<Vector2D> {
            return Set(firstWire.positions.keys).intersection(secondWire.positions.keys)
        }
        
        var minIntersectDistance: Int {
            return intersections.map({ $0.manatthanDistance }).min() ?? 0
        }

        var minIntersectDelay: Int {
            return intersections.map({ firstWire.positions[$0]! + secondWire.positions[$0]! }).min() ?? 0
        }
    }
}
