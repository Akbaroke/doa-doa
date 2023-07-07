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
        primarySwatch: const MaterialColor(
          0xFF00957B,
          <int, Color>{
            50: Color(0xFFE6F5F2),
            100: Color(0xFFB3DDD0),
            200: Color(0xFF80C6AD),
            300: Color(0xFF4DAD8A),
            400: Color(0xFF269671),
            500: Color(0xFF00957B),
            600: Color(0xFF008A71),
            700: Color(0xFF007E66),
            800: Color(0xFF00735C),
            900: Color(0xFF006549),
          },
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'IndoQur`an'),
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
        title: Row(
          children: [
            Image.asset(
              'assets/images/logo.png',
              width: 30,
              height: 30,
            ),
            const SizedBox(width: 10),
            Text(
              widget.title,
              style: const TextStyle(
                fontFamily: 'Quicksand',
                fontWeight: FontWeight.w700,
                fontStyle: FontStyle.italic,
                fontSize: 22,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding:
                const EdgeInsets.only(left: 18, right: 18, top: 15, bottom: 15),
            child: Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Color.fromARGB(244, 223, 223, 223),
                    width: 2.0,
                  ),
                ),
              ),
              child: const Text(
                'Daftar Doa :',
                style: TextStyle(
                  fontFamily: 'Quicksand',
                  fontSize: 15,
                  color: Color(0xFF00957B),
                ),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Doa>>(
              future: _doaList,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final doaList = snapshot.data!;
                  return ListView.builder(
                    itemCount: doaList.length,
                    itemBuilder: (context, index) {
                      final doa = doaList[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 1.0, horizontal: 7.0),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          elevation: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      '${doa.id}. ',
                                      style: const TextStyle(
                                        fontFamily: 'Quicksand',
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF00957B),
                                        fontSize: 15,
                                      ),
                                    ),
                                    Text(
                                      doa.doa,
                                      style: const TextStyle(
                                        fontFamily: 'Quicksand',
                                        fontWeight: FontWeight.w700,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 15),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 4.0),
                                  child: Align(
                                    alignment: Alignment.topRight,
                                    child: Text(
                                      doa.ayat,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontFamily: 'Scheherazade',
                                      ),
                                      textAlign: TextAlign.right,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 15),
                                Text(
                                  doa.latin,
                                  style: const TextStyle(
                                    fontStyle: FontStyle.italic,
                                    fontSize: 14,
                                    fontFamily: 'Quicksand',
                                    color: Color(0xFF00957B),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  doa.artinya,
                                  style: const TextStyle(
                                    fontStyle: FontStyle.normal,
                                    fontSize: 14,
                                    fontFamily: 'Quicksand',
                                  ),
                                ),
                              ],
                            ),
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
          ),
        ],
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
