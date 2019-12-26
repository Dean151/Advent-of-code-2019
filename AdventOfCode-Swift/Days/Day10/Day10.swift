
import Foundation

struct Day10: Day {
    static func run(input: String) {
        // Part 1 requirements
        assert(AsteroidField(input: ".#..#\n.....\n#####\n....#\n...##").findBestPlace() == (Vector2D(x: 3, y: 4), 8))
        assert(AsteroidField(input: "......#.#.\n#..#.#....\n..#######.\n.#.#.###..\n.#..#.....\n..#....#.#\n#..#....#.\n.##.#..###\n##...#..#.\n.#....####").findBestPlace() == (Vector2D(x: 5, y: 8), 33))
        assert(AsteroidField(input: "#.#...#.#.\n.###....#.\n.#....#...\n##.#.#.#.#\n....#.#.#.\n.##..###.#\n..#...##..\n..##....##\n......#...\n.####.###.").findBestPlace() == (Vector2D(x: 1, y: 2), 35))
        assert(AsteroidField(input: ".#..#..###\n####.###.#\n....###.#.\n..###.##.#\n##.##.#.#.\n....###..#\n..#.#..#.#\n#..#.#.###\n.##...##.#\n.....#.#..").findBestPlace() == (Vector2D(x: 6, y: 3), 41))
        #if DEBUG
        let testField = AsteroidField(input: ".#..##.###...#######\n##.############..##.\n.#.######.########.#\n.###.#######.####.#.\n#####.##.#.##.###.##\n..#####..#.#########\n####################\n#.####....###.#.#.##\n##.#################\n#####.##.###..####..\n..######..##.#######\n####.##.####...##..#\n.#####..#.######.###\n##...#.##########...\n#.##########.#######\n.####.#.###.###.#.##\n....##.##.###..#####\n.#.#.###########.###\n#.#.#.#####.####.###\n###.##.####.##.#..##")
        assert(testField.findBestPlace() == (Vector2D(x: 11, y: 13), 210))
        #endif

        let field = AsteroidField(input: input)
        let bestPlace = field.findBestPlace()
        print("Best position for Day 10-1 is at \(bestPlace.position), with \(bestPlace.visibleNumber) asteroid visibles")

        // Part 2 requirement
        #if DEBUG
        let testShootAsteroids = testField.asteroidsInShotOrder(from: Vector2D(x: 11, y: 13))
        assert(testShootAsteroids[1] == Vector2D(x: 11, y: 12))
        assert(testShootAsteroids[2] == Vector2D(x: 12, y: 1))
        assert(testShootAsteroids[3] == Vector2D(x: 12, y: 2))
        assert(testShootAsteroids[10] == Vector2D(x: 12, y: 8))
        assert(testShootAsteroids[20] == Vector2D(x: 16, y: 0))
        assert(testShootAsteroids[50] == Vector2D(x: 16, y: 9))
        assert(testShootAsteroids[100] == Vector2D(x: 10, y: 16))
        assert(testShootAsteroids[199] == Vector2D(x: 9, y: 6))
        assert(testShootAsteroids[200] == Vector2D(x: 8, y: 2))
        assert(testShootAsteroids[201] == Vector2D(x: 10, y: 9))
        assert(testShootAsteroids[299] == Vector2D(x: 11, y: 1))
        #endif

        let vaporized = field.asteroidsInShotOrder(from: bestPlace.position, stopAt: 200)
        let vaporized200th = vaporized[200]
        print("200th asteroid to be vaporized for Day 10-2 is at \(vaporized200th) -> x*100+y = \(vaporized200th.x * 100 + vaporized200th.y)")
    }

    struct AsteroidField {
        let width: Int
        let height: Int
        var asteroids: Set<Vector2D> = []

        init(input: String) {
            var pos = Vector2D.zero
            let lines = input.components(separatedBy: .newlines).filter { !$0.isEmpty }
            self.height = lines.count
            self.width = lines[0].count
            for line in lines {
                for char in line {
                    switch char {
                    case "#":
                        asteroids.insert(pos)
                    default:
                        break
                    }
                    pos.x += 1
                }
                pos.x = 0
                pos.y += 1
            }
        }

        func findBestPlace() -> (position: Vector2D, visibleNumber: Int) {
            var visibleCount: [Vector2D: Int] = [:]
            asteroids.forEach { position in
                visibleCount.updateValue(visibleNumber(from: position), forKey: position)
            }
            guard let bestPlace = visibleCount.map({ return ($0.key, $0.value) }).max(by: { $0.1 < $1.1 }) else {
                fatalError("Nowhere to be found...")
            }
            return bestPlace
        }

        func visibleNumber(from position: Vector2D) -> Int {
            return asteroidsPerAngle(from: position).count
        }

        func asteroidsPerAngle(from position: Vector2D) -> [Double: Set<Vector2D>] {
            var asteroidsPerAngle: [Double: Set<Vector2D>] = [:]
            asteroids.forEach { other in
                if other == position { return }
                var argument = Vector2D(x: other.x - position.x, y: other.y - position.y).argument
                // We change the offset for the laser part
                if argument < -.pi / 2 {
                    argument += 2 * .pi
                }
                if asteroidsPerAngle[argument]?.insert(other) == nil {
                    asteroidsPerAngle.updateValue([other], forKey: argument)
                }
            }
            return asteroidsPerAngle
        }

        func asteroidsInShotOrder(from position: Vector2D, stopAt: Int? = nil) -> [Vector2D] {
            var asteroidsToShoot = asteroidsPerAngle(from: position).mapValues {
                $0.sorted {
                    Vector2D(x: $0.x - position.x, y: $0.y - position.y).manatthanDistance > Vector2D(x: $1.x - position.x, y: $1.y - position.y).manatthanDistance
                }
            }

            let stopAt = stopAt ?? asteroids.count - 1
            if stopAt >= asteroids.count {
                fatalError("Not enough asteroids")
            }

            var angleLoop = asteroidsToShoot.keys.sorted()
            var angleIndex = 0
            var asteroidsShooted = [position] // We'll be at 0 to offset ^^
            while asteroidsShooted.count <= stopAt {
                let angle = angleLoop[angleIndex]
                if let asteroid = asteroidsToShoot[angle]?.popLast() {
                    asteroidsShooted.append(asteroid)
                    angleIndex += 1
                } else {
                    angleLoop.remove(at: angleIndex)
                }
                angleIndex %= angleLoop.count
            }
            return asteroidsShooted
        }
    }
}

// 1160 too high
