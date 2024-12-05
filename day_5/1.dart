import "dart:io";
import 'dart:convert';

List<List<int>> rules = [];
List<List<int>> pages = [];
List<int> middles = [];


bool checkPage(List<int> page) {

  for (var i=0; i < page.length; i++) {
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

  //turn 56/56 into list [56,56]
  for (var rule in rulesStr) {
    List<int> l = rule
      .split("|")
      .map((e) => int.tryParse(e) ?? 0) 
      .toList(); 
    rules.add(l);
  }

  print(pages);
  print(rules);

  for (var page in pages) {
    if (checkPage(page)) {
      print(page);
      middles.add(page[page.length~/2]);
    }
  }
  print(middles);
  int sum = middles.reduce((a, b) => a + b);
  print(sum);
}