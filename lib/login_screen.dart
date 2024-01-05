import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'auth.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final BuildContext context;

  LoginScreen(this.context);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Iniciar sesión'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Stack(
            children: [
              Container(
                margin: EdgeInsets.only(top: 120),
                width: 500,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  color: Color.fromRGBO(0, 0, 0, 0.053),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.all(16.0),
                  children: [
                    TextField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        labelText: 'Nombre de usuario',
                        icon: Icon(Icons.person),
                        hintStyle: TextStyle(color: Colors.blue),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Contraseña',
                        icon: Icon(Icons.lock),
                        hintStyle: TextStyle(color: Colors.blue),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        final username = _usernameController.text;
                        final password = _passwordController.text;
                        final response = await http.post(
                          Uri.parse('http://15.228.202.64:8501/login'),
                          headers: <String, String>{
                            'Content-Type': 'application/json',
                          },
                          body: jsonEncode(<String, String>{
                            'username': username,
                            'password': password,
                          }),
                        );
                        if (response.statusCode == 200) {
                          final responseData = jsonDecode(response.body);
                          final message = responseData["message"];
                          final data = responseData["data"];
                          final role = responseData["role"];
                          print('Mensaje del servidor: $message');
                          if (data == 1) {
                            setAuthenticated(
                                true, username, role, responseData["user_id"]);
                            Navigator.pushNamed(context, '/main');
                          } else {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Inicio de sesión fallido'),
                                  content: Text(message.toString()),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text('Cerrar'),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                          _usernameController.clear();
                          _passwordController.clear();
                        } else {
                          print('Inicio de sesión fallido');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blue,
                        onPrimary: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)
                        ),
                        fixedSize: Size(100, 40),
                      ),
                      child: Text('Iniciar sesión',
                      style: TextStyle(fontSize: 18),),
                    ),
                  ],
                ),
              ),
              // Imagen en la parte superior centrada
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15.0),
                      topRight: Radius.circular(15.0),
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15.0),
                      topRight: Radius.circular(15.0),
                    ),
                    child: Image.network(
                      'https://iili.io/HIO1NSI.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}