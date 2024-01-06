//: [Previous](@previous)

import Foundation

struct Card {
    typealias ID = Int

    let id: ID
    let myWinNumbersCount: Int

    private let winningNumbers: Set<Int>
    private let myNumbers: Set<Int>

    init?(string: String) {
        let parts = string.components(separatedBy: ":")
        guard parts.count == 2 else { return nil }

        // id
        let cardPrefix = "Card"
        guard parts[0].hasPrefix(cardPrefix),
              let id = Int(parts[0].suffix(from: cardPrefix.endIndex).trimmingCharacters(in: .whitespaces))
        else { return nil }
        self.id = id

        // numbers
        let numbersParts = parts[1].components(separatedBy: " | ")
        guard numbersParts.count == 2 else { return nil }
        self.winningNumbers = Set(
            numbersParts[0]
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .components(separatedBy: " ")
                .compactMap({ Int($0.trimmingCharacters(in: .whitespacesAndNewlines)) })
        )
        self.myNumbers = Set(
            numbersParts[1]
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .components(separatedBy: " ")
                .compactMap({ Int($0.trimmingCharacters(in: .whitespacesAndNewlines)) })
        )
        self.myWinNumbersCount = myNumbers.intersection(winningNumbers).count
    }

    var winPower: Int {
        guard myWinNumbersCount > 0 else { return 0 }
        return Int(pow(Double(2), Double(myWinNumbersCount - 1)))
    }
}

let inputUrl = Bundle.main.url(forResource: "input4", withExtension: "txt")
let inputData = try Data(contentsOf: inputUrl!)
let input = String(data: inputData, encoding: .utf8)!.components(separatedBy: "\n")

let cards = input.compactMap({ Card(string: $0) })
let result1 = cards.map({ $0.winPower }).reduce(0, +)
print("result1: \(result1)")

var result2: Int = 0
var cache = [Card.ID: Int]()

let addCardAndProceed: (Card) -> (Int) = { card in
    if let cachedCount = cache[card.id] {
        result2 += cachedCount
        return cachedCount
    }

    var localCount = 1

    defer {
        cache[card.id] = localCount
    }

    guard card.myWinNumbersCount > 0 else {
        result2 += 1
        return localCount
    }

    let lowerCardIdx = min(cards.count - 1, card.id)
    let upperCardIdx = min(cards.count - 1, card.id + card.myWinNumbersCount - 1)

    for idx in lowerCardIdx ... upperCardIdx {
        guard cards.indices.contains(idx) else { break }
        localCount += addCardAndProceed(cards[idx])
    }

    result2 += 1

    return localCount
}

cards.forEach { _ = addCardAndProceed($0) }

print("result2: \(result2)")

//: [Next](@next)
