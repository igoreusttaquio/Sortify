import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'icon_tile.dart';

class _FileTypeStyle {
  const _FileTypeStyle(this.icon, this.color);

  final IconData icon;
  final Color color;
}

/// Resolves a file extension to a consistent icon + hue.
abstract final class FileTypeIcons {
  static const _map = <String, _FileTypeStyle>{
    'pdf': _FileTypeStyle(Icons.picture_as_pdf_outlined, AppColors.error),
    'doc': _FileTypeStyle(Icons.description_outlined, AppColors.primary),
    'docx': _FileTypeStyle(Icons.description_outlined, AppColors.primary),
    'txt': _FileTypeStyle(Icons.article_outlined, AppColors.textSecondary),
    'md': _FileTypeStyle(Icons.article_outlined, AppColors.textSecondary),
    'rtf': _FileTypeStyle(Icons.description_outlined, AppColors.primary),
    'png': _FileTypeStyle(Icons.image_outlined, AppColors.purple),
    'jpg': _FileTypeStyle(Icons.image_outlined, AppColors.purple),
    'jpeg': _FileTypeStyle(Icons.image_outlined, AppColors.purple),
    'webp': _FileTypeStyle(Icons.image_outlined, AppColors.purple),
    'gif': _FileTypeStyle(Icons.gif_box_outlined, AppColors.purple),
    'svg': _FileTypeStyle(Icons.polyline_outlined, AppColors.purple),
    'xls': _FileTypeStyle(Icons.table_chart_outlined, AppColors.success),
    'xlsx': _FileTypeStyle(Icons.table_chart_outlined, AppColors.success),
    'csv': _FileTypeStyle(Icons.table_chart_outlined, AppColors.success),
    'ppt': _FileTypeStyle(Icons.slideshow_outlined, AppColors.accent),
    'pptx': _FileTypeStyle(Icons.slideshow_outlined, AppColors.accent),
    'zip': _FileTypeStyle(Icons.folder_zip_outlined, AppColors.accent),
    'rar': _FileTypeStyle(Icons.folder_zip_outlined, AppColors.accent),
    '7z': _FileTypeStyle(Icons.folder_zip_outlined, AppColors.accent),
    'tar': _FileTypeStyle(Icons.folder_zip_outlined, AppColors.accent),
    'gz': _FileTypeStyle(Icons.folder_zip_outlined, AppColors.accent),
    'mp3': _FileTypeStyle(Icons.music_note_outlined, AppColors.pink),
    'wav': _FileTypeStyle(Icons.music_note_outlined, AppColors.pink),
    'flac': _FileTypeStyle(Icons.music_note_outlined, AppColors.pink),
    'aac': _FileTypeStyle(Icons.music_note_outlined, AppColors.pink),
    'ogg': _FileTypeStyle(Icons.music_note_outlined, AppColors.pink),
    'mp4': _FileTypeStyle(Icons.movie_outlined, AppColors.teal),
    'mov': _FileTypeStyle(Icons.movie_outlined, AppColors.teal),
    'avi': _FileTypeStyle(Icons.movie_outlined, AppColors.teal),
    'mkv': _FileTypeStyle(Icons.movie_outlined, AppColors.teal),
    'exe': _FileTypeStyle(Icons.terminal_outlined, AppColors.cyan),
    'msi': _FileTypeStyle(Icons.terminal_outlined, AppColors.cyan),
    'dmg': _FileTypeStyle(Icons.terminal_outlined, AppColors.cyan),
    'dart': _FileTypeStyle(Icons.code_outlined, AppColors.cyan),
    'js': _FileTypeStyle(Icons.code_outlined, AppColors.cyan),
    'ts': _FileTypeStyle(Icons.code_outlined, AppColors.cyan),
    'json': _FileTypeStyle(Icons.data_object_outlined, AppColors.cyan),
  };

  static _FileTypeStyle _styleFor(String path) {
    final dot = path.lastIndexOf('.');
    final extension = dot == -1 ? '' : path.substring(dot + 1).toLowerCase();
    return _map[extension] ??
        const _FileTypeStyle(
          Icons.insert_drive_file_outlined,
          AppColors.textSecondary,
        );
  }

  static IconData iconFor(String path) => _styleFor(path).icon;

  static Color colorFor(String path) => _styleFor(path).color;
}

/// Rounded container holding a file-type icon.
class FileTypeIcon extends StatelessWidget {
  const FileTypeIcon({
    super.key,
    required this.path,
    this.size = 40,
    this.iconSize = 20,
  });

  final String path;
  final double size;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return IconTile(
      icon: FileTypeIcons.iconFor(path),
      color: FileTypeIcons.colorFor(path),
      size: size,
      iconSize: iconSize,
    );
  }
}
