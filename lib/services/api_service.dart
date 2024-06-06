import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:proyectoflutter/models/category.dart';
import 'package:proyectoflutter/models/comment.dart';
import 'package:proyectoflutter/models/topper.dart';
import 'package:proyectoflutter/models/user.dart';

class ApiService {
  static final String baseUrl = 'http://localhost:8888';
  static int? userId;
  static String? userName;

// Métodos para user
  static Future<bool> login(String username, String password) async {
    final List<Map<String, dynamic>>? users = await getUsers(); // Obtiene la lista de usuarios

    if (users == null) {
      // No se pudo obtener la lista de usuarios
      return false;
    }

    // Comprueba si la lista de usuarios es válida y no está vacía
    if (users.isEmpty) {
      // La lista de usuarios está vacía
      return false;
    }
    
    // Compara las credenciales proporcionadas con cada usuario en la lista
    for (var user in users) {
      if (user['email'] == username && user['password'] == password) {
        userId = user['id'];
        userName= user['username'];
        return true; // Credenciales válidas
      }
    }

    return false; // Credenciales inválidas
  }

  static Future<List<User>> getUser() async {
    final String usersUrl = '$baseUrl/users';
    try {
      final response = await http.get(Uri.parse(usersUrl));

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        return responseData.map((json) => User.fromJSON(json)).toList();
      } else {
        // Error en la solicitud HTTP
        print('Error en la solicitud HTTP: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      // Error en la solicitud HTTP
      print('Error durante la solicitud HTTP: $e');
      return [];
    }
  }

  static Future<List<Map<String, dynamic>>?> getUsers() async {
    final String usersUrl = '$baseUrl/users';
    try {
      final response = await http.get(Uri.parse(usersUrl));

      if (response.statusCode == 200) {
        final List<dynamic> responseData = json.decode(response.body);
        return responseData.cast<Map<String, dynamic>>();
      } else {
        // Error en la solicitud HTTP
        print('Error en la solicitud HTTP: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      // Error en la solicitud HTTP
      print('Error durante la solicitud HTTP: $e');
      return null;
    }
  }
  
  static Future<User> addUser(User user) async {
    final url = '$baseUrl/users';
    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'username': user.username,
        'email': user.email,
        'password': user.password,
        'url':null,
        'fullName':null,
        'birthDate':null
        
      }),
    );

    if (response.statusCode == 200) {
      // Si la llamada al servidor fue exitosa, parsea el JSON
      print('User agregado correctamente');
      return User.fromJSON(jsonDecode(response.body));
    } else {
      // Si la llamada no fue exitosa, lanza un error
      throw Exception('Failed to add user');
    }
  }

  static Future<void> deleteUser(int id) async {
    final String userUrl = '$baseUrl/users/$id';

    try {
      final response = await http.delete(Uri.parse(userUrl));
      if (response.statusCode == 200) {
        // Eliminación exitosa, no se devuelve nada
        print('Usuario eliminado correctamente');
      } else {
        // Si no se puede eliminar correctamente, imprime el mensaje de error recibido del servidor
        print('Error al eliminar usuario: ${response.body}');
      }
    } catch (e) {
      // Si ocurre un error durante la solicitud, imprime el mensaje de error
      print('Error al eliminar usuario: $e');
    }
  }

  static Future<void> updateUser(User user) async {
    final String userUrl = '$baseUrl/users/${user.id}';

    final response = await http.put(
      Uri.parse(userUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'username': user.username,
        'email': user.email,
        'password': user.password,
        'url':user.url,
        'fullName':user.fullName,
        'birthDate': user.birthDate
      }),
    );
    if (response.statusCode == 200) {
      // Actualización exitosa, no se devuelve nada
      print('Usuario actualizado correctamente');
    } else {
      // Si no se puede actualizar correctamente, imprime el mensaje de error recibido del servidor
      print('Error al actualizar usuario');
    }
  }

// Métodos para toppers
  static Future<List<Topper>> getToppers() async {
  final String toppersUrl = '$baseUrl/toppers';
  final response = await http.get(Uri.parse(toppersUrl));  
  if(response.statusCode == 200){
    List<dynamic> body= jsonDecode(response.body);
    List<Topper> _topperList = body.map((dynamic item) => Topper.fromJSON(item)).toList();
    return _topperList;
  } else {
    throw Exception('Error al obtener los toppers: ${response.statusCode}');
  }
}
  
  static Future<Topper> addTopper(Topper topper) async {
    final url = '$baseUrl/toppers';
    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'title': topper.title,
        'description': topper.description,
        'imageUrl': topper.imageUrl,
        'userId': topper.userId,
        'categoryId': topper.categoryId,
        'createdAt': topper.createdAt.toIso8601String(),
      }),
    );

    if (response.statusCode == 200) {
      // Si la llamada al servidor fue exitosa, parsea el JSON
      print('Topper agregado correctamente');
      return Topper.fromJSON(jsonDecode(response.body));
    } else {
      // Si la llamada no fue exitosa, lanza un error
      throw Exception('Failed to add topper');
    }
  }

  static Future<void> deleteTopper(int id) async {
  print(id);
  final String topperUrl = '$baseUrl/toppers/$id';

  try {
    final response = await http.delete(Uri.parse(topperUrl));
    if (response.statusCode == 200) {
      // Eliminación exitosa, no se devuelve nada
      print('Topper eliminado correctamente');
    } else {
      // Si no se puede eliminar correctamente, imprime el mensaje de error recibido del servidor
      print('Error al eliminar topper: ${response.body}');
    }
  } catch (e) {
    // Si ocurre un error durante la solicitud, imprime el mensaje de error
    print('Error al eliminar topper: $e');
  }
}

  static Future<void> updateTopper(Topper topper) async {
    final String topperUrl = '$baseUrl/toppers/${topper.id}';

    final response = await http.put(
      Uri.parse(topperUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'title': topper.title,
        'description': topper.description,
        'imageUrl': topper.imageUrl,
        'userId': topper.userId,
        'categoryId': topper.categoryId,
        'createdAt': topper.createdAt.toIso8601String(),
      }),
    );
    if (response.statusCode == 200) {
      // Eliminación exitosa, no se devuelve nada
      print('Topper actualizado correctamente');
    } else {
      // Si no se puede eliminar correctamente, imprime el mensaje de error recibido del servidor
      print('Error al actualizar topper');
    }
  }

// Métodos para categorías
  static Future<List<Category>> getCategories() async {
    final String categoriesUrl = '$baseUrl/category';
    final response = await http.get(Uri.parse(categoriesUrl));  
    if(response.statusCode == 200){
      List<dynamic> body = jsonDecode(response.body);
      List<Category> categories = body.map((dynamic item) => Category.fromJSON(item)).toList();
      return categories;
    } else {
      throw Exception('Error al obtener las categorías: ${response.statusCode}');
    }
  }
  
  static Future<Category> addCategory(Category category) async {
    final url = '$baseUrl/category';
    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'name': category.name,
        'description': category.description,
      }),
    );

    if (response.statusCode == 200) {
      // Si la llamada al servidor fue exitosa, parsea el JSON
      print('Categoría agregada correctamente');
      return Category.fromJSON(jsonDecode(response.body));
    } else {
      // Si la llamada no fue exitosa, lanza un error
      throw Exception('Failed to add category');
    }
  }

  static Future<void> deleteCategory(int id) async {
    final String categoryUrl = '$baseUrl/category/$id';

    try {
      final response = await http.delete(Uri.parse(categoryUrl));
      if (response.statusCode == 200) {
        // Eliminación exitosa, no se devuelve nada
        print('Categoría eliminada correctamente');
      } else {
        // Si no se puede eliminar correctamente, imprime el mensaje de error recibido del servidor
        print('Error al eliminar categoría: ${response.body}');
      }
    } catch (e) {
      // Si ocurre un error durante la solicitud, imprime el mensaje de error
      print('Error al eliminar categoría: $e');
    }
  }

  static Future<void> updateCategory(Category category) async {
    final String categoryUrl = '$baseUrl/category/${category.id}';

    final response = await http.put(
      Uri.parse(categoryUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'name': category.name,
        'description': category.description,
      }),
    );
    if (response.statusCode == 200) {
      // Actualización exitosa, no se devuelve nada
      print('Categoría actualizada correctamente');
    } else {
      // Si no se puede actualizar correctamente, imprime el mensaje de error recibido del servidor
      print('Error al actualizar categoría');
    }
  }

  // Métodos para comentarios
  static Future<List<Comment>> getComments() async {
    final String commentsUrl = '$baseUrl/comment';
    final response = await http.get(Uri.parse(commentsUrl));  
    if(response.statusCode == 200){
      List<dynamic> body = jsonDecode(response.body);
      List<Comment> comments = body.map((dynamic item) => Comment.fromJSON(item)).toList();
      return comments;
    } else {
      throw Exception('Error al obtener los comentarios: ${response.statusCode}');
    }
  }
  
  static Future<Comment> addComment(Comment comment) async {
    final url = '$baseUrl/comment';
    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'content': comment.content,
        'userId': comment.userId,
        'topperId': comment.topperId,
        'createdAt': comment.createdAt.toIso8601String(),
      }),
    );

    if (response.statusCode == 200) {
      // Si la llamada al servidor fue exitosa, parsea el JSON
      print('Comentario agregado correctamente');
      return Comment.fromJSON(jsonDecode(response.body));
    } else {
      // Si la llamada no fue exitosa, lanza un error
      throw Exception('Failed to add comment');
    }
  }

  static Future<void> deleteComment(int id) async {
    final String commentUrl = '$baseUrl/comment/$id';

    try {
      final response = await http.delete(Uri.parse(commentUrl));
      if (response.statusCode == 200) {
        // Eliminación exitosa, no se devuelve nada
        print('Comentario eliminado correctamente');
      } else {
        // Si no se puede eliminar correctamente, imprime el mensaje de error recibido del servidor
        print('Error al eliminar comentario: ${response.body}');
      }
    } catch (e) {
      // Si ocurre un error durante la solicitud, imprime el mensaje de error
      print('Error al eliminar comentario: $e');
    }
  }

  static Future<void> updateComment(Comment comment) async {
    final String commentUrl = '$baseUrl/comment/${comment.id}';

    final response = await http.put(
      Uri.parse(commentUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'content': comment.content,
        'userId': comment.userId,
        'topperId': comment.topperId,
        'createdAt': comment.createdAt.toIso8601String(),
      }),
    );
    if (response.statusCode == 200) {
      // Actualización exitosa, no se devuelve nada
      print('Comentario actualizado correctamente');
    } else {
      // Si no se puede actualizar correctamente, imprime el mensaje de error recibido del servidor
      print('Error al actualizar comentario');
    }
  }
}
