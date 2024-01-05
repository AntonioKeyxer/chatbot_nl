import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'auth.dart';

class QuestionnaireCScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: QuestionnaireC(),
    );
  }
}

class QuestionnaireC extends StatefulWidget {
  @override
  _QuestionnaireCState createState() => _QuestionnaireCState();
}

class _QuestionnaireCState extends State<QuestionnaireC> {
  List<String> items = [
    '1. Las personas deprimidas suelen hablar de forma incoherente.',
    '2. Las personas con depresión pueden sentirse culpables cuando no tienen la culpa.',
    '3. El comportamiento imprudente y temerario es un signo frecuente de depresión.',
    '4. La pérdida de confianza y la baja autoestima pueden ser síntomas de depresión.',
    '5. No pisar las grietas del sendero puede ser un signo de depresión',
    '6. Las personas con depresión suelen oír voces que no existen.',
    '7. Dormir demasiado o demasiado poco puede ser un signo de depresión.',
    '8. Comer demasiado o perder el interés por la comida puede ser un signo de depresión.',
    '9. La depresión no afecta tu memoria y concentración.',
    '10. Tener varias personalidades distintas puede ser un signo de depresión.',
    '11. Las personas pueden moverse más despacio o agitarse como consecuencia de su depresión.',
    '12. Los psicólogos clínicos pueden recetar antidepresivos.',
    '13. La depresión moderada interrumpe la vida de una persona tanto como la esclerosis múltiple o la sordera.',
    '14. La mayoría de las personas con depresión necesitan ser hospitalizadas.',
    '15. Muchas personas famosas han sufrido de depresión',
    '16. Muchos tratamientos para la depresión son más efectivos que los antidepresivos',
    '17. El asesoramiento es tan eficaz como la terapia cognitivo-conductual para la depresión.',
    '18. La terapia cognitivo-conductual es tan eficaz como los antidepresivos para la depresión leve a moderada.',
    '19. De todos los tratamientos alternativos y de estilo de vida para la depresión, las vitaminas son probablemente los más útiles.',
    '20. Las personas con depresión deben dejar de tomar antidepresivos en cuanto se sientan mejor.',
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
                  'Cuestionario de alfabetización sobre la depresión (D-Lit)',
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
                          'El test consta de 22 ítems que son verdaderos o falsos. Puedes responder a cada ítem con una de las tres opciones siguientes: verdadero, falso o no estoy seguro(a)',
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
                    for (int i = 1; i <= 3; i++) // Cambiado de 4 a 3
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
                            for (int i = 1; i <= 3; i++) // Cambiado de 4 a 3
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
              Text(
                  'Tu porcentaje de respuestas correctas es de: ${porcentaje.toStringAsFixed(2)}%'),
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
          'nota_depresion': porcentaje.toString(),
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
      case '1. Las personas deprimidas suelen hablar de forma incoherente.':
      case '3. El comportamiento imprudente y temerario es un signo frecuente de depresión.':
      case '5. No pisar las grietas del sendero puede ser un signo de depresión':
      case '6. Las personas con depresión suelen oír voces que no existen.':
      case '9. La depresión no afecta tu memoria y concentración.':
      case '10. Tener varias personalidades distintas puede ser un signo de depresión.':
      case '12. Los psicólogos clínicos pueden recetar antidepresivos.':
      case '14. La mayoría de las personas con depresión necesitan ser hospitalizadas.':
      case '16. Muchos tratamientos para la depresión son más efectivos que los antidepresivos':
      case '17. El asesoramiento es tan eficaz como la terapia cognitivo-conductual para la depresión.':
      case '19. De todos los tratamientos alternativos y de estilo de vida para la depresión, las vitaminas son probablemente los más útiles.':
      case '20. Las personas con depresión deben dejar de tomar antidepresivos en cuanto se sientan mejor.':
      case '21. Los antidepresivos son adictivos.':
      case '22. Los antidepresivos suelen funcionar de inmediato.':
        return 1; // La respuesta correcta es "Falso" (segundo checkbox)
      case '2. Las personas con depresión pueden sentirse culpables cuando no tienen la culpa.':
      case '4. La pérdida de confianza y la baja autoestima pueden ser síntomas de depresión.':
      case '7. Dormir demasiado o demasiado poco puede ser un signo de depresión.':
      case '8. Comer demasiado o perder el interés por la comida puede ser un signo de depresión.':
      case '11. Las personas pueden moverse más despacio o agitarse como consecuencia de su depresión.':
      case '13. La depresión moderada interrumpe la vida de una persona tanto como la esclerosis múltiple o la sordera.':
      case '15. Muchas personas famosas han sufrido de depresión':
      case '18. La terapia cognitivo-conductual es tan eficaz como los antidepresivos para la depresión leve a moderada.':
        return 0; // La respuesta correcta es "Verdadero" (primer checkbox)
      default:
        return -1; // En caso de que el item no tenga respuesta definida
    }
  }
}
