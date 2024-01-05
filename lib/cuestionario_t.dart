import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'auth.dart';

class QuestionnaireTScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: QuestionnaireT(),
    );
  }
}

class QuestionnaireT extends StatefulWidget {
  @override
  _QuestionnaireTState createState() => _QuestionnaireTState();
}

class _QuestionnaireTState extends State<QuestionnaireT> {
  bool instructionsExpanded = false;
  int currentQuestionIndex = 0;
  List<int> correctAnswers = [3, 0, 1, 3, 3, 2, 1, 2];
  int totalScore = 0;
  Map<int, int?> selectedAnswers = {};
  bool warningSnackBarDisplayed = false;

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
                  'Conocimiento sobre Técnicas de autoayuda y autorregulación emocional',
                  style: TextStyle(
                    color: Colors.white, // Cambia este valor al color blanco que desees
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
                          'Lea con detenimiento cada una de las preguntas y marque la alternativa que usted crea que es correcta.',
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ),
                      isExpanded: instructionsExpanded,
                    ),
                  ],
                ),
                SizedBox(height: 16),
                QuestionWidget(
                  question:
                      '1. ¿Qué tipo de actividades o prácticas crees que pueden ayudar a mejorar tu estado de ánimo cuando te sientes ansioso(a) o triste?',
                  options: [
                    'A. Consumir alimentos ricos en azúcar y grasas como el chocolate o las galletas, ya que pueden proporcionar un impulso temporal de energía y hacer que te sientas mejor.',
                    'B. Hacer ejercicio regularmente para liberar endorfinas y mejorar tu bienestar emocional.',
                    'C. Dedicar tiempo a ver programas de televisión de calidad o leer libros para distraerte de tus emociones y encontrar consuelo en las historias.',
                    'D. Practicar la meditación para calmar tu mente y reducir la ansiedad y la tristeza.',
                  ],
                  correctAnswer: 3,
                  questionIndex: 0,
                  onAnswerSelected: (int answer, int questionIndex) {
                    updateScore(answer, questionIndex);
                  },
                  selectedOption: selectedAnswers[0],
                ),
                SizedBox(height: 16),
                QuestionWidget(
                  question:
                      '2. ¿Crees que la respiración profunda puede ser una técnica útil para manejar el estrés y las emociones intensas?',
                  options: [
                    'A. SI',
                    'B. NO',
                    'C. NO ESTOY SEGURO(A)',
                  ],
                  correctAnswer: 0,
                  questionIndex: 1,
                  onAnswerSelected: (int answer, int questionIndex) {
                    updateScore(answer, questionIndex);
                  },
                  selectedOption: selectedAnswers[1],
                ),
                SizedBox(height: 16),
                QuestionWidget(
                  question:
                      '3. ¿Qué entiendes por "mindfulness" o atención plena? ',
                  options: [
                    'A. Mindfulness es la práctica de mantener la mente vacía de pensamientos en todo momento, lo que garantiza la felicidad perpetua.',
                    'B. Mindfulness es una técnica de meditación que implica enfocarse conscientemente en el momento presente, sin juzgar los pensamientos o sensaciones que surgen.',
                    'C. Mindfulness es un tipo de yoga extremo que involucra contorsiones físicas avanzadas mientras se medita para alcanzar un estado superior de conciencia.',
                    'D. Mindfulness es la creencia en la influencia de fuerzas cósmicas en nuestras vidas que pueden predecir el futuro y cambiar el destino.',
                  ],
                  correctAnswer: 1,
                  questionIndex: 2,
                  onAnswerSelected: (int answer, int questionIndex) {
                    updateScore(answer, questionIndex);
                  },
                  selectedOption: selectedAnswers[2],
                ),
                SizedBox(height: 16),
                QuestionWidget(
                  question:
                      '4. ¿Sabes en qué consiste la técnica de la visualización? ',
                  options: [
                    'A. La visualización es la capacidad de leer la mente de las personas a través de imágenes mentales y predecir sus pensamientos y acciones.',
                    'B. La visualización implica mirar fijamente un objeto durante largos períodos de tiempo para desarrollar habilidades de clarividencia y percepción extrasensorial.',
                    'C. La visualización es una técnica que implica cerrar los ojos y tratar de ver ilusiones ópticas para mejorar la visión física.',
                    'D. La visualización es una técnica en la que uno se imagina de manera vívida y detallada alcanzando un objetivo específico o viviendo una experiencia deseada para mejorar la concentración y aumentar la confianza.',
                  ],
                  correctAnswer: 3,
                  questionIndex: 3,
                  onAnswerSelected: (int answer, int questionIndex) {
                    updateScore(answer, questionIndex);
                  },
                  selectedOption: selectedAnswers[3],
                ),
                SizedBox(height: 16),
                QuestionWidget(
                  question: '5. ¿Qué es la práctica de la gratitud?',
                  options: [
                    'A. La práctica de la gratitud implica pagar a las personas para que te agradezcan por cosas que no has hecho, aumentando así tu autoestima.',
                    'B. La práctica de la gratitud es un ritual mágico en el que se agradece a los espíritus ancestrales por conceder deseos y fortuna.',
                    'C. La práctica de la gratitud consiste en quejarse constantemente de las cosas que no te gustan en la vida, con la esperanza de que mejoren.',
                    'D. La práctica de la gratitud implica reconocer y apreciar conscientemente las cosas buenas en tu vida, lo que puede mejorar tu bienestar emocional y tu perspectiva.',
                  ],
                  correctAnswer: 3,
                  questionIndex: 4,
                  onAnswerSelected: (int answer, int questionIndex) {
                    updateScore(answer, questionIndex);
                  },
                  selectedOption: selectedAnswers[4],
                ),
                SizedBox(height: 16),
                QuestionWidget(
                  question:
                      '6. ¿Qué efectos positivos podría tener una actividad regular que incluya movimiento físico en tu bienestar mental y emocional?',
                  options: [
                    'A. Mejora en la calidad del sueño y aumento en los niveles de energía durante el día.',
                    'B. Fortalecimiento de los músculos y mejora en la salud cardiovascular.',
                    'C. Reducción del estrés y aumento en la concentración y la claridad mental.',
                    'D. Mayor sociabilidad y mejora en las relaciones personales.',
                  ],
                  correctAnswer: 2,
                  questionIndex: 5,
                  onAnswerSelected: (int answer, int questionIndex) {
                    updateScore(answer, questionIndex);
                  },
                  selectedOption: selectedAnswers[5],
                ),
                SizedBox(height: 16),
                QuestionWidget(
                  question:
                      '7. ¿Cuáles de las siguientes estrategias consideras que pueden ser útiles para manejar la ansiedad?',
                  options: [
                    'A. Represión de emociones.',
                    'B. Meditar.',
                    'C. Ignorar los sentimientos.',
                    'D. No dormir adecuadamente.',
                  ],
                  correctAnswer: 1,
                  questionIndex: 6,
                  onAnswerSelected: (int answer, int questionIndex) {
                    updateScore(answer, questionIndex);
                  },
                  selectedOption: selectedAnswers[6],
                ),
                SizedBox(height: 16),
                QuestionWidget(
                  question:
                      '8. ¿Cuáles de las siguientes estrategias consideras que pueden ser útiles para manejar la tristeza?',
                  options: [
                    'A. Aislarse socialmente.',
                    'B. Comer comida chatarra.',
                    'C. Hablar con un consejero.',
                    'D. Ignorar la tristeza.',
                  ],
                  correctAnswer: 2,
                  questionIndex: 7,
                  onAnswerSelected: (int answer, int questionIndex) {
                    updateScore(answer, questionIndex);
                  },
                  selectedOption: selectedAnswers[7],
                ),
                Container(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      // Calcular y mostrar el puntaje total
                      showTotalScore();
                    },
                    child: Text(
                      'Calcular Puntaje Total',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                )
              ]),
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
 

  void updateScore(int selectedAnswer, int questionIndex) {
    // Verificar si la respuesta ya fue seleccionada previamente
    if (selectedAnswers.containsKey(questionIndex)) {
      // Si ya fue seleccionada, restar el puntaje si era correcta previamente
      if (selectedAnswers[questionIndex] == correctAnswers[questionIndex]) {
        totalScore--;
      }
    }

    // Asignar la nueva respuesta seleccionada
    selectedAnswers[questionIndex] = selectedAnswer;

    // Evaluar si la nueva respuesta es correcta y sumar el puntaje si es así
    if (selectedAnswer == correctAnswers[questionIndex]) {
      totalScore++;
    }

    // Actualizar la interfaz de usuario
    setState(() {});
  }

  void showTotalScore() {
    // Verificar si todas las preguntas han sido respondidas
    bool allQuestionsAnswered = selectedAnswers.length == correctAnswers.length;

    if (!allQuestionsAnswered) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Aún hay preguntas sin responder'),
            content: Text(
                'Por favor, responde todas las preguntas antes de calcular el puntaje total.'),
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
    } else {
      // Calcular el puntaje total en porcentaje
      double percentageScore = (totalScore / correctAnswers.length) * 100;

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Puntaje Total'),
            content: Text('El puntaje total es: $percentageScore%'),
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

      enviarPorcentajeAlBackend(percentageScore);
    }
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
          'nota_tecnicas': porcentaje.toString(),
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
}

class QuestionWidget extends StatefulWidget {
  final String question;
  final List<String> options;
  final int correctAnswer;
  final Function(int, int) onAnswerSelected;
  final int questionIndex;
  final int? selectedOption;

  QuestionWidget({
    required this.question,
    required this.options,
    required this.correctAnswer,
    required this.onAnswerSelected,
    required this.questionIndex,
    this.selectedOption,
  });

  @override
  _QuestionWidgetState createState() => _QuestionWidgetState();
}

class _QuestionWidgetState extends State<QuestionWidget> {
  late int? selectedOption;

  @override
  void initState() {
    super.initState();
    selectedOption = widget.selectedOption;
  }

  @override
  void didUpdateWidget(covariant QuestionWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    selectedOption = widget.selectedOption;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.question,
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: widget.options.length,
              itemBuilder: (context, i) => RadioListTile<int>(
                value: i,
                groupValue: selectedOption,
                onChanged: (value) {
                  setState(() {
                    selectedOption = value;
                    widget.onAnswerSelected(value!, widget.questionIndex);
                  });
                },
                title: Text(widget.options[i]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: QuestionnaireTScreen(),
  ));
}
