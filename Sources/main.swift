import ArgumentParser

let days: [Solver.Type] = [
    DayOne.self,
    DayTwo.self,
    DayThree.self,
    DayFour.self,
    DayFive.self,
    DaySix.self,
]

struct AOCError: Error {
    var message: String
}

enum DayPart: String, CaseIterable, ExpressibleByArgument {
    case a, b
}

struct AOC: ParsableCommand {
    @Argument(help: "The day to process (1 - 25)")
    var day: Int

    @Argument(help: "The part of the day to process (a or b)")
    var part: DayPart

    func run() throws {
        guard let input = loader(day: day) else {
            throw AOCError(message: "No input found for day \(day).")
        }

        guard (day - 1) >= 0 && (day - 1) < days.count else {
            throw AOCError(message: "No solution found for day \(day).")
        }

        let solver = days[day - 1]
        let result = solver.init().solve(part: part, input: input)

        print(result)
    }
}

AOC.main()
