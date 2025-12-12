import 'package:flutter/material.dart';
import '../../widgets/development_targets.dart';

class AdminChildDevelopmentPage extends StatelessWidget {
  final String childId;
  final String childName;

  const AdminChildDevelopmentPage({
    super.key,
    required this.childId,
    required this.childName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Perkembangan $childName"),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: DevelopmentTargetsWidget(childId: childId),
      ),
    );
  }
}
