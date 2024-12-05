struct DayTwo: Solver {
    func parseInput(input: String) -> [[Int]] {
        return input.split(separator: "\n")
            .map { l in
                l.split(separator: " ").map { Int($0)! }
            }
    }

    func assertLineSafety(line: [Int]) -> Bool {
        let safeRange = line[0] < line[1] ? -3 ... -1 : 1 ... 3
        return line
            .dropLast()
            .enumerated()
            .allSatisfy { safeRange.contains($0.element - line[$0.offset + 1]) }
    }

    func dampen(line: [Int]) -> Bool {
        if assertLineSafety(line: line) { return true }
        return (0 ... line.count - 1).contains(where: {
            assertLineSafety(
                line: Array([line.prefix(upTo: $0), line.suffix(from: $0 + 1)].joined())
            )
        })
    }

    func a(input: String) -> Int {
        return parseInput(input: input).reduce(0) { assertLineSafety(line: $1) ? $0 + 1 : $0 }
    }

    func b(input: String) -> Int {
        return parseInput(input: input).reduce(0) { dampen(line: $1) ? $0 + 1 : $0 }
    }
}
