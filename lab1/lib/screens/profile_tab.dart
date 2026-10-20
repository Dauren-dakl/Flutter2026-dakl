import 'package:flutter/material.dart';
import '../models/profile.dart';

class ProfileTab extends StatefulWidget {
  final Profile profile;
  final Function(Profile) onProfileChanged;
  final ThemeMode themeMode;
  final Function(ThemeMode) onThemeChanged;

  const ProfileTab({
    super.key,
    required this.profile,
    required this.onProfileChanged,
    required this.themeMode,
    required this.onThemeChanged,
  });

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  late final TextEditingController _name;
  late final TextEditingController _group;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.profile.name);
    _group = TextEditingController(text: widget.profile.group);
  }

  @override
  void dispose() {
    _name.dispose();
    _group.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _name,
            decoration: const InputDecoration(labelText: 'Name'),
            onSubmitted: (v) => widget.onProfileChanged(widget.profile.copyWith(name: v)),
          ),
          TextField(
            controller: _group,
            decoration: const InputDecoration(labelText: 'Group'),
            onSubmitted: (v) => widget.onProfileChanged(widget.profile.copyWith(group: v)),
          ),
          const SizedBox(height: 24),
          const Text('Theme'),
          Row(
            children: [
              ChoiceChip(
                label: const Text('System'),
                selected: widget.themeMode == ThemeMode.system,
                onSelected: (_) => widget.onThemeChanged(ThemeMode.system),
              ),
              const SizedBox(width: 8),
              ChoiceChip(
                label: const Text('Light'),
                selected: widget.themeMode == ThemeMode.light,
                onSelected: (_) => widget.onThemeChanged(ThemeMode.light),
              ),
              const SizedBox(width: 8),
              ChoiceChip(
                label: const Text('Dark'),
                selected: widget.themeMode == ThemeMode.dark,
                onSelected: (_) => widget.onThemeChanged(ThemeMode.dark),
              ),
            ],
          ),
        ],
      ),
    );
  }
}