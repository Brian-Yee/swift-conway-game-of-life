/*
Conways Game of life simulator
- write everything as one dimensional struct ro array
*/

func defineNeighbours(grid: [[Int]], height: Int, width: Int) -> [[[(Int, Int)]]] {
    var neighbours = [[[(Int, Int)]]]()

    for i in 0...height-1 {
        let east = (i - 1 + width) % width
        let west = (i + 1) % width

        var row_neighbours = [[(Int, Int)]]()
        for j in 0...width-1 {
            let north = (j - 1 + height) % height
            let south = (j + 1) % height

            let cell_neighbours = [
                (east, north),
                (east, j),
                (east, south),
                (i, north),
                (i, south),
                (west, north),
                (west, j),
                (west, south),
            ]
            row_neighbours.append(cell_neighbours)
        }
        neighbours.append(row_neighbours)
    }

    return neighbours
}

func flipCoords(grid: inout [[Int]], coords: [(Int, Int)]) {
    for (i, j) in coords {
        grid[i][j] = 1 - grid[i][j]
    }
}

func printGrid(grid: [[Int]]){
    for row in grid {
        print(row)
    }
    print()
}

func calcUpdates(grid: [[Int]], neighbours: [[[(Int, Int)]]]) -> [(Int, Int)]{
    var updates = [(Int, Int)]()

    for i in 0...grid.count-1 {
        for j in 0...grid[i].count-1 {
            var alive_cells = 0;
            for (p, q) in neighbours[i][j] {
                alive_cells += grid[p][q]
            }

            let birth = (grid[i][j] == 0 && alive_cells == 3)
            let death = (grid[i][j] == 1 && alive_cells != 2 && alive_cells != 3)
            if birth || death {
                updates.append((i, j))
            }
        }
    }

    return updates
}

func conway (height: Int, width: Int) {
    var grid = Array(repeating:Array(repeating:0, count:width), count:height)
    let neighbours = defineNeighbours(grid:grid, height:height, width:width)

    let coords = [(0, 1), (1, 2), (2, 0), (2, 1), (2, 2)]
    flipCoords(grid:&grid, coords:coords)

    for _ in 0...100 {
        printGrid(grid:grid)
        let updates = calcUpdates(grid:grid, neighbours:neighbours)
        flipCoords(grid:&grid, coords:updates)
    }


}

conway(height: 10, width: 10)
