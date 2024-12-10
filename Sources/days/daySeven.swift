struct DaySeven: Solver {
    struct Equation {
        let test: Int
        let operands: [Int]
    }

    func executeCombosOf(
        operators: [Operator],
        on: [Int],
        test: Int,
        cache: inout [Int: Set<Int>]
    ) -> Set<Int> {
        guard on.count > 1 else {
            return Set(on)
        }

        if let cached = cache[on.hashValue] {
            return cached
        }

        var totals: Set<Int> = Set()

        for op in operators {
            let preTotals = executeCombosOf(
                operators: operators,
                on: Array(on.dropLast()),
                test: test,
                cache: &cache
            )
            for pt in preTotals {
                if pt <= test {
                    totals.insert(op.appl(lhs: pt, rhs: on.last!))
                }
            }
        }

        cache[on.hashValue] = totals
        return totals
    }

    enum Operator {
        case Add, Multiply, Concat

        func appl(lhs: Int, rhs: Int) -> Int {
            switch self {
                case .Add:
                    return lhs + rhs
                case .Multiply:
                    return lhs * rhs
                case .Concat:
                    return Int("\(lhs)\(rhs)")!
            }
        }
    }

    func parseInput(input: String) -> [Equation] {
        let lines = input.split(separator: "\n")
        return lines.map { line in
            let parts = line.split(separator: ":")
            let (test, opStr) = (Int(parts[0])!, parts[1])
            let ops = opStr.split(separator: " ").map { Int($0)! }
            return Equation(
                test: test,
                operands: ops
            )
        }
    }

    func solveEquation(eq: Equation, operators: [Operator]) -> Int {
        let (test, operands) = (eq.test, eq.operands)
        var cache = [Int: Set<Int>]()
        let combos = executeCombosOf(
            operators: operators,
            on: operands,
            test: test,
            cache: &cache
        )
        if combos.contains(test) {
            return test
        }
        return 0
    }

    func a(input: String) -> Int {
        let eqs = parseInput(input: input)
        let operatorsToUse = [Operator.Add, Operator.Multiply]
        return eqs.reduce(0) { acc, eq in acc + solveEquation(eq: eq, operators: operatorsToUse) }
    }

    func b(input: String) -> Int {
        let eqs = parseInput(input: input)
        let operatorsToUse = [Operator.Add, Operator.Multiply, Operator.Concat]
        return eqs.reduce(0) { acc, eq in acc + solveEquation(eq: eq, operators: operatorsToUse) }
    }
}
