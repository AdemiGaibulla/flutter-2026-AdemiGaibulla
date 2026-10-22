import 'package:flutter/material.dart';
import 'package:reading_club/models/profile.dart';

class ProfileScreen extends StatelessWidget{
  final Profile profile;
  final ValueChanged<Profile> onProfileChanged;
  final ThemeMode currentThemeMode;
  final ValueChanged<ThemeMode> onChangeTheme;

  const ProfileScreen({super.key, required this.profile, required this.onProfileChanged, required this.currentThemeMode, required this.onChangeTheme});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextFormField(
              initialValue: profile.name,
              decoration: const InputDecoration(
                labelText: 'Name',
              ),
              onChanged: (value) {
                onProfileChanged(
                  profile.copyWith(name: value),
                );
              },
            ),
          ),
          Padding(
              padding: const EdgeInsets.all(8),
              child: TextFormField(
                initialValue: profile.group,
                decoration: const InputDecoration(
                  labelText: 'Group',
                ),
                onChanged: (value) {
                  onProfileChanged(
                    profile.copyWith(group: value),
                  );
                },
              ),
          ),
          SegmentedButton<ThemeMode>(
            segments: const [
              ButtonSegment(
                value: ThemeMode.system,
                label: Text('System'),
              ),
              ButtonSegment(
                value: ThemeMode.light,
                label: Text('Light'),
              ),
              ButtonSegment(
                value: ThemeMode.dark,
                label: Text('Dark'),
              ),
            ],
            selected: {currentThemeMode},
            onSelectionChanged: (modes) {
              onChangeTheme(modes.first);
            },
          ),
        ],
      ),
    );
  }
}