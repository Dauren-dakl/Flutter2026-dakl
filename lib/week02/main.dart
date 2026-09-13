// ignore_for_file: avoid_print
import 'catalogue.dart';
import 'data.dart';
import 'models.dart';
import 'shelf_state.dart';

void main() {
  final library = Library();

  for (final raw in rawBooks) {
    library.add(Book.fromJson(raw));
  }

  library.add(const Magazine(title: 'Dart Weekly', year: 2024, issue: 12));
  library.add(const Ghost(title: 'Lost Catalogue Card', year: 1975));

  library.open();

  print(library.report());
  print('');

  print('All titles: ${library.allTitles.toList()}');
  print(
    'Books after 2010: '
    '${library.booksAfter2010.map((b) => b.title).toList()}',
  );
  print('Average pages: ${library.averagePages.toStringAsFixed(1)}');
  print('Author counts: ${library.authorBookCounts}');
  print('Author names: ${library.authorNames}');
  print('Genres present: ${library.genresPresent}');
  print('Opened at: ${library.openedAt}');
  print('');

  print('Country of "Clean Code": ${library.countryOf('Clean Code')}');
  print('Country of "Design Patterns": ${library.countryOf('Design Patterns')}');
  print('Country of "Nonexistent Book": ${library.countryOf('Nonexistent Book')}');
  print('');

  final firstBook = library.books.first;
  print(firstBook.borrowLabel());
  print('');

  final stats = statsOf(library.books.toList());
  print(
    'Stats record: count=${stats.count}, '
    'avgPages=${stats.avgPages.toStringAsFixed(1)}',
  );
  print('');

  print(describe(const Empty()));
  print(describe(Ready(library.books.toList())));
  print(describe(const Broken('shelf collapsed during renovation')));
}
