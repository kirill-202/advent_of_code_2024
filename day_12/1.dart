import "dart:io";


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
  int borderPrice = 0;
  Plot(this.type, this.x, this.y);

void calculateBorderPrice(List<List<String>> matrix) {
  for (var direction in Direction.values) {
    try {
 
      String bType = matrix[y + direction.dy][x + direction.dx];
      if (bType != this.type) {
        borderPrice++;
      }
    } catch (RangeError) {

      borderPrice++;
    }
  }
  }
  @override
  String toString() => "Plot(x: $x, y: $y, type: $type)";


}
class Region {
  List<Plot> plots;

  Region(this.plots);

  int get plotLength => plots.length;

  int borderSum(List<List<String>> matrix) {
  int sum = 0;
  for (var plot in plots) {
    plot.calculateBorderPrice(matrix); 
    sum += plot.borderPrice;
  }
  return sum;
}

  @override
  String toString() {
    String plotsString = plots.map((plot) => plot.toString()).join("\n");
    return "\n\nRegion with ${plots.length} plots:\n$plotsString";
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
          regions.add(Region(regionPlots));
        }
      }
    }
  }
  return regions;
}

void main() async {
  File file = File("input.txt");

  List<List<String>> matrix = await file.readAsLines().then(
  (lines) => lines.map((line) => line.split("")).toList(),
  );
  List<Region> regions = getRegions(matrix);

  print(matrix);
  print(regions);
  int totalPrice = 0;
  for (var region in regions) {
    totalPrice += region.plotLength * region.borderSum(matrix);
  }
  print(totalPrice);

}