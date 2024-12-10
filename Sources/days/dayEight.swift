struct DayEight: Solver {
    struct Map {
        let width, height: Int
        let antennas: [String: Set<Vec2>]
    }

    struct Vec2: Hashable {
        let x, y: Int

        static func + (_ lhs: Vec2, _ rhs: Vec2) -> Vec2 {
            return Vec2(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
        }

        static func - (_ lhs: Vec2, _ rhs: Vec2) -> Vec2 {
            return Vec2(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
        }

        static func * (_ lhs: Vec2, _ rhs: Int) -> Vec2 {
            return Vec2(x: lhs.x * rhs, y: lhs.y * rhs)
        }

        static func == (_ lhs: Vec2, _ rhs: Vec2) -> Bool {
            return lhs.x == rhs.x && lhs.y == rhs.y
        }

        var length: Int {
            return Int(Double(x * x + y * y).squareRoot())
        }
    }

    func parseInput(input: String) -> Map {
        let lines = input.split(separator: "\n")
        var antennas = [String: Set<Vec2>]()
        for (y, line) in lines.enumerated() {
            for (x, char) in line.enumerated() {
                let freq = String(char)
                if freq != "." {
                    antennas[freq, default: Set()].insert(Vec2(x: x, y: y))
                }
            }
        }
        return Map(width: lines[0].count, height: lines.count, antennas: antennas)
    }

    func getAntinodes(byDistance: Set<Vec2>) -> Set<Vec2> {
        var antis = Set<Vec2>()
        for a in byDistance {
            for b in byDistance {
                guard a != b else { continue }
                let distance = a - b
                antis.formUnion([a + distance, b - distance])
            }
        }
        return antis
    }

    func getAntinodes(byLine: Set<Vec2>) -> Set<Vec2> {
        if byLine.count <= 1 {
            return Set()
        }
        var antis = Set<Vec2>(byLine)
        for a in byLine {
            for b in byLine {
                guard a != b else { continue }
                let distance = a - b
                // dirty hack, the extras get filtered out
                for i in 0 ... 100 {
                    antis.formUnion([a + distance * i, b - distance * i])
                }
            }
        }
        return antis
    }

    func getAntinodes(forMap map: Map, byDistance: Bool) -> Set<Vec2> {
        var antis = Set<Vec2>()
        for (_, value) in map.antennas {
            if byDistance {
                antis.formUnion(getAntinodes(byDistance: value))
            } else {
                antis.formUnion(getAntinodes(byLine: value))
            }
        }
        let widthRange = (0 ..< map.width)
        let heightRange = (0 ..< map.height)
        return antis.filter {
            widthRange.contains($0.x) && heightRange.contains($0.y)
        }
    }

    func a(input: String) -> Int {
        let antennas = parseInput(input: input)
        return getAntinodes(forMap: antennas, byDistance: true).count
    }

    func b(input: String) -> Int {
        let antennas = parseInput(input: input)
        return getAntinodes(forMap: antennas, byDistance: false).count
    }
}
