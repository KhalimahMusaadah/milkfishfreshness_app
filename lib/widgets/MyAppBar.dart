import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget{ //cari tahu preferredsizewidget
  final String title;
  final List<Widget>? actions;
  final bool showBackButton;
  final VoidCallback? onBackPressed;

  const MyAppBar({
    super.key,
    required this.title, //kudu terisi ya gan
    this.actions,
    this.showBackButton = false,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context){
    return AppBar(
      title: Text(
        title, // Use the provided title directly
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      centerTitle: true,
      backgroundColor: Colors.blueAccent,
      elevation: 0,
      leading: showBackButton ? IconButton(
        icon: const Icon(
          Icons.arrow_back,
          color: Colors.white
        ),
        onPressed: onBackPressed ?? () => Navigator.pop(
          context
        ),
      )
      : null,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

