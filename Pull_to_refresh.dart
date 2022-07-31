import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Refresh extends StatefulWidget {
  Refresh({Key? key}) : super(key: key);
  @override
  State<Refresh> createState() => _RefreshState();
}

class _RefreshState extends State<Refresh> {
  List<String> items = ['item 1', 'item 2', 'item 3'];

  Future refresh() async {
    setState(() {
      items.clear();
    });
    final url = Uri.parse('https://jsonplaceholder.typicode.com/posts');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List newItems = json.decode(response.body);

      setState(() {
        items = newItems.map<String>((item) {
          final number = item['id'];
          return 'Item $number';
        }).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 227, 227, 227),
        body: items.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: refresh,
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return ListTile(title: Text(item));
                  },
                )));
  }
}
