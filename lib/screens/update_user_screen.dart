import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Para formatear fechas
import 'package:proyectoflutter/models/user.dart';
import 'package:proyectoflutter/services/api_service.dart';

class UpdateUserProfileScreen extends StatefulWidget {
  final User user;

  const UpdateUserProfileScreen({Key? key, required this.user}) : super(key: key);

  @override
  _UpdateUserProfileScreenState createState() => _UpdateUserProfileScreenState();
}

class _UpdateUserProfileScreenState extends State<UpdateUserProfileScreen> {
  late TextEditingController _fullNameController;
  late DateTime _birthDate;
  late String _imageUrl;

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController(text: widget.user.fullName ?? '');
    _birthDate = widget.user.birthDate ?? DateTime.now();
    _imageUrl = widget.user.url ?? '';
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    super.dispose();
  }

  Future<void> _updateUserProfile() async {
    final updatedUser = User(
      id: widget.user.id,
      username: widget.user.username,
      email: widget.user.email,
      password: widget.user.password,
      fullName: _fullNameController.text,
      birthDate: _birthDate,
      url: _imageUrl, // URL de la imagen
    );

    try {
      await ApiService.updateUser(updatedUser);
       print('Exito');
    } catch (e) {
      print('Error updating user profile: $e');
    }
  }

  Future<void> _selectBirthDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _birthDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null && pickedDate != _birthDate) {
      setState(() {
        _birthDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Profile'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _fullNameController,
              decoration: InputDecoration(
                labelText: 'Full Name',
              ),
            ),
            SizedBox(height: 16.0),
            InkWell(
              onTap: () {
                _selectBirthDate(context);
              },
              child: InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Birth Date',
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      DateFormat('dd/MM/yyyy').format(_birthDate),
                      style: TextStyle(fontSize: 16.0),
                    ),
                    Icon(Icons.calendar_today),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              initialValue: _imageUrl,
              onChanged: (value) {
                setState(() {
                  _imageUrl = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Image URL',
              ),
            ),
            SizedBox(height: 16.0),
            _imageUrl.isNotEmpty
                ? Image.network(
                    _imageUrl,
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                  )
                : SizedBox(height: 100, width: 100, child: Placeholder()),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _updateUserProfile,
              child: Text('Update Profile'),
            ),
          ],
        ),
      ),
    );
  }
}
