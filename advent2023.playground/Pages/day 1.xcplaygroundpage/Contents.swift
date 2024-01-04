//: [Previous](@previous)
import Foundation

let inputUrl = Bundle.main.url(forResource: "input1", withExtension: "txt")
let inputData = try Data(contentsOf: inputUrl!)
let input = String(data: inputData, encoding: .utf8)!.components(separatedBy: "\n")

let spelledNumbers = [
    "one": "1",
    "two": "2",
    "three": "3",
    "four": "4",
    "five": "5",
    "six": "6",
    "seven": "7",
    "eight": "8",
    "nine": "9",
    "1": "1",
    "2": "2",
    "3": "3",
    "4": "4",
    "5": "5",
    "6": "6",
    "7": "7",
    "8": "8",
    "9": "9",
]

let reversedSpelledNumbers = Dictionary(uniqueKeysWithValues: spelledNumbers.map { key, value in
    return (String(key.reversed()), value)
})

let numbers = input
    .map { original in
        let run: ([String: String], String) -> String = { replacementsDict, input in
            var retval = input
            var ranges: [String: Range<String.Index>] = [:]
            replacementsDict.forEach { (key: String, value: String) in
                if let range = retval.firstRange(of: key) {
                    ranges[key] = range
                }
            }

            if let info = ranges.min(by: { $0.value.lowerBound < $1.value.lowerBound }),
               let replacementString = replacementsDict[info.key] {
                retval = retval.replacing(info.key,
                                          with: replacementString,
                                          subrange: info.value,
                                          maxReplacements: 1)
            }

            return retval
        }

        var result = run(spelledNumbers, original)
        return String(run(reversedSpelledNumbers, String(result.reversed())).reversed())
    }
    .map { $0.components(separatedBy: CharacterSet.decimalDigits.inverted).joined() }

let final = numbers.compactMap { numberString -> Int? in
    guard !numberString.isEmpty,
          let firstChar = numberString.first,
          let lastChar = numberString.last
    else { return nil }
    return Int("\(firstChar)\(lastChar)") ?? nil
}

var result2 = final.reduce(0, +)

//: [Next](@next)
