import 'package:flutter/material.dart';

class AdminProfileScreen extends StatelessWidget {
  const AdminProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Profil Admin",
        style: TextStyle(fontSize: 18, color: Colors.green[800]),
      ),
    );
  }
}
