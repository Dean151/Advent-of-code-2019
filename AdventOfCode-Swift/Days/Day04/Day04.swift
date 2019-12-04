
import Foundation

struct Day04: Day {
    static func run(input: String) {
        
        // Part 1 requirements
        assert(Password(number: 111111).isMatchingCriteria() == true)
        assert(Password(number: 223450).isMatchingCriteria() == false)
        assert(Password(number: 123789).isMatchingCriteria() == false)
        
        let numbers = input.components(separatedBy: CharacterSet.decimalDigits.inverted).compactMap { Int($0) }
        guard numbers.count == 2 else {
            fatalError("Puzzle input should consist of two numbers only")
        }
        let range = numbers[0]...numbers[1]
        
        let result = Password.numberMatching(within: range)
        print("Number of matching password for day 4-1 is \(result)")
        
        // Part 2 requirements
        assert(Password(number: 112233).isMatchingCriteria(haveExactDoublon: true) == true)
        assert(Password(number: 123444).isMatchingCriteria(haveExactDoublon: true) == false)
        assert(Password(number: 111122).isMatchingCriteria(haveExactDoublon: true) == true)
        
        // My added assertions for debugging part two
        assert(Password(number: 568888).isMatchingCriteria(haveExactDoublon: true) == false)
        assert(Password(number: 588889).isMatchingCriteria(haveExactDoublon: true) == false)
        assert(Password(number: 588999).isMatchingCriteria(haveExactDoublon: true) == true)
        
        let resultWithNoTriple = Password.numberMatching(within: range, haveExactDoublon: true)
        print("Number of matching password for day 4-2 is \(resultWithNoTriple)")
    }
    
    struct Password {
        // Well treat it as a string (easier)
        let password: String
        
        init(number: Int) {
            self.password = number.description
        }
        
        func isMatchingCriteria(haveExactDoublon: Bool = false) -> Bool {
            var haveDouble = false
            var doublon: Character?
            var skipped: Character?
            for index in password.indices[password.startIndex..<password.endIndex] {
                let after = password.index(after: index)
                if after == password.endIndex {
                    // No next characters
                    if haveExactDoublon && doublon != nil {
                        haveDouble = true
                    }
                    break
                }
                let current = password[index]
                let next = password[after]
                if current > next {
                    // It's decreasing at some point
                    return false
                }
                if !haveDouble && haveExactDoublon {
                    if doublon != nil && doublon != next {
                        haveDouble = true
                    }
                    else if doublon == next {
                        doublon = nil
                        skipped = next
                    }
                    else if current == next && skipped != current {
                        doublon = current
                    }
                }
                else if !haveDouble && current == next {
                    haveDouble = true
                }
            }
            return haveDouble
        }
        
        static func numberMatching(within range: ClosedRange<Int>, haveExactDoublon: Bool = false) -> Int {
            range.map({ Password(number: $0) }).filter({ $0.isMatchingCriteria(haveExactDoublon: haveExactDoublon) }).count
        }
    }
}
