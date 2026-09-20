import 'package:flutter/material.dart';

import 'home_screen.dart';

class HomePage extends StatelessWidget {
  final VoidCallback? onSearchTap;

  const HomePage({super.key, this.onSearchTap});

  @override
  Widget build(BuildContext context) {
    return HomeScreen(onSearchTap: onSearchTap);
  }
}
