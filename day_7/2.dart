import "dart:io";


List<Map<int,List>> equations = [];
int total = 0;

int concat(int x, int y) {
  return int.parse('$x$y');
}

bool checkOperation(int product, List operands) {
  return tryOperations(operands, 0, operands[0], product);
}

bool tryOperations(List numbers, int index, int currentResult, int target) {
  // Base case: If we've applied all numbers, check the result
  if (index == numbers.length - 1) {
    return currentResult == target;
  }

  int nextNumber = numbers[index + 1];

  if (tryOperations(numbers, index + 1, currentResult + nextNumber, target)) {
    return true;
  }

  if (tryOperations(numbers, index + 1, currentResult * nextNumber, target)) {
    return true;
  }

  if (tryOperations(numbers, index + 1, concat(currentResult, nextNumber), target)) {
    return true;
  }

  return false;
}

void main() async {
  File file = File("inpput.txt");

  var lines = await file.readAsLines();

  for (var line in lines ) {
    var parts = line.split(":");
    // Create a map with product as a key and list of operands as values
    int key = int.parse(parts[0]);
    List<int> values = parts[1].trimLeft().split(" ").map(int.parse).toList();
    var map = {key:values};
    print(map);
    equations.add(map);
  }
  for (var map in equations) {
    map.forEach((product, operands) {
      if (checkOperation(product, operands)) {
        total += product;
      }
    });
  }

  print("Total: $total");
}