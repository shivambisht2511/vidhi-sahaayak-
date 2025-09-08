import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppDrawer extends StatelessWidget {
  final bool isLoggedIn;
  final String? userName;
  final String? userEmail;
  final String? userPhoto;

  const AppDrawer({
    super.key,
    this.isLoggedIn = false,
    this.userName,
    this.userEmail,
    this.userPhoto,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.65,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.deepPurple,
            ),
            accountName: Text(
              isLoggedIn ? (userName ?? "User") : "Guest User",
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
            accountEmail: Text(
              isLoggedIn ? (userEmail ?? "") : "Not signed in",
              style: GoogleFonts.poppins(fontSize: 14),
            ),
            currentAccountPicture: CircleAvatar(
              radius: 28,
              backgroundColor: Colors.white,
              backgroundImage: (isLoggedIn && userPhoto != null)
                  ? NetworkImage(userPhoto!)
                  : null,
              child: (!isLoggedIn || userPhoto == null)
                  ? const Icon(Icons.person, size: 40, color: Colors.deepPurple)
                  : null,
            ),
          ),

          // 🔹 Chat History
          ListTile(
            leading: const Icon(Icons.history, color: Colors.deepPurple),
            title: Text("Chat History", style: GoogleFonts.poppins()),
            onTap: () {
              Navigator.pop(context);
            },
          ),

          const Divider(),

          // 🔹 Sign-in / Logout (UI only)
          ListTile(
            leading: Icon(
              isLoggedIn ? Icons.logout : Icons.login,
              color: Colors.deepPurple,
            ),
            title: Text(
              isLoggedIn ? "Logout" : "Sign in with Google",
              style: GoogleFonts.poppins(),
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),

          const Spacer(),

          // 🔹 Footer
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              "© 2025 Law AI Assistant",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
