import 'package:flutter/material.dart';
import 'package:zavod_test/map_screen.dart';
import 'package:zavod_test/profile_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final List<Widget> _body = [
    MapScreen(),
    ProfileScreen()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _body[_currentIndex],
      bottomNavigationBar:
      BottomNavigationBar(
          currentIndex: _currentIndex,
          selectedItemColor: Color(0xff005E5E),
          showUnselectedLabels: true,
          unselectedItemColor: Colors.grey,
        onTap: (newIndex){
          setState(() {
            _currentIndex = newIndex;
          });
        },
          items: [
            BottomNavigationBarItem(
              label: "Map",
                icon: Icon(Icons.map),
            ),
            BottomNavigationBarItem(
              label: "Profile",
              icon: Icon(Icons.person),
            ),
          ]
      ),
    );
  }
}
