
import "dart:io";



enum Direction {
  up,
  left,
  right,
  down
}

class Map {
  List<Cell> cells = [];

  Map();
      
  void addCell(Cell cell) {
    this.cells.add(cell);
  }

  void printCells() {
    for (var cell in cells) {
      print(cell);
    }
  }

  Cell? getCell(int x, int y) {
    for (var cell in this.cells) {
      if (cell.x == x && cell.y == y) {
        return cell;
      }
    }
    return null;
  }
}

class Cell {
  int x; 
  int y;
  String value;
  bool visited = false;

  Cell(this.x, this.y, this.value);

  @override
  String toString() {
    return 'Cell(x: $x, y: $y, value: $value)';
  }
}

class Guard {
  Cell? initPosition;
  Cell? currentPosition;
  Direction direction = Direction.up;
  int travercedCells = 1;
  bool leftMap = false;

  void Move(Map map) {
    var currentCellMap = map.getCell(currentPosition!.x, currentPosition!.y);
    if (currentCellMap != null) {
      currentCellMap.visited = true;
    }

    Cell? nextPosition;

    switch (this.direction) {
      case Direction.up:
        nextPosition = map.getCell(this.currentPosition!.x, this.currentPosition!.y - 1);
        if (nextPosition == null) {
          leftMap = true;
          return;
        }
        if (!traverceble(nextPosition)) {
          direction = Direction.right;
          return;
        }
        this.currentPosition = nextPosition;
        if (!nextPosition.visited) {
          this.travercedCells++;
        }
        
        break;
      case Direction.left:
        nextPosition = map.getCell(this.currentPosition!.x-1, this.currentPosition!.y);
        if (nextPosition == null) {
          leftMap = true;
          return;
        }
        if (!traverceble(nextPosition)) {
          direction = Direction.up;
          return;
        }
        this.currentPosition = nextPosition;
        if (!nextPosition.visited) {
          this.travercedCells++;
        }
        break;
      case Direction.right:
        nextPosition = map.getCell(this.currentPosition!.x+1, this.currentPosition!.y);
        if (nextPosition == null) {
          leftMap = true;
          return;
        }
        if (!traverceble(nextPosition)) {
          direction = Direction.down;
          return;
        }
        this.currentPosition = nextPosition;
        if (!nextPosition.visited) {
          this.travercedCells++;
        }
        break;
      case Direction.down:
        nextPosition = map.getCell(this.currentPosition!.x, this.currentPosition!.y+1);
        if (nextPosition == null) {
          leftMap = true;
          return;
        }
        if (!traverceble(nextPosition)) {
          direction = Direction.left;
          return;
        }
        this.currentPosition = nextPosition;
        if (!nextPosition.visited) {
          this.travercedCells++;
        }
        break;
    }
    print("next cell is $nextPosition");
  }

  bool traverceble(Cell cell) {
    if (cell.value == "#") {
      return false;
    }
    return true;

  }



}

int simulateGuardMovement(Map map, Guard guard) {

  for (var cell in map.cells) {
    cell.visited = false;
  }

  guard.travercedCells = 1;
  guard.leftMap = false;

  while (!guard.leftMap) {
    guard.Move(map);

    if (guard.currentPosition == guard.initPosition && guard.travercedCells > 1) {
      return guard.travercedCells;
    }
  }

  return guard.travercedCells;
}

void main() async {
  var map = Map();
  var guard = Guard();

  var file = File("test.txt");
  var lines = await file.readAsLines();

  for (var i = 0; i < lines.length; i++) {
    var chars = lines[i].split("");
    for (var j = 0; j < chars.length; j++) {
      var cell = Cell(j, i, chars[j]);
      if (cell.value == "^") {
        guard
          ..initPosition = cell
          ..currentPosition = cell;
      }
      map.addCell(cell);
    }
  }

  print("Initial guard traversed cells: ${simulateGuardMovement(map, guard)}");
  int loopCount = 0;
  for (var cell in map.cells) {
    if (cell.value == ".") {
      cell.value = "#"; 

      var newGuard = Guard()
        ..initPosition = map.getCell(guard.initPosition!.x, guard.initPosition!.y)
        ..currentPosition = map.getCell(guard.initPosition!.x, guard.initPosition!.y);

      int traversedCells = simulateGuardMovement(map, newGuard);

      if (!newGuard.leftMap) {
        print("Obstacle at (${cell.x}, ${cell.y}) causes a loop!");
        loopCount++;
      }


      cell.value = ".";
    }
  }
  print("This is the loopcount $loopCount");
}

