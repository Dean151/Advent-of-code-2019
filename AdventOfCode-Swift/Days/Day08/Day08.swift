
import Foundation

struct Day08: Day {
    static func run(input: String) {
        let picture = Picture(width: 25, height: 6, input: input)
        print("Checksum for Day 8-1 is \(picture.checksum)")
        picture.print()
    }

    struct Picture {
        let width: Int
        let height: Int
        let layers: [[Int]]

        init(width: Int, height: Int, input: String) {
            self.width = width
            self.height = height
            let size = width * height
            let pixels = input.compactMap { Int(String($0)) }
            assert(pixels.count % size == 0)
            self.layers = stride(from: 0, to: pixels.count, by: size).map { Array(pixels[$0 ..< min($0 + size, pixels.count)]) }
        }

        var layerWithMin0: [Int] {
            let index = layers.enumerated().map({ (offset, element) -> (Int, Int) in
                return (offset, element.filter({ $0 == 0 }).count)
            }).min(by: { $0.1 < $1.1 })!.0
            return layers[index]
        }

        var checksum: Int {
            let layer = layerWithMin0
            let (ones, twos) = layer.reduce((0,0)) { initial, element in
                return (
                    initial.0 + (element == 1 ? 1 : 0),
                    initial.1 + (element == 2 ? 1 : 0)
                )
            }
            return ones * twos
        }

        var decode: [Int] {
            var image = [Int]()
            let size = width*height
            for index in 0..<size {
                var offset = 0
                var pixel: Int
                repeat {
                    pixel = layers[offset][index]
                    offset += 1
                } while pixel == 2
                image.append(pixel)
            }
            return image
        }

        func print() {
            for (index, pixel) in decode.enumerated() {
                Swift.print(pixel == 1 ? "X" : " ", terminator: "")
                if index % width == width - 1 {
                    Swift.print("") // Will go to the line
                }
            }
        }
    }
}
