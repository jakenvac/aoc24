struct DayThree: Solver {
    let mulRegex = #/mul\((\d+),(\d+)\)/#
    let dontRegex = #/don't\(\).*?((do\(\))|$)/#.dotMatchesNewlines()

    func excludeMuls(input: String) -> String {
        return input.replacing(dontRegex, with: "")
    }

    func solveMuls(input: String) -> Int {
        return input.matches(of: mulRegex).reduce(0) {
            $0 + Int($1.output.1)! * Int($1.output.2)!
        }
    }

    func a(input: String) -> Int {
        return solveMuls(input: input)
    }

    func b(input: String) -> Int {
        return solveMuls(input: excludeMuls(input: input))
    }
}
