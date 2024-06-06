import 'package:flutter/material.dart';
import 'package:proyectoflutter/models/topper.dart';
import 'package:proyectoflutter/models/category.dart'; // Importa el modelo de categoría
import 'package:proyectoflutter/services/api_service.dart';

class AddTopperScreen extends StatefulWidget {
  @override
  _AddTopperScreenState createState() => _AddTopperScreenState();
}

class _AddTopperScreenState extends State<AddTopperScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _description;
  late String _imageUrl;
  Category? _selectedCategory;
  late List<Category> _categories = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadCategories();
    _title = '';
    _description = '';
    _imageUrl = '';
  }

  Future<void> _loadCategories() async {
    try {
      final categories = await ApiService.getCategories();
      setState(() {
        _categories = categories;
        _selectedCategory = _categories.isNotEmpty ? _categories[0] : null;
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
        final newTopper = Topper(
          id: 0,
          title: _title,
          description: _description,
          imageUrl: _imageUrl,
          userId: ApiService.userId ?? 0,
          createdAt: DateTime.now(),
          categoryId: _selectedCategory!.id,
        );
        final savedTopper = await ApiService.addTopper(newTopper);
        if (!mounted) return;
        Navigator.pop(context, savedTopper);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving topper: $e')),
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
        title: Text('Add Topper'),
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
