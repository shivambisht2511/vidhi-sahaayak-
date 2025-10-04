import 'dart:convert';
import 'package:http/http.dart' as http;

class GeminiService {
  final String apiKey = "AIzaSyAXSylR3MEoraifNZ0sAPmIclFcePH-VsE";

  Future<String> sendMessage(String message, String category) async {
    final url = Uri.parse(
        "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$apiKey");

    final headers = {"Content-Type": "application/json"};

    // 👇 Prompt modified
    final body = jsonEncode({
      "contents": [
        {
          "parts": [
            {
              "text": """
You are an AI Assistant. Your role depends on the selected category:

1. If category = "I need a lawyer" OR "I need legal guidance":
   - Act as a professional LAW expert.
   - Only answer law-related queries.
   - If user asks non-legal questions, reply: ⚠ Sorry, I can only answer legal queries.

2. If category = "I need a study companion":
   - Act as a helpful Study Assistant.
   - Explain concepts in simple words with examples.
   - Never give legal advice.

3. If category = "I need an Ai Assistant":
   - Act as a general AI Assistant.
   - Answer normal day-to-day queries.

4. If category = "Other":
   - Reply casually and keep answers short.

Selected Category: $category
User: $message
"""
            }
          ]
        }
      ]
    });

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      try {
        return data["candidates"][0]["content"]["parts"][0]["text"];
      } catch (e) {
        return "⚠ AI could not generate a proper response.";
      }
    } else {
      return "⚠ Error: ${response.body}";
    }
  }
}
