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

    func isComboTrue(operands: [Int], operators: [Operator], test: Int) -> Bool {
        var str = "\(operands[0])"
        let opCount = operands.count - 1
        let applied = (0 ..< opCount).reduce(operands[0]) { lhs, oi in
            let op = operators[oi]
            let rhs = operands[oi + 1]
            str = str + "\(op)\(rhs)"
            return op.appl(lhs: lhs, rhs: rhs)
        }
        print("Trying \(str). Got: \(applied). \(applied == test ? "HIT!" : "")")
        return applied == test
    }

    func solveEquation(eq: Equation, operators: [Operator]) -> Int {
        print(eq)
        let (test, operands) = (eq.test, eq.operands)
        let opCount = operands.count - 1
        for opCombo in getCombosOf(operators: operators, length: opCount) {
            if isComboTrue(operands: operands, operators: opCombo, test: test) {
                return test
            }
        }
        return 0
    }

    func a(input: String) -> Int {
        let eqs = parseInput(input: input)
        print("Solving \(eqs.count) equations!")
        let operatorsToUse = [Operator.Add, Operator.Multiply]
        return eqs.reduce(0) { acc, eq in acc + solveEquation(eq: eq, operators: operatorsToUse) }
    }

    func b(input: String) -> Int {
        let eqs = parseInput(input: input)
        print("Solving \(eqs.count) equations!")
        let operatorsToUse = Operator.allCases
        return eqs.reduce(0) { acc, eq in acc + solveEquation(eq: eq, operators: operatorsToUse) }
    }
}
