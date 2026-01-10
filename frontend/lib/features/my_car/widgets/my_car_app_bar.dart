import 'package:flutter/material.dart';

class MyCarAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onAddCar;
  final bool isAddCarMode;

  const MyCarAppBar({super.key, this.onAddCar, this.isAddCarMode = false});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () {
          if (isAddCarMode && onAddCar != null) {
            // If in add car mode, cancel it instead of navigating back
            onAddCar!();
          } else {
            Navigator.of(context).pop();
          }
        },
      ),
      title: Text(
        isAddCarMode ? 'Add Car' : 'My Car',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      actions:
          isAddCarMode
              ? null
              : [
                IconButton(
                  icon: const Icon(Icons.add, color: Colors.white),
                  onPressed: onAddCar ?? () {},
                  iconSize: 28,
                ),
                const SizedBox(width: 8),
              ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
