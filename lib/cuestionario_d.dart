import 'package:auto_orientation/auto_orientation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'auth.dart';

class QuestionnaireDScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AutoOrientation.portraitUpMode();
    return Scaffold(
      body: QuestionnaireD(),
    );
  }
}

class QuestionnaireD extends StatefulWidget {
  @override
  _QuestionnaireDState createState() => _QuestionnaireDState();
}

class _QuestionnaireDState extends State<QuestionnaireD> {
  List<String> items = [
    '1. Tenía poco apetito',
    '2. No podía quitarme la tristeza',
    '3. Tenía dificultad para mantener mi mente en lo que estaba haciendo',
    '4. Me sentía deprimido(a)',
    '5. Dormía sin descansar',
    '6. Me sentía triste',
    '7. No podía seguir adelante',
    '8. Nada me hacía feliz',
    '9. Sentía que era una mala persona',
    '10. Había perdido interés en mis actividades diarias',
    '11. Dormía más de lo habitual',
    '12. Sentía que me movía muy lento',
    '13. Me sentía agitado(a)',
    '14. Sentía deseos de estar muerto(a)',
    '15. Quería hacerme daño',
    '16. Me sentía cansado(a) todo el tiempo',
    '17. Estaba a disgusto conmigo mismo(a)',
    '18. Perdí peso sin intentarlo',
    '19. Me costaba mucho trabajo dormir',
    '20. Era difícil concentrarme en las cosas importantes',
    '21. Me molesté por cosas que usualmente no me molestan',
    '22. Sentía que era tan bueno(a) como otra gente',
    '23. Sentí que todo lo que hacía era con esfuerzo',
    '24. Me sentía esperanzado(a) hacia el futuro',
    '25. Pensé que mi vida ha sido un fracaso',
    '26. Me sentía temeroso(a)',
    '27. Me sentía feliz',
    '28. Hablé menos de lo usual',
    '29. Me sentía solo(a)',
    '30. Las personas eran poco amigables',
    '31. Disfruté de la vida',
    '32. Tenía ataques de llanto',
    '33. Me divertí mucho',
    '34. Sentía que iba a darme por vencido(a)',
    '35. Sentía que le desagradaba a la gente',
  ];

  Map<String, int> selectedResponses = {};
  bool instructionsExpanded = false;
  int lastCheckboxTotal = 0; // Variable de instancia para lastCheckboxTotal
  Map<String, int> lastCheckboxCount = {};
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
    // Bloquea la orientación en modo retrato al inicio
    AutoOrientation.portraitUpMode();
    print('InitState executed');
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _showWarningSnackBar(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(
      builder: (context, orientation) {
        if (orientation == Orientation.portrait) {
          AutoOrientation.portraitUpMode();
        } else {
          AutoOrientation.landscapeRightMode();
        }
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
                      'Cuestionario CES-D-R',
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
                          headerBuilder:
                              (BuildContext context, bool isExpanded) {
                            return ListTile(
                              title: Text(
                                'ABRIR INSTRUCCIONES:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            );
                          },
                          body: ListTile(
                            title: Text(
                              'A continuación, hay una lista de emociones y situaciones que probablemente hayas sentido o tenido. Por favor marca la casilla en la columna correspondiente para indicar cuántos días en la semana pasada te sentiste así, o si te ocurrió casi diario en las últimas dos semanas.',
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
                          flex: 5,
                          child: Container(
                            padding: EdgeInsets.only(left: 400.0),
                            child: Text(
                              '',
                              style: TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            'En la Semana Pasada',
                            style: TextStyle(
                                fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Container(
                            padding: EdgeInsets.only(left: 55.0),
                            child: Text(
                              '| Ultimas dos semanas',
                              style: TextStyle(
                                  fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
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
                        for (int i = 1; i <= 5; i++)
                          Expanded(
                            flex: 1,
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
                                for (int i = 1; i <= 5; i++)
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
      },
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
        return 'Escasamente\n(0 a 1 días)';
      case 2:
        return 'Algo\n(1 a 2 días)';
      case 3:
        return 'Ocasionalmente\n(3 a 4 días)';
      case 4:
        return 'La Mayoría\n(5 a 7 días)';
      case 5:
        return 'Casi a diario\n(10 a 14 días)';
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
          'nota_sintomas_depresion': respuesta,
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

    List<String> specificItems = [
      '2. No podía quitarme la tristeza',
      '4. Me sentía deprimido(a)',
      '6. Me sentía triste',
      '8. Nada me hacía feliz',
      '10. Había perdido interés en mis actividades diarias',
      '21. Me molesté por cosas que usualmente no me molestan',
      '24. Me sentía esperanzado(a) hacia el futuro',
      '26. Me sentía temeroso(a)',
      '27. Me sentía feliz',
      '31. Disfruté de la vida',
      '32. Tenía ataques de llanto',
      '33. Me divertí mucho',
      '34. Sentía que iba a darme por vencido(a)',
    ];

    selectedResponses.forEach((item, score) {
      totalScore += score;
      if (specificItems.contains(item)) {
        if (score == 4) {
          lastCheckboxTotal += 1;
        }
      }
    });

    // Envía el puntaje al backend
    String backendMessage = await sendScore(totalScore, lastCheckboxTotal);

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
                // Restablece lastCheckboxTotal a cero después de enviar los datos
                setState(() {
                  lastCheckboxTotal = 0;
                });

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

  Future<String> sendScore(int totalScore, int lastCheckboxTotal) async {
    try {
      final response = await http.post(
        Uri.parse('http://15.228.202.64:8501/puntajed'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          'scored': totalScore,
          'lastCheckboxTotal': lastCheckboxTotal,
        }),
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
