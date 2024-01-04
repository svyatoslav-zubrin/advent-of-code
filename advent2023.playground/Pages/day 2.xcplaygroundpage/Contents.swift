//: [Previous](@previous)

import Foundation

struct CubesSet {
    let red: Int?
    let blue: Int?
    let green: Int?

    init(red: Int, green: Int, blue: Int) {
        self.red = red
        self.green = green
        self.blue = blue
    }

    init(string: String) {
        var red: Int? = nil
        var green: Int? = nil
        var blue: Int? = nil

        // e.g. "3 blue, 4 red"
        let colorPairs = string
            .components(separatedBy: ", ")
            .compactMap { colorString -> (String, Int)? in
                let pair = colorString.components(separatedBy: " ")
                guard pair.count == 2,
                      let value = Int(pair[0]),
                      ["red", "green", "blue"].contains(pair[1])
                else { return nil }
                return (pair[1], value)
            }

        for pair in colorPairs {
            switch pair.0 {
            case "red": red = pair.1
            case "green": green = pair.1
            case "blue": blue = pair.1
            default: continue
            }
        }

        self.red = red
        self.green = green
        self.blue = blue
    }

    func isPossible(with limits: CubesSet) -> Bool {
        guard let limitRed = limits.red,
              let limitGreen = limits.green,
              let limitBlue = limits.blue
        else { fatalError("Limits for all colors must be set") }
        return self.red ?? 0 <= limitRed
            && self.green ?? 0 <= limitGreen
            && self.blue ?? 0 <= limitBlue
    }

    var power: Int {
        guard let r = red, let g = green, let b = blue else { return 0 }
        return r * g * b
    }
}

class Game {
    let id: Int
    let sets: [CubesSet]

    init?(string: String) {
        guard !string.isEmpty else { return nil }
        let parts = string.components(separatedBy: ":")

        guard parts.count == 2 else { return nil }

        // Game
        let gamePrefix = "Game "
        guard parts[0].hasPrefix(gamePrefix),
              let id = Int(parts[0].suffix(from: gamePrefix.endIndex))
        else { return nil }

        self.id = id

        // Sets
        self.sets = parts[1]
            .components(separatedBy: ";")
            .map { CubesSet(string: $0.trimmingCharacters(in: .whitespaces)) }
    }

    func isPossible(with limits: CubesSet) -> Bool {
        return sets.allSatisfy { $0.isPossible(with: limits) }
    }

    var minSet: CubesSet {
        let red = sets.map({ $0.red ?? 0 }).max() ?? 0
        let green = sets.map({ $0.green ?? 0 }).max() ?? 0
        let blue = sets.map({ $0.blue ?? 0 }).max() ?? 0
        return .init(red: red, green: green, blue: blue)
    }
}

// Solution
let inputUrl = Bundle.main.url(forResource: "input2", withExtension: "txt")
let inputData = try Data(contentsOf: inputUrl!)
let games = String(data: inputData, encoding: .utf8)!
    .components(separatedBy: "\n")
    .compactMap { Game(string: $0) }

let limits = CubesSet(red: 12, green: 13, blue: 14)

let result1 = games
    .filter { $0.isPossible(with: limits) }
    .map { $0.id }
    .reduce(0, +)
print(result1)

let result2 = games
    .map { $0.minSet.power }
    .reduce(0, +)

//: [Next](@next)
