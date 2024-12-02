import 'dart:io';

var allReports = [];
var safeReports = [];

bool isSafe(List<int> list ){
  const maxDiff = 3; 
  bool increasing = false;
  var faultCheck = 0;
  if (list[0] < list[1]) {
    increasing = true;
  } else if ( list[0] == list[1]) {
    faultCheck++;
    list.removeAt(1);
    if (list[0] < list[1]) {
      increasing = true;
    }

  }

  for (int index = 1; index < list.length; index++) {
    int diff = (list[index] - list[index - 1]).abs();

    if (diff > maxDiff || (list[index] == list[index - 1])) {
      faultCheck++;

      if (faultCheck > 1) {
        return false;
      }

      if (index + 1 < list.length && (list[index + 1] - list[index - 1]).abs() <= maxDiff) {
        continue;
      } else {
        return false;
      }
    }

    if ((increasing && list[index] < list[index - 1]) || (!increasing && list[index] > list[index - 1])) {
      faultCheck++;

      if (faultCheck > 1) {
        return false;
      }
    }
  }
  return true;
}

void main() {
  final file = File("test2.txt");

  final lines = file.readAsLinesSync();

  for (var line in lines) {
    final parts = line.split(" ");
    List<int> report = parts.map((str) => int.parse(str)).toList();
    allReports.add(report);
  }
  for (var report in allReports) {
    if (isSafe(report)) {
      safeReports.add(report);
    }
  }
  print(safeReports);
  print(safeReports.length);
}