import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Everything the side panel needs to know to open. [token] changes on every
/// open so the panel always rebuilds with a fresh form.
class RuleEditorRequest {
  const RuleEditorRequest({required this.token, this.ruleId});

  final int token;
  final String? ruleId;

  bool get isNew => ruleId == null;
}

/// Controls the right-side rule editor panel (replaces the old dedicated route).
class RuleEditorController extends Notifier<RuleEditorRequest?> {
  int _token = 0;

  @override
  RuleEditorRequest? build() => null;

  void openNew() {
    _token++;
    state = RuleEditorRequest(token: _token);
  }

  void openEdit(String ruleId) {
    _token++;
    state = RuleEditorRequest(token: _token, ruleId: ruleId);
  }

  void close() => state = null;
}

final ruleEditorProvider =
    NotifierProvider<RuleEditorController, RuleEditorRequest?>(
      RuleEditorController.new,
    );
