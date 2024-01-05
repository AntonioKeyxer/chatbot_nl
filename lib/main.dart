import 'package:dialog_flowtter/dialog_flowtter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialogflow/auth.dart';
import 'login_screen.dart';
import 'Messages.dart';
import 'VideoPlayerDialog.dart';
import 'second_window.dart';
import 'cuestionario.dart';
import 'cuestionario_d.dart';
import 'cuestionario_t.dart';
import 'cuestionario_c.dart';
import 'cuestionario_a.dart';
import 'usuariosControl.dart';
import 'mostrar_notas.dart';
import 'dart:math';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  final Brightness _brightness = Brightness.dark;
  

  @override
  Widget build(BuildContext context) {

    final ScrollController scrollController = ScrollController();
    

    return Builder(
      builder: (BuildContext context) {
        return MaterialApp(
          title: 'AMBot',
          theme: ThemeData(
            brightness: _brightness,
            primaryColor: Colors.white,
            inputDecorationTheme: InputDecorationTheme(
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
              focusColor: Colors.blue,
            ),
          ),
          /*initialRoute: '/login',*/
          initialRoute: '/main',
          routes: {
            '/login': (context) => LoginScreen(context),
            '/main': (context) {
              if (isAuthenticated) {
                return Home(
                  scrollController: scrollController,
                );
              } else {
                // return LoginScreen(context);
                return Home(
                  scrollController: scrollController,
                );
              }
            },
            '/second_window': (context) => SecondWindow(),
            '/user_management': (context) {
              return userRole == 'A' ? UserManagementWindow() : Container();
            },
            '/cuestionario': (context) => QuestionnaireScreen(),
            '/cuestionariod': (context) => QuestionnaireDScreen(),
            '/cuestionariot': (context) => QuestionnaireTScreen(),
            '/cuestionarioc': (context) => QuestionnaireCScreen(),
            '/cuestionarioa': (context) => QuestionnaireAScreen(),
            '/mostrar_notas': (context) {
              return userRole == 'A' ? MostrarNotasScreen() : Container();
            },
          },
        );
      },
    );
  }

}


class Home extends StatefulWidget {
  final ScrollController scrollController;

  const Home({Key? key, required this.scrollController}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late DialogFlowtter dialogFlowtter;
  final TextEditingController _controller = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<Map<String, dynamic>> messages = [];

  @override
  void initState() {
    DialogFlowtter.fromFile().then((instance) => dialogFlowtter = instance);

    sendWelcomeMessage();

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      widget.scrollController
          .jumpTo(widget.scrollController.position.maxScrollExtent);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            /* IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),*/
            SizedBox(width: 8),
            Text('EMMA-Bot'),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app_rounded),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/login');
              setAuthenticated(false, '', '', 0);
            },
          ),
        ],
      ),
      drawer: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.blue.withOpacity(0.5),
        ),
        child: Drawer(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: 15),
                Container(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                SizedBox(height: 25),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/cuestionarioa');
                  },
                  style: ElevatedButton.styleFrom(
                    primary: const Color.fromARGB(221, 65, 65, 65),
                    onPrimary: Colors.white,
                    textStyle: TextStyle(
                      fontSize: 15, // Tamaño del texto ajustado
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal:
                          24, // Ajuste el espacio horizontal según sea necesario
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.description),
                          SizedBox(
                              width:
                                  4), // Ajuste el espacio entre el icono y el texto
                          Text('Demuestra tu conocimiento:',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      SizedBox(
                          height:
                              4), // Ajuste el espacio entre las líneas de texto
                      Text('        Inicia el cuestionario sobre'),
                      Text('        ansiedad'),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/cuestionarioc');
                  },
                  style: ElevatedButton.styleFrom(
                    primary: const Color.fromARGB(221, 65, 65, 65),
                    onPrimary: Colors.white,
                    textStyle: TextStyle(
                      fontSize: 15, // Tamaño del texto ajustado
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal:
                          24, // Ajuste el espacio horizontal según sea necesario
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.description),
                          SizedBox(
                              width:
                                  4), // Ajuste el espacio entre el icono y el texto
                          Text('Demuestra tu conocimiento:',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      SizedBox(
                          height:
                              4), // Ajuste el espacio entre las líneas de texto
                      Text('        Inicia el cuestionario sobre'),
                      Text('        depresion'),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/cuestionariot');
                  },
                  style: ElevatedButton.styleFrom(
                    primary: const Color.fromARGB(221, 65, 65, 65),
                    onPrimary: Colors.white,
                    textStyle: TextStyle(
                      fontSize: 15, // Tamaño del texto ajustado
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical: 16,
                      horizontal:
                          24, // Ajuste el espacio horizontal según sea necesario
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.description),
                          SizedBox(
                              width:
                                  4), // Ajuste el espacio entre el icono y el texto
                          Text('Evalúa tus habilidades:',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      SizedBox(
                          height:
                              4), // Ajuste el espacio entre las líneas de texto
                      Text('        Haz clic para explorar'),
                      Text('        técnicas de autocontrol'),
                    ],
                  ),
                ),
                SizedBox(height: 32),
                if (userRole == 'A')
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/user_management');
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Color.fromARGB(243, 255, 200, 0),
                      onPrimary: const Color.fromARGB(255, 0, 0, 0),
                      textStyle: TextStyle(
                        fontSize: 15, // Tamaño del texto ajustado
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal:
                            24, // Ajuste el espacio horizontal según sea necesario
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.manage_accounts_rounded),
                            SizedBox(
                                width:
                                    4), // Ajuste el espacio entre el icono y el texto
                            Text('Administrar Usuarios:',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                        SizedBox(
                            height:
                                4), // Ajuste el espacio entre las líneas de texto
                        Text('        Manejar Usuarios'),
                        Text('        de la app'),
                      ],
                    ),
                  ),
                SizedBox(height: 16),
                if (userRole == 'A')
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/mostrar_notas');
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Color.fromARGB(243, 255, 200, 0),
                      onPrimary: Color.fromARGB(255, 0, 0, 0),
                      textStyle: TextStyle(
                        fontSize: 15, // Tamaño del texto ajustado
                      ),
                      padding: EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal:
                            24, // Ajuste el espacio horizontal según sea necesario
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.article_rounded),
                            SizedBox(
                                width:
                                    4), // Ajuste el espacio entre el icono y el texto
                            Text('Notas Alumnos:',
                                style: TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                        SizedBox(
                            height:
                                4), // Ajuste el espacio entre las líneas de texto
                        Text('        Observar Notas'),
                        Text('        de los usuarios'),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
      body: Builder(
        builder: (BuildContext context) {
          return Column(
            children: [
              Expanded(
                child: MessagesScreen(
                  messages: messages,
                  scrollController: widget.scrollController,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                color: Color.fromARGB(255, 0, 95, 173),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: "Escribir Mensaje",  // Texto de fondo
                          hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          isDense: true,
                        ),
                        onSubmitted: (text) {
                          sendMessage(text);
                          _controller.clear();
                        },
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        sendMessage(_controller.text);
                        _controller.clear();
                      },
                      icon: Icon(Icons.send),
                    ),
                    SizedBox(width: 16),
                    /*if (userRole == 'A')
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/user_management');
                        },
                        child: Text('Ir a la gestión de usuarios'),
                      ),
                    if (userRole == 'A')
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/mostrar_notas');
                        },
                        child: Text('Ver notas'),
                      ),*/
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void sendWelcomeMessage() async {
    final List<String> welcomeMessages = [
      "¡Hola! Soy Emma tu chatbot de apoyo emocional. Estoy aquí para ayudarte a manejar la ansiedad y la depresión. ¿Qué deseas hacer hoy?",
      "Hola! Estoy aquí como tu chatbot de apoyo emocional. ¿En qué puedo colaborar contigo hoy?",
      "Hey, ¿cómo puedo contribuir a tu bienestar emocional hoy?",
      "Hola, soy Emma tu chatbot de apoyo emocional. ¿En qué puedo ser de ayuda en este momento?",
    ];

    final Random random = Random();
    final int index = random.nextInt(welcomeMessages.length);

    final String welcomeMessage = welcomeMessages[index];
    final String optionsMessage = """   
Estas son algunas cosas que puedes pedirme:\n
1. Puedo Brindarte Información sobre la Ansiedad.
2. Puedo Darte Información sobre la Depresión.
3. Puedo Enseñarte Técnicas de autocontrol emocional.
4. Puedo Mostrarte Videos sobre la Ansiedad o Depresión.
5. Puedo Proveer Cuestionarios o Tests de evaluación de Ansiedad o de Depresión.
6. También puedo ayudarte a contactar con un Profesional.
7. O simplemente puedes contarme como te sientes.
""";

    // Envía un mensaje de bienvenida al usuario al iniciar la conversación
    addMessage(Message(text: DialogText(text: [welcomeMessage])), false);

    // Envía el segundo mensaje con las opciones
    addMessage(Message(text: DialogText(text: [optionsMessage])), false);
  }

  sendMessage(String text) async {
    if (text.isEmpty) {
      print('Message is empty');
    } else {
      setState(() {
        addMessage(Message(text: DialogText(text: [text])), true);
      });

      DetectIntentResponse response = await dialogFlowtter.detectIntent(
        queryInput: QueryInput(text: TextInput(text: text)),
      );

      if (response.message == null) return;

      setState(() {
        addMessage(response.message!);
      });

      WidgetsBinding.instance!.addPostFrameCallback((_) {
        widget.scrollController.animateTo(
          widget.scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      });

      //PARTE QUE ABRE EL VIDEO DESDE EL CHATBOT...

      if (response.queryResult?.fulfillmentMessages!.nonNulls.last.text!.text!
                  .first !=
              null &&
          response.queryResult?.fulfillmentMessages!.nonNulls.first.text!.text!
                  .first ==
              "Aquí está el video que solicitaste.") {
        var videoUrl = response
            .queryResult?.fulfillmentMessages!.nonNulls.last.text!.text!.first;
        String url = videoUrl.toString();

        openVideoPlayer(url);
      } else {}

      //PARTE QUE ABRE EL CUESTIONARIO EVALUA SINTOMAS DE ANSIEDAD-DEPRESIÓN DESDE EL CHATBOT...

      if (response.queryResult?.fulfillmentMessages!.nonNulls.last.text!.text!
                  .first !=
              null &&
          response.queryResult?.fulfillmentMessages!.nonNulls.first.text!.text!
                  .first ==
              "El siguiente cuestionario te puede ayudar a saber si tienes ansiedad") {
        Navigator.pushNamed(context, '/cuestionario');
      } else if (response.queryResult?.fulfillmentMessages!.nonNulls.last.text!
                  .text!.first !=
              null &&
          response.queryResult?.fulfillmentMessages!.nonNulls.first.text!.text!
                  .first ==
              "El siguiente cuestionario te puede ayudar a saber si tienes depresion") {
        Navigator.pushNamed(context, '/cuestionariod');
      } else {}
    }
  }

  addMessage(Message message, [bool isUserMessage = false]) {
    messages.add({'message': message, 'isUserMessage': isUserMessage});
  }


  // Método para abrir el reproductor de video con la URL
  void openVideoPlayer(String videoUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return VideoPlayerDialog(
          videoUrl: videoUrl,
        );
      },
    );
  }
  // Método para abrir el reproductor de video con la URL

  
}