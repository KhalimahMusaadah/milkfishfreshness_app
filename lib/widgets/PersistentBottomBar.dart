import 'package:flutter/material.dart';

class PersistentBottomBar extends StatelessWidget{
  final int currentIndex;
  final Function(int) onTap;

  const PersistentBottomBar({
    super.key,
    required this.currentIndex,
    required this.onTap
  }); 

  @override
  Widget build(BuildContext context){
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      items: const[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Beranda',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.camera_alt),
          label: 'Deteksi',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.menu_book),
          label: 'Panduan',
        ),
      ],
      selectedItemColor: Colors.blueAccent,
      unselectedItemColor: Colors.grey,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
    );
  }
}