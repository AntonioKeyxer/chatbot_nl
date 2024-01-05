import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'auth.dart';

class QuestionnaireScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Questionnaire(),
    );
  }
}

class Questionnaire extends StatefulWidget {
  @override
  _QuestionnaireState createState() => _QuestionnaireState();
}

class _QuestionnaireState extends State<Questionnaire> {
  List<String> items = [
    '1. Entumecimiento o hormigueo',
    '2. Sensación de calor',
    '3. Inestabilidad en las piernas',
    '4. Incapacidad para relajarse.',
    '5. Miedo a que suceda lo peor',
    '6. Mareo o sensación de aturdimiento',
    '7. Palpitaciones o latidos acelerados del corazón',
    '8. Inestable',
    '9. Aterrado(a)',
    '10. Nervioso(a)',
    '11. Sensación de asfixia',
    '12. Temblores en las manos',
    '13. Tembloroso(a)',
    '14. Miedo a perder el control',
    '15. Dificultad para respirar',
    '16. Miedo a morir',
    '17. Asustado(a)',
    '18. Indigestión o malestar en el abdomen',
    '19. Desmayo o sensación de desvanecimiento',
    '20. Enrojecimiento del rostro',
    '21. Sudoración (no debido al calor)',
  ];

  Map<String, int> selectedResponses = {};
  bool instructionsExpanded = false;
  int hoveredItemIndex = -1;
  bool warningSnackBarDisplayed = false;

  void _clearSelections() {
    setState(() {
      selectedResponses.clear();
    });
  }

  @override
  void initState() {
    super.initState();
    print('InitState executed');
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _showWarningSnackBar(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            instructionsExpanded
                ? 'Las Instrucciones se están mostrando'
                : 'No olvides Abrir las Instrucciones',
            style: TextStyle(
              color: instructionsExpanded ? Colors.green : Colors.red,
            ),
          ),
          bottom: TabBar(
            tabs: [
              Tab(
                // Modifica aquí para cambiar el color del texto
                child: Text(
                  'Cuestionario NEPALESE BAI-Adolescent',
                  style: TextStyle(
                    color: Colors
                        .white, // Cambia este valor al color blanco que desees
                  ),
                ),
              ),
            ],
          ),
        ),
        body: CustomScrollView(
          slivers: [
            SliverList(
              delegate: SliverChildListDelegate([
                ExpansionPanelList(
                  elevation: 1,
                  expandedHeaderPadding: EdgeInsets.all(0),
                  expansionCallback: (int panelIndex, bool isExpanded) {
                    setState(() {
                      instructionsExpanded = !instructionsExpanded;
                    });
                  },
                  children: [
                    ExpansionPanel(
                      headerBuilder: (BuildContext context, bool isExpanded) {
                        return ListTile(
                          title: Text(
                            'ABRIR INSTRUCCIONES:',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        );
                      },
                      body: ListTile(
                        title: Text(
                          'A continuación, se muestra una lista de los síntomas comunes de la ansiedad. Lea atentamente cada elemento de la lista. Indica cuánto has estado molestado por ese síntoma durante el último mes, incluido hoy, marcando en el cuadro correspondiente en la columna al lado de cada síntoma.',
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ),
                      isExpanded: instructionsExpanded,
                    ),
                  ],
                ),
              ]),
            ),
            SliverAppBar(
              floating: false,
              pinned: true,
              automaticallyImplyLeading: false,
              flexibleSpace: FlexibleSpaceBar(
                title: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        'ITEMS',
                        style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                    for (int i = 1; i <= 4; i++)
                      Expanded(
                        child: Text(
                          getHeaderTitle(i),
                          style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final item = items[index];
                  return MouseRegion(
                    onEnter: (_) {
                      setState(() {
                        hoveredItemIndex = index;
                      });
                    },
                    onExit: (_) {
                      setState(() {
                        hoveredItemIndex = -1;
                      });
                    },
                    child: Card(
                      margin: EdgeInsets.all(8.0),
                      color: hoveredItemIndex == index
                          ? Colors.blue.withOpacity(0.2)
                          : null,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Text(
                                item,
                                style: TextStyle(fontSize: 16.0),
                              ),
                            ),
                            for (int i = 1; i <= 4; i++)
                              Expanded(
                                child: Checkbox(
                                  value: selectedResponses[item] == i - 1,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedResponses[item] =
                                          value! ? i - 1 : 0;
                                    });
                                  },
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                childCount: items.length,
              ),
            ),
            SliverToBoxAdapter(
              child: Container(
                height: 50, // Ajusta la altura aquí según tus necesidades
                child: ElevatedButton(
                  onPressed: () {
                    if (_allItemsSelected()) {
                      _showScore();
                      _clearSelections();
                    } else {
                      _showAlert();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                  ),
                  child: Text(
                    'Mostrar Puntaje',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

void _showWarningSnackBar(BuildContext context) {
  if (!warningSnackBarDisplayed) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    Scaffold.of(context).showBottomSheet(
      (BuildContext context) {
        return Container(
          width: screenWidth,
          constraints: BoxConstraints(
            maxWidth: screenWidth,
            maxHeight: screenHeight * 0.5, // Ajusta la altura vertical según tus necesidades
          ),
          color: Color.fromARGB(255, 255, 238, 0),
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Recuerda responder este cuestionario con la mayor sinceridad posible, así será más beneficioso para ti.',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.0,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16.0),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Cerrar el bottom sheet
                },
                child: Text(
                  'Cerrar',
                  style: TextStyle(
                    color: const Color.fromARGB(255, 0, 0, 0),
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );

    warningSnackBarDisplayed = true;
  }
}


  String getHeaderTitle(int columnIndex) {
    switch (columnIndex) {
      case 1:
        return 'No del todo';
      case 2:
        return 'Ligeramente';
      case 3:
        return 'Moderadamente';
      case 4:
        return 'Severamente';
      default:
        return '';
    }
  }

  bool _allItemsSelected() {
    for (var item in items) {
      if (selectedResponses[item] == null) {
        return false;
      }
    }
    return true;
  }

  Future<void> enviarPorcentajeAlBackend(String respuesta) async {
    try {
      print('Enviando porcentaje al backend...');
      final response = await http.post(
        Uri.parse('http://15.228.202.64:8501/actualizar_notas'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, dynamic>{
          'id_usuario': userId,
          'nota_sintomas_ansiedad': respuesta,
        }),
      );
      print('Respuesta del backend: ${response.statusCode}');
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final message = responseData["message"];
        print('Mensaje del servidor: $message');
      } else {
        print('Error al enviar la respuesta al backend');
        print('Cuerpo de la respuesta: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void _showScore() async {
    int totalScore = 0;
    selectedResponses.values.forEach((score) {
      totalScore += score;
    });

    // Envía el puntaje al backend
    String backendMessage = await sendScore(totalScore);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Puntaje Total'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min, // Ajusta el tamaño al contenido
            children: [
              Text('El puntaje total es: $totalScore'),
              SizedBox(height: 10),
              Text('Resultado del Cuestionario: $backendMessage'),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Aceptar'),
            ),
          ],
        );
      },
    );

    enviarPorcentajeAlBackend(backendMessage);
  }

  void _showAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Alerta'),
          content: Text(
              'Por favor, marque todos los items antes de mostrar el puntaje.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Aceptar'),
            ),
          ],
        );
      },
    );
  }

  Future<String> sendScore(int score) async {
    try {
      final response = await http.post(
        Uri.parse('http://15.228.202.64:8501/puntaje'),
        headers: {"Content-Type": "application/json"},
        body: '{"score": $score}',
      );

      if (response.statusCode == 200) {
        print('Puntaje enviado correctamente');
        Map<String, dynamic> jsonResponse = json.decode(response.body);
        return jsonResponse['message']; // Devuelve solo el mensaje del backend
      } else {
        print(
            'Error al enviar el puntaje. Código de estado: ${response.statusCode}');
        print('Respuesta del servidor: ${response.body}');
        return 'Error en la solicitud al servidor';
      }
    } catch (e) {
      print('Excepción durante la solicitud HTTP: $e');
      return 'Excepción durante la solicitud al servidor';
    }
  }
}
