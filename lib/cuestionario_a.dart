import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'auth.dart';

class QuestionnaireAScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: QuestionnaireA(),
    );
  }
}

class QuestionnaireA extends StatefulWidget {
  @override
  _QuestionnaireAState createState() => _QuestionnaireAState();
}

class _QuestionnaireAState extends State<QuestionnaireA> {
  List<String> items = [
    '1. Las personas con trastorno de ansiedad suelen hablar de forma incoherente y desordenada.',
    '2. Fatigarse con facilidad puede ser un síntoma de trastorno de ansiedad.',
    '3. El comportamiento imprudente y temerario es un signo común del trastorno de ansiedad.',
    '4. La irritabilidad puede ser un síntoma de trastorno de ansiedad.',
    '5. Guardar rencor y negarse a perdonar a los demás puede ser un signo de trastorno de ansiedad.',
    '6.	Las personas con trastorno de ansiedad suelen oír voces que no existen.',
    '7.	Preocuparse demasiado es el principal síntoma del trastorno de ansiedad.',
    '8.	La tensión muscular puede ser un síntoma de trastorno de ansiedad.',
    '9.	El trastorno de ansiedad no afecta a la concentración.',
    '10. Tener varias personalidades distintas puede ser un signo de trastorno de ansiedad.',
    '11. La sequedad bucal puede ser un síntoma de trastorno de ansiedad.',
    '12. La mejor forma de afrontar el trastorno de ansiedad es hacerlo uno mismo.',
    '13. El trastorno de ansiedad generalizada es una causa frecuente de discapacidad laboral.',
    '14. El trastorno de ansiedad generalizada no es hereditario.',
    '15. Ser acosado o victimizado aumenta el riesgo de desarrollar un trastorno de ansiedad.',
    '16. Los antidepresivos son un tratamiento eficaz para el trastorno de ansiedad.',
    '17. Muchos tratamientos para el trastorno de ansiedad son más eficaces que los antidepresivos.',
    '18. La acupuntura es tan eficaz como la terapia cognitivo-conductual para el trastorno de ansiedad.',
    '19. La lectura de libros de autoayuda sobre terapia cognitivo-conductual no es eficaz para el trastorno de ansiedad.',
    '20. No es un problema dejar de tomar antidepresivos rápidamente.',
    '21. Los antidepresivos son adictivos.',
    '22. Los antidepresivos suelen funcionar de inmediato.',
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
                  'Cuestionario de alfabetización sobre ansiedad (A-Lit)',
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
                          'El cuestionario consta de 22 ítems que son verdaderos o falsos. Puedes responder a cada ítem con una de las tres opciones siguientes: verdadero, falso o no estoy seguro(a).',
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
                            fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                    for (int i = 1; i <= 3; i++)
                      Expanded(
                        child: Text(
                          getHeaderTitle(i),
                          style: TextStyle(
                              fontSize: 16.0, fontWeight: FontWeight.bold, color: Colors.white),
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
                            for (int i = 1; i <= 3; i++)
                              Expanded(
                                child: Checkbox(
                                  value: selectedResponses[item] == i - 1,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedResponses[item] =
                                          value != null ? i - 1 : 0;
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
        return 'Verdadero';
      case 2:
        return 'Falso';
      case 3:
        return 'No estoy seguro(a)';
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

  void _showScore() {
    int totalScore = 0;

    for (var item in items) {
      int respuestaCorrecta = getRespuestaCorrecta(item);

      if (selectedResponses[item] == respuestaCorrecta) {
        totalScore += 1; // Sumar 1 punto si la respuesta es correcta
      }
    }

    double porcentaje = (totalScore / items.length) * 100;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Puntaje Total'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min, // Ajusta el tamaño al contenido
            children: [
              //Text('Nombre del Usuario: $username'),
              Text(
                  'Tu porcentaje de respuestas correctas es de: ${porcentaje.toStringAsFixed(2)}%'),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                // Enviar el porcentaje al backend
                //await enviarPorcentajeAlBackend(porcentaje);

                Navigator.of(context).pop();
              },
              child: Text('Aceptar'),
            ),
          ],
        );
      },
    );

    enviarPorcentajeAlBackend(porcentaje);
  }

  Future<void> enviarPorcentajeAlBackend(double porcentaje) async {
    try {
      print('Enviando porcentaje al backend...');
      final response = await http.post(
        Uri.parse('http://15.228.202.64:8501/actualizar_notas'),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, dynamic>{
          'id_usuario': userId,
          'nota_ansiedad': porcentaje
              .toString(), // Cambia 'nota_ansiedad' por el campo correcto en tu backend
        }),
      );
      print('Respuesta del backend: ${response.statusCode}');
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        final message = responseData["message"];
        print('Mensaje del servidor: $message');
      } else {
        print('Error al enviar el porcentaje al backend');
        print('Cuerpo de la respuesta: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    }
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

  // Función para obtener la respuesta correcta del item
  int getRespuestaCorrecta(String item) {
    switch (item) {
      case '1. Las personas con trastorno de ansiedad suelen hablar de forma incoherente y desordenada.':
      case '3. El comportamiento imprudente y temerario es un signo común del trastorno de ansiedad.':
      case '5. Guardar rencor y negarse a perdonar a los demás puede ser un signo de trastorno de ansiedad.':
      case '6.	Las personas con trastorno de ansiedad suelen oír voces que no existen.':
      case '9.	El trastorno de ansiedad no afecta a la concentración.':
      case '10. Tener varias personalidades distintas puede ser un signo de trastorno de ansiedad.':
      case '12. La mejor forma de afrontar el trastorno de ansiedad es hacerlo uno mismo.':
      case '14. El trastorno de ansiedad generalizada no es hereditario.':
      case '17. Muchos tratamientos para el trastorno de ansiedad son más eficaces que los antidepresivos.':
      case '18. La acupuntura es tan eficaz como la terapia cognitivo-conductual para el trastorno de ansiedad.':
      case '19. La lectura de libros de autoayuda sobre terapia cognitivo-conductual no es eficaz para el trastorno de ansiedad.':
      case '20. No es un problema dejar de tomar antidepresivos rápidamente.':
      case '21. Los antidepresivos son adictivos.':
      case '22. Los antidepresivos suelen funcionar de inmediato.':
        return 1; // La respuesta correcta es "Falso" (segundo checkbox)
      case '2. Fatigarse con facilidad puede ser un síntoma de trastorno de ansiedad.':
      case '4. La irritabilidad puede ser un síntoma de trastorno de ansiedad.':
      case '7.	Preocuparse demasiado es el principal síntoma del trastorno de ansiedad.':
      case '8.	La tensión muscular puede ser un síntoma de trastorno de ansiedad.':
      case '11. La sequedad bucal puede ser un síntoma de trastorno de ansiedad.':
      case '13. El trastorno de ansiedad generalizada es una causa frecuente de discapacidad laboral.':
      case '15. Ser acosado o victimizado aumenta el riesgo de desarrollar un trastorno de ansiedad.':
      case '16. Los antidepresivos son un tratamiento eficaz para el trastorno de ansiedad.':
        return 0; // La respuesta correcta es "Verdadero" (primer checkbox)
      default:
        return -1; // En caso de que el item no tenga respuesta definida
    }
  }
}
