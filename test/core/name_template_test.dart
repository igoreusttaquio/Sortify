import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:sortify/core/filesystem/name_template.dart';

void main() {
  final modified = DateTime(2026, 3, 7);

  group('NameTemplate.render', () {
    test('expands every supported token', () {
      final result = NameTemplate.render(
        '{name}|{ext}|{year}|{month}|{day}|{date}',
        filePath: p.join('dir', 'Report.PDF'),
        modified: modified,
      );
      expect(result, 'Report|pdf|2026|03|07|2026-03-07');
    });

    test('is case-insensitive and keeps unknown tokens', () {
      final result = NameTemplate.render(
        '{YEAR}-{oops}',
        filePath: 'a.txt',
        modified: modified,
      );
      expect(result, '2026-{oops}');
    });

    test('uses "other" for files without extension', () {
      expect(
        NameTemplate.render('{ext}', filePath: 'README', modified: modified),
        'other',
      );
    });
  });

  group('NameTemplate.renderFolder', () {
    test('supports nested folders', () {
      final result = NameTemplate.renderFolder(
        '{year}/{month}',
        filePath: 'a.jpg',
        modified: modified,
      );
      expect(result, p.join('2026', '03'));
    });

    test('drops traversal segments and invalid characters', () {
      final result = NameTemplate.renderFolder(
        '../a:b/./c',
        filePath: 'a.jpg',
        modified: modified,
      );
      expect(result, p.join('a_b', 'c'));
    });
  });
}
