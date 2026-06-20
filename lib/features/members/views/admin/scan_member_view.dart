import 'package:flutter/material.dart';

class ScanMemberView extends StatelessWidget {
  const ScanMemberView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('مسح العضو')),
      body: const Center(child: Text('Scan Member View')),
    );
  }
}
