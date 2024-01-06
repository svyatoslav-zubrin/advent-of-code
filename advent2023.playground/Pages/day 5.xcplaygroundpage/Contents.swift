//: [Previous](@previous)

import Foundation

struct MapItem {
    let originRange: ClosedRange<Int>

    private let origin: Int
    private let destination: Int
    private let length: Int

    init?(_ input: String) {
        let nums = input
            .components(separatedBy: " ")
            .compactMap({ Int($0.trimmingCharacters(in: .whitespacesAndNewlines)) })
        guard nums.count == 3 else { return nil }
        self.destination = nums[0]
        self.origin = nums[1]
        self.length = nums[2]
        self.originRange = origin...(origin + length)
    }

    func destination(for origin: Int) -> Int {
        let shift = origin - self.origin
        return destination + shift
    }
}

struct Map {
    let name: String
    let items: [MapItem]

    init(_ input: [String]) {
        self.name = input[0]
        self.items = input
            .dropFirst()
            .compactMap({ MapItem($0) })
//            .sorted(by: { $0.origin > $1.origin })
    }

    func destination(for origin: Int) -> Int {
        guard let item = items.first(where: { $0.originRange.contains(origin) }) else { return origin }
        return item.destination(for: origin)
    }
}

// read input
let inputUrl = Bundle.main.url(forResource: "input5", withExtension: "txt")
let inputData = try Data(contentsOf: inputUrl!)
let input = String(data: inputData, encoding: .utf8)!.components(separatedBy: "\n")

// parse input
// ..seeds
let seeds = input[0]
    .components(separatedBy: " ")
    .dropFirst()
    .compactMap { Int($0.trimmingCharacters(in: .whitespacesAndNewlines)) }

// ..maps
var mapsInput = Array(input.dropFirst(2))
var inputGrouped: [[String]] = []

for i in 0..<7 {
    if let emptyLineIndex = mapsInput.firstIndex(where: { $0.isEmpty }) {
        let group = mapsInput[0..<emptyLineIndex]
        inputGrouped.append(Array(group))
        mapsInput = Array(mapsInput[(emptyLineIndex + 1)...])
    }
}

let maps = inputGrouped.map { Map($0) }

let locations = seeds.map { seed in
    var retval: Int = seed
    for map in maps {
        retval = map.destination(for: retval)
    }
    return retval
}

print(locations.min())

//: [Next](@next)
