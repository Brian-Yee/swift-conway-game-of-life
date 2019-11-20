/*
Conways Game of life simulator
*/

import Foundation

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

    for i in 0...num_rows-1 {
        let east = (i - 1 + num_rows) % num_rows
        let west = (i + 1) % num_rows

        var row_neighbours = [[(Int, Int)]]()
        for j in 0...num_cols-1 {
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
        for col in row {
            if col == 0 {
                print("⚫", terminator:" ")
            } else if col == 1 {
                print("⚪", terminator:" ")
            }
        }
        print()
    }
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
    let num_rows = grid.count
    let num_cols = grid[0].count

    for i in 0...num_rows-1 {
        for j in 0...num_cols-1 {
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
             Number of equal sized rows to play game with.
         num_cols:
             Number of equal sized columns to play game with.
     */
    var grid = Array(repeating:Array(repeating:0, count:num_cols), count:num_rows)
    let neighbours = defineNeighbours(num_rows: num_rows, num_cols: num_cols)

    let initial_coords = [
      (6, 1), (6, 2), (7, 1), (7, 2),
      (6, 11), (7, 11), (8, 11),
      (5, 12), (9, 12),
      (4, 13), (10, 13), (4, 14), (10, 14),
      (7, 15),
      (5, 16), (9, 16),
      (6, 17), (7, 17), (8, 17),
      (7, 18),
      (6, 21), (6, 22), (5, 21), (5, 22), (4, 21), (4, 22),
      (3, 23), (7, 23),
      (3, 25), (7, 25), (2, 25), (8, 25),
      (4, 35), (4, 36), (5, 35), (5, 36)

      // glider
      // (0, 1), (1, 2), (2, 0), (2, 1), (2, 2)
      //
      // pulsar
      // (5, 3), (6, 3), (7, 3),
      // (3, 5), (3, 6), (3, 7),
      // (8, 5), (8, 6), (8, 7),
      // (5, 8), (6, 8), (7, 8),
      // (5, 10), (6, 10), (7, 10),
      // (5, 15), (6, 15), (7, 15),
      // (3, 11), (3, 12), (3, 13),
      // (11, 15), (12, 15), (13, 15),
      // (11, 8), (12, 8), (13, 8),
      // (11, 10), (12, 10), (13, 10),
      // (15, 11), (15, 12), (15, 13),
      // (8, 11), (8, 12), (8, 13),
      // (10, 11), (10, 12), (10, 13),
      // (10, 5), (10, 6), (10, 7),
      // (15, 5), (15, 6), (15, 7),
      // (11, 3), (12, 3), (13, 3),
      //
      // random
      // (3, 7), (3, 8), (4, 7), (4, 8),
      // (3, 10), (3, 11), (4, 10), (4, 11), (5, 12), (5, 13), (6, 12), (4, 13),
    ]
    flipCoords(grid:&grid, coords:initial_coords)

    for _ in 0...100 {
        printGrid(grid:grid)
        Thread.sleep(forTimeInterval: 0.2)
        let updates = calcUpdates(grid:grid, neighbours:neighbours)
        flipCoords(grid:&grid, coords:updates)
    }
}

func main(num_rows: Int, num_cols: Int){
    /*
     Main function responsible for execution.
     */
    conway(num_rows: num_rows, num_cols: num_cols)
}

main(num_rows: 25, num_cols: 40)
