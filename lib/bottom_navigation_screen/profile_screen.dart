import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1B2E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A1B2E),
        elevation: 0,
        automaticallyImplyLeading: false,
        titleSpacing: 0,
        title: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            const Icon(Icons.person, color: Colors.amber, size: 24),
            const SizedBox(width: 8),
            const Text(
              'Profile',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
                fontFamily: 'Roboto_Condensed-Bold',
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ✅ Swapped Colors: white background, amber icon
            const Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.white, // 🔄 Was amber
                child: Icon(
                  Icons.person,
                  size: 45,
                  color: Colors.amber, // 🔄 Was white
                ),
              ),
            ),
            const SizedBox(height: 20),

            const Center(
              child: Text(
                'Welcome back!',
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                  fontFamily: 'Roboto_Condensed-Bold',
                ),
              ),
            ),
            const SizedBox(height: 8),

            const Center(
              child: Text(
                'Manage your profile details here.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.white70,
                  fontFamily: 'Roboto_Condensed-Italic',
                ),
              ),
            ),
            const SizedBox(height: 30),

            Center(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                icon: const Icon(Icons.edit, color: Colors.black),
                label: const Text(
                  "Edit Profile",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontFamily: 'Roboto_Condensed-Bold',
                  ),
                ),
                onPressed: () {
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
