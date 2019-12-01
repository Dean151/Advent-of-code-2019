//
//  Shared.swift
//  AdventOfCode-Swift
//
//  Created by Thomas Durand on 01/12/2019.
//  Copyright © 2019 Thomas Durand. All rights reserved.
//

import Foundation

extension String {
    func breakLines() -> [String] {
        return self.components(separatedBy: .newlines)
    }
}
