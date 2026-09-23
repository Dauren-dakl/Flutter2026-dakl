import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    super.key,
    required this.name,
    required this.university,
  });

  final String name;
  final String university;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Column(
      children: [
        const CircleAvatar(
          radius: 60,
          backgroundImage: AssetImage('assets/images/me.jpg'),
        ),
        const Padding(padding: EdgeInsets.all(8)),
        Text(
          name,
          style: TextStyle(
            fontFamily: 'RobotoMono',
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: colors.onSurface,
          ),
        ),
        const Padding(padding: EdgeInsets.all(4)),
        Text(
          university,
          style: TextStyle(fontSize: 16, color: colors.onSurfaceVariant),
        ),
      ],
    );
  }
}
