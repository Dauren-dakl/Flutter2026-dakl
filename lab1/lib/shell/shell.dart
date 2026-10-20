import 'package:flutter/material.dart';
import '../data/seed.dart';
import '../models/item.dart';
import '../models/profile.dart';
import '../screens/list_tab.dart';
import '../screens/favourites_tab.dart';
import '../screens/profile_tab.dart';
import '../routes/routes.dart';

class Shell extends StatefulWidget {
  const Shell({super.key});

  @override
  State<Shell> createState() => _ShellState();
}

class _ShellState extends State<Shell> {
  int _index = 0;

  List<Item> _items = [...seedItems];
  Profile _profile = const Profile.empty();

  void _toggleFavourite(Item item) {
    setState(() {
      final idx = _items.indexOf(item);
      if (idx != -1) {
        _items[idx] = item.copyWith(favourite: !item.favourite);
      }
    });
  }

  void _openDetail(Item item) {
    Navigator.pushNamed(
      context,
      Routes.detail,
      arguments: {'item': item, 'profile': _profile},
    ).then((updatedItem) {
      if (updatedItem != null && updatedItem is Item) {
        setState(() {
          final idx = _items.indexWhere((i) => i.title == item.title); // dummy match
          if (idx != -1) _items[idx] = updatedItem;
        });
      }
    });
  }

  void _openForm() {
    Navigator.pushNamed(context, Routes.form).then((newItem) {
      if (newItem != null && newItem is Item) {
        setState(() => _items.add(newItem));
      }
    });
  }

  void _resetData() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Reset data?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              setState(() {
                _items = [...seedItems];
                _profile = const Profile.empty();
              });
            },
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(['Campus Events', 'Favourites', 'Profile'][_index]),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(child: Text('Menu', style: theme.textTheme.headlineMedium)),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('About'),
              onTap: () {
                Navigator.pop(context);
                showDialog(context: context, builder: (ctx) => const AlertDialog(title: Text('Lab 1 App'), content: Text('Made by Dauren')));
              },
            ),
            ListTile(
              leading: const Icon(Icons.refresh),
              title: const Text('Reset data'),
              onTap: () {
                Navigator.pop(context);
                _resetData();
              },
            ),
          ],
        ),
      ),
      body: [
        ListTab(items: _items, onToggleFavourite: _toggleFavourite, onOpenDetail: _openDetail),
        FavouritesTab(items: _items, onToggleFavourite: _toggleFavourite, onOpenDetail: _openDetail),
        ProfileTab(
          profile: _profile,
          onProfileChanged: (p) => setState(() => _profile = p),
          themeMode: ThemeMode.system, // Упрощено
          onThemeChanged: (t) {}, // Упрощено
        ),
      ][_index],
      floatingActionButton: _index == 0 ? FloatingActionButton(
        onPressed: _openForm,
        child: const Icon(Icons.add),
      ) : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.list), label: 'List'),
          NavigationDestination(icon: Icon(Icons.favorite), label: 'Favorites'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}