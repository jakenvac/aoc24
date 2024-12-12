func printDisk(_ disk: [Int?]) {
    print(disk.reduce("") { acc, item in
        if let item = item {
            return acc + String(item)
        } else {
            return acc + "."
        }
    })
}

struct DayNine: Solver {
    func parseInput(_ input: String) -> [Int?] {
        return input.replacing("\n", with: "").enumerated().flatMap { cell in
            let block = Int(String(cell.element))!
            let index = cell.offset
            return [Int?](repeating: index.isMultiple(of: 2) ? index / 2 : nil, count: block)
        }
    }

    func sortBy(block disk: [Int?]) -> [Int?] {
        var toSort = Array(disk.compactMap { $0 })
        let count = toSort.count
        return Array(disk.map { $0 == nil ? toSort.popLast() : $0 }[0 ..< count])
    }

    func findEmptySpace(_ disk: [Int?], before: Int, count: Int) -> Int? {
        guard before < disk.count && count <= before else {
            return nil
        }

        var nils = 0
        for i in 0 ..< before {
            if disk[i] == nil {
                nils += 1
                if nils == count {
                    return i - count + 1
                }
            } else {
                nils = 0
            }
        }

        return nil
    }

    func sortBy(file disk: [Int?]) -> [Int?] {
        let files = disk.enumerated().reduce(into: [Int: (index: Int, size: Int)]()) { f, block in
            if let file = block.element {
                let cur = f[file, default: (index: Int.max, size: 0)]
                let newIndex = min(cur.index, block.offset)
                let size = cur.size + 1
                f[file] = (index: newIndex, size: size)
            }
        }

        var sortedDisk = disk
        for (id, (fi, size)) in files.sorted(by: { $0.key > $1.key }) {
            guard let freeSpace = findEmptySpace(sortedDisk, before: fi, count: size) else {
                continue
            }

            for b in freeSpace ..< (freeSpace + size) {
                sortedDisk[b] = id
            }

            for f in fi ..< (fi + size) {
                sortedDisk[f] = nil
            }
        }
        return sortedDisk
    }

    func createCheckSum(_ disk: [Int?]) -> Int {
        return disk.enumerated()
            .reduce(0) { $1.element == nil ? $0 : $0 + ($1.element! * $1.offset) }
    }

    func a(input: String) -> Int {
        return createCheckSum(sortBy(block: parseInput(input)))
    }

    func b(input: String) -> Int {
        return createCheckSum(sortBy(file: parseInput(input)))
    }
}
