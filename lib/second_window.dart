import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SecondWindow extends StatefulWidget {
  const SecondWindow({Key? key}) : super(key: key);

  @override
  _SecondWindowState createState() => _SecondWindowState();
}

class _SecondWindowState extends State<SecondWindow> {
  String message = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter FastAPI Demo'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              // Navegar de vuelta a la primera ventana
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Mensaje desde FastAPI:',
              style: TextStyle(fontSize: 20),
            ),
            Text(
              message,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            ElevatedButton(
              onPressed: () {
                fetchMessage();
              },
              child: Text('Obtener Mensaje'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> fetchMessage() async {
    final response = await http.get(Uri.parse('http://15.228.202.64:8501/'));
    if (response.statusCode == 200) {
      setState(() {
        message = 'Respuesta: ${response.body}';
      });
    } else {
      setState(() {
        message = 'Error: ${response.statusCode}';
      });
    }
  }
}
