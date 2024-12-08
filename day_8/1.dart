import 'dart:io';

List<Point> initMap = [];
int antennaPlaced = 0;

bool isOccupied(int x, int y) {
  for (var point in initMap) {
    if (point.x == x && point.y == y && point.type == "#") {
      return true;
    }
  }
  return false;
}

Set<List<Point>> createUniquePairs(List<Point> items) {
  Set<List<Point>> uniquePairs = {};

  for (int i = 0; i < items.length; i++) {
    for (int j = i + 1; j < items.length; j++) {
      uniquePairs.add([items[i], items[j]]);
    }
  }

  return uniquePairs;
}

Map<String, List<Point>> findSameTypeAntenna(List<Point> map) {
  final Map<String, List<Point>> result = {};
  for (var point in initMap) {
    if (!point.occupied) {
      continue;
    }
    if (!result.containsKey(point.type)) {
      result[point.type] = [];
    }

    result[point.type]!.add(point);
  }
  return result;
}

void addAntennas(Map<String, List<Point>> antennas) {
  antennas.forEach((key, value) {
    var uniquePairs = createUniquePairs(value);
    for (var pair in uniquePairs) {
      putAntennasforPair(pair[0], pair[1], 50);
    }
  });
}

void putAntennasforPair(Point a, Point b, int bounds) {
  int difX = b.x - a.x;
  int difY = b.y - a.y;
  
  int symX1 = a.x - difX;
  int symY1 = a.y - difY;
  int symX2 = b.x + difX;
  int symY2 = b.y + difY;
  

  if (symX1 >= 0 && symX1 < bounds && symY1 >= 0 && symY1 < bounds && !isOccupied(symX1, symY1)) {
    antennaPlaced++;
    initMap.add(Point(symX1, symY1, '#')); 
  }

  if (symX2 >= 0 && symX2 < bounds && symY2 >= 0 && symY2 < bounds && !isOccupied(symX2, symY2)) {
    antennaPlaced++;
    initMap.add(Point(symX2, symY2, '#')); 
  }
}

class Point {
  int x;
  int y;
  String type;
  bool occupied;

  Point(this.x, this.y, this.type) : occupied = (type != '.');

  @override
  String toString() {
    return 'Point(x: $x, y: $y, type: $type, occupied: $occupied)';
  }
}

void printGrid(int gridWidth, int gridHeight) {

  List<List<String>> grid = List.generate(gridHeight, (_) => List.generate(gridWidth, (_) => '.'));


  for (var point in initMap) {
    if (point.x < gridWidth && point.y < gridHeight) {
      grid[point.y][point.x] = point.type;
    }
  }

  for (var row in grid) {
    print(row.join(''));
  }
}

void main() async {
  File file = File("input.txt");

  var lines = await file.readAsLines();
  for (var j = 0; j < lines.length; j++) {
    for (var i = 0; i < lines[j].length; i++) {
      Point point = Point(i, j, lines[j][i]);
      initMap.add(point);
    }
  }

  var antennas = findSameTypeAntenna(initMap);
  addAntennas(antennas);

  print("Antenna Placed: $antennaPlaced");

  int maxWidth = lines[0].length;
  int maxHeight = lines.length;
  print(maxWidth);
   print(maxHeight);
  print("Grid Visualization:");
  printGrid(maxWidth, maxHeight);
}
