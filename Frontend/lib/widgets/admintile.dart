import 'package:flutter/material.dart';

class AdminTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Function() onTap;
  AdminTile({required this.onTap, required this.title, required this.subtitle, required this.icon, super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      title: Text(
        title,
        style: const TextStyle(fontSize: 18, color: Color.fromARGB(
            211, 255, 250, 250),),
      ),
      leading: Icon(
        icon,
        size: 30,
        color: Color.fromARGB(
            211, 255, 250, 250),
      ),
      subtitle: Text(subtitle),
      contentPadding: const EdgeInsets.only(left: 25, top: 18, right: 10, bottom: 5),
    );
  }
}
