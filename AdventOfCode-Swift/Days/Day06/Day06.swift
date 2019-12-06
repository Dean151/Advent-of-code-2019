
import Foundation

struct Day06: Day {
    static func run(input: String) {

        // Part 1 requirements
        assert(System(input: "COM)B\nB)C\nC)D\nD)E\nE)F\nB)G\nG)H\nD)I\nE)J\nJ)K\nK)L").sumOfOrbits == 42)

        let system = System(input: input)
        print("Number of direct & indirect orbits for Day 6-1 is \(system.sumOfOrbits)")

        // Part 2 requirements
        assert(System(input: "COM)B\nB)C\nC)D\nD)E\nE)F\nB)G\nG)H\nD)I\nE)J\nJ)K\nK)L\nK)YOU\nI)SAN").minNumberOfOrbitJumps == 4)

        print("Minimum number of orbital jumps for Day 6-2 is \(system.minNumberOfOrbitJumps)")
    }

    struct System {
        let root: Body
        let you: Body?
        let santa: Body?

        class Body: Equatable, Hashable {
            // Need to be passed by reference, because it's easier this way
            let id: String
            weak var parent: Body?
            var children: Set<Body> = []

            init(id: String) {
                self.id = id
            }

            // Equatable
            static func ==(lhs: Body, rhs: Body) -> Bool {
                return lhs.id == rhs.id
            }

            // Hashable
            func hash(into hasher: inout Hasher) {
                hasher.combine(id)
            }

            var numberOfOrbits: Int {
                return (parent?.numberOfOrbits ?? -1) + 1
            }

            var sumOfOrbits: Int {
                return children.reduce(self.numberOfOrbits, { $0 + $1.sumOfOrbits })
            }

            var allParents: Set<Body> {
                guard let parent = parent else {
                    return []
                }
                var parents = parent.allParents
                parents.insert(parent)
                return parents
            }

            var distanceFromRoot: Int {
                return 1 + (parent?.distanceFromRoot ?? -1)
            }
        }

        var sumOfOrbits: Int {
            return root.sumOfOrbits
        }

        var minNumberOfOrbitJumps: Int {
            guard let origin = you?.parent, let destination = santa?.parent else {
                fatalError("We're lost forever in the deep space")
            }
            let commonParents = origin.allParents.intersection(destination.allParents)
            guard let pivot = commonParents.max(by: { $0.distanceFromRoot < $1.distanceFromRoot }) else {
                fatalError("No common parents! Hyperspace on!")
            }
            // No need for a complicated stuff ^^
            return origin.distanceFromRoot + destination.distanceFromRoot - 2 * pivot.distanceFromRoot
        }

        init(input: String) {
            let definition = input.components(separatedBy: .whitespacesAndNewlines).compactMap { string -> [String]? in
                let subarray = string.components(separatedBy: .init(charactersIn: ")"))
                return subarray.count == 2 ? subarray : nil
            }

            // Create the bodies
            var bodies: [String: Body] = [:]
            for def in definition {
                for i in 0...1 {
                    let id = def[i]
                    if bodies[id] == nil {
                        bodies.updateValue(Body(id: id), forKey: id)
                    }
                }

            }

            // Assign the children
            for def in definition {
                guard let parent = bodies[def[0]], let child = bodies[def[1]] else {
                    fatalError("Missing planet!")
                }
                child.parent = parent
                parent.children.insert(child)
            }

            // Find the root
            guard let root = bodies.filter({ $0.value.parent == nil }).first?.value else {
                fatalError("No root, makes little sence!")
            }
            self.root = root

            // Find you & san
            self.you = bodies["YOU"]
            self.santa = bodies["SAN"]
        }
    }
}
