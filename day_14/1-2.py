import re
from itertools import count
from math import prod

GRID_HEIGHT = 103
GRID_WIDTH = 101

def parse_input():
    """
    Parse the input file to extract robot positions and velocities.

    Returns:
        List of tuples: Each tuple contains (x, y, dx, dy) representing
        position (x, y) and velocity (dx, dy) of a robot.
    """
    with open("input.txt", "r") as file:
        data = file.read()
    pattern = r"p=(-?\d+),(-?\d+) v=(-?\d+),(-?\d+)"
    return [list(map(int, match)) for match in re.findall(pattern, data)]


ROBOTS = parse_input()

def move_robot(x, y, dx, dy, t):
    """
    Calculate the position of a robot after t seconds, considering wrapping.

    Args:
        x (int): Initial x-coordinate.
        y (int): Initial y-coordinate.
        dx (int): Velocity in x-direction.
        dy (int): Velocity in y-direction.
        t (int): Time steps.

    Returns:
        Tuple[int, int]: New wrapped position (x, y).
    """
    new_x = (x + dx * t) % GRID_WIDTH
    new_y = (y + dy * t) % GRID_HEIGHT
    return new_y, new_x  # Note: y comes first to match row-major grid indexing

def draw_grid(positions):
    """
    Draw the grid with robot positions.

    Args:
        positions (set): Set of (row, col) positions of robots.
    """
    grid = [["."] * GRID_WIDTH for _ in range(GRID_HEIGHT)]
    for row, col in positions:
        grid[row][col] = "\u2588"  # Unicode full block character for robots
    print("\n".join("".join(row) for row in grid))

def calculate_safety_factor():
    """
    Calculate the safety factor after 100 seconds by counting robots in quadrants.

    Returns:
        int: The product of robot counts in each quadrant.
    """
    quadrants = [0] * 4  

    for row, col in (move_robot(*robot, 100) for robot in ROBOTS):
        mid_row = GRID_HEIGHT // 2
        mid_col = GRID_WIDTH // 2


        if row == mid_row or col == mid_col:
            continue

        quadrant_index = (row > mid_row) * 2 + (col > mid_col)
        quadrants[quadrant_index] += 1

    return prod(quadrants)

def find_first_no_collision_time():
    """
    Find the first time step where all robots are in unique positions.

    Returns:
        int: Time step where all robots have unique positions.
    """
    for t in count():
        positions = {move_robot(*robot, t) for robot in ROBOTS}
        if len(positions) == len(ROBOTS):  # No overlapping positions
            draw_grid(positions)
            return t

if __name__ == "__main__":
    print(f"Part 1: Safety Factor = {calculate_safety_factor()}")
    print(f"Part 2: First Unique Positions Time = {find_first_no_collision_time()}")
