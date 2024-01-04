//: [Previous](@previous)
import Foundation

struct Match {
    let row: Int
    let range: Range<Int>
    let value: Substring

    init(row: Int, range: Range<Int>, value: Substring) {
        self.row = row
        self.range = range
        self.value = value
    }

    init(row: Int, string: String, match: Regex<Substring>.Match) {
        self.row = row
        self.range = Range(uncheckedBounds: (lower: string.distance(from: string.startIndex, to: match.startIndex),
                                             upper: string.distance(from: string.startIndex, to: match.endIndex)))
        self.value = match.output
    }
}

extension Match {
    func isAdjacent(to other: Match) -> Bool {
        guard abs(self.row - other.row) <= 1 else { return false }
        let extendedRange = Range(uncheckedBounds: (lower: max(self.range.lowerBound - 1, 0),
                                                    upper: self.range.upperBound + 1))
        return extendedRange.contains(other.range)
    }
}

let inputUrl = Bundle.main.url(forResource: "input3", withExtension: "txt")
let inputData = try Data(contentsOf: inputUrl!)
let input = String(data: inputData, encoding: .utf8)!.components(separatedBy: "\n")

// part1
let runPart1 = false
if runPart1 {
    let symbolsMatches = input
        .enumerated()
        .flatMap { idx, input in
            let regex = try! Regex<Substring>("[^0-9.]")
            return input.matches(of: regex).map({ Match(row: idx, string: input, match: $0) })
        }

    let numbersMatches = input
        .enumerated()
        .flatMap { idx, input in
            let regex = try! Regex<Substring>("[0-9]+")
            return input.matches(of: regex).map({ Match(row: idx, string: input, match: $0) })
        }

    var result1 = 0
    for nMatch in numbersMatches {
        for sMatch in symbolsMatches {
            if nMatch.isAdjacent(to: sMatch) {
                result1 += Int(nMatch.value) ?? 0
                break
            }
        }
    }

    // 525911
}

// part 2
let starsMatches = input
    .enumerated()
    .flatMap { idx, input in
        let regex = try! Regex<Substring>("\\*")
        return input.matches(of: regex).map({ Match(row: idx, string: input, match: $0) })
    }

let numbersMatches = Dictionary(uniqueKeysWithValues: input
    .enumerated()
    .map { idx, input in
        let regex = try! Regex<Substring>("[0-9]+")
        return (idx, input.matches(of: regex).map({ Match(row: idx, string: input, match: $0) }))
    })

var result2 = 0
for sMatch in starsMatches {
    let numbersRowsRange = max(sMatch.row - 1, 0) ... min(sMatch.row + 1, input.count - 1)
    var partsMatches: [Match] = []
    for nRow in numbersRowsRange {
        guard let nRowMatches = numbersMatches[nRow] else { continue }
        for nMatch in nRowMatches {
            if nMatch.isAdjacent(to: sMatch) {
                partsMatches.append(nMatch)
            }
        }
    }
    if partsMatches.count == 2,
       let lValue = Int(partsMatches[0].value),
       let rValue = Int(partsMatches[1].value) {
        result2 += lValue * rValue
    }
}
// 75805607

//: [Next](@next)
