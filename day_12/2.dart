import 'dart:io';

enum Direction {
  top(-1, 0),
  bottom(1, 0),
  left(0, -1),
  right(0, 1);

  final int dx;
  final int dy;

  const Direction(this.dx, this.dy);
}

class Plot {
  String type;
  int x;
  int y;

  Plot(this.type, this.x, this.y);

  @override
  String toString() => "Plot(x: $x, y: $y, type: $type)";
}

class Region {
  List<Plot> plots;
  String type;
  int sides = 0;  

  Region(this.plots, this.type);

  int get plotLength => plots.length;


  void calculateSides(List<List<String>> matrix) {

    for (var plot in plots) {
      for (var direction in Direction.values) {
        int newX = plot.x + direction.dx;
        int newY = plot.y + direction.dy;


        if (newX < 0 || newX >= matrix[0].length || newY < 0 || newY >= matrix.length) {
          sides++;
        } else {
          String neighborType = matrix[newY][newX];
          if (neighborType != this.type) {

            sides++;
          }
        }
      }
    }

  }




  int calculatePrice() {
    int area = plotLength;
    return area * sides;  
  }

  @override
  String toString() {
    String plotsString = plots.map((plot) => plot.toString()).join("\n");
    return "\nRegion with ${plots.length} plots and type '$type' has $sides sides:\n$plotsString";
  }
}

String checkType(List<List<String>> matrix, int x, int y) {
  return matrix[y][x];
}

List<Region> getRegions(List<List<String>> matrix) {
  List<Region> regions = [];
  List<List<bool>> visited = List.generate(matrix.length, (_) => List.filled(matrix[0].length, false));

  void dfs(int x, int y, String type, List<Plot> regionPlots) {
    if (x < 0 || x >= matrix[0].length || y < 0 || y >= matrix.length || visited[y][x] || matrix[y][x] != type) {
      return;
    }
    visited[y][x] = true;
    regionPlots.add(Plot(type, x, y));


    for (var direction in Direction.values) {
      dfs(x + direction.dx, y + direction.dy, type, regionPlots);
    }
  }

  for (int y = 0; y < matrix.length; y++) {
    for (int x = 0; x < matrix[0].length; x++) {
      if (!visited[y][x]) {
        List<Plot> regionPlots = [];
        dfs(x, y, matrix[y][x], regionPlots);
        if (regionPlots.isNotEmpty) {
          regions.add(Region(regionPlots, matrix[y][x]));
        }
      }
    }
  }
  return regions;
}

void main() async {
  File file = File("test.txt");

  List<List<String>> matrix = await file.readAsLines().then(
    (lines) => lines.map((line) => line.split("")).toList(),
  );
  print("Matrix:");
  matrix.forEach((row) => print(row.join("")));  

  List<Region> regions = getRegions(matrix);
  print("Number of regions: ${regions.length}");

  int totalPrice = 0;
  for (var region in regions) {
    region.calculateSides(matrix);  
    int regionPrice = region.calculatePrice();
    print("Region type: '${region.type}' has ${region.sides} sides and price: $regionPrice");
    totalPrice += regionPrice;
  }

  print("Total price: $totalPrice");
}
