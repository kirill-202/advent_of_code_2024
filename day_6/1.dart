import "dart:io";



enum Direction {
  up,
  right,
  down,
  left
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
        break;
      case Direction.left:
        nextPosition = map.getCell(this.currentPosition!.x-1, this.currentPosition!.y);
        break;
      case Direction.right:
        nextPosition = map.getCell(this.currentPosition!.x+1, this.currentPosition!.y);
        break;
      case Direction.down:
        nextPosition = map.getCell(this.currentPosition!.x, this.currentPosition!.y+1);
        break;
    }
    if (nextPosition == null) {
      leftMap = true;
      return;
    }
    if (!traverceble(nextPosition)) {
      var values = Direction.values;
      int nextIndex = (this.direction.index + 1) % values.length;
      this.direction = values[nextIndex];
      return;
    }
    this.currentPosition = nextPosition;
    if (!nextPosition.visited) {
      this.travercedCells++;
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

void main() async {
  
  var map = Map();
  var guard = Guard();

  var file = File("test.txt");


  var lines = await file.readAsLines();
  for (var i=0; i < lines.length; i++) {
    var chars = lines[i].split("");

    for (var j=0; j < chars.length; j++) {
      var cell = Cell(j, i, chars[j]);
      if (cell.value == "^") {
      guard
        ..initPosition = cell
        ..currentPosition = cell;
      }
      map.addCell(cell);
    }
  }
  
  print(guard.initPosition);
  while (!guard.leftMap) {
    guard.Move(map);
  }
  print(guard.travercedCells);
}