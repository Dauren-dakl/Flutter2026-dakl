import 'category.dart';
import 'countdown.dart';

class Item {
  Item({
    required this.title,
    required this.category,
    required this.when,
    required this.limit,
    required this.location,
    required List<String> attendees,
    this.mode = false,
    this.description,
    this.favourite = false,
  }) : _attendees = List.unmodifiable(attendees);

  Item.empty()
      : title = '',
        category = Category.tech,
        when = DateTime.now().add(const Duration(days: 1)),
        limit = 10,
        location = '',
        _attendees = const [],
        mode = false,
        description = null,
        favourite = false;

  final String title;
  final Category category;
  final DateTime when;
  final int limit;
  final String location;
  final List<String> _attendees;
  final bool mode;
  final String? description;
  final bool favourite;

  List<String> get attendees => _attendees;
  int get count => _attendees.length;
  int get freePlaces => limit - count;
  bool get isFull => count >= limit;
  bool get isPast => when.isBefore(DateTime.now());
  bool contains(String name) => _attendees.contains(name);

  ({int taken, int free}) get places => (taken: count, free: freePlaces);

  Item copyWith({
    String? title,
    Category? category,
    DateTime? when,
    int? limit,
    String? location,
    List<String>? attendees,
    bool? mode,
    String? description,
    bool? favourite,
  }) =>
      Item(
        title: title ?? this.title,
        category: category ?? this.category,
        when: when ?? this.when,
        limit: limit ?? this.limit,
        location: location ?? this.location,
        attendees: attendees ?? _attendees,
        mode: mode ?? this.mode,
        description: description ?? this.description,
        favourite: favourite ?? this.favourite,
      );

  Countdown get countdown {
    final now = DateTime.now();
    if (now.isBefore(when)) return Upcoming(when.difference(now));
    if (now.difference(when).inHours < 3) return Started(now.difference(when));
    return const Ended();
  }
}