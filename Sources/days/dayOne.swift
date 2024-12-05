struct DayOne: Solver {
    let numRegex = #/\d+/#

    func parseInput(input: String) -> ([Int], [Int]) {
        let numbers = input.matches(of: numRegex)
            .map { Int($0.output)! }
        let left = numbers.enumerated()
            .compactMap { $0.offset.isMultiple(of: 2) ? $0.element : nil }.sorted()
        let right = numbers.enumerated()
            .compactMap { !$0.offset.isMultiple(of: 2) ? $0.element : nil }.sorted()

        return (left, right)
    }

    func a(input: String) -> Int {
        let (left, right) = parseInput(input: input)
        return left.enumerated().reduce(0) { $0 + abs($1.element - right[$1.offset]) }
    }

    func b(input: String) -> Int {
        let (left, right) = parseInput(input: input)
        return left.reduce(0) { acc, num in acc + num * right.count(where: { $0 == num }) }
    }
}
