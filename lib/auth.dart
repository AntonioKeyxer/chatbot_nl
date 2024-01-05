// auth.dart

bool isAuthenticated = false;
String username = '';
String userRole = '';
int userId = 0;

void setAuthenticated(bool value, String name, String role, int id) {
  isAuthenticated = value;
  username = name;
  userRole = role;
  userId = id;
}