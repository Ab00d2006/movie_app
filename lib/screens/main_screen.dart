import 'package:flutter/material.dart';

import 'home_page.dart';
import 'search_screen.dart';
import 'watch_list_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      HomePage(onSearchTap: () => setState(() => currentIndex = 1)),
      const SearchScreen(),
      const WatchListScreen(),
    ];

    return Scaffold(
      backgroundColor: const Color(0xff242A32),
      body: IndexedStack(index: currentIndex, children: pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) => setState(() => currentIndex = index),
        backgroundColor: const Color(0xff242A32),
        selectedItemColor: const Color(0xff0296E5),
        unselectedItemColor: const Color(0xff67686D),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.bookmark_border), label: 'Watch list'),
        ],
      ),
    );
  }
}
