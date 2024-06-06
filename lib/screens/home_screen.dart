import 'package:flutter/material.dart';
import 'package:proyectoflutter/models/topper.dart';
import 'package:proyectoflutter/models/category.dart';
import 'package:proyectoflutter/screens/add_comment_screen.dart';
import 'package:proyectoflutter/screens/add_topper_screen.dart';
import 'package:proyectoflutter/screens/user_perfil_screen.dart'; // Importa la clase UserProfileScreen
import 'package:proyectoflutter/services/api_service.dart';

class ToppersScreen extends StatefulWidget {
  const ToppersScreen({Key? key}) : super(key: key);

  @override
  _ToppersScreenState createState() => _ToppersScreenState();
}

class _ToppersScreenState extends State<ToppersScreen> {
  List<Topper> _toppers = [];
  List<Category> _categories = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final toppers = await ApiService.getToppers();
      final categories = await ApiService.getCategories();
      setState(() {
        _toppers = toppers;
        _categories = categories;
        _isLoading = false;
      });
    } catch (e) {
      // Manejo de errores adecuado
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching data: $e')),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  String _getCategoryName(int categoryId) {
    final category = _categories.firstWhere(
      (category) => category.id == categoryId,
      orElse: () => Category(id: 0, name: 'Unknown', description: ''),
    );
    return category.name;
  }

  Future<void> _addTopper() async {
    final newTopper = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddTopperScreen()),
    );
    if (newTopper != null) {
      setState(() {
        _toppers.add(newTopper);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Toppers'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UserProfileScreen()),
              );
            },
            icon: Icon(Icons.person),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                SizedBox(
                  height: 350, // Altura fija para la lista de tarjetas
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _toppers.length,
                    itemBuilder: (context, index) {
                      final topper = _toppers[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => CommentTopperScreen(topper: topper)),
                          );
                        },
                        child: Card(
                          margin: const EdgeInsets.all(8.0),
                          elevation: 4.0,
                          child: SizedBox(
                            width: 250, // Ancho deseado del card
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: double.infinity,
                                  height: 160, // Alto deseado del cuadro de imagen
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.vertical(top: Radius.circular(8.0)), // Bordes redondeados solo arriba
                                    image: DecorationImage(
                                      image: NetworkImage(topper.imageUrl),
                                      fit: BoxFit.cover, // Ajustar imagen al cuadro
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        topper.title,
                                        style: Theme.of(context).textTheme.headlineLarge,
                                      ),
                                      Text(
                                        topper.description,
                                        style: Theme.of(context).textTheme.headlineMedium,
                                      ),
                                      Text(
                                        _getCategoryName(topper.categoryId), // Usar función para obtener el nombre
                                        style: Theme.of(context).textTheme.headlineMedium,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTopper,
        tooltip: 'Agregar Topper',
        child: Icon(Icons.add),
      ),
    );
  }
}
