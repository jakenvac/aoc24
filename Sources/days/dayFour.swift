typealias Pos = (Int, Int)

struct DayFour: Solver {
    let xmasDirs: [Pos] = [
        (-1, 0), // up
        (-1, 1), // up-right
        (0, 1), // right
        (1, 1), // down-right
        (1, 0), // down
        (1, -1), // down-left
        (0, -1), // left
        (-1, -1), // up-left
    ]

    let masDirs: [Pos] = [
        (-1, 1), // up-right
        (1, 1), // down-right
        (1, -1), // down-left
        (-1, -1), // up-left
    ]

    func parseInput(input: String) -> [String] {
        return input.split(separator: "\n").map { String($0) }
    }

    func isPhrase(rows: [String], target: String, pos: Pos, dir: Pos) -> Bool {
        let (row, col) = pos
        let (dr, dc) = dir

        guard (0 ..< rows.count).contains(row) && (0 ..< rows[row].count).contains(col) else {
            return false
        }

        if rows[row][col] == target[0] {
            return target.count == 1 || isPhrase(
                rows: rows,
                target: String(target.dropFirst()),
                pos: (row + dr, col + dc),
                dir: dir
            )
        }

        return false
    }

    func a(input: String) -> Int {
        let table = parseInput(input: input)
        return (0 ..< table.count).reduce(0) { acc, rI in
            acc + (0 ..< table[rI].count).reduce(0) { acc, cI in
                acc + xmasDirs
                    .count(where: { isPhrase(rows: table, target: "XMAS", pos: (rI, cI), dir: $0) })
            }
        }
    }

    func b(input: String) -> Int {
        let table = parseInput(input: input)
        let hits = (0 ..< table.count).flatMap { rI in
            (0 ..< table[rI].count).flatMap { cI in
                masDirs.compactMap {
                    isPhrase(rows: table, target: "MAS", pos: (rI, cI), dir: $0) ?
                        "\(rI + $0.0),\(cI + $0.1)" : nil
                }
            }
        }
        return Dictionary(hits.map { ($0, 1) }, uniquingKeysWith: +).count(where: { $0.value == 2 })
    }
}
