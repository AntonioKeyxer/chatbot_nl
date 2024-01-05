import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NotasUsuario {
  String nombreUsuario;
  String notaAnsiedad;
  String notaDepresion;
  String notaTecnicas;
  String notaSintomasAnsiedad;
  String notaSintomasDepresion;

  NotasUsuario({
    required this.nombreUsuario,
    required this.notaAnsiedad,
    required this.notaDepresion,
    required this.notaTecnicas,
    required this.notaSintomasAnsiedad,
    required this.notaSintomasDepresion,
  });

  NotasUsuario.fromJson(Map<String, dynamic> json)
      : nombreUsuario = json['nombre_usuario'] ?? '',
        notaAnsiedad = json['nota_ansiedad'] ?? '',
        notaDepresion = json['nota_depresion'] ?? '',
        notaTecnicas = json['nota_tecnicas'] ?? '',
        notaSintomasAnsiedad = json['nota_sintomas_ansiedad'] ?? '',
        notaSintomasDepresion = json['nota_sintomas_depresion'] ?? '';
}

class MostrarNotasScreen extends StatefulWidget {
  @override
  _MostrarNotasScreenState createState() => _MostrarNotasScreenState();
}

class _MostrarNotasScreenState extends State<MostrarNotasScreen> {
  List<NotasUsuario> notas = [];

  @override
  void initState() {
    super.initState();
    obtenerNotasDesdeBackend();
  }

  Future<void> obtenerNotasDesdeBackend() async {
    final response = await http
        .get(Uri.parse('http://15.228.202.64:8501/obtener_notas_usuarios'));

    if (response.statusCode == 200) {
      // Decodificar el JSON y actualizar el estado del widget
      dynamic data = json.decode(response.body);

      if (data is List) {
        List<NotasUsuario> notasObtenidas =
            data.map((json) => NotasUsuario.fromJson(json)).toList();

        // Ordenar las notas alfabéticamente por el nombre del usuario
        notasObtenidas.sort((a, b) => a.nombreUsuario.compareTo(b.nombreUsuario));

        setState(() {
          notas = notasObtenidas;
        });
      } else {
        print('La respuesta del servidor no es una lista');
      }
    } else {
      // Manejar errores de solicitud
      print('Error al obtener notas desde el backend');
    }
  }

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notas de Usuarios'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Lista de Notas',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Text("Nombre",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Text("Nota Ansiedad",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Text("Nota Depresion",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Text("Nota Tecnicas",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Text("Nota Sintomas Ansiedad",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Text("Nota Sintomas Depresion",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            Divider(height: 1, thickness: 1, color: Colors.grey),
            Expanded(
              child: ListView.separated(
                itemCount: notas.length,
                separatorBuilder: (BuildContext context, int index) {
                  return Divider(height: 1, thickness: 1, color: Colors.grey);
                },
                itemBuilder: (BuildContext context, int index) {
                  NotasUsuario nota = notas[index];
                  // Alternar el color de fondo de las filas
                  Color bgColor = index % 2 == 0 ? const Color.fromARGB(255, 27, 27, 27)! : Color.fromARGB(255, 72, 72, 72)!;
                  return Container(
                    color: bgColor,
                    child: ListTile(
                      leading: Icon(Icons.person),
                      title: Row(
                        children: [
                          Expanded(child: Text(nota.nombreUsuario)),
                          SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              double.parse(nota.notaAnsiedad)
                              .toStringAsFixed(2)
                              ),
                              ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              double.parse(nota.notaDepresion)
                                  .toStringAsFixed(2),
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(child: Text(nota.notaTecnicas)),
                          SizedBox(width: 16),
                          Expanded(child: Text(nota.notaSintomasAnsiedad)),
                          SizedBox(width: 16),
                          Expanded(child: Text(nota.notaSintomasDepresion)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
