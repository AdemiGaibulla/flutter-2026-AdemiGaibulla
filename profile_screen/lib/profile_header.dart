import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  final String name;
  final String university;

  const ProfileHeader({
    super.key,
    required this.name,
    required this.university,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset('assets/images/ademi.jpg', width: 150, height: 150),

        Text(name, style: TextStyle(fontFamily: 'FiraSans')),
        Text(university),
      ],
    );
  }
}
