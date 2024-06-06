import 'package:flutter/material.dart';
import 'package:proyectoflutter/models/topper.dart';
import 'package:proyectoflutter/models/category.dart'; 
import 'package:proyectoflutter/services/api_service.dart';

class UpdateTopperScreen extends StatefulWidget {
  final Topper topper;

  const UpdateTopperScreen({required this.topper, Key? key}) : super(key: key);

  @override
  _UpdateTopperScreenState createState() => _UpdateTopperScreenState();
}

class _UpdateTopperScreenState extends State<UpdateTopperScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _description;
  late String _imageUrl;
  Category? _selectedCategory; // Cambiado a Category nullable
  late List<Category> _categories = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _title = widget.topper.title;
    _description = widget.topper.description;
    _imageUrl = widget.topper.imageUrl;
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    try {
      final categories = await ApiService.getCategories();
      setState(() {
        _categories = categories;
        _selectedCategory = _categories.isNotEmpty ? _categories[0] : null; // Inicializa la categoría seleccionada
      });
    } catch (e) {
      print('Error loading categories: $e');
    }
  }

  Future<void> _saveTopper() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
      });

      try {
        final updatedTopper = Topper(
          id: widget.topper.id,
          title: _title,
          description: _description,
          imageUrl: _imageUrl,
          userId: widget.topper.userId,
          createdAt: widget.topper.createdAt,
          categoryId: _selectedCategory!.id, // Asigna la categoría seleccionada
        );
        await ApiService.updateTopper(updatedTopper);
        if (!mounted) return;
        Navigator.pop(context); // No need to pass a result
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating topper: $e')),
        );
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Topper'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextFormField(
                        initialValue: _title,
                        decoration: InputDecoration(labelText: 'Title'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a title';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _title = value!;
                        },
                      ),
                      TextFormField(
                        initialValue: _description,
                        decoration: InputDecoration(labelText: 'Description'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a description';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _description = value!;
                        },
                      ),
                      TextFormField(
                        initialValue: _imageUrl,
                        decoration: InputDecoration(labelText: 'Image URL'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter an image URL';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _imageUrl = value!;
                        },
                      ),
                      DropdownButtonFormField<Category>(
                        value: _selectedCategory,
                        items: _categories.map((category) {
                          return DropdownMenuItem<Category>(
                            value: category,
                            child: Text(category.name),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedCategory = value!;
                          });
                        },
                        decoration: InputDecoration(labelText: 'Category'),
                        validator: (value) {
                          if (value == null) {
                            return 'Please select a category';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _saveTopper,
                        child: Text('Save'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
