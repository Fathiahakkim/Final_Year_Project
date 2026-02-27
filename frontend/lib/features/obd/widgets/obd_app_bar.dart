import 'package:flutter/material.dart';

class OBDAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onNavigateHome;

  const OBDAppBar({super.key, this.onNavigateHome});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => onNavigateHome?.call(),
      ),
      title: const Text(
        'OBD Data',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
