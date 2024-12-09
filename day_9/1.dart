import "dart:io";

String transformToBlocks(String raw) {
  String intoBlocks = "";
  int counter = 0;
  for (var i = 0; i < raw.length; i++) {
    if (i.isEven) {
      intoBlocks += '${counter.toString() * int.parse(raw[i])}';
      counter++;
    } else {
      intoBlocks += '${"." * int.parse(raw[i])}';
    }
  }
  return intoBlocks;
}

String dencify(String blocks) {
  List<String> chars = blocks.split('');
  int lastFileBlockIndex = chars.length - 1;

  for (var i = lastFileBlockIndex; i >= 0; i--) {
    if (chars[i] == ".") {
      continue;
    }

    for (var j = 0; j < i; j++) {
      if (chars[j] == ".") {
        chars[j] = chars[i];
        chars[i] = ".";
        break;
      }
    }
  }

  return chars.join("");
}

int checksum(String str) {
  int sum = 0;
  for (var i = 0; i < str.length; i++) {
    if (str[i] != ".") {
      sum += int.parse(str[i]) * i;
    }
  }
  return sum;
}

void main() async {
  File file = File("input.txt");
  String rawInput = await file.readAsString();
  print("Raw input: $rawInput");

  var blocks = transformToBlocks(rawInput.trim());
  print("Blocks: $blocks");

  var densified = dencify(blocks);
  print("Densified blocks: $densified");

  var finalChecksum = checksum(densified);
  print("Checksum: $finalChecksum");
}
