import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;
import 'package:sortify/core/filesystem/file_utils.dart';

void main() {
  group('FileUtils.extensionOf', () {
    test('lowercases and keeps the dot', () {
      expect(FileUtils.extensionOf('Invoice.PDF'), '.pdf');
      expect(FileUtils.extensionOf('photo.JPG'), '.jpg');
    });

    test('returns empty when there is no extension', () {
      expect(FileUtils.extensionOf('README'), '');
    });
  });

  group('FileUtils.resolveDestination', () {
    test('resolves relative destinations against the watched folder parent', () {
      final watched = p.join('home', 'user', 'Downloads');
      final destination = p.join('Documents', 'PDFs');
      final result = FileUtils.resolveDestination(
        watchedFolder: watched,
        destination: destination,
      );
      expect(result, p.normalize(p.join('home', 'user', 'Documents', 'PDFs')));
    });

    test('keeps absolute destinations untouched', () {
      final absolute = p.join(p.rootPrefix(Directory.current.path), 'mnt', 'archive');
      final result = FileUtils.resolveDestination(
        watchedFolder: p.join('home', 'user', 'Downloads'),
        destination: absolute,
      );
      expect(result, p.normalize(absolute));
    });
  });

  group('FileUtils.parseSize', () {
    test('parses common units', () {
      expect(FileUtils.parseSize('10 MB'), 10 * 1024 * 1024);
      expect(FileUtils.parseSize('500kb'), 500 * 1024);
      expect(FileUtils.parseSize('2 gb'), 2 * 1024 * 1024 * 1024);
      expect(FileUtils.parseSize('1024'), 1024);
    });

    test('returns null for invalid input', () {
      expect(FileUtils.parseSize('large'), isNull);
    });
  });

  group('FileUtils.formatBytes', () {
    test('formats human readable sizes', () {
      expect(FileUtils.formatBytes(512), '512 B');
      expect(FileUtils.formatBytes(10 * 1024 * 1024), '10 MB');
    });
  });
}
