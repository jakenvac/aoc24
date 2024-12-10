struct DaySeven: Solver {
    struct Equation: CustomStringConvertible {
        let test: Int
        let operands: [Int]

        var description: String {
            return "\(test): \(operands.map { "\($0) " }) ======="
        }
    }

    func getCombosOf(operators: [Operator], length: Int) -> [[Operator]] {
        guard length > 0 else {
            return [[]]
        }

        guard length > 1 else {
            return operators.map { [$0] }
        }

        var combos: [[Operator]] = []

        for op in operators {
            let preCombos = getCombosOf(operators: operators, length: length - 1)
            for pc in preCombos {
                combos.append(pc + [op])
            }
        }

        return combos
    }

    // TODO: maybe pass in the test here and exit early if its found
    func executeCombosOf(operators: [Operator], on: [Int]) -> [Int] {
        guard on.count > 1 else {
            return on
        }

        // guard on.count > 2 else {
        //     return operators.map { $0.appl(lhs: on[0], rhs: on[1]) }
        // }

        var totals: [Int] = []

        for op in operators {
            let preTotals = executeCombosOf(operators: operators, on: Array(on.dropLast()))
            for pt in preTotals {
                totals.append(op.appl(lhs: pt, rhs: on.last!))
            }
        }

        return totals
    }

    enum Operator: CaseIterable, CustomStringConvertible {
        case Add, Multiply, Concat

        static var count: Int {
            return Operator.allCases.count
        }

        var description: String {
            return switch self {
                case .Add: "\u{1B}[32m + \u{1B}[0m"
                case .Multiply: "\u{1B}[31m * \u{1b}[0m"
                case .Concat: "\u{1B}[33m || \u{1B}[0m"
            }
        }

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
        let combos = executeCombosOf(operators: operators, on: operands)
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
        let operatorsToUse = Operator.allCases
        return eqs.reduce(0) { acc, eq in acc + solveEquation(eq: eq, operators: operatorsToUse) }
    }
}
