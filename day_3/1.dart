import "dart:convert";
import "dart:core";
import "dart:io";


List<String> cleaned = [];
RegExp exp = RegExp(r'mul\(\d+\,\d+\)');


int multiplyStrings(List<String> list) {
  int total = 0;
  for (var mul in list) {

    int start = mul.indexOf('(') + 1;
    int middle = mul.indexOf(',');
    int end = mul.indexOf(')');

    int part1 = int.tryParse(mul.substring(start, middle)) ?? 0;
    int part2 = int.tryParse(mul.substring(middle + 1, end)) ?? 0;

    total = total + (part1 * part2);
    
  }
  return total;
}

void main() async {
  final file = File("input.txt");

  String string = await file.readAsString();
  Iterable<RegExpMatch> matches = exp.allMatches(string);
  for (var m in matches) {
    if (m[0] != null) {
    cleaned.add(m[0]!);
    }
  }
  print(cleaned);
  print(multiplyStrings(cleaned));
}