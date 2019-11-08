/*
Conways Game of life simulator
*/

func defineNeighbours(num_rows: Int, num_cols: Int) -> [[[(Int, Int)]]] {
    /*
     Define neighbours at for every cell on a grid.

     Neighbourhood is visualized below

     . . . . . o o o . .
     . . . . . o x o . .
     p p . . . o o o . p
     r p . . . . . . . p
     p p . . . . . . . p

     where `o` correponds to the neighbours of `x` and `p` correponds to the neighbours
     of`r. The case of cell `r` is given to visualize the effect of Periodic Boundary
     conditions.

     Arguments:
         num_rows
             Number of rows to calculate neighbours for.
         num_cols
             Number of columns to calculate neighbours for.

     Returns:
        neighbours
             Adjacent neighbours of every cell arranged in a 2d array.
     */
    var neighbours = [[[(Int, Int)]]]()

    for i in 0...num_rows {
        let east = (i - 1 + num_rows) % num_rows
        let west = (i + 1) % num_rows

        var row_neighbours = [[(Int, Int)]]()
        for j in 0...num_cols {
            let north = (j - 1 + num_cols) % num_cols
            let south = (j + 1) % num_cols

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
    /*
     Flips specific boolean integers on a grid.

     Arguments:
         grid
             Array of boolean integer values.
         coords
             Coordinates of array elements to be flipped.
     */
    for (i, j) in coords {
        grid[i][j] = 1 - grid[i][j]
    }
}

func printGrid(grid: [[Int]]){
    /*
     Pretty print grid to stdout.

     Arguments:
         grid
             Array of boolean integer values.
     */
    for row in grid {
        print(row)
    }
    print()
}

func calcUpdates(grid: [[Int]], neighbours: [[[(Int, Int)]]]) -> [(Int, Int)]{
    /*
     Calculates cells that need to be updated according to Conway's Game of Life rules.


     Arguments:
         grid
             Array of boolean integer values.
         neighbours
             Neighbours according to Conway's Game of Life.

     Returns:
         updates
             Cells which according to Conways Game of Life rules would be updated at the
             next iteration.
     */
    var updates = [(Int, Int)]()
    let num_rows = grid.count-1
    let num_cols = num_rows

    for i in 0...num_rows {
        for j in 0...num_cols {
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

func conway(num_rows: Int, num_cols: Int) {
    /*
     Simulates one game of Conway's Game of Life

     Arguments:
         num_rows
             Number of equal sized rows to play game with.
         num_cols:
             Number of equal sized columns to play game with.
     */

    // TODO: add an assert that heigh and width must be greater than or equal to 1

    var grid = Array(repeating:Array(repeating:0, count:num_cols), count:num_rows)
    let neighbours = defineNeighbours(num_rows: num_rows, num_cols: num_cols)

    let initial_coords = [(0, 1), (1, 2), (2, 0), (2, 1), (2, 2)]
    flipCoords(grid:&grid, coords:initial_coords)

    for _ in 0...10 {
        printGrid(grid:grid)
        let updates = calcUpdates(grid:grid, neighbours:neighbours)
        flipCoords(grid:&grid, coords:updates)
    }


}

conway(num_rows: 10, num_cols: 10)
