import 'package:flutter/material.dart';
import 'package:proyectoflutter/models/topper.dart';
import 'package:proyectoflutter/models/comment.dart';
import 'package:proyectoflutter/models/user.dart';
import 'package:proyectoflutter/services/api_service.dart';

class CommentTopperScreen extends StatefulWidget {
  final Topper topper;

  const CommentTopperScreen({required this.topper, Key? key}) : super(key: key);

  @override
  _CommentTopperScreenState createState() => _CommentTopperScreenState();
}

class _CommentTopperScreenState extends State<CommentTopperScreen> {
  final TextEditingController _commentController = TextEditingController();
  bool _isLoading = true;
  List<Comment> _comments = [];
  Map<int, String> _userNames = {};

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final comments = await ApiService.getComments();
      if (comments != null) {
        final users = await ApiService.getUsers();

        if (users != null) {
          // Map userId to username
          final userNames = <int, String>{};
          for (var user in users) {
            userNames[user['id'] as int] = user['username'] as String;
          }

          // Assign usernames to comments
          for (var comment in comments) {
            comment.username = userNames[comment.userId];
          }

          setState(() {
            _comments = comments;
            _userNames = userNames;
            _isLoading = false;
          });
        } else {
          setState(() {
            _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to load users')),
          );
        }
      } else {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load comments')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load data: $e')),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _submitComment() async {
    setState(() {
      _isLoading = true;
    });

    final newComment = Comment(
      id: 0,
      content: _commentController.text,
      userId: ApiService.userId ?? 0, // Replace with the actual user ID
      username: _userNames[ApiService.userId ?? 0], // Assign the username
      topperId: widget.topper.id,
      createdAt: DateTime.now(),
    );

    try {
      final addedComment = await ApiService.addComment(newComment);
      setState(() {
        _comments.add(addedComment);
        _commentController.clear();
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Comment added successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add comment: $e')),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Filtra los comentarios para mostrar solo aquellos cuyo topperId coincida con el id del topper actual
    final filteredComments = _comments.where((comment) => comment.topperId == widget.topper.id).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Comentar en ${widget.topper.title}'),
      ),
      body: _isLoading
      ? Center(child: CircularProgressIndicator())
      : Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ListView(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 200,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(widget.topper.imageUrl),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      widget.topper.title,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    Text(
                      widget.topper.description,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Comentarios',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    SizedBox(height: 10),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: filteredComments.length,
                      itemBuilder: (context, index) {
                        final comment = filteredComments[index];
                        return ListTile(
                          title: Text('${comment.username} : ${comment.content}'),
                          subtitle: Text('Publicado en: ${comment.createdAt}'),
                        );
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Publicar',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              TextField(
                controller: _commentController,
                decoration: InputDecoration(
                  labelText: 'Comentario',
                  border: OutlineInputBorder(),
                ),
                maxLines: 1,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _isLoading ? null : _submitComment,
                child: Text('Enviar comentario'),
              ),
            ],
          ),
        ),


    );
  }
}
