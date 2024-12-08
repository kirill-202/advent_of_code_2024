import 'dart:io';

List<Point> initMap = [];
int antennaPlaced = 0;

bool isOccupied(int x, int y) {
  for (var point in initMap) {
    if (point.x == x && point.y == y && point.occupied) {
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
    antennaPlaced++;
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


  int x = a.x;
  int y = a.y;
  while (x >= 0 && y >= 0) {
    addAntinode(x, y, bounds);
    x -= difX;  
    y -= difY;  
  }

  x = b.x;
  y = b.y;
  while (x < bounds && y < bounds) {
    addAntinode(x, y, bounds);
    x += difX; 
    y += difY;  
  }
}

void addAntinode(int x, int y, int bounds) {
  if (x >= 0 && x < bounds && y >= 0 && y < bounds && !isOccupied(x, y)) {
    antennaPlaced++;
    initMap.add(Point(x, y, '#'));
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
