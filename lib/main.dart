import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UTS MOBILE',
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'Doa-Doa'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final Future<List<Doa>> _doaList = fetchDoaList();

  Future<List<Doa>> fetchDoaList() async {
    try {
      final response = await http
          .get(Uri.parse('https://doa-doa-api-ahmadramadhan.fly.dev/api'));
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body) as List<dynamic>;
        return jsonData.map((item) => Doa.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load doa list');
      }
    } catch (e) {
      throw Exception('Failed to fetch doa list: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: FutureBuilder<List<Doa>>(
        future: _doaList,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final doaList = snapshot.data!;
            return ListView.builder(
              itemCount: doaList.length,
              itemBuilder: (context, index) {
                final doa = doaList[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4.0),
                          child: Text(doa.doa,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4.0),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              doa.ayat,
                              style: const TextStyle(
                                  fontStyle: FontStyle.italic, fontSize: 20),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4.0),
                          child: Text(doa.latin),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4.0),
                          child: Text(doa.artinya),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Failed to load doa list'),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

class Doa {
  final String id;
  final String doa;
  final String ayat;
  final String latin;
  final String artinya;

  Doa({
    required this.id,
    required this.doa,
    required this.ayat,
    required this.latin,
    required this.artinya,
  });

  factory Doa.fromJson(Map<String, dynamic> json) {
    return Doa(
      id: json['id'] as String,
      doa: json['doa'] as String,
      ayat: json['ayat'] as String,
      latin: json['latin'] as String,
      artinya: json['artinya'] as String,
    );
  }
}
