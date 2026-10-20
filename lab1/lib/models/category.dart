import 'package:flutter/material.dart';

enum Category {
  tech('Tech', Icons.computer),
  sports('Sports', Icons.sports_soccer),
  art('Art', Icons.palette),
  music('Music', Icons.music_note),
  science('Science', Icons.science);

  const Category(this.label, this.icon);
  final String label;
  final IconData icon;

  Color color(ColorScheme scheme) => switch (this) {
    Category.tech => scheme.primary,
    Category.sports => scheme.secondary,
    Category.art => scheme.tertiary,
    Category.music => scheme.error,
    Category.science => scheme.primaryContainer,
  };
}