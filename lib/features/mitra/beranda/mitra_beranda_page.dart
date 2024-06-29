import 'package:douce/shared/widget/topbar.dart';
import 'package:flutter/material.dart';

class MitraBerandaPage extends StatelessWidget {
  const MitraBerandaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(0),
      children: const [
        TopBar(),
        SizedBox(height: 50),
        
      ],
    );
  }
}
