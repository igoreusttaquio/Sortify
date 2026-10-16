// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appName => 'Sortify';

  @override
  String get appTagline => 'Organização automática de arquivos';

  @override
  String get navWorkspace => 'ESPAÇO DE TRABALHO';

  @override
  String get navDashboard => 'Painel';

  @override
  String get navRules => 'Regras';

  @override
  String get navActivity => 'Atividade';

  @override
  String get navLocations => 'LOCAIS';

  @override
  String get navFolders => 'Pastas';

  @override
  String get navSettings => 'Configurações';

  @override
  String get collapseMenu => 'Recolher menu';

  @override
  String get expandMenu => 'Expandir menu';

  @override
  String get search => 'Buscar';

  @override
  String get help => 'Ajuda';

  @override
  String get settings => 'Configurações';

  @override
  String get statusMonitoring => 'Monitorando';

  @override
  String get statusPaused => 'Pausado';

  @override
  String statusMonitoringSubtitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pastas estão sendo monitoradas',
      one: '1 pasta está sendo monitorada',
      zero: 'Nenhuma pasta está sendo monitorada',
    );
    return '$_temp0';
  }

  @override
  String activeRulesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count regras ativas',
      one: '1 regra ativa',
      zero: 'Nenhuma regra ativa',
    );
    return '$_temp0';
  }

  @override
  String get dashboardTitle => 'Painel';

  @override
  String get dashboardSubtitle =>
      'Tudo o que o Sortify está fazendo, de relance';

  @override
  String get statFilesToday => 'Arquivos organizados hoje';

  @override
  String get statActiveRules => 'Regras ativas';

  @override
  String get statFoldersMonitored => 'Pastas monitoradas';

  @override
  String get statFilesPending => 'Arquivos pendentes';

  @override
  String get recentActivity => 'Atividade recente';

  @override
  String get viewAll => 'Ver tudo';

  @override
  String get rulesTitle => 'Regras';

  @override
  String get rulesSubtitle => 'Decida o que acontece com cada arquivo';

  @override
  String get newRule => 'Nova regra';

  @override
  String get editRule => 'Editar regra';

  @override
  String get duplicateRule => 'Duplicar regra';

  @override
  String get deleteRule => 'Excluir regra';

  @override
  String get runRuleNow => 'Executar agora';

  @override
  String get viewRuleActivity => 'Ver atividade';

  @override
  String get enableRule => 'Ativar';

  @override
  String get disableRule => 'Desativar';

  @override
  String get enabled => 'Ativada';

  @override
  String get disabled => 'Desativada';

  @override
  String ruleProcessed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count arquivos processados',
      one: '1 arquivo processado',
      zero: 'Nunca usada',
    );
    return '$_temp0';
  }

  @override
  String ruleLastRun(String when) {
    return 'Última execução $when';
  }

  @override
  String get ruleNeverRun => 'Nunca executada';

  @override
  String get ruleDeleted => 'Regra excluída';

  @override
  String get ruleSaved => 'Regra salva';

  @override
  String get undo => 'Desfazer';

  @override
  String get noRulesTitle => 'Nenhuma regra ainda';

  @override
  String get noRulesBody =>
      'As regras dizem ao Sortify para onde mover seus arquivos. Crie a primeira para começar.';

  @override
  String get noRulesAction => 'Criar primeira regra';

  @override
  String get ruleName => 'Nome da regra';

  @override
  String get ruleNameHint => 'Organizar PDFs';

  @override
  String get ruleScope => 'Aplica-se a';

  @override
  String get allFolders => 'Todas as pastas';

  @override
  String get ruleDescription => 'Descrição (opcional)';

  @override
  String get ruleDescriptionHint =>
      'Mover todos os documentos PDF para uma pasta dedicada';

  @override
  String get whenLabel => 'QUANDO';

  @override
  String get andLabel => 'E';

  @override
  String get thenLabel => 'ENTÃO';

  @override
  String get addCondition => 'Adicionar condição';

  @override
  String get conditionExtension => 'Extensão do arquivo';

  @override
  String get conditionSize => 'Tamanho do arquivo';

  @override
  String get conditionName => 'Nome do arquivo';

  @override
  String get operatorIs => 'é';

  @override
  String get operatorIsNot => 'não é';

  @override
  String get operatorContains => 'contém';

  @override
  String get operatorDoesNotContain => 'não contém';

  @override
  String get operatorGreaterThan => 'maior que';

  @override
  String get operatorLessThan => 'menor que';

  @override
  String get operatorEqualTo => 'igual a';

  @override
  String get actionMove => 'Mover para';

  @override
  String get actionCopy => 'Copiar para';

  @override
  String get actionRename => 'Renomear';

  @override
  String get actionDelete => 'Excluir';

  @override
  String get actionComingSoon => 'Em breve';

  @override
  String get destinationFolder => 'Pasta de destino';

  @override
  String get newFileName => 'Novo nome';

  @override
  String get chooseFolder => 'Escolher pasta';

  @override
  String get previewTitle => 'Prévia';

  @override
  String previewMatches(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count arquivos correspondem a esta regra',
      one: '1 arquivo corresponde a esta regra',
      zero: 'Nenhum arquivo corresponde a esta regra',
    );
    return '$_temp0';
  }

  @override
  String get previewScanning => 'Procurando correspondências nas pastas...';

  @override
  String get previewNoMatchesHint =>
      'Tente ampliar as condições para que mais arquivos correspondam.';

  @override
  String get applyRule => 'Aplicar regra';

  @override
  String get saveRule => 'Salvar regra';

  @override
  String get backToRules => 'Voltar para regras';

  @override
  String get activityTitle => 'Atividade';

  @override
  String get activitySubtitle => 'Um histórico completo do que o Sortify fez';

  @override
  String get filterAll => 'Tudo';

  @override
  String get filterMoved => 'Movidos';

  @override
  String get filterSkipped => 'Ignorados';

  @override
  String get filterFailed => 'Falhas';

  @override
  String get statusMoved => 'Movido';

  @override
  String get statusSkipped => 'Ignorado';

  @override
  String get statusFailed => 'Falhou';

  @override
  String get noActivityTitle => 'Nada por aqui ainda';

  @override
  String get noActivityBody =>
      'As operações aparecerão aqui assim que o Sortify começar a organizar seus arquivos.';

  @override
  String get noActivityFilteredTitle => 'Nenhuma operação correspondente';

  @override
  String get noActivityFilteredBody =>
      'Nenhuma atividade corresponde ao filtro selecionado.';

  @override
  String get noMatchingRule => 'Nenhuma regra correspondente';

  @override
  String get operationDetails => 'Detalhes da operação';

  @override
  String get detailTimestamp => 'Data e hora';

  @override
  String get detailSource => 'Origem';

  @override
  String get detailDestination => 'Destino';

  @override
  String get detailRule => 'Regra';

  @override
  String get detailOperation => 'Operação';

  @override
  String get detailStatus => 'Status';

  @override
  String get detailError => 'Erro';

  @override
  String get technicalDetails => 'Detalhes técnicos';

  @override
  String get detailOperationId => 'ID da operação';

  @override
  String get detailRuleId => 'ID da regra';

  @override
  String get clearHistory => 'Limpar histórico';

  @override
  String get clearHistoryConfirm =>
      'Limpar todo o histórico de atividades? Isso não pode ser desfeito.';

  @override
  String get foldersTitle => 'Pastas monitoradas';

  @override
  String get foldersSubtitle => 'Pastas que o Sortify observa';

  @override
  String get addFolder => 'Adicionar pasta';

  @override
  String get folderMonitoring => 'Monitorando';

  @override
  String get folderPaused => 'Pausada';

  @override
  String get openFolder => 'Abrir pasta';

  @override
  String get revealInExplorer => 'Mostrar no gerenciador de arquivos';

  @override
  String get removeFolder => 'Remover pasta';

  @override
  String get removeFolderConfirmTitle => 'Remover pasta monitorada?';

  @override
  String removeFolderConfirmBody(String path) {
    return 'O Sortify deixará de monitorar $path. Arquivos já organizados não são afetados.';
  }

  @override
  String get addFolderPreviewTitle => 'Começar a monitorar esta pasta?';

  @override
  String addFolderPreviewBody(String path) {
    return 'O Sortify vai monitorar $path e aplicar suas regras ativadas a novos arquivos.';
  }

  @override
  String get folderPickerTitle => 'Escolha uma pasta para monitorar';

  @override
  String get folderAlreadyWatched => 'Esta pasta já está sendo monitorada';

  @override
  String get folderAdded => 'Pasta adicionada';

  @override
  String get folderRemoved => 'Pasta removida';

  @override
  String get noFoldersTitle => 'Nenhuma pasta está sendo monitorada';

  @override
  String get noFoldersBody =>
      'Adicione uma pasta para começar a organizar seus arquivos automaticamente.';

  @override
  String get noFoldersAction => 'Adicionar uma pasta';

  @override
  String get fileExistsTitle => 'O arquivo já existe';

  @override
  String fileExistsBody(String fileName) {
    return '$fileName já existe na pasta de destino.';
  }

  @override
  String get keepBoth => 'Manter ambos';

  @override
  String get replace => 'Substituir';

  @override
  String get skip => 'Ignorar';

  @override
  String get unmatchedTitle => 'Arquivos sem correspondência';

  @override
  String get unmatchedSubtitle =>
      'Arquivos que não correspondem a nenhuma regra';

  @override
  String unmatchedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count arquivos não correspondem a nenhuma regra',
      one: '1 arquivo não corresponde a nenhuma regra',
      zero: 'Nenhum arquivo sem correspondência',
    );
    return '$_temp0';
  }

  @override
  String get createRuleFromFile => 'Criar regra a partir do arquivo';

  @override
  String get deleteFile => 'Excluir arquivo';

  @override
  String get deleteFileConfirmTitle => 'Excluir este arquivo?';

  @override
  String deleteFileConfirmPermanent(String fileName) {
    return '$fileName será excluído permanentemente. Isso não pode ser desfeito.';
  }

  @override
  String deleteFileConfirmTrash(String fileName) {
    return '$fileName será movido para a lixeira.';
  }

  @override
  String get fileDeleted => 'Arquivo excluído';

  @override
  String get deleteToTrash => 'Mover arquivos excluídos para a lixeira';

  @override
  String get deleteToTrashDesc =>
      'Quando desativado, excluir um arquivo o remove permanentemente';

  @override
  String get filterByType => 'Filtrar por tipo';

  @override
  String get allTypes => 'Todos os tipos';

  @override
  String get tableFile => 'Arquivo';

  @override
  String get tableType => 'Tipo';

  @override
  String get tableFolder => 'Pasta';

  @override
  String createRuleForType(String type) {
    return 'Criar regra para $type';
  }

  @override
  String ignoreType(String type) {
    return 'Ignorar $type';
  }

  @override
  String get paginationPrev => 'Anterior';

  @override
  String get paginationNext => 'Próximo';

  @override
  String paginationSummary(int start, int end, int total) {
    return '$start–$end de $total';
  }

  @override
  String trayMonitoring(int count) {
    return 'Monitorando $count pastas';
  }

  @override
  String get trayOpen => 'Abrir o Sortify';

  @override
  String get trayPause => 'Pausar monitoramento';

  @override
  String get trayResume => 'Retomar monitoramento';

  @override
  String get trayRunAll => 'Executar todas as regras';

  @override
  String get traySettings => 'Configurações';

  @override
  String get trayQuit => 'Sair';

  @override
  String get trayTooltip => 'Sortify - organizador de arquivos';

  @override
  String notificationsMoved(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count arquivos movidos',
      one: '1 arquivo movido',
    );
    return '$_temp0';
  }

  @override
  String get paletteSearchHint => 'Buscar comandos, regras e arquivos...';

  @override
  String get paletteCommands => 'Comandos';

  @override
  String get paletteRules => 'Regras';

  @override
  String get paletteFiles => 'Arquivos sem correspondência';

  @override
  String get paletteNoResults => 'Nenhum resultado encontrado';

  @override
  String get paletteCreateRule => 'Criar nova regra';

  @override
  String get paletteAddFolder => 'Adicionar pasta';

  @override
  String get paletteRunAll => 'Executar todas as regras';

  @override
  String get palettePause => 'Pausar monitoramento';

  @override
  String get paletteResume => 'Retomar monitoramento';

  @override
  String get paletteOpenSettings => 'Abrir configurações';

  @override
  String get paletteGoDashboard => 'Ir para o painel';

  @override
  String get paletteGoActivity => 'Ir para a atividade';

  @override
  String get paletteGoRules => 'Ir para regras';

  @override
  String get paletteGoFolders => 'Ir para pastas';

  @override
  String get paletteRunRule => 'Executar regra';

  @override
  String get paletteToggleTheme => 'Alternar tema';

  @override
  String get paletteClose => 'Fechar';

  @override
  String get settingsTitle => 'Configurações';

  @override
  String get settingsSubtitle => 'Ajuste como o Sortify se comporta';

  @override
  String get sectionGeneral => 'Geral';

  @override
  String get sectionMonitoring => 'Monitoramento';

  @override
  String get sectionConflicts => 'Conflitos';

  @override
  String get sectionAppearance => 'Aparência';

  @override
  String get sectionLanguage => 'Idioma';

  @override
  String get startWithSystem => 'Iniciar com o sistema';

  @override
  String get startWithSystemDesc => 'Abrir o Sortify ao entrar no sistema';

  @override
  String get startMinimized => 'Iniciar minimizado';

  @override
  String get startMinimizedDesc => 'Abrir na bandeja do sistema sem janela';

  @override
  String get confirmFileOperations => 'Confirmar operações de arquivo';

  @override
  String get confirmFileOperationsDesc =>
      'Perguntar antes de mover ou excluir arquivos';

  @override
  String get scanInterval => 'Intervalo de verificação';

  @override
  String get scanIntervalDesc =>
      'Com que frequência as pastas monitoradas são verificadas';

  @override
  String secondsShort(int count) {
    return '${count}s';
  }

  @override
  String get watchSubfolders => 'Monitorar subpastas';

  @override
  String get watchSubfoldersDesc => 'Incluir pastas aninhadas no monitoramento';

  @override
  String get ignoreHidden => 'Ignorar arquivos ocultos';

  @override
  String get ignoreHiddenDesc => 'Ignorar arquivos ocultos e do sistema';

  @override
  String get ignoredExtensions => 'Extensões ignoradas';

  @override
  String get ignoredExtensionsDesc =>
      'Arquivos com estas extensões nunca são rastreados nem organizados';

  @override
  String get extensionHint => 'tmp, log';

  @override
  String get addExtension => 'Adicionar';

  @override
  String get conflictAskEveryTime => 'Perguntar sempre';

  @override
  String get conflictAskEveryTimeDesc =>
      'Mostrar um diálogo quando o arquivo de destino já existir';

  @override
  String get conflictKeepBoth => 'Manter ambos';

  @override
  String get conflictKeepBothDesc =>
      'Renomear o arquivo de entrada para não sobrescrever';

  @override
  String get conflictReplace => 'Substituir';

  @override
  String get conflictReplaceDesc => 'Sobrescrever o arquivo existente';

  @override
  String get conflictSkip => 'Ignorar';

  @override
  String get conflictSkipDesc => 'Deixar o arquivo onde está';

  @override
  String get appearanceDark => 'Escuro';

  @override
  String get appearanceLight => 'Claro';

  @override
  String get appearanceSystem => 'Sistema';

  @override
  String get languageEnglish => 'English';

  @override
  String get languagePortuguese => 'Português';

  @override
  String get languageSpanish => 'Español';

  @override
  String get settingsSaved => 'Configurações salvas';

  @override
  String get commonSave => 'Salvar';

  @override
  String get commonCancel => 'Cancelar';

  @override
  String get commonDelete => 'Excluir';

  @override
  String get commonEdit => 'Editar';

  @override
  String get commonClose => 'Fechar';

  @override
  String get commonConfirm => 'Confirmar';

  @override
  String get commonApply => 'Aplicar';

  @override
  String get commonRun => 'Executar';

  @override
  String get commonPause => 'Pausar';

  @override
  String get commonResume => 'Retomar';

  @override
  String get commonRetry => 'Tentar novamente';

  @override
  String get commonLoading => 'Carregando...';

  @override
  String get commonError => 'Algo deu errado';

  @override
  String get commonSuccess => 'Sucesso';

  @override
  String get commonWarning => 'Aviso';

  @override
  String get commonYes => 'Sim';

  @override
  String get commonNo => 'Não';

  @override
  String get commonComingSoon => 'Em breve';

  @override
  String commonFiles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count arquivos',
      one: '1 arquivo',
    );
    return '$_temp0';
  }

  @override
  String get shortcutCommandPalette => 'Paleta de comandos';

  @override
  String get shortcutSearch => 'Buscar';

  @override
  String get helpTitle => 'Guia rápido';

  @override
  String get helpBody =>
      'Adicione uma pasta, crie uma regra, e o Sortify organizará novos arquivos automaticamente.';

  @override
  String get filesUnit => 'MB';

  @override
  String get today => 'Hoje';

  @override
  String get yesterday => 'Ontem';
}
