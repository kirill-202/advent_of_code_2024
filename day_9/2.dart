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

String densify(String blocks) {
  List<String> parts = blocks.split(RegExp(r'(?<=\d)(?=\.)|(?<=\.)(?=\d)'));

  int lastFileBlockIndex = parts.length - 1;


  for (var i = lastFileBlockIndex; i >= 0; i--) {
    if (parts[i].contains(".")) {
      continue; 
    }

    int dotIndex = parts.indexWhere((part) => part.contains(".") && part.length >= parts[i].length);

    if (dotIndex != -1) {

      String tempPart = parts[dotIndex].substring(0, parts[i].length);
      tempPart += "." * (parts[dotIndex].length - parts[i].length);
      parts[dotIndex] = parts[i]; 
      parts[i] = tempPart; 
    }
  }
  return parts.join("");
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
  File file = File("test.txt");
  String rawInput = await file.readAsString();
  print("Raw input: $rawInput");

  var blocks = transformToBlocks(rawInput.trim());
  print("Blocks: $blocks");

  var densified = densify(blocks);
  print("Densified blocks: $densified");

  var finalChecksum = checksum(densified);
  print("Checksum: $finalChecksum");
}
