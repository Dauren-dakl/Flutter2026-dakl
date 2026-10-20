import 'package:flutter/material.dart';
import '../models/item.dart';
import '../models/profile.dart';
import '../models/countdown.dart';
import '../utils/format.dart';
import '../routes/routes.dart';

class DetailScreen extends StatefulWidget {
  final Item item;
  final Profile profile;

  const DetailScreen({
    super.key,
    required this.item,
    required this.profile,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late Item _item;

  @override
  void initState() {
    super.initState();
    _item = widget.item;
  }

  void _register() async {
    if (_item.isFull || _item.contains(widget.profile.name)) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Register?'),
        content: Text('Do you want to register for ${_item.title}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Yes'),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      final updated = _item.copyWith(
        attendees: [..._item.attendees, widget.profile.name],
      );
      setState(() => _item = updated);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(_item.title),
        actions: [
          PopupMenuButton<String>(
            onSelected: (v) {
              if (v == 'edit') {
                Navigator.pushNamed(context, Routes.form, arguments: _item).then((updatedItem) {
                  if (updatedItem != null && updatedItem is Item) {
                    setState(() => _item = updatedItem);
                  }
                });
              } else if (v == 'delete') {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Delete?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx, false),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(ctx, true);
                          Navigator.pop(context);
                        },
                        child: const Text('Delete'),
                      ),
                    ],
                  ),
                );
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(value: 'edit', child: Text('Edit')),
              PopupMenuItem(value: 'delete', child: Text('Delete')),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // R24: Stack header with image from assets, icon, category, countdown
            Stack(
              children: [
                Image.asset(
                  'assets/images/banner.jpg', // Убедись, что эта картинка есть в папке
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Container(
                  height: 200,
                  color: Colors.black.withOpacity(0.4),
                ),
                Positioned.fill(
                  child: Center(
                    child: Icon(
                      _item.category.icon,
                      size: 64,
                      color: Colors.white,
                    ),
                  ),
                ),
                Positioned(
                  top: 16,
                  left: 16,
                  child: Chip(
                    label: Text(_item.category.label),
                    backgroundColor: theme.colorScheme.surface,
                  ),
                ),
                Positioned(
                  top: 16,
                  right: 16,
                  child: Chip(
                    label: Text(
                      switch (_item.countdown) {
                        Upcoming() => 'Soon',
                        Started() => 'Live',
                        Ended() => 'Past',
                      },
                    ),
                    backgroundColor: theme.colorScheme.surface,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(formatDateTime(_item.when), style: theme.textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Text(
                    '${_item.location} • ${_item.mode ? 'Online' : 'Offline'}',
                    style: theme.textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Places: ${_item.places.taken} / ${_item.limit}',
                    style: theme.textTheme.titleMedium,
                  ),

                  if (_item.description != null) ...[
                    const SizedBox(height: 16),
                    Text(_item.description!, style: theme.textTheme.bodyMedium),
                  ],

                  const SizedBox(height: 24),
                  Text('Attendees:', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 8),

                  if (_item.attendees.isEmpty)
                    const Text('Nobody yet')
                  else
                    ..._item.attendees.map(
                          (name) => ListTile(
                        leading: Icon(
                          Icons.person,
                          color: name == widget.profile.name ? theme.colorScheme.primary : null,
                        ),
                        title: Text(
                          name,
                          style: TextStyle(
                            fontWeight: name == widget.profile.name ? FontWeight.bold : null,
                          ),
                        ),
                        dense: true,
                      ),
                    ),

                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: (_item.isFull || _item.contains(widget.profile.name)) ? null : _register,
                      child: Text(
                        _item.contains(widget.profile.name)
                            ? 'Already registered'
                            : (_item.isFull ? 'Full' : 'Register'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}