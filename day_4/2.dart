import 'dart:convert';
import 'dart:io';

List<List<String>> matrix =[];

var counter = 0;

void splitByChars(List<String> splittedInput) {
  for (var line in splittedInput) {
    var charList = line.split("");
    print(charList);
    matrix.add(charList);
  }
}


void checkWord(int row, int col) {
  var m = "M";
  var s = "S";

  try {
      if (matrix[row - 1][col - 1] == m && matrix[row - 1][col + 1] == m && 
          matrix[row + 1][col - 1] == s && matrix[row + 1][col + 1] == s) {
        counter++;
      }

      if (matrix[row - 1][col - 1] == s && matrix[row - 1][col + 1] == s && 
          matrix[row + 1][col - 1] == m && matrix[row + 1][col + 1] == m) {
        counter++;
      }

      if (matrix[row - 1][col - 1] == s && matrix[row + 1][col - 1] == s && 
          matrix[row + 1][col + 1] == m && matrix[row - 1][col + 1] == m) {
        counter++;
      }

      if (matrix[row - 1][col - 1] == m && matrix[row + 1][col - 1] == m && 
          matrix[row + 1][col + 1] == s && matrix[row - 1][col + 1] == s) {
        counter++;
    }
  } on RangeError catch (e) {
    // do nothing
  }
}
void findWords() {
  for (var i = 0; i < matrix.length; i++) {
    for (var j = 0; j < matrix[i].length; j++) {
      if (matrix[i][j] == "A") {
        checkWord(i, j);

      }
    }
  }
}

void main() async {
  final file = File("input.txt");

  var string = await file.readAsString(encoding: utf8);
  var finalSplitted = string.split(RegExp(r'\s?\n'));

  splitByChars(finalSplitted);
  
  findWords();
  
  print("Total XMAS found: $counter");
}