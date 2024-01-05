import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserManagementWindow extends StatefulWidget {
  @override
  _UserManagementWindowState createState() => _UserManagementWindowState();
}

class _UserManagementWindowState extends State<UserManagementWindow> {
  Future<List<Map<String, dynamic>>>? userFuture;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Controller for the editing text fields
  TextEditingController _editUserNameController = TextEditingController();
  TextEditingController _editUserPasswordController = TextEditingController();
  TextEditingController _editUserRoleController = TextEditingController();

  // Controller for the selected user to edit
  String selectedUserToEdit = '';

  // Variable para controlar el orden actual
  bool isAscendingOrderByName = true;
  bool isAscendingOrderByRole = true;

  // Método para ordenar la lista por nombre
  void _sortByName() {
    setState(() {
      isAscendingOrderByName = !isAscendingOrderByName;
      userFuture = _sortListByName(isAscendingOrderByName);
    });
  }

  // Método para ordenar la lista por rol
  void _sortByRole() {
    setState(() {
      isAscendingOrderByRole = !isAscendingOrderByRole;
      userFuture = _sortListByRole(isAscendingOrderByRole);
    });
  }

  // Método para ordenar la lista por nombre
  Future<List<Map<String, dynamic>>> _sortListByName(bool isAscending) async {
    List<Map<String, dynamic>> userList = await getUserList();
    userList.sort((a, b) => isAscending
        ? a['nombre'].compareTo(b['nombre'])
        : b['nombre'].compareTo(a['nombre']));
    return userList;
  }

  // Método para ordenar la lista por rol
  Future<List<Map<String, dynamic>>> _sortListByRole(bool isAscending) async {
    List<Map<String, dynamic>> userList = await getUserList();
    userList.sort((a, b) {
      if (isAscending) {
        if (a['rol'] == 'U' && b['rol'] == 'A') {
          return -1;
        } else if (a['rol'] == 'A' && b['rol'] == 'U') {
          return 1;
        } else {
          return a['nombre'].compareTo(b['nombre']);
        }
      } else {
        if (a['rol'] == 'A' && b['rol'] == 'U') {
          return -1;
        } else if (a['rol'] == 'U' && b['rol'] == 'A') {
          return 1;
        } else {
          return b['nombre'].compareTo(a['nombre']);
        }
      }
    });
    return userList;
  }

  @override
  void initState() {
    super.initState();
    // Llamar a la función para obtener la lista de usuarios al inicio
    userFuture = getUserList();
  }

  // Método para obtener la lista de usuarios desde el backend
  Future<List<Map<String, dynamic>>> getUserList() async {
    final response =
        await http.get(Uri.parse('http://15.228.202.64:8501/get_user_list'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<Map<String, dynamic>> userList =
          List<Map<String, dynamic>>.from(data['userList']);

      // Ordenar la lista por el nombre del usuario
      userList.sort((a, b) => a['nombre'].compareTo(b['nombre']));

      return userList;
    } else {
      print('Error al obtener la lista de usuarios');
      return [];
    }
  }

  // Controladores para los campos de texto
  TextEditingController _newUserNameController = TextEditingController();
  TextEditingController _newUserPasswordController = TextEditingController();
  TextEditingController _newUserRoleController = TextEditingController();

  // Método para agregar un nuevo usuario
  void addUser() async {
    String newUserName = _newUserNameController.text.trim();
    String newUserPassword = _newUserPasswordController.text.trim();
    String newUserRole = _newUserRoleController.text.trim();

    if (newUserName.isNotEmpty &&
        newUserPassword.isNotEmpty &&
        newUserRole.isNotEmpty) {
      try {
        final response = await http.post(
          Uri.parse('http://15.228.202.64:8501/registrar_usuario'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'nombre': newUserName,
            'contrasena': newUserPassword,
            'rol': newUserRole,
          }),
        );

        if (response.statusCode == 200) {
          print('Usuario registrado correctamente');
          // Actualizar la lista de usuarios después de registrar
          setState(() {
            userFuture = getUserList();
          });
        } else {
          // Mostrar el mensaje de error en un SnackBar
          _showErrorSnackBar('Error al registrar usuario');
        }
      } catch (e) {
        // Mostrar el mensaje de error en un SnackBar
        _showErrorSnackBar('Error al realizar la solicitud: $e');
      } finally {
        // Limpiar los campos después de agregar el usuario
        _newUserNameController.clear();
        _newUserPasswordController.clear();
        _newUserRoleController.clear();
      }
    }
  }

  void deleteUser(String userName) async {
    try {
      final response = await http.post(
        Uri.parse('http://15.228.202.64:8501/eliminar_usuario'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'nombre_usuario': userName}),
      );

      if (response.statusCode == 200) {
        print('Usuario eliminado correctamente');
        // Actualizar la lista de usuarios después de eliminar
        setState(() {
          userFuture = getUserList();
        });
      } else {
        // Mostrar el mensaje de error en un SnackBar
        _showErrorSnackBar('Error al eliminar usuario');
      }
    } catch (e) {
      // Mostrar el mensaje de error en un SnackBar
      _showErrorSnackBar('Error al realizar la solicitud: $e');
    }
  }

  // Método para mostrar un SnackBar con un mensaje de error
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Duration(seconds: 3),
      ),
    );
  }

  // Método para abrir el diálogo de edición
  void _openEditDialog(String userName) {
    // Set the selected user for editing
    selectedUserToEdit = userName;

    // Set the initial values in the edit text fields
    _editUserNameController.text = userName;
    _editUserPasswordController.text = '';
    _editUserRoleController.text = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Editar Usuario'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SizedBox(height: 8), // Añadir espacio en la parte superior

              TextField(
                controller: _editUserNameController,
                decoration: InputDecoration(
                    labelText: 'Nombre de Usuario',
                    border: OutlineInputBorder()),
              ),
              SizedBox(height: 8), // Añadir espacio en la parte superior

              TextField(
                controller: _editUserPasswordController,
                decoration: InputDecoration(
                    labelText: 'Nueva Contraseña',
                    border: OutlineInputBorder()),
              ),
              SizedBox(height: 8), // Añadir espacio en la parte superior

              TextField(
                controller: _editUserRoleController,
                decoration: InputDecoration(
                    labelText: 'Nuevo Rol (U o A)',
                    border: OutlineInputBorder()),
              ),
              SizedBox(height: 8), // Añadir espacio en la parte superior
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                // Call the function to edit the user
                editUser();
                Navigator.of(context).pop();
              },
              child: Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  // Método para editar un usuario
  void editUser() async {
    String editedUserName = _editUserNameController.text.trim();
    String editedUserPassword = _editUserPasswordController.text.trim();
    String editedUserRole = _editUserRoleController.text.trim();

    if (editedUserName.isNotEmpty) {
      try {
        final response = await http.post(
          Uri.parse('http://15.228.202.64:8501/editar_usuario'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'nombre_usuario': selectedUserToEdit,
            'nuevo_nombre': editedUserName,
            'nueva_contrasena': editedUserPassword,
            'nuevo_rol': editedUserRole,
          }),
        );

        if (response.statusCode == 200) {
          print('Usuario editado correctamente');
          // Actualizar la lista de usuarios después de editar
          setState(() {
            userFuture = getUserList();
          });
        } else {
          // Mostrar el mensaje de error en un SnackBar
          _showErrorSnackBar('Error al editar usuario');
        }
      } catch (e) {
        // Mostrar el mensaje de error en un SnackBar
        _showErrorSnackBar('Error al realizar la solicitud: $e');
      } finally {
        // Limpiar los campos después de editar el usuario
        _editUserNameController.clear();
        _editUserPasswordController.clear();
        _editUserRoleController.clear();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Gestión de Usuarios'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Registrar Nuevo Usuario',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _newUserNameController,
                    decoration: InputDecoration(
                      hintText: 'Ingrese el nuevo nombre de usuario',
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _newUserPasswordController,
                    decoration: InputDecoration(
                      hintText: 'Ingrese la nueva contraseña',
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _newUserRoleController,
                    decoration: InputDecoration(
                      hintText: 'Ingrese el nuevo rol (U o A)',
                    ),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: addUser,
                  child: Text('Registrar'),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Lista de Usuarios',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.sort_by_alpha),
                      onPressed: _sortByName,
                      tooltip: 'Ordenar por nombre',
                    ),
                    IconButton(
                      icon: Icon(Icons.sort),
                      onPressed: _sortByRole,
                      tooltip: 'Ordenar por rol',
                    ),
                  ],
                ),
              ],
            ),

            // Utilizar FutureBuilder para manejar la carga asincrónica de datos
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: userFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        // Encabezados
                        Row(
                          children: [
                            Expanded(
                              child: Text("Nombre:",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: Text("Contraseña:",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: Text("Rol:",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ),
                            SizedBox(width: 16),
                            // Añadir espacio para los íconos de acción
                            SizedBox(width: 64),
                          ],
                        ),
                        // Separador
                        Divider(height: 1, thickness: 1, color: Colors.grey),
                        // Datos
                        Expanded(
                          child: ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              final userData = snapshot.data![index];

                              return Card(
                                elevation: 2,
                                margin: EdgeInsets.symmetric(vertical: 8),
                                child: ListTile(
                                  title: Row(
                                    children: [
                                      Expanded(
                                        child: Text(userData['nombre']),
                                      ),
                                      SizedBox(width: 16),
                                      Expanded(
                                        child: Text(userData['contrasena']),
                                      ),
                                      SizedBox(width: 16),
                                      Expanded(
                                        child: Text(userData['rol']),
                                      ),
                                    ],
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          Icons.edit,
                                          color: Colors.amber,
                                        ),
                                        onPressed: () {
                                          _openEditDialog(userData['nombre']);
                                        },
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        ),
                                        onPressed: () {
                                          deleteUser(userData['nombre']);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
