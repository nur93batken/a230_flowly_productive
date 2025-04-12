import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsPageA230 extends StatelessWidget {
  const SettingsPageA230({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF0F3),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,

        title: Text(
          'Settings',
          style: GoogleFonts.instrumentSans(
            color: Colors.black,
            fontSize: 28,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildItem(context, title: 'Privacy Policy', onTap: () {}),
          const SizedBox(height: 12),
          _buildItem(context, title: 'Terms of Use', onTap: () {}),
          const SizedBox(height: 12),
          _buildItem(context, title: 'Support', onTap: () {}),
          const SizedBox(height: 12),
          _buildItem(context, title: 'Share', onTap: () {}),
        ],
      ),
    );
  }

  Widget _buildItem(
    BuildContext context, {
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          title,
          style: GoogleFonts.inter(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
