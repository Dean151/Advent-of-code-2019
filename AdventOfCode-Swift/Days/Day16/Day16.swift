
import Foundation

struct Day16: Day {
    static func run(input: String) {

        // Part 1 requirements
        assert(Signal(input: "12345678").firstHeightDigits == 12345678)
        assert(Signal(input: "12345678").processed(1).firstHeightDigits == 48226158)
        assert(Signal(input: "12345678").processed(2).firstHeightDigits == 34040438)
        assert(Signal(input: "12345678").processed(3).firstHeightDigits == 03415518)
        assert(Signal(input: "12345678").processed(4).firstHeightDigits == 01029498)
        assert(Signal(input: "80871224585914546619083218645595").processed(100).firstHeightDigits == 24176176)
        assert(Signal(input: "19617804207202209144916044189917").processed(100).firstHeightDigits == 73745418)
        assert(Signal(input: "69317163492948606335995924319873").processed(100).firstHeightDigits == 52432133)

        let signal = Signal(input: input).processed(100)
        print("Height first digits after processing the signal 100 times for Day 16-1 is \(signal.firstHeightDigits)")

        // Part 2 requirements
        // Seems like performances matters for this one :-/
        assert(Signal(input: "03036732577212944063491565474664", longInput: true).processed(100).firstHeightDigits == 84462026)
        assert(Signal(input: "02935109699940807407585447034323", longInput: true).processed(100).firstHeightDigits == 78725270)
        assert(Signal(input: "03081770884921959731165446850517", longInput: true).processed(100).firstHeightDigits == 53553731)

        let longSignal = Signal(input: input, longInput: true).processed(100)
        print("Output digits after processing the long signal 100 times for Day 16-2 is \(longSignal.firstHeightDigits)")
    }

    struct Signal {
        let signal: [UInt8]
        let offset: Int?

        init(signal: [UInt8], offset: Int?) {
            self.signal = signal
            self.offset = offset
        }

        init(input: String, longInput: Bool = false) {
            let input = input.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
            self.offset = longInput ? Int(input[input.startIndex..<input.index(input.startIndex, offsetBy: 7)]) : nil
            let data = input.compactMap({ UInt8("\($0)") })
            self.signal = !longInput ? data : [[UInt8]](repeating: data, count: 10_000).reduce([], +)
        }

        func reduce(for offset: Int) -> UInt8 {
            precondition(offset >= 0)
            let sum = signal.enumerated().reduce(0) {
                let factor = [0, 1, 0, -1][($1.offset + 1) / (offset + 1) % 4]
                return $0 + (Int($1.element) * factor)
            }
            return UInt8(abs(sum) % 10)
        }

        func processedOnce() -> Signal {
            var new = signal
            var i = signal.count - 2
            while i >= 0 {
                if i >= signal.count / 2 {
                    // What a nice simplification
                    new[i] = (signal[i] + new[i+1]) % 10
                } else if offset == nil || offset! < signal.count / 2 {
                    // We calculate first numbers only if required
                    new[i] = reduce(for: i)
                }
                i -= 1
            }
            return Signal(signal: new, offset: offset)
        }

        func processed(_ times: Int) -> Signal {
            var signal = self
            for _ in 0..<times {
                signal = signal.processedOnce()
            }
            return signal
        }

        var firstHeightDigits: Int {
            let start = offset ?? 0
            let digits = signal[start ..< start + 8].reduce(0, { $0 * 10 + Int($1) })
            return digits
        }
    }
}
