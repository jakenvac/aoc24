protocol Solver {
    init()

    func a(input: String) -> Int
    func b(input: String) -> Int
}

extension Solver {
    func solve(part: DayPart, input: String) -> Int {
        return switch part {
        case .a: a(input: input)
        case .b: b(input: input)
        }
    }
}
