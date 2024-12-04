import 'dart:convert';
import 'dart:io';

List<List<String>> matrix =[];
const XMAS = "XMAS";
var counter = 0;

void splitByChars(List<String> splittedInput) {
  for (var line in splittedInput) {
    var charList = line.split("");
    matrix.add(charList);
  }
}


void checkWord(int row, int col, int dRow, int dCol) {
  for (int i = 0; i < XMAS.length; i++) {
    int newRow = row + i * dRow;
    int newCol = col + i * dCol;
    if (newRow < 0 || newRow >= matrix.length || newCol < 0 || newCol >= matrix[0].length || matrix[newRow][newCol] != XMAS[i]) {
      return;
    }
  }
  counter++;
}

void findWords() {
  for (var i = 0; i < matrix.length; i++) {
    for (var j = 0; j < matrix[i].length; j++) {
      if (matrix[i][j] == "X") {
        checkWord(i, j, 0, 1);   // Horizontal right
        checkWord(i, j, 0, -1);  // Horizontal left
        checkWord(i, j, 1, 0);   // Vertical down
        checkWord(i, j, -1, 0);  // Vertical up
        checkWord(i, j, 1, 1);  // Diagonal down-right
        checkWord(i, j, -1, -1); // Diagonal up-left
        checkWord(i, j, 1, -1);  // Diagonal down-left
        checkWord(i, j, -1, 1);
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