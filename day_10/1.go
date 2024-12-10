package main

import (
  "fmt"
  "os"
)

var directions = []struct{ dx, dy int }{
  {-1, 0}, 
  {1, 0},  
  {0, -1}, 
  {0, 1},  
}


func dfs(grid [][]int, x, y int, visited [][]bool, reachable map[string]struct{}) {
  
  visited[x][y] = true

  
  if grid[x][y] == 9 {
    key := fmt.Sprintf("%d,%d", x, y)
    reachable[key] = struct{}{}
    return
  }

  
  for _, dir := range directions {
    nx, ny := x+dir.dx, y+dir.dy

    
    if nx >= 0 && ny >= 0 && nx < len(grid) && ny < len(grid[0]) &&
      !visited[nx][ny] && grid[nx][ny] == grid[x][y]+1 {
      dfs(grid, nx, ny, visited, reachable)
    }
  }
}


func calculateTotalScore(grid [][]int) int {
  totalScore := 0

  // Iterate over the grid to find all trailheads (cells with 0)
  for x := 0; x < len(grid); x++ {
    for y := 0; y < len(grid[0]); y++ {
      if grid[x][y] == 0 {
        
        visited := make([][]bool, len(grid))
        for i := range visited {
          visited[i] = make([]bool, len(grid[0]))
        }

        
        reachable := make(map[string]struct{})

        
        dfs(grid, x, y, visited, reachable)

        
        totalScore += len(reachable)
      }
    }
  }

  return totalScore
}

func main() {
  
  var grid [][]int
  file, err := os.ReadFile("input.txt")
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

  
  score := calculateTotalScore(grid)

  
  fmt.Printf("Total score for the trail map: %d\n", score)
}
