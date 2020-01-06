
import Foundation

struct Day22: Day {
    static func run(input: String) {

        // Part 1 requirements
        assert(DealMove.dealInNewDeck.index(for: 4, with: 10) == 5)
        assert(DealMove.cut(n: 3).index(for: 4, with: 10) == 1)
        assert(DealMove.cut(n: -4).index(for: 4, with: 10) == 8)
        assert(DealMove.dealWithIncrement(n: 3).index(for: 4, with: 10) == 2)

        let moves = input.components(separatedBy: .newlines).compactMap({ DealMove(line: $0) })
        var index = 2019
        for move in moves {
            index = move.index(for: index, with: 10_007)
        }
        print("Position of card 2019 for Day 22-1 is \(index)")
    }

    enum DealMove {
        case dealInNewDeck
        case cut(n: Int)
        case dealWithIncrement(n: Int)

        init?(line: String) {
            if line == "deal into new stack" {
                self = .dealInNewDeck
                return
            }

            guard let number = line.components(separatedBy: .whitespaces).last.flatMap({ Int($0) }) else {
                return nil
            }

            if line.starts(with: "deal with increment ") {
                self = .dealWithIncrement(n: number)
            }
            else if line.starts(with: "cut ") {
                self = .cut(n: number)
            }
            else {
                return nil
            }
        }

        func index(for index: Int, with deckSize: Int) -> Int {
            switch self {
            case .dealInNewDeck:
                return deckSize - (index + 1)
            case .cut(n: let n):
                return (index - n) % deckSize
            case .dealWithIncrement(n: let n):
                return (index * n) % deckSize
            }
        }

        func reverseIndex(for index: Int, numberOfCards: Int) -> Int {
            return index
        }
    }
}
