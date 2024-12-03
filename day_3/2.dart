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

void doProcessor(String raw, bool isMulEnabled) {
  
  if (raw.isEmpty) return;

  int index = raw.indexOf(doSrt);
  int dontIndex = raw.indexOf(dontStr);
  

  if (index == -1 && dontIndex == -1) {
    if (isMulEnabled) {
      addToCleaned(raw); 
    }
    return;
  }

  if (index != -1 && (dontIndex == -1 || index < dontIndex)) {

    String beforeDo = raw.substring(0, index);
    if (isMulEnabled) {
      addToCleaned(beforeDo);
    }
    doProcessor(raw.substring(index + doSrt.length), true);
  } else if (dontIndex != -1) {

    String beforeDont = raw.substring(0, dontIndex);
    if (isMulEnabled) {
      addToCleaned(beforeDont);
    }

    doProcessor(raw.substring(dontIndex + dontStr.length), false);
  }
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

  doProcessor(string, true);

  print(multiplyStrings(cleaned));  
}
