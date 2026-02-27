import 'package:flutter/material.dart';

class DiagnoseAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onNavigateHome;

  const DiagnoseAppBar({super.key, this.onNavigateHome});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => onNavigateHome?.call(),
      ),
      title: const Text(
        'Diagnose',
        style: TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
