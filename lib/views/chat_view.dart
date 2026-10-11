import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:io';

class ChatView extends StatefulWidget {
  const ChatView({super.key});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final List<Map<String, dynamic>> _messages = [];
  final TextEditingController _msgController = TextEditingController();
  
  late final AudioRecorder _audioRecorder;
  late final AudioPlayer _audioPlayer;
  bool _isRecording = false;
  String? _recordedFilePath;

  @override
  void initState() {
    super.initState();
    _audioRecorder = AudioRecorder();
    _audioPlayer = AudioPlayer();
  }

  @override
  void dispose() {
    _audioRecorder.dispose();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _startRecording() async {
    try {
      if (await _audioRecorder.hasPermission()) {
        final path = '${Directory.systemTemp.path}/audio_${DateTime.now().millisecondsSinceEpoch}.m4a';
        await _audioRecorder.start(const RecordConfig(), path: path);
        setState(() {
          _isRecording = true;
          _recordedFilePath = path;
        });
      }
    } catch (e) {
      debugPrint('Error starting record: $e');
    }
  }

  Future<void> _stopRecording() async {
    final path = await _audioRecorder.stop();
    setState(() {
      _isRecording = false;
      if (path != null) {
        _recordedFilePath = path;
        _messages.add({'type': 'audio', 'path': _recordedFilePath, 'isMe': true});
      }
    });
  }

  void _sendMessage() {
    if (_msgController.text.isNotEmpty) {
      setState(() {
        _messages.add({'type': 'text', 'text': _msgController.text, 'isMe': true});
        _msgController.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الدردشة الخاصة', style: TextStyle(color: Color(0xFFD4AF37))),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isMe = msg['isMe'];
                return Align(
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isMe ? const Color(0xFF8A2BE2).withOpacity(0.4) : const Color(0xFF1A1A24),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: msg['type'] == 'text'
                        ? Text(msg['text'])
                        : Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.play_arrow, color: Color(0xFFD4AF37)),
                                onPressed: () async {
                                  await _audioPlayer.play(DeviceFileSource(msg['path']));
                                },
                              ),
                              const Text('مقطع صوتي مسجل 🎙️'),
                            ],
                          ),
                  ),
                );
              },
            ),
          ),
          // شريط إرسال الرسائل والتسجيل الصوتي
          Container(
            padding: const EdgeInsets.all(8),
            color: const Color(0xFF161622),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _msgController,
                    decoration: const InputDecoration(
                      hintText: 'اكتب رسالة...',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(_isRecording ? Icons.stop : Icons.mic, color: _isRecording ? Colors.red : const Color(0xFFD4AF37)),
                  onPressed: _isRecording ? _stopRecording : _startRecording,
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Color(0xFFD4AF37)),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
