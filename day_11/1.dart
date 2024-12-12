import "dart:io";


List<int> toInt(List<int> bytes) {
  String content = String.fromCharCodes(bytes);
  return content.split(' ').map(int.parse).toList();
}

class Elem {
  int value;
  Elem? next;
  Elem(this.value);

  bool IsNullTranform() {
    if (this.value == 0) {
      this.value = 1;
      return true;
    }
    return false;
  }

  bool IsEvenSplit() {
    String str = '$value';
    if (str.length % 2 != 0) {
      return false;
    }
    int LeftNodeValue = int.parse(str.substring(0, str.length~/2));
    int RightNodeValue  = int.parse(str.substring(str.length~/2));
    print("These are left: $LeftNodeValue and right $RightNodeValue");
    
    Elem rightNode = Elem(RightNodeValue);
    this.value = LeftNodeValue;
    if (this.next != null) {
      Elem currentNext = this.next!;
      this.next = rightNode;
      rightNode.next = currentNext;
    } else {
      this.next = rightNode;
    }

    return true;
  }

  void MultiplyCurrentYear() {
    this.value *= 2024;
  }
}

class LinkedList {
  Elem? head;


  void Add(int value) {
    if (this.head == null) {
      this.head = Elem(value);
      return;
    }
    Elem current = this.head!;
    while (current.next != null) {
      current = current.next!;
    }
    current.next = Elem(value);
  }

  int CountLength() {
    if (this.head == null) {
      return 0;
    }
    int counter = 1;
    Elem current = this.head!;
    while (current.next != null) {
      counter++;
      current = current.next!;
    }
    return counter;
  }

  void Blink(int times) {
    for (var i=0; i< times; i++) {
      Elem? current = this.head;
      while (current != null) {
        if (current.IsNullTranform()) {
          current = current.next;
          continue;
        } 
        if (current.IsEvenSplit()) {
          current = current.next?.next;

          continue;
        }
        current.MultiplyCurrentYear();
        current = current.next;
      }
    }
  }

  void PrintElems() {
    Elem current = this.head!;

    while (current.next != null) {
    stdout.write("${current.value}" + ", ");
    current = current.next!;
  }
  stdout.write("${current.value}\n");
  }

}

void main() async {
  var file = File("input.txt");
  List<int> raw = await  file.readAsBytes();
  print(raw);
  List<int> values = toInt(raw);
  
  print(values);

  LinkedList llist = LinkedList();
  for (var value in values) {
    llist.Add(value);
  }
  print(llist.CountLength());
  llist.PrintElems();
  llist.Blink(25);
  print(llist.CountLength());


}