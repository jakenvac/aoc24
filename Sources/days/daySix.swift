struct DaySix: Solver {
    enum Direction: CaseIterable {
        case north, east, south, west
        func next() -> Direction {
            let i = Direction.allCases.firstIndex(of: self)!
            let ni = (i + 1) % Direction.allCases.count
            return Direction.allCases[ni]
        }
    }

    let directionMods: [Direction: Point] = [
        .north: Point(x: 0, y: -1),
        .east: Point(x: 1, y: 0),
        .south: Point(x: 0, y: 1),
        .west: Point(x: -1, y: 0),
    ]

    struct Point: Hashable, CustomStringConvertible {
        var x: Int, y: Int
        var description: String {
            // match nvim
            return "[\(y + 1):\(x + 1)]"
            // return "(x: \(x+1), y:\(y+1))"
        }

        static func + (l: Point, r: Point) -> Point {
            return Point(x: l.x + r.x, y: l.y + r.y)
        }
    }

    enum PointType {
        case start(p: Point)
        case obstacle(p: Point)
        var point: Point {
            switch self {
                case let .start(p), let .obstacle(p): return p
            }
        }
    }

    struct Movement: CustomStringConvertible, Hashable {
        let point: Point
        let direction: Direction
        var description: String {
            return "\(point):\(direction)"
        }
    }

    struct Map {
        let width, height: Int
        let obstacles: Set<Point>
    }

    func parseMap(input: String) -> (Point, Map) {
        let lines = input.split(separator: "\n").map { String($0) }
        let points: [PointType] = (0 ..< lines.count).flatMap { y in
            (0 ..< lines[y].count).compactMap { x in
                switch lines[y][x] {
                    case "#": return .obstacle(p: Point(x: x, y: y))
                    case "^": return .start(p: Point(x: x, y: y))
                    default: return nil
                }
            }
        }
        let position = points.first {
            switch $0 {
                case .start: true
                case .obstacle: false
            }
        }!
        let obstacles = points.filter {
            switch $0 {
                case .start: false
                case .obstacle: true
            }
        }
        return (
            position.point,
            Map(
                width: lines[0].count,
                height: lines.count,
                obstacles: Set(obstacles.map { $0.point })
            )
        )
    }

    func findNorthObstacle(map: Map, from: Point) -> Point? {
        return map.obstacles
            .compactMap {
                $0.y < from.y && $0.x == from.x ? $0 : nil
            }.sorted(by: { $0.y < $1.y }).last
    }

    func findSouthObstacle(map: Map, from: Point) -> Point? {
        return map.obstacles
            .compactMap {
                $0.y > from.y && $0.x == from.x ? $0 : nil
            }.sorted(by: { $0.y < $1.y }).first
    }

    func findEastObstacle(map: Map, from: Point) -> Point? {
        return map.obstacles
            .compactMap {
                $0.y == from.y && $0.x > from.x ? $0 : nil
            }.sorted(by: { $0.x < $1.x }).first
    }

    func findWestObstacle(map: Map, from: Point) -> Point? {
        return map.obstacles
            .compactMap {
                $0.y == from.y && $0.x < from.x ? $0 : nil
            }.sorted(by: { $0.x < $1.x }).last
    }

    func positionsBetween(direction: Direction, from: Point, to: Point) -> [Point] {
        return switch direction {
            case .north: ((to.y + 1) ..< from.y).map {
                    Point(x: from.x, y: $0)
                }.reversed()
            case .east: ((from.x + 1) ..< to.x).map {
                    Point(x: $0, y: from.y)
                }
            case .south: ((from.y + 1) ..< to.y).map {
                    Point(x: from.x, y: $0)
                }
            case .west: ((to.x + 1) ..< from.x).map {
                    Point(x: $0, y: from.y)
                }.reversed()
        }
    }

    func getNearestObstacle(map: Map, from: Point, direction: Direction) -> Point? {
        return switch direction {
            case .north: findNorthObstacle(map: map, from: from)
            case .east: findEastObstacle(map: map, from: from)
            case .south: findSouthObstacle(map: map, from: from)
            case .west: findWestObstacle(map: map, from: from)
        }
    }

    func walkPath(map: Map, direction: Direction, positions: [Movement]) -> [Movement]? {
        let from = positions.last!.point
        // print("Moving \(positions.last!)")
        let nextObst = getNearestObstacle(map: map, from: from, direction: direction)

        if let nextObst = nextObst {
            let nextPositions = positionsBetween(direction: direction, from: from, to: nextObst)
                .map { Movement(point: $0, direction: direction) }

            let repeats = Set(nextPositions).intersection(Set(positions))
            if repeats.count > 0 {
                // print("Hit a loop at \(from), already visited: \(repeats)")
                // return positions + nextPositions
                return nil
            }

            return walkPath(
                map: map,
                direction: direction.next(),
                positions: positions + nextPositions
            )
        }

        let edgePos: Point = switch direction {
            case .north: Point(x: from.x, y: -1)
            case .east: Point(x: map.width, y: from.y)
            case .south: Point(x: from.x, y: map.height)
            case .west: Point(x: -1, y: from.y)
        }

        let next = positionsBetween(direction: direction, from: from, to: edgePos)
            .map { Movement(point: $0, direction: direction) }

        // print("Exited: \(next.last ?? positions.last!)")

        return positions + next
    }

    func a(input: String) -> Int {
        let (start, map) = parseMap(input: input)
        return Set(walkPath(
            map: map,
            direction: .north,
            positions: [Movement(point: start, direction: .north)]
        )!.map { $0.point }).count
    }

    func b(input: String) -> Int {
        let (start, map) = parseMap(input: input)
        let path = walkPath(
            map: map,
            direction: .north,
            positions: [Movement(point: start, direction: .north)]
        )!

        return (0 ..< path.count).reduce(0) { acc, i in
            let last = path[i]
            let forward = last.point + directionMods[last.direction]!
            let isEmpty = !map.obstacles.contains(forward)
            let currentDir = isEmpty ? last.direction : last.direction.next()
            let target = last.point + directionMods[currentDir]!
        
            let obstacles = map.obstacles.union([target])

            let newMap = Map(width: map.width, height: map.height, obstacles: obstacles)
             
            if target == start {
                // print("Can't block the guard")
                return acc
            }

            if !(0 ..< map.width).contains(target.x) || !(0 ..< map.height).contains(target.y) {
                // print(target)
                // print("Can't place out of bounds")
                return acc
            }

            let current = Array(path[0 ... i])

            if current.contains(where: { m in m.point == target }) {
                // print("Can't block where we've already been!, \(target)")
                return acc
            }

            let newPath = walkPath(
                map: newMap,
                direction: currentDir.next(),
                positions: current
            )

            if let _ = newPath {
                return acc
            }

            return acc + 1
        }
    }
}
