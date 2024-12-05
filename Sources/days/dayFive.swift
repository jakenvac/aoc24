struct DayFive: Solver {
    let ruleRegex = #/^(\d{2})\|(\d{2})$/#.anchorsMatchLineEndings()
    let pagesRegex = #/^(\d{2},)+\d{2}$/#.anchorsMatchLineEndings()

    func parseRules(input: String) -> [Int: [Int]] {
        let rules = input.matches(of: ruleRegex).map { (Int($0.output.1)!, [Int($0.output.2)!]) }
        return Dictionary(
            rules,
            uniquingKeysWith: { $0 + $1 }
        )
    }

    func parsePageLists(input: String) -> [[Int]] {
        return input.matches(of: pagesRegex).map {
            $0.output.0.split(separator: ",").map { Int($0)! }
        }
    }

    func isListValid(list: [Int], rules: [Int: [Int]]) -> Bool {
        return (1 ..< list.count).allSatisfy { pI in
            guard let preceeds = rules[list[pI]] else {
                return true
            }
            let preceeding = list[0 ..< pI]
            return Set(preceeds).intersection(Set(preceeding)).isEmpty
        }
    }

    func swapPages(b: Int, rule: [Int]?) -> Bool {
        guard let rule = rule else {
            return true
        }
        return rule.contains(b)
    }

    func a(input: String) -> Int {
        let rules = parseRules(input: input)
        let pagesLists = parsePageLists(input: input)
        return pagesLists.reduce(0) { acc, list in
            isListValid(list: list, rules: rules) ? acc + list[(list.count) / 2] : acc
        }
    }

    func b(input: String) -> Int {
        let rules = parseRules(input: input)
        let pagesLists = parsePageLists(input: input)
        let brokenLists = pagesLists.filter { !isListValid(list: $0, rules: rules) }

        return brokenLists
            .map { list in list.sorted(by: { a, b in swapPages(b: b, rule: rules[a]) }) }
            .reduce(0) { acc, sorted in
                acc + sorted[sorted.count / 2]
            }
    }
}
