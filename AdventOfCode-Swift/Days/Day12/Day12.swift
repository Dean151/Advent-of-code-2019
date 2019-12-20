
import Foundation

struct Day12: Day {
    static func run(input: String) {

        // Part 1 requirement
        assert(System(input: "<x=-1, y=0, z=2>\n<x=2, y=-10, z=-7>\n<x=4, y=-8, z=8>\n<x=3, y=5, z=-1>").forwarded(by: 10).energy == 179)
        assert(System(input: "<x=-8, y=-10, z=0>\n<x=5, y=5, z=10>\n<x=2, y=-7, z=3>\n<x=9, y=-8, z=-3>").forwarded(by: 100).energy == 1940)

        let system = System(input: input)
        print("Energy for System for Day 12-1 is \(system.forwarded(by: 1000).energy)")

        // Part 2 requirement
        assert(System(input: "<x=-8, y=-10, z=0>\n<x=5, y=5, z=10>\n<x=2, y=-7, z=3>\n<x=9, y=-8, z=-3>").numberOfStepsBeforeRepeats == 4686774924)

        print("Number of steps before seeing a previous state for Day 12-2 is \(system.numberOfStepsBeforeRepeats)")
    }

    struct System: CustomStringConvertible, Hashable {
        struct Moon: CustomStringConvertible, Hashable {
            var position: Vector3D
            var velocity: Vector3D = .zero

            init(position: Vector3D, velocity: Vector3D) {
                self.position = position
                self.velocity = velocity
            }

            init?(line: String) {
                let numbers = [Int].parse(rawValue: line)
                if numbers.count != 3 {
                    return nil
                }
                position = Vector3D(x: numbers[0], y: numbers[1], z: numbers[2])
            }

            var energy: Int {
                return position.manatthanDistance * velocity.manatthanDistance
            }

            func gravity(from others: [Moon]) -> Moon {
                var moon = self
                for other in others {
                    if other.position.x != position.x {
                        moon.velocity.x += other.position.x > position.x ? 1 : -1
                    }
                    if other.position.y != position.y {
                        moon.velocity.y += other.position.y > position.y ? 1 : -1
                    }
                    if other.position.z != position.z {
                        moon.velocity.z += other.position.z > position.z ? 1 : -1
                    }
                }
                return moon
            }

            func moved() -> Moon {
                var moon = self
                moon.position = position + velocity
                return moon
            }

            var description: String {
                return "pos=\(position), vel=\(velocity)"
            }
        }

        var moons: [Moon]

        init(input: String) {
            moons = input.components(separatedBy: .newlines).compactMap { Moon(line: $0) }
            if moons.count != 4 {
                fatalError("Wrong number of moons")
            }
        }

        mutating func forwardOnce() {
            // Apply gravity on velocities
            moons = moons.enumerated().map({
                var others = moons
                others.remove(at: $0.offset)
                return $0.element.gravity(from: others)
            })

            // Apply velocities
            moons = moons.map { $0.moved() }
        }

        func forwardedOnce() -> System {
            var system = self
            system.forwardOnce()
            return system
        }

        mutating func forward(by steps: Int) {
            for _ in 0..<steps {
                forwardOnce()
            }
        }

        func forwarded(by steps: Int) -> System {
            var system = self
            system.forward(by: steps)
            return system
        }

        var energy: Int {
            return moons.reduce(0) { $0 + $1.energy }
        }

        var numberOfStepsBeforeRepeats: Int {
            // TODO!
            return 0
        }

        var description: String {
            return moons.map({ $0.description }).joined(separator: "\n")
        }
    }
}
