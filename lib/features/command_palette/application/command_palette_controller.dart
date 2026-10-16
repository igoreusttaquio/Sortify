import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Controls the visibility of the global command palette (Ctrl+K).
class CommandPaletteController extends Notifier<bool> {
  @override
  bool build() => false;

  void open() => state = true;

  void close() => state = false;

  void toggle() => state = !state;
}

final commandPaletteProvider = NotifierProvider<CommandPaletteController, bool>(
  CommandPaletteController.new,
);
