
import Foundation

class Day03: Day {
    static func run(input: String) {
        
        // Part 1 requirements
        assert(FrontPanel(wires: "R8,U5,L5,D3\nU7,R6,D4,L4").minIntersectDistance() == 6)
        assert(FrontPanel(wires: "R75,D30,R83,U83,L12,D49,R71,U7,L72\nU62,R66,U55,R34,D71,R55,D58,R83").minIntersectDistance() == 159)
        assert(FrontPanel(wires: "R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51\nU98,R91,D20,R16,D67,R40,U7,R15,U6,R7").minIntersectDistance() == 135)
        
        let panel = FrontPanel(wires: input)
        print("Minimum distanced intersection for day 3-1 is \(panel.minIntersectDistance())")
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
    
    struct WireDefinition {
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
    
    struct Vector2D: Hashable {
        let x: Int
        let y: Int
    
        var manatthanDistance: Int {
            return abs(x) + abs(y)
        }
    }
    
    enum WireType {
        case wire
        case intersection
    }
    
    struct FrontPanel {
        let panel: [Vector2D: WireType]
        
        init(wires: String) {
            var panel: [Vector2D: WireType] = [:]
            for wireDef in wires.components(separatedBy: .newlines) {
                var pos = Vector2D(x: 0, y: 0)
                for def in wireDef.components(separatedBy: .punctuationCharacters) {
                    guard let wire = WireDefinition(rawValue: def) else {
                        continue
                    }
                    for _ in 0..<wire.distance {
                        pos = wire.direction.follow(from: pos)
                        panel[pos] = panel[pos] != nil ? .intersection : .wire
                    }
                }
            }
            self.panel = panel
        }
        
        func minIntersectDistance() -> Int {
            let distance = panel.filter({ return $0.value == .intersection }).keys.map({ $0.manatthanDistance }).min() ?? 0
            print(distance)
            return distance
        }
    }
}
