package main

import (
	"fmt"
	"os"
)

type Point struct {
    x, y int
}

func isValid(x, y, currentHeight int, grid [][]int, visited map[Point]bool) bool {
    rows, cols := len(grid), len(grid[0])
    return x >= 0 && x < rows && y >= 0 && y < cols && !visited[Point{x, y}] && grid[x][y] == currentHeight+1
}

func findTrails(x, y int, grid [][]int, visited map[Point]bool) int {
    if grid[x][y] == 9 {
        return 1 
    }

    visited[Point{x, y}] = true
    totalTrails := 0


    directions := []Point{{-1, 0}, {1, 0}, {0, -1}, {0, 1}}
    for _, dir := range directions {
        newX, newY := x+dir.x, y+dir.y
        if isValid(newX, newY, grid[x][y], grid, visited) {
            totalTrails += findTrails(newX, newY, grid, visited)
        }
    }

    visited[Point{x, y}] = false 
    return totalTrails
}

func calculateRatings(grid [][]int) int {
    rows, cols := len(grid), len(grid[0])
    totalRating := 0

    for i := 0; i < rows; i++ {
        for j := 0; j < cols; j++ {
            if grid[i][j] == 0 {
                visited := make(map[Point]bool)
                totalRating += findTrails(i, j, grid, visited)
            }
        }
    }

    return totalRating
}

func main() {
	
	var grid [][]int
	file, err := os.ReadFile("test.txt")
	if err != nil {
		fmt.Printf("Error reading file: %v\n", err)
		return
	}

	row := []int{}
	for _, b := range file {
		if b == '\n' {
			grid = append(grid, row)
			row = []int{}
			continue
		}
		row = append(row, int(b-'0'))
	}
	if len(row) > 0 {
		grid = append(grid, row)
	}

	fmt.Println("Total Trailhead Ratings:", calculateRatings(grid))

}
