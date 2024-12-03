import "dart:core";
import "dart:io";

List<String> cleaned = [];
RegExp exp = RegExp(r'mul\(\d+\,\d+\)');
String doSrt = "do()";
String dontStr = "don't()";

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

void doProcessor(String raw, String stopper) {

  int index = raw.indexOf(stopper);
  
  if (index == -1) {
    return;
  }
  index = index + stopper.length;
  if (stopper == dontStr) {
    stopper = doSrt;
    addToCleaned(raw.substring(0, index));
  } else {
    stopper = dontStr;
  }
  doProcessor(raw.substring(index), stopper);
}

void addToCleaned(String subraw) {
  Iterable<RegExpMatch> matches = exp.allMatches(subraw);
  for (var m in matches) {
    if (m[0] != null) {
      cleaned.add(m[0]!);
    }
  }
}

void main() async {
  final file = File("input.txt");

  String string = await file.readAsString();

  doProcessor(string, dontStr);

  print(multiplyStrings(cleaned));  
}
