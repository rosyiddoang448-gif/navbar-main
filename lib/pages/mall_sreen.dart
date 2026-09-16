import 'package:flutter/material.dart';
import 'package:mysample/widgets/my_app_bar.dart';

class MallScreen extends StatelessWidget {
  const MallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(),
      body: Center(child: Text('Mall')),
    );
  }
}
