import 'dart:io';

var allReports = [];
var safeReports = [];

bool isSafe(List<int> list ){
  const maxDiff = 3; 
  bool increasing = false;

  if (list[0] < list[1]) {
    increasing = true;
  } else if ( list[0] == list[1]) {
    return false;
  }

  for (var index=1;index < list.length; index++) {

    int diff = (list[index] - list[index - 1]).abs(); 
    if (diff > maxDiff) {
      return false; 
    }
    if (list[index] > list[index-1] && increasing) {
      continue;
    } else if 
      (list[index] < list[index-1] && !increasing) {
      continue;
    } else return false;
  
  }
  return true;
}

void main() {
  final file = File("input.txt");

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
  print(safeReports.length);
}