
import Foundation

class Day01: Day {
    static func run(input: String) {
        
        // Part 1 requirements
        assert(fuelRequired(for: 12) == 2)
        assert(fuelRequired(for: 14) == 2)
        assert(fuelRequired(for: 1969) == 654)
        assert(fuelRequired(for: 100756) == 33583)
        
        let masses = [Int].parse(rawValue: input)
        let fuelRequirement = masses.reduce(0) {
            return $0 + fuelRequired(for: $1)
        }
        print("Fuel requirement for Day 1-1 is \(fuelRequirement)")
        
        // Part 2 requirements
        assert(fuelRequired(for: 14, extraFuel: true) == 2)
        assert(fuelRequired(for: 1969, extraFuel: true) == 966)
        assert(fuelRequired(for: 100756, extraFuel: true) == 50346)
        
        let completeFuelRequirement = masses.reduce(0) {
            return $0 + fuelRequired(for: $1, extraFuel: true)
        }
        print("Fuel requirement with extra fuel for Day 1-2 is \(completeFuelRequirement)")
    }
    
    static func fuelRequired(for mass: Int, extraFuel: Bool = false) -> Int {
        // No need for rounding down, since Int division does that already
        var fuel = (mass / 3) - 2
        // Also skip if fuel <= 6 -> extraFuel <= 0
        if !extraFuel || fuel <= 6 {
            return fuel
        }
        var extra = fuel
        while extra > 6 {
            extra = fuelRequired(for: extra)
            fuel += extra
        }
        return fuel
    }
}
