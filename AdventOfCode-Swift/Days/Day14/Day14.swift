
import Foundation

struct Day14: Day {
    static func run(input: String) {

        // Part 1 requirements
        assert(ReactionSet(input: "10 ORE => 10 A\n1 ORE => 1 B\n7 A, 1 B => 1 C\n7 A, 1 C => 1 D\n7 A, 1 D => 1 E\n7 A, 1 E => 1 FUEL").orePerFuel() == 31)
        assert(ReactionSet(input: "9 ORE => 2 A\n8 ORE => 3 B\n7 ORE => 5 C\n3 A, 4 B => 1 AB\n5 B, 7 C => 1 BC\n4 C, 1 A => 1 CA\n2 AB, 3 BC, 4 CA => 1 FUEL").orePerFuel() == 165)
        assert(ReactionSet(input: "157 ORE => 5 NZVS\n165 ORE => 6 DCFZ\n44 XJWVT, 5 KHKGT, 1 QDVJ, 29 NZVS, 9 GPVTF, 48 HKGWZ => 1 FUEL\n12 HKGWZ, 1 GPVTF, 8 PSHF => 9 QDVJ\n179 ORE => 7 PSHF\n177 ORE => 5 HKGWZ\n7 DCFZ, 7 PSHF => 2 XJWVT\n165 ORE => 2 GPVTF\n3 DCFZ, 7 NZVS, 5 HKGWZ, 10 PSHF => 8 KHKGT").orePerFuel() == 13_312)
        assert(ReactionSet(input: "2 VPVL, 7 FWMGM, 2 CXFTF, 11 MNCFX => 1 STKFG\n17 NVRVD, 3 JNWZP => 8 VPVL\n53 STKFG, 6 MNCFX, 46 VJHF, 81 HVMC, 68 CXFTF, 25 GNMV => 1 FUEL\n22 VJHF, 37 MNCFX => 5 FWMGM\n139 ORE => 4 NVRVD\n144 ORE => 7 JNWZP\n5 MNCFX, 7 RFSQX, 2 FWMGM, 2 VPVL, 19 CXFTF => 3 HVMC\n5 VJHF, 7 MNCFX, 9 VPVL, 37 CXFTF => 6 GNMV\n145 ORE => 6 MNCFX\n1 NVRVD => 8 CXFTF\n1 VJHF, 6 MNCFX => 4 RFSQX\n176 ORE => 6 VJHF").orePerFuel() == 180_697)
        assert(ReactionSet(input: "171 ORE => 8 CNZTR\n7 ZLQW, 3 BMBT, 9 XCVML, 26 XMNCP, 1 WPTQ, 2 MZWV, 1 RJRHP => 4 PLWSL\n114 ORE => 4 BHXH\n14 VRPVC => 6 BMBT\n6 BHXH, 18 KTJDG, 12 WPTQ, 7 PLWSL, 31 FHTLT, 37 ZDVW => 1 FUEL\n6 WPTQ, 2 BMBT, 8 ZLQW, 18 KTJDG, 1 XMNCP, 6 MZWV, 1 RJRHP => 6 FHTLT\n15 XDBXC, 2 LTCX, 1 VRPVC => 6 ZLQW\n13 WPTQ, 10 LTCX, 3 RJRHP, 14 XMNCP, 2 MZWV, 1 ZLQW => 1 ZDVW\n5 BMBT => 4 WPTQ\n189 ORE => 9 KTJDG\n1 MZWV, 17 XDBXC, 3 XCVML => 2 XMNCP\n12 VRPVC, 27 CNZTR => 2 XDBXC\n15 KTJDG, 12 BHXH => 5 XCVML\n3 BHXH, 2 VRPVC => 7 MZWV\n121 ORE => 7 VRPVC\n7 XCVML => 6 RJRHP\n5 BHXH, 4 VRPVC => 5 LTCX").orePerFuel() == 2_210_736)

        let reactionSet = ReactionSet(input: input)
        let orePerFuel = reactionSet.orePerFuel()
        print("To produce 1 FUEL for Day 14-1, we require \(orePerFuel) ORE")

        // Part 2 requirements
        assert(ReactionSet(input: "157 ORE => 5 NZVS\n165 ORE => 6 DCFZ\n44 XJWVT, 5 KHKGT, 1 QDVJ, 29 NZVS, 9 GPVTF, 48 HKGWZ => 1 FUEL\n12 HKGWZ, 1 GPVTF, 8 PSHF => 9 QDVJ\n179 ORE => 7 PSHF\n177 ORE => 5 HKGWZ\n7 DCFZ, 7 PSHF => 2 XJWVT\n165 ORE => 2 GPVTF\n3 DCFZ, 7 NZVS, 5 HKGWZ, 10 PSHF => 8 KHKGT").fuelProducedWithATrillionOre() == 82_892_753)
        assert(ReactionSet(input: "2 VPVL, 7 FWMGM, 2 CXFTF, 11 MNCFX => 1 STKFG\n17 NVRVD, 3 JNWZP => 8 VPVL\n53 STKFG, 6 MNCFX, 46 VJHF, 81 HVMC, 68 CXFTF, 25 GNMV => 1 FUEL\n22 VJHF, 37 MNCFX => 5 FWMGM\n139 ORE => 4 NVRVD\n144 ORE => 7 JNWZP\n5 MNCFX, 7 RFSQX, 2 FWMGM, 2 VPVL, 19 CXFTF => 3 HVMC\n5 VJHF, 7 MNCFX, 9 VPVL, 37 CXFTF => 6 GNMV\n145 ORE => 6 MNCFX\n1 NVRVD => 8 CXFTF\n1 VJHF, 6 MNCFX => 4 RFSQX\n176 ORE => 6 VJHF").fuelProducedWithATrillionOre() == 5_586_022)
        assert(ReactionSet(input: "171 ORE => 8 CNZTR\n7 ZLQW, 3 BMBT, 9 XCVML, 26 XMNCP, 1 WPTQ, 2 MZWV, 1 RJRHP => 4 PLWSL\n114 ORE => 4 BHXH\n14 VRPVC => 6 BMBT\n6 BHXH, 18 KTJDG, 12 WPTQ, 7 PLWSL, 31 FHTLT, 37 ZDVW => 1 FUEL\n6 WPTQ, 2 BMBT, 8 ZLQW, 18 KTJDG, 1 XMNCP, 6 MZWV, 1 RJRHP => 6 FHTLT\n15 XDBXC, 2 LTCX, 1 VRPVC => 6 ZLQW\n13 WPTQ, 10 LTCX, 3 RJRHP, 14 XMNCP, 2 MZWV, 1 ZLQW => 1 ZDVW\n5 BMBT => 4 WPTQ\n189 ORE => 9 KTJDG\n1 MZWV, 17 XDBXC, 3 XCVML => 2 XMNCP\n12 VRPVC, 27 CNZTR => 2 XDBXC\n15 KTJDG, 12 BHXH => 5 XCVML\n3 BHXH, 2 VRPVC => 7 MZWV\n121 ORE => 7 VRPVC\n7 XCVML => 6 RJRHP\n5 BHXH, 4 VRPVC => 5 LTCX").fuelProducedWithATrillionOre() == 460_664)
        print("With 1 Trillion ORE, we can produce \(reactionSet.fuelProducedWithATrillionOre()) FUEL for Day 14-2")
        // 2639016 Too Low
        // 2639037 Too Low
    }

    struct ReactionSet {
        let reactions: [String: Reaction]

        struct Reaction: CustomStringConvertible {
            struct Reactive: CustomStringConvertible {
                let type: String
                var quantity: Int

                // 5 WLMCM
                init?(from string: String) {
                    let sep = string.components(separatedBy: .whitespaces)
                    guard sep.count == 2, let type = sep.last, let quantity = sep.first.flatMap({ Int($0) }) else {
                        return nil
                    }
                    self.type = type
                    self.quantity = quantity
                }

                init(type: String, quantity: Int) {
                    self.type = type
                    self.quantity = quantity
                }

                var description: String {
                    return "\(quantity) \(type)"
                }
            }
            var reactives: [Reactive]
            var product: Reactive

            // PQXHB, 5 WLMCM => 5 XTLB
            init?(from line: String) {
                let sep = line.components(separatedBy: " => ")
                guard sep.count == 2, let reactivesString = sep.first, let product = sep.last.flatMap({ Reactive(from: $0) }) else {
                    return nil
                }
                self.reactives = reactivesString.components(separatedBy: ", ").compactMap { Reactive(from: $0) }
                self.product = product
            }

            var description: String {
                return "\(reactives) => \(product)"
            }

            func multiplied(by amount: Int) -> Reaction {
                var reaction = self
                reaction.reactives = reaction.reactives.map { Reactive(type: $0.type, quantity: $0.quantity * amount) }
                reaction.product.quantity *= amount
                return reaction
            }

            func reduce(with reactions: [String: Reaction], productsLeft: inout [String: Int]) -> Int {
                var number = 0
                for reactive in reactives {
                    var target = reactive.quantity
                    if let left = productsLeft[reactive.type], left > 0 {
                        let amount = min(target, left)
                        target -= amount
                        productsLeft[reactive.type] = left - amount
                    }
                    if target == 0 {
                        continue
                    }
                    // We find out how to produce the target
                    guard let reaction = reactions[reactive.type] else {
                        // We have no reaction here.
                        // So it's ORE
                        number += reactive.quantity
                        continue
                    }
                    // We need to know how many time we need to perform the reaction ^^
                    let times = Int((Double(target) / Double(reaction.product.quantity)).rounded(.awayFromZero))
                    // Number of extra productions
                    let extra = (times * reaction.product.quantity) - target
                    productsLeft[reaction.product.type] = extra
                    // And we consumme the reactives
                    number += reaction.multiplied(by: times).reduce(with: reactions, productsLeft: &productsLeft)
                }
                return number
            }

            func produce(with reactions: [String: Reaction], productsLeft: inout [String: Int], times: Int = 1) -> Bool {
                precondition(times > 0)
                var removed: [String: Int] = [:]
                defer {
                    for (type, quantity) in removed {
                        // We put back the wrongly removed stuff into place
                        productsLeft[type] = (productsLeft[type] ?? 0) + quantity
                    }
                }
                for reactive in reactives {
                    let required = reactive.quantity * times
                    if (productsLeft[reactive.type] ?? 0) < required {
                        guard let reaction = reactions[reactive.type] else {
                            // We have no reaction here.
                            // So it's ORE that we cannot produce
                            return false
                        }
                        // How many times we need to perform the reaction here
                        let target = required - (productsLeft[reactive.type] ?? 0)
                        let subtimes = Int((Double(target) / Double(reaction.product.quantity)).rounded(.awayFromZero))
                        if !reaction.produce(with: reactions, productsLeft: &productsLeft, times: subtimes) {
                            return false
                        }
                    }
                    assert(productsLeft[reactive.type]! >= reactive.quantity * times)
                    productsLeft[reactive.type] = productsLeft[reactive.type]! - (reactive.quantity * times)
                    removed.updateValue(reactive.quantity * times, forKey: reactive.type)
                }
                // Finally we have a production
                productsLeft[product.type] = (productsLeft[product.type] ?? 0) + (product.quantity * times)
                removed.removeAll()
                return true
            }
        }

        init(input: String) {
            var reactions = [String: Reaction]()
            for line in input.components(separatedBy: .newlines) {
                guard let reaction = Reaction(from: line) else {
                    continue
                }
                if reactions[reaction.product.type] != nil {
                    fatalError("Overriding reactions is not supported!")
                }
                reactions.updateValue(reaction, forKey: reaction.product.type)
            }
            self.reactions = reactions
        }

        func orePerFuel() -> Int {
            guard let targetReaction = reactions["FUEL"] else {
                fatalError("No FUEL to be produced ... ever :'(")
            }
            var left = [String: Int]()
            return targetReaction.reduce(with: reactions, productsLeft: &left)
        }

        func produceFuelUntilNothingLeft(left: inout [String: Int]) {
            guard let targetReaction = reactions["FUEL"] else {
                fatalError("No FUEL to be produced ... ever :'(")
            }
            // Make the first production
            let amount = Int((Double(left["ORE"] ?? 0) / Double(self.orePerFuel())).rounded(.down))
            precondition(targetReaction.produce(with: reactions, productsLeft: &left, times: amount))
            for times in [10_000_000, 1_000_000, 100_000, 10_000, 1_000, 100, 10, 1] {
                var save = left
                while targetReaction.produce(with: reactions, productsLeft: &left, times: times) {
                    save = left
                }
                left = save
            }
        }

        func fuelProducedWithATrillionOre() -> Int {
            var left = [String: Int]()
            left["ORE"] = 1_000_000_000_000
            // Need to find how much fuel we can create with the components lefts
            produceFuelUntilNothingLeft(left: &left)
            return left["FUEL"] ?? 0
        }
    }
}
