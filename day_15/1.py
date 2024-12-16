MAP_RANGE = 50



class Robot:
    def __init__(self, robot_tyle, moves, rmap):
        self.robot_tyle: Tyle = robot_tyle
        self.moves: list = moves
        self.map: Map = rmap

    def move(self):
        for move in self.moves:
            self.perform_move(move)
            self.display_map(MAP_RANGE)

    def go_on_free_tyle(self, tyle):

        self.robot_tyle, tyle = tyle, self.robot_tyle
        tyle.value, self.robot_tyle.value = self.robot_tyle.value, tyle.value
        self.map.update_tyle(self.robot_tyle)
        self.map.update_tyle(tyle)

    def push_box(self, target, move):

        direction = {
            "<": (-1, 0),  # Left
            ">": (1, 0),   # Right
            "^": (0, -1),  # Up
            "v": (0, 1)    # Down
        }
        
        dx, dy = direction[move]
        push_x, push_y = target.x, target.y
        
        while True:
            push_x += dx
            push_y += dy
            push_target = self.map.get_tyle(push_x, push_y)
            
            if push_target is None or push_target.value == "#":
                break
            
            if push_target.value == ".":
                target.value = "."
                push_target.value = "O"
                self.robot_tyle.value = "."
                self.robot_tyle = target
                self.robot_tyle.value = "@"
                target = push_target  

    def perform_move(self, move):
        x, y = self.robot_tyle.x, self.robot_tyle.y
        
        if move == "<":
            print(f"going_left...")
            target = self.map.get_tyle(x-1, y)
        elif move == ">":
            print(f"going_right...")
            target = self.map.get_tyle(x+1, y)
        elif move == "^":
            print(f"going_up...")
            target = self.map.get_tyle(x, y-1)
        elif move == "v":
            print(f"going_down...")
            target = self.map.get_tyle(x, y+1)
        

        if target and target.value == ".":
            self.go_on_free_tyle(target)
            return
            
        elif target and target.value == "O":
            self.push_box(target, move)
            return
        print(f"Can't go to that direction. Tyle: {target} ")
            


    def display_map(self, map_range):
        for i in range(0, len(self.map.tyles), map_range):  
            print("".join([tyle.value for tyle in self.map.tyles[i:i+map_range]]))
        print()


class Tyle:
    def __init__(self, x, y, value):
        self.x = x
        self.y = y
        self.value = value

    def __repr__(self):
        return f"Tyle coords x={self.x}, y={self.y}, value<{self.value}>\n"


class Map:
    def __init__(self):
        self.tyles: list[Tyle] = []

    def ProcessRawMap(self, m: str):
        lines = m.split("\n")
        for i in range(len(lines)):
            line_tyles = [Tyle(x=x, y=i, value=value) for x, value in enumerate(lines[i])]
            self.tyles.extend(line_tyles)

    def get_tyle(self, x, y):
        for tyle in self.tyles:
            if tyle.x == x and tyle.y == y:
                return tyle
        return None
    
    def update_tyle(self, updated_tyle):
        for i, tyle in enumerate(self.tyles):
            if tyle.x == updated_tyle.x and tyle.y == updated_tyle.y:
                self.tyles[i] = updated_tyle
        

def split_input(path: str) -> list:
    with open(path, "r") as f:
        raw = f.read()
        split = raw.split("\n\n")
        return split


def main():
    raw_map, moves = split_input("input.txt")
    list_moves = list(moves.replace("\n", ""))  

    full_map = Map()
    full_map.ProcessRawMap(raw_map)

    robotTyle = None
    for tyle in full_map.tyles:
        if tyle.value == "@":
            robotTyle = tyle

    robot = Robot(robotTyle, list_moves, full_map)
    robot.move()

    gps_sum = 0
    for tyle in full_map.tyles:
        if tyle.value == "O":
            gps_sum += (tyle.y * 100) + tyle.x
    print(f"Sum of all boxes' GPS coordinates: {gps_sum}")


if __name__ == "__main__":
    main()
