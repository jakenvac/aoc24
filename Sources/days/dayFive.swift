struct DayFive: Solver {
    let ruleRegex = #/^(\d{2})\|(\d{2})$/#.anchorsMatchLineEndings()
    let pagesRegex = #/^(\d{2},)+\d{2}$/#.anchorsMatchLineEndings()

    func parseRules(input: String) -> [Int: [Int]] {
        return Dictionary(
            input.matches(of: ruleRegex).map {
                (Int($0.output.1)!, [Int($0.output.2)!])
            },
            uniquingKeysWith: { $0 + $1 }
        )
    }

    func parsePageLists(input: String) -> [[Int]] {
        return input.matches(of: pagesRegex).map {
            $0.output.0.split(separator: ",").map { Int($0)! }
        }
    }

    func sortList(list: [Int], rules: [Int: [Int]]) -> [Int] {
        return list.sorted(by: { (rules[$0] ?? []).contains($1) })
    }

    func isSorted(list: [Int], rules: [Int: [Int]]) -> Bool {
        return list == sortList(list: list, rules: rules)
    }

    // Part 1
    func a(input: String) -> Int {
        let rules = parseRules(input: input)
        return parsePageLists(input: input).reduce(0) {
            isSorted(list: $1, rules: rules) ? $0 + $1[($1.count) / 2] : $0
        }
    }

    // Part 2
    func b(input: String) -> Int {
        let rules = parseRules(input: input)
        return parsePageLists(input: input)
            .reduce(0) { acc, list in
                let s = sortList(list: list, rules: rules)
                return list == s ? acc : acc + s[s.count / 2]
            }
    }
}
