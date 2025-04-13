import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SenderPage extends StatefulWidget {
  final Map<String, dynamic> sender;
  
  const SenderPage({super.key, required this.sender});

  @override
  SenderPageState createState() => SenderPageState();
}

class SenderPageState extends State<SenderPage> {
  late TextEditingController emailController;
  final TextEditingController contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController(text: widget.sender['email']);
  }

  Future<void> sendEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: widget.sender['email'], // Fixed recipient
      queryParameters: {
        'subject': 'Internship Application',
        'body': contentController.text,
      },
    );

    if (!await launchUrl(emailUri)) {
      showMessage("Could not open email app.");
    }
  }

  void showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Applying Page",
          style: TextStyle(fontSize: 20, color: Colors.indigo),
        ),
        centerTitle: true,
        elevation: 1,
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          double mainWidth = constraints.maxWidth > 1200
              ? 0.4 // Large screens
              : constraints.maxWidth > 800
                  ? 0.6 // Tablet
                  : 0.9; // Mobile

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * mainWidth,
                  child: TextField(
                    readOnly: true,
                    controller: emailController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: MediaQuery.of(context).size.width * mainWidth,
                  child: TextField(
                    controller: contentController,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      hintText: "Enter your message",
                      labelText: "Message",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: MediaQuery.of(context).size.width * mainWidth - 50,
                  child: ElevatedButton(
                    onPressed: sendEmail,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo.shade900,
                    ),
                    child: const Text(
                      "Send Email",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
