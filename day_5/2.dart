import "dart:io";
import 'dart:convert';

List<List<int>> rules = [];
List<List<int>> pages = [];
List<int> middles = [];

bool checkPage(List<int> page) {
  for (var i = 0; i < page.length; i++) {
    List<List<int>> matchingRules = rules.where((num) => num.contains(page[i])).toList();

    for (var rule in matchingRules) {
      var valuesToCheck = page.sublist(i);
      if (page[i] == rule[1] && valuesToCheck.contains(rule[0])) {
        return false; 
      }
    }
  }
  return true;
}

void fixOrder(List<int> page) {

  bool changed = true;
  while (changed) {
    changed = false;
    for (var i = 0; i < page.length - 1; i++) {

      List<List<int>> matchingRules = rules.where((num) => num.contains(page[i])).toList();

      for (var rule in matchingRules) {

        if (page[i] == rule[1] && page.indexOf(rule[0]) > i) {
          var temp = page[i];
          page[i] = page[i + 1];
          page[i + 1] = temp;
          changed = true; 
        }
      }
    }
  }
}

void main() async {
  final file = File("input.txt");

  var string = await file.readAsString(encoding: utf8);
  var Raw = string.split(RegExp(r'\n\s*\n'));  

  List<String> rulesStr = Raw[0].split(RegExp(r'\s*\n')); 
  List<String> pagesStr = Raw[1].split(RegExp(r'\s*\n')); 


  for (var list in pagesStr) {
    List<int> nPages = list
      .split(',')
      .map((e) => int.tryParse(e) ?? 0) 
      .toList(); 
    pages.add(nPages);
  }

  for (var rule in rulesStr) {
    List<int> l = rule
      .split("|")
      .map((e) => int.tryParse(e) ?? 0)
      .toList(); 
    rules.add(l);
  }

  print("Initial Pages: $pages");
  print("Rules: $rules");


  for (var page in pages) {
    if (!checkPage(page)) {
      fixOrder(page);  
      middles.add(page[page.length ~/ 2]); 
    }
  }

  print("Middle Pages: $middles");

  int sum = middles.reduce((a, b) => a + b);
  print("Sum of Middle Pages: $sum");
}
