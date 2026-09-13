import 'models.dart';

class Library {
  final List<LibraryItem> items = [];

  void add(LibraryItem item) => items.add(item);

  Book? findByTitle(String title) {
    for (final item in items) {
      if (item is Book && item.title == title) return item;
    }
    return null;
  }

  String countryOf(String title) =>
      findByTitle(title)?.author.country ?? 'unknown';

  late final DateTime openedAt;

  void open() {
    openedAt = DateTime.now();
  }

  String? _cachedReport;

  String report() => _cachedReport ??= _buildReport();

  String _buildReport() => displayList.join('\n');

  Iterable<Book> get books => items.whereType<Book>();

  Iterable<String> get allTitles => items.map((item) => item.title);

  Iterable<Book> get booksAfter2010 => books.where((b) => b.year > 2010);

  double get averagePages => books.isEmpty
      ? 0
      : books.fold<int>(0, (sum, b) => sum + b.pages) / books.length;

  Map<String, int> get authorBookCounts => books.fold<Map<String, int>>(
        {},
        (map, b) =>
            map..update(b.author.name, (count) => count + 1, ifAbsent: () => 1),
      );

  Set<String> get authorNames => books.map((b) => b.author.name).toSet();

  Set<Genre> get genresPresent => books.map((b) => b.genre).toSet();

  List<String> get displayList => [
        'CATALOGUE',
        for (final b in books) '${b.title} (${b.year})',
        ...authorNames,
        if (books.any((b) => b.pages == 0)) '(incomplete data)',
      ];
}