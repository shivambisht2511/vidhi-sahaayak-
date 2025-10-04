// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import '../../../data/services/gemini_service.dart';
//
// class ChatScreen extends StatefulWidget {
//   final String category;
//
//   const ChatScreen({super.key, required this.category});
//
//   @override
//   State<ChatScreen> createState() => _ChatScreenState();
// }
//
// class _ChatScreenState extends State<ChatScreen> {
//   final TextEditingController _controller = TextEditingController();
//   final List<Map<String, String>> _messages = [];
//   final GeminiService _geminiService = GeminiService();
//
//   bool _isLoading = false;
//
//   void _sendMessage() async {
//     if (_controller.text.trim().isEmpty) return;
//
//     final userMessage = _controller.text.trim();
//
//     setState(() {
//       _messages.add({"role": "user", "text": userMessage});
//       _isLoading = true;
//     });
//
//     _controller.clear();
//
//     // Gemini API Call
//     final aiReply =
//     await _geminiService.sendMessage(userMessage, widget.category);
//
//     setState(() {
//       _messages.add({"role": "ai", "text": aiReply});
//       _isLoading = false;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       drawer: Drawer(
//         width: MediaQuery.of(context).size.width * 0.6,
//         child: Column(
//           children: [
//             DrawerHeader(
//               decoration: const BoxDecoration(color: Colors.deepPurple),
//               child: Align(
//                 alignment: Alignment.bottomLeft,
//                 child: Text(
//                   "Law AI Assistant",
//                   style: GoogleFonts.poppins(
//                     color: Colors.white,
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//             ),
//             ListTile(
//               leading: const Icon(Icons.history),
//               title: const Text("Chat History"),
//               onTap: () {},
//             ),
//             const Divider(),
//             ListTile(
//               leading: const Icon(Icons.login),
//               title: const Text("Sign in with Google"),
//               onTap: () {},
//             ),
//           ],
//         ),
//       ),
//       appBar: AppBar(
//         title: Text(
//           widget.category,
//           style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
//         ),
//         backgroundColor: Colors.deepPurple,
//         foregroundColor: Colors.white,
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               padding: const EdgeInsets.all(12),
//               itemCount: _messages.length,
//               itemBuilder: (context, index) {
//                 final msg = _messages[index];
//                 final isUser = msg["role"] == "user";
//
//                 return Align(
//                   alignment:
//                   isUser ? Alignment.centerRight : Alignment.centerLeft,
//                   child: Container(
//                     margin: const EdgeInsets.symmetric(vertical: 4),
//                     padding:
//                     const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
//                     decoration: BoxDecoration(
//                       color: isUser
//                           ? Colors.deepPurple
//                           : Colors.deepPurple.shade100,
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Text(
//                       msg["text"]!,
//                       style: GoogleFonts.poppins(
//                         color: isUser ? Colors.white : Colors.black87,
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//
//           if (_isLoading)
//             const Padding(
//               padding: EdgeInsets.all(8),
//               child: CircularProgressIndicator(color: Colors.deepPurple),
//             ),
//
//           // Input Field
//           Container(
//             padding: const EdgeInsets.all(8),
//             decoration: BoxDecoration(
//               color: Colors.grey.shade100,
//               border: const Border(
//                 top: BorderSide(color: Colors.black12),
//               ),
//             ),
//             child: Row(
//               children: [
//                 Expanded(
//                   child: TextField(
//                     controller: _controller,
//                     decoration: InputDecoration(
//                       hintText: "Type your message...",
//                       border: InputBorder.none,
//                       hintStyle: GoogleFonts.poppins(color: Colors.grey),
//                     ),
//                     onSubmitted: (_) => _sendMessage(),
//                   ),
//                 ),
//                 IconButton(
//                   icon: const Icon(Icons.send, color: Colors.deepPurple),
//                   onPressed: _sendMessage,
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../data/services/gemini_service.dart';
import '../drawer/app_drawer.dart';

class ChatScreen extends StatefulWidget {
  final String category;

  const ChatScreen({super.key, required this.category});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  final GeminiService _geminiService = GeminiService();

  bool _isLoading = false;

  // 🔹 Guest restriction variables
  int _guestMessageCount = 0;
  bool _isLoggedIn = false;

  void _sendMessage() async {
    if (_controller.text.trim().isEmpty) return;

    // 🚫 Restrict guest after 2 messages
    if (!_isLoggedIn && _guestMessageCount >= 2) {
      _showLoginDialog();
      return;
    }

    final userMessage = _controller.text.trim();

    setState(() {
      _messages.add({"role": "user", "text": userMessage});
      _isLoading = true;
      if (!_isLoggedIn) _guestMessageCount++;
    });

    _controller.clear();

    // Gemini API Call
    final aiReply =
    await _geminiService.sendMessage(userMessage, widget.category);

    setState(() {
      _messages.add({"role": "ai", "text": aiReply});
      _isLoading = false;
    });
  }

  // 🔹 Popup when limit reached
  void _showLoginDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Sign in Required"),
        content: const Text(
          "You’ve reached the free limit (2 messages). Please sign in with Google to continue chatting.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              _loginWithGoogle();
            },
            child: const Text("Sign in"),
          ),
        ],
      ),
    );
  }

  // 🔹 Temporary login function (future me Firebase ayega)
  void _loginWithGoogle() {
    setState(() {
      _isLoggedIn = true;
      _guestMessageCount = 0; // reset guest limit
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("✅ Signed in successfully (demo mode)")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(
        isLoggedIn: _isLoggedIn,
        userName: _isLoggedIn ? "Demo User" : null,
        userEmail: _isLoggedIn ? "demo@gmail.com" : null,
        userPhoto: null,
      ),
      appBar: AppBar(
        title: Text(
          widget.category,
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // 🔹 Chat messages
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isUser = msg["role"] == "user";

                return Align(
                  alignment:
                  isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                    decoration: BoxDecoration(
                      color: isUser
                          ? Colors.deepPurple
                          : Colors.deepPurple.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      msg["text"]!,
                      style: GoogleFonts.poppins(
                        color: isUser ? Colors.white : Colors.black87,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(8),
              child: CircularProgressIndicator(color: Colors.deepPurple),
            ),

          // 🔹 Input Field
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              border: const Border(
                top: BorderSide(color: Colors.black12),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Type your message...",
                      border: InputBorder.none,
                      hintStyle: GoogleFonts.poppins(color: Colors.grey),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.deepPurple),
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


