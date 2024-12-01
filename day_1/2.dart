import 'dart:io';

var LeftList = [];
var RightList = [];

Map<int,int> frequency = {};
Map<int,int> commonOccurrences = {};


int calculateTotal(Map<int, int> frequency, Map<int, int> occurences) {
  int total = 0;
  occurences.forEach((key, value) {
    total += key * value * (frequency[key] ?? 0); 
  });
  return total;
}

void main() {
  final file = File("input.txt");

  final lines = file.readAsLinesSync();

  for (var line in lines) {
    final parts = line.split("   ");
    LeftList.add(int.parse(parts[0].trim()));
    RightList.add(int.parse(parts[1].trim()));
  }

  for (var number in LeftList) {
    frequency[number] = (frequency[number] ?? 0) + 1;
  }

  for (var num in RightList) {
    if (frequency.containsKey(num)) {
      commonOccurrences[num] = (commonOccurrences[num] ?? 0) + 1;
    }
  }
  print("This is the frequesncy data");
  print(frequency);
  print("Occurrences of values from rightList in leftList");
  commonOccurrences.forEach((key, value) {
    print('$key: $value');
  });

  print(calculateTotal(frequency, commonOccurrences));


}