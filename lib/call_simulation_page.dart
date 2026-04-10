import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:audioplayers/audioplayers.dart';

class CallSimulationPage extends StatefulWidget {
  final String phoneNumber;
  final String scenario;

  const CallSimulationPage({
    super.key,
    required this.phoneNumber,
    required this.scenario,
  });

  @override
  State<CallSimulationPage> createState() => _CallSimulationPageState();
}

class _CallSimulationPageState extends State<CallSimulationPage> {
  final List<Map<String, String>> _chatHistory = [];
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FlutterTts flutterTts = FlutterTts();
  final AudioPlayer _audioPlayer = AudioPlayer();

  bool _isSimulating = false;
  bool _isLoadingAI = false;
  List<String> _suggestions = [];

  // UPDATE THIS TO YOUR CURRENT PC IP ADDRESS
  final String ollamaUrl = "http://192.168.1.19:11434/api/chat";

  @override
  void initState() {
    super.initState();
    _initTts();
    _startRinging();
  }

  Future<void> _initTts() async {
    await flutterTts.setLanguage("en-US");
    await flutterTts.setSpeechRate(0.5);
    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(1.0);
  }

  Future<void> _startRinging() async {
    await _audioPlayer.setReleaseMode(ReleaseMode.loop);
    await _audioPlayer.play(AssetSource('ringing.mp3'));
  }

  Future<void> _speak(String text, bool isReceptionist) async {
    await flutterTts.setPitch(isReceptionist ? 1.2 : 0.9);
    await flutterTts.speak(text);
  }

  // Robust JSON extractor to handle messy Llama 3 output
  String _extractJson(String input) {
    final start = input.indexOf('{');
    final end = input.lastIndexOf('}');
    if (start != -1 && end != -1 && end > start) {
      return input.substring(start, end + 1);
    }
    return "";
  }

  Future<void> _getAiTurn(String userLastMessage) async {
    setState(() => _isLoadingAI = true);
    try {
      final response = await http.post(
        Uri.parse(ollamaUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "model": "llama3",
          "messages": [
            {
              "role": "system",
              "content":
                  "You are the other person in a ${widget.scenario} call. "
                  "Respond to the user in ONE short sentence. "
                  "Provide 3 short suggested replies for the non-verbal user. "
                  "Respond ONLY in JSON format like this: "
                  "{\"reply\": \"Hello, how can I help?\", \"suggestions\": [\"Order food\", \"Ask price\", \"Cancel\"]}",
            },
            {"role": "user", "content": userLastMessage},
          ],
          "stream": false,
        }),
      );

      if (response.statusCode == 200) {
        final rawContent = jsonDecode(response.body)['message']['content'];
        final cleanJson = _extractJson(rawContent);

        if (cleanJson.isNotEmpty) {
          final data = jsonDecode(cleanJson);
          _addMessage("🎧 Recipient", data['reply']);
          await _speak(data['reply'], true);
          setState(() => _suggestions = List<String>.from(data['suggestions']));
        }
      }
    } catch (e) {
      debugPrint("AI Turn Error: $e");
    } finally {
      setState(() => _isLoadingAI = false);
    }
  }

  void _handleUserSend(String text) async {
    if (text.trim().isEmpty) return;
    _textController.clear();
    setState(() => _suggestions = []);

    _addMessage("🧑 User", text);
    await _speak(text, false);

    // Trigger AI response after user speaks
    _getAiTurn(text);
  }

  Future<void> _runFullSimulation() async {
    await _audioPlayer.stop();

    setState(() {
      _isSimulating = true;
      _chatHistory.clear();
      _suggestions = [];
    });

    // 1. Mandatory AI Introduction
    String intro =
        "Hello, this is an AI call assistant for a person with verbal disabilities. Please hold for their response.";
    _addMessage("🤖 Assistant", intro);
    await _speak(intro, false);

    // 2. Initial prompt based on scenario to get the conversation moving
    String initialPrompt =
        "I am calling regarding a ${widget.scenario} request.";
    _getAiTurn(initialPrompt);
  }

  void _addMessage(String sender, String text) {
    if (!mounted) return;
    setState(() => _chatHistory.add({"sender": sender, "text": text}));

    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      appBar: AppBar(
        title: const Text("Assistive Call"),
        backgroundColor: const Color(0xFF1D5CFF),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _chatHistory.length,
              itemBuilder: (context, index) {
                final msg = _chatHistory[index];
                bool isUser = msg['sender'] == "🧑 User";
                bool isAssistant = msg['sender'] == "🤖 Assistant";

                return Align(
                  alignment: isUser || isAssistant
                      ? Alignment.centerLeft
                      : Alignment.centerRight,
                  child: Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.75,
                    ),
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: isUser || isAssistant
                          ? const Color(0xFF1D5CFF)
                          : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: const [
                        BoxShadow(color: Colors.black12, blurRadius: 4),
                      ],
                    ),
                    child: Text(
                      msg['text']!,
                      style: TextStyle(
                        color: isUser || isAssistant
                            ? Colors.white
                            : Colors.black87,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          if (_isSimulating) ...[
            // LOADING INDICATOR
            if (_isLoadingAI)
              const LinearProgressIndicator(
                backgroundColor: Colors.transparent,
              ),

            // SUGGESTIONS CHIPS
            Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: _suggestions
                    .map(
                      (s) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ActionChip(
                          label: Text(s),
                          onPressed: () => _handleUserSend(s),
                          backgroundColor: Colors.white,
                          side: const BorderSide(color: Color(0xFF1D5CFF)),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),

            // KEYBOARD INPUT
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      decoration: InputDecoration(
                        hintText: "Type your message...",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onSubmitted: _handleUserSend,
                    ),
                  ),
                  const SizedBox(width: 8),
                  FloatingActionButton(
                    mini: true,
                    backgroundColor: const Color(0xFF1D5CFF),
                    onPressed: () => _handleUserSend(_textController.text),
                    child: const Icon(Icons.send, color: Colors.white),
                  ),
                ],
              ),
            ),
          ],

          // START BUTTON (STYLING FROM YOUR CALL.TXT)
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _isSimulating
                    ? () => setState(() => _isSimulating = false)
                    : _runFullSimulation,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isSimulating
                      ? Colors.redAccent
                      : const Color(0xFF1D5CFF),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  _isSimulating
                      ? "Stop Simulation"
                      : "Start Voice Call Simulation",
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    flutterTts.stop();
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
