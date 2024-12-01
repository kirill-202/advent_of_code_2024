import 'dart:io';

var LeftList = [];
var RightList = [];

void mergeSort(List list) {
  if (list.length <= 1) {
    return;
  }

  int middle = list.length ~/ 2;
  

  List  leftList = list.sublist(0, middle);
  List  rightList = list.sublist(middle);

  mergeSort(leftList);
  mergeSort(rightList);

  merge(leftList, rightList, list);
}

void merge(List leftList, List rightList, List mergedList) {
  int li= 0;
  int ri = 0;
  int mi = 0;

  while (li < leftList.length && ri < rightList.length) {
    if (leftList[li] <= rightList[ri]) {
      mergedList[mi++] = leftList[li++];
    } else {
      mergedList[mi++] = rightList[ri++];
    }
  }

  while (li < leftList.length) {
    mergedList[mi++] = leftList[li++];
  }

  while (ri < rightList.length) {
    mergedList[mi++] = rightList[ri++];
  }
}

num totalDistance(List leftList, List rightList) {
  num total = 0;
  for (var i = 0; i < leftList.length; i++) {
    if (leftList[i] >= rightList[i]) {
      total += leftList[i] - rightList[i];
    } else {
      total += rightList[i] - leftList[i];
    }
  }
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
  mergeSort(RightList);
  mergeSort(LeftList);
  
  print(totalDistance(LeftList, RightList));

 
}