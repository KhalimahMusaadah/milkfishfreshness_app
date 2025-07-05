import 'package:flutter/material.dart';

class PersistentBottomBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const PersistentBottomBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        backgroundColor: Colors.white,
        selectedItemColor: Color(0xFF2272BB),
        unselectedItemColor: Colors.grey,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera),
            label: 'Deteksi',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: 'Panduan',
          ),
        ],
      ),
    );
  }
}
