import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class FeedView extends StatefulWidget {
  const FeedView({super.key});

  @override
  State<FeedView> createState() => _FeedViewState();
}

class _FeedViewState extends State<FeedView> {
  final List<Map<String, dynamic>> _posts = [
    {
      'username': 'أحمد الأحمد',
      'content': 'أهلاً بك في التطبيق الفاخر الجديد! تجربة فريدة بتصميم عصري.',
      'image': '',
      'likes': 142,
    }
  ];

  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;
  final TextEditingController _postController = TextEditingController();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  void _createPost() {
    if (_postController.text.isNotEmpty || _selectedImage != null) {
      setState(() {
        _posts.insert(0, {
          'username': 'مستخدم مميز',
          'content': _postController.text,
          'image': _selectedImage?.path ?? '',
          'likes': 0,
        });
        _postController.clear();
        _selectedImage = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('المجتمع الفاخر', style: TextStyle(color: Color(0xFFD4AF37), fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          // صندوق كتابة منشور جديد
          Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A24),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFD4AF37).withOpacity(0.3)),
            ),
            child: Column(
              children: [
                TextField(
                  controller: _postController,
                  decoration: const InputDecoration(
                    hintText: 'ما الذي يجول في خاطرك؟',
                    border: InputBorder.none,
                  ),
                  maxLines: 3,
                ),
                if (_selectedImage != null)
                  Stack(
                    children: [
                      Image.file(_selectedImage!, height: 100, width: double.infinity, fit: BoxFit.cover),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.red),
                        onPressed: () => setState(() => _selectedImage = null),
                      ),
                    ],
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.image, color: Color(0xFFD4AF37)),
                      onPressed: _pickImage,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFD4AF37),
                        foregroundColor: Colors.black,
                      ),
                      onPressed: _createPost,
                      child: const Text('نشر'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // قائمة المنشورات
          Expanded(
            child: ListView.builder(
              itemCount: _posts.length,
              itemBuilder: (context, index) {
                final post = _posts[index];
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF161622),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const CircleAvatar(backgroundColor: Color(0xFFD4AF37), child: Icon(Icons.person, color: Colors.black)),
                          const SizedBox(width: 10),
                          Text(post['username'], style: const TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(post['content']),
                      if (post['image'].isNotEmpty) ...[
                        const SizedBox(height: 10),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(File(post['image']), height: 200, width: double.infinity, fit: BoxFit.cover),
                        ),
                      ],
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.favorite_border, color: Color(0xFFD4AF37)),
                            onPressed: () {},
                          ),
                          Text('${post['likes']}'),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
