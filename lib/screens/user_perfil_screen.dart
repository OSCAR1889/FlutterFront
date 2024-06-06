import 'package:flutter/material.dart';
import 'package:proyectoflutter/models/user.dart';
import 'package:proyectoflutter/models/topper.dart';
import 'package:proyectoflutter/screens/update_topper_screen.dart';
import 'package:proyectoflutter/screens/update_user_screen.dart';
import 'package:proyectoflutter/services/api_service.dart';

class UserProfileScreen extends StatefulWidget {
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  late User _user = User(id: 0, username: '', email: '', password: '');
  late List<Topper> _userToppers = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final List<User>? users = await ApiService.getUser();
      if (users == null) {
        throw Exception('Failed to load users');
      }

      final List<Topper> toppers = await ApiService.getToppers();

      final userId = ApiService.userId;
      final user = users.firstWhere(
        (user) => user.id == userId,
        orElse: () {
          print('No se encontró ningún usuario con el ID correspondiente');
          return User(
            id: -1,
            username: 'Usuario Predeterminado',
            email: '',
            password: '',
          );
        },
      );

      final List<Topper> userToppers =
          toppers.where((topper) => topper.userId == userId).toList();

      setState(() {
        _user = user;
        _userToppers = userToppers;
        _isLoading = false;
      });
    } catch (e) {
      // Error handling
      print('Error loading user data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _updateTopper(Topper topper) async {
    final updatedTopper = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => UpdateTopperScreen(topper: topper)),
    );
    if (updatedTopper != null) {
      setState(() {
        final index = _userToppers
            .indexWhere((element) => element.id == updatedTopper.id);
        if (index != -1) {
          _userToppers[index] = updatedTopper;
        }
      });
    }
  }

  Future<void> _deleteTopper(int topperId) async {
    try {
      await ApiService.deleteTopper(topperId);
      setState(() {
        _userToppers.removeWhere((topper) => topper.id == topperId);
      });
    } catch (e) {
      print('Error deleting topper: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil de Usuario'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 20),
                  _buildProfileHeader(),
                  SizedBox(height: 20),
                  _buildUserToppers(),
                ],
              ),
            ),
    );
  }

  ImageProvider<Object>? _getUserImageProvider(User user) {
    if (user.url != null && user.url!.isNotEmpty) {
      return NetworkImage(user.url!);
    } else {
      return AssetImage('assets/images/avatar.png');
    }
  }

  ImageProvider<Object>? _getTopperImageProvider(Topper topper) {
    if (topper.imageUrl != null && topper.imageUrl!.isNotEmpty) {
      return NetworkImage(topper.imageUrl!);
    } else {
      return AssetImage('assets/images/avatar.png');
    }
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        CircleAvatar(
          radius: 60,
          backgroundImage: _getUserImageProvider(_user),
        ),
        SizedBox(height: 10),
        Text(
          _user.username ?? 'Nombre de Usuario',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UpdateUserProfileScreen(user: _user),
              ),
            );
          },
          child: Text('Editar Perfil'),
        ),
      ],
    );
  }

  Widget _buildUserToppers() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: _userToppers.length,
      itemBuilder: (context, index) {
        final topper = _userToppers[index];
        return ListTile(
          leading: CircleAvatar(
            radius: 30,
            backgroundImage: _getTopperImageProvider(topper),
          ),
          title: Text(topper.title),
          subtitle: Text(topper.description),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () => _updateTopper(topper),
              ),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () => _deleteTopper(topper.id),
              ),
            ],
          ),
        );
      },
    );
  }
}
