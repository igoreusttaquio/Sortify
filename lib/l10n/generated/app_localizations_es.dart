// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appName => 'Sortify';

  @override
  String get appTagline => 'Organización automática de archivos';

  @override
  String get navWorkspace => 'ESPACIO DE TRABAJO';

  @override
  String get navDashboard => 'Panel';

  @override
  String get navRules => 'Reglas';

  @override
  String get navActivity => 'Actividad';

  @override
  String get navLocations => 'UBICACIONES';

  @override
  String get navFolders => 'Carpetas';

  @override
  String get navSettings => 'Ajustes';

  @override
  String get collapseMenu => 'Contraer menú';

  @override
  String get expandMenu => 'Expandir menú';

  @override
  String get search => 'Buscar';

  @override
  String get help => 'Ayuda';

  @override
  String get settings => 'Ajustes';

  @override
  String get statusMonitoring => 'Monitoreando';

  @override
  String get statusPaused => 'En pausa';

  @override
  String statusMonitoringSubtitle(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Se están monitoreando $count carpetas',
      one: 'Se está monitoreando 1 carpeta',
      zero: 'No se está monitoreando ninguna carpeta',
    );
    return '$_temp0';
  }

  @override
  String activeRulesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count reglas activas',
      one: '1 regla activa',
      zero: 'Ninguna regla activa',
    );
    return '$_temp0';
  }

  @override
  String get dashboardTitle => 'Panel';

  @override
  String get dashboardSubtitle => 'Todo lo que hace Sortify, de un vistazo';

  @override
  String get statFilesToday => 'Archivos organizados hoy';

  @override
  String get statActiveRules => 'Reglas activas';

  @override
  String get statFoldersMonitored => 'Carpetas monitoreadas';

  @override
  String get statFilesPending => 'Archivos pendientes';

  @override
  String get recentActivity => 'Actividad reciente';

  @override
  String get viewAll => 'Ver todo';

  @override
  String get rulesTitle => 'Reglas';

  @override
  String get rulesSubtitle => 'Decide qué pasa con cada archivo';

  @override
  String get newRule => 'Nueva regla';

  @override
  String get editRule => 'Editar regla';

  @override
  String get duplicateRule => 'Duplicar regla';

  @override
  String get deleteRule => 'Eliminar regla';

  @override
  String get runRuleNow => 'Ejecutar ahora';

  @override
  String get viewRuleActivity => 'Ver actividad';

  @override
  String get enableRule => 'Activar';

  @override
  String get disableRule => 'Desactivar';

  @override
  String get enabled => 'Activa';

  @override
  String get disabled => 'Desactivada';

  @override
  String ruleProcessed(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count archivos procesados',
      one: '1 archivo procesado',
      zero: 'Nunca usada',
    );
    return '$_temp0';
  }

  @override
  String ruleLastRun(String when) {
    return 'Última ejecución $when';
  }

  @override
  String get ruleNeverRun => 'Nunca ejecutada';

  @override
  String get ruleDeleted => 'Regla eliminada';

  @override
  String get ruleSaved => 'Regla guardada';

  @override
  String get undo => 'Deshacer';

  @override
  String get noRulesTitle => 'Aún no hay reglas';

  @override
  String get noRulesBody =>
      'Las reglas le dicen a Sortify dónde mover tus archivos. Crea la primera para empezar.';

  @override
  String get noRulesAction => 'Crear tu primera regla';

  @override
  String get ruleName => 'Nombre de la regla';

  @override
  String get ruleNameHint => 'Organizar PDFs';

  @override
  String get ruleScope => 'Se aplica a';

  @override
  String get allFolders => 'Todas las carpetas';

  @override
  String get ruleDescription => 'Descripción (opcional)';

  @override
  String get ruleDescriptionHint =>
      'Mover todos los documentos PDF a una carpeta dedicada';

  @override
  String get whenLabel => 'CUANDO';

  @override
  String get andLabel => 'Y';

  @override
  String get thenLabel => 'ENTONCES';

  @override
  String get addCondition => 'Agregar condición';

  @override
  String get conditionExtension => 'Extensión del archivo';

  @override
  String get conditionSize => 'Tamaño del archivo';

  @override
  String get conditionName => 'Nombre del archivo';

  @override
  String get conditionModified => 'Fecha de modificación';

  @override
  String get operatorIs => 'es';

  @override
  String get operatorIsNot => 'no es';

  @override
  String get operatorContains => 'contiene';

  @override
  String get operatorDoesNotContain => 'no contiene';

  @override
  String get operatorGreaterThan => 'mayor que';

  @override
  String get operatorLessThan => 'menor que';

  @override
  String get operatorEqualTo => 'igual a';

  @override
  String get operatorStartsWith => 'empieza con';

  @override
  String get operatorEndsWith => 'termina con';

  @override
  String get operatorOlderThan => 'más antiguo que';

  @override
  String get operatorNewerThan => 'más reciente que';

  @override
  String get daysUnit => 'días';

  @override
  String get actionMove => 'Mover a';

  @override
  String get actionCopy => 'Copiar a';

  @override
  String get actionRename => 'Renombrar';

  @override
  String get actionDelete => 'Eliminar';

  @override
  String get actionComingSoon => 'Próximamente';

  @override
  String get destinationFolder => 'Carpeta de destino';

  @override
  String get newFileName => 'Nuevo nombre';

  @override
  String get chooseFolder => 'Elegir carpeta';

  @override
  String get createSubfolder => 'Crear subcarpeta';

  @override
  String get createSubfolderHelp =>
      'Agrupa los archivos en una nueva carpeta dentro del destino. Usa / para carpetas anidadas.';

  @override
  String get subfolderName => 'Nombre de la subcarpeta';

  @override
  String get renameHelp =>
      'Usa tokens para formar el nombre. Se conserva la extensión original.';

  @override
  String get deleteHelp =>
      'Los archivos coincidentes se envían a la papelera o se eliminan permanentemente, según tu configuración.';

  @override
  String get templateTokens => 'Insertar token';

  @override
  String get tokenName => 'Nombre del archivo sin extensión';

  @override
  String get tokenExt => 'Extensión';

  @override
  String get tokenYear => 'Año de modificación';

  @override
  String get tokenMonth => 'Mes de modificación';

  @override
  String get tokenDay => 'Día de modificación';

  @override
  String get tokenDate => 'Fecha de modificación (aaaa-mm-dd)';

  @override
  String get exampleResult => 'Ejemplo';

  @override
  String get actionLabel => 'Acción';

  @override
  String get onConflict => 'Si el archivo ya existe';

  @override
  String get previewTitle => 'Vista previa';

  @override
  String previewMatches(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count archivos coinciden con esta regla',
      one: '1 archivo coincide con esta regla',
      zero: 'Ningún archivo coincide con esta regla',
    );
    return '$_temp0';
  }

  @override
  String get previewScanning => 'Buscando coincidencias en las carpetas...';

  @override
  String get previewNoMatchesHint =>
      'Intenta ampliar las condiciones para que coincidan más archivos.';

  @override
  String get applyRule => 'Aplicar regla';

  @override
  String get saveRule => 'Guardar regla';

  @override
  String get backToRules => 'Volver a reglas';

  @override
  String get activityTitle => 'Actividad';

  @override
  String get activitySubtitle => 'Un historial completo de lo que hizo Sortify';

  @override
  String get filterAll => 'Todo';

  @override
  String get filterMoved => 'Movidos';

  @override
  String get filterSkipped => 'Omitidos';

  @override
  String get filterFailed => 'Fallidos';

  @override
  String get statusMoved => 'Movido';

  @override
  String get statusSkipped => 'Omitido';

  @override
  String get statusFailed => 'Falló';

  @override
  String get noActivityTitle => 'Aún no hay nada aquí';

  @override
  String get noActivityBody =>
      'Las operaciones aparecerán aquí en cuanto Sortify empiece a organizar tus archivos.';

  @override
  String get noActivityFilteredTitle => 'No hay operaciones coincidentes';

  @override
  String get noActivityFilteredBody =>
      'Ninguna actividad coincide con el filtro seleccionado.';

  @override
  String get noMatchingRule => 'Ninguna regla coincide';

  @override
  String get operationDetails => 'Detalles de la operación';

  @override
  String get detailTimestamp => 'Fecha y hora';

  @override
  String get detailSource => 'Origen';

  @override
  String get detailDestination => 'Destino';

  @override
  String get detailRule => 'Regla';

  @override
  String get detailOperation => 'Operación';

  @override
  String get detailStatus => 'Estado';

  @override
  String get detailError => 'Error';

  @override
  String get technicalDetails => 'Detalles técnicos';

  @override
  String get detailOperationId => 'ID de la operación';

  @override
  String get detailRuleId => 'ID de la regla';

  @override
  String get clearHistory => 'Borrar historial';

  @override
  String get clearHistoryConfirm =>
      '¿Borrar todo el historial de actividad? Esto no se puede deshacer.';

  @override
  String get foldersTitle => 'Carpetas monitoreadas';

  @override
  String get foldersSubtitle => 'Carpetas que Sortify vigila';

  @override
  String get addFolder => 'Agregar carpeta';

  @override
  String get folderMonitoring => 'Monitoreando';

  @override
  String get folderPaused => 'En pausa';

  @override
  String get openFolder => 'Abrir carpeta';

  @override
  String get revealInExplorer => 'Mostrar en el explorador de archivos';

  @override
  String get removeFolder => 'Quitar carpeta';

  @override
  String get removeFolderConfirmTitle => '¿Quitar carpeta monitoreada?';

  @override
  String removeFolderConfirmBody(String path) {
    return 'Sortify dejará de monitorear $path. Los archivos ya organizados no se ven afectados.';
  }

  @override
  String get addFolderPreviewTitle => '¿Empezar a monitorear esta carpeta?';

  @override
  String addFolderPreviewBody(String path) {
    return 'Sortify monitoreará $path y aplicará tus reglas activas a los archivos nuevos.';
  }

  @override
  String get folderPickerTitle => 'Elige una carpeta para monitorear';

  @override
  String get folderAlreadyWatched => 'Esta carpeta ya se está monitoreando';

  @override
  String get folderAdded => 'Carpeta agregada';

  @override
  String get folderRemoved => 'Carpeta quitada';

  @override
  String get noFoldersTitle => 'No se está monitoreando ninguna carpeta';

  @override
  String get noFoldersBody =>
      'Agrega una carpeta para empezar a organizar tus archivos automáticamente.';

  @override
  String get noFoldersAction => 'Agregar una carpeta';

  @override
  String get fileExistsTitle => 'El archivo ya existe';

  @override
  String fileExistsBody(String fileName) {
    return '$fileName ya existe en la carpeta de destino.';
  }

  @override
  String get keepBoth => 'Conservar ambos';

  @override
  String get replace => 'Reemplazar';

  @override
  String get skip => 'Omitir';

  @override
  String get unmatchedTitle => 'Archivos sin coincidencia';

  @override
  String get unmatchedSubtitle => 'Archivos que no coinciden con ninguna regla';

  @override
  String unmatchedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count archivos no coinciden con ninguna regla',
      one: '1 archivo no coincide con ninguna regla',
      zero: 'Ningún archivo sin coincidencia',
    );
    return '$_temp0';
  }

  @override
  String get createRuleFromFile => 'Crear regla desde el archivo';

  @override
  String get deleteFile => 'Eliminar archivo';

  @override
  String get deleteFileConfirmTitle => '¿Eliminar este archivo?';

  @override
  String deleteFileConfirmPermanent(String fileName) {
    return '$fileName se eliminará permanentemente. Esto no se puede deshacer.';
  }

  @override
  String deleteFileConfirmTrash(String fileName) {
    return '$fileName se moverá a la papelera.';
  }

  @override
  String get fileDeleted => 'Archivo eliminado';

  @override
  String get deleteToTrash => 'Mover archivos eliminados a la papelera';

  @override
  String get deleteToTrashDesc =>
      'Si está desactivado, eliminar un archivo lo borra permanentemente';

  @override
  String get filterByType => 'Filtrar por tipo';

  @override
  String get allTypes => 'Todos los tipos';

  @override
  String get tableFile => 'Archivo';

  @override
  String get tableType => 'Tipo';

  @override
  String get tableFolder => 'Carpeta';

  @override
  String createRuleForType(String type) {
    return 'Crear regla para $type';
  }

  @override
  String ignoreType(String type) {
    return 'Ignorar $type';
  }

  @override
  String get paginationPrev => 'Anterior';

  @override
  String get paginationNext => 'Siguiente';

  @override
  String paginationSummary(int start, int end, int total) {
    return '$start–$end de $total';
  }

  @override
  String trayMonitoring(int count) {
    return 'Monitoreando $count carpetas';
  }

  @override
  String get trayOpen => 'Abrir Sortify';

  @override
  String get trayPause => 'Pausar monitoreo';

  @override
  String get trayResume => 'Reanudar monitoreo';

  @override
  String get trayRunAll => 'Ejecutar todas las reglas';

  @override
  String get traySettings => 'Ajustes';

  @override
  String get trayQuit => 'Salir';

  @override
  String get trayTooltip => 'Sortify - organizador de archivos';

  @override
  String notificationsMoved(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count archivos movidos',
      one: '1 archivo movido',
    );
    return '$_temp0';
  }

  @override
  String get paletteSearchHint => 'Buscar comandos, reglas y archivos...';

  @override
  String get paletteCommands => 'Comandos';

  @override
  String get paletteRules => 'Reglas';

  @override
  String get paletteFiles => 'Archivos sin coincidencia';

  @override
  String get paletteNoResults => 'No se encontraron resultados';

  @override
  String get paletteCreateRule => 'Crear nueva regla';

  @override
  String get paletteAddFolder => 'Agregar carpeta';

  @override
  String get paletteRunAll => 'Ejecutar todas las reglas';

  @override
  String get palettePause => 'Pausar monitoreo';

  @override
  String get paletteResume => 'Reanudar monitoreo';

  @override
  String get paletteOpenSettings => 'Abrir ajustes';

  @override
  String get paletteGoDashboard => 'Ir al panel';

  @override
  String get paletteGoActivity => 'Ir a actividad';

  @override
  String get paletteGoRules => 'Ir a reglas';

  @override
  String get paletteGoFolders => 'Ir a carpetas';

  @override
  String get paletteRunRule => 'Ejecutar regla';

  @override
  String get paletteToggleTheme => 'Cambiar tema';

  @override
  String get paletteClose => 'Cerrar';

  @override
  String get settingsTitle => 'Ajustes';

  @override
  String get settingsSubtitle => 'Ajusta cómo se comporta Sortify';

  @override
  String get sectionGeneral => 'General';

  @override
  String get sectionMonitoring => 'Monitoreo';

  @override
  String get sectionConflicts => 'Conflictos';

  @override
  String get sectionAppearance => 'Apariencia';

  @override
  String get sectionLanguage => 'Idioma';

  @override
  String get startWithSystem => 'Iniciar con el sistema';

  @override
  String get startWithSystemDesc => 'Abrir Sortify al iniciar sesión';

  @override
  String get startMinimized => 'Iniciar minimizado';

  @override
  String get startMinimizedDesc =>
      'Abrir en la bandeja del sistema sin ventana';

  @override
  String get confirmFileOperations => 'Confirmar operaciones de archivos';

  @override
  String get confirmFileOperationsDesc =>
      'Preguntar antes de mover o eliminar archivos';

  @override
  String get scanInterval => 'Intervalo de análisis';

  @override
  String get scanIntervalDesc =>
      'Con qué frecuencia se revisan las carpetas monitoreadas';

  @override
  String secondsShort(int count) {
    return '${count}s';
  }

  @override
  String get watchSubfolders => 'Monitorear subcarpetas';

  @override
  String get watchSubfoldersDesc => 'Incluir carpetas anidadas en el monitoreo';

  @override
  String get ignoreHidden => 'Ignorar archivos ocultos';

  @override
  String get ignoreHiddenDesc => 'Omitir archivos ocultos y del sistema';

  @override
  String get ignoredExtensions => 'Extensiones ignoradas';

  @override
  String get ignoredExtensionsDesc =>
      'Los archivos con estas extensiones nunca se rastrean ni se organizan';

  @override
  String get extensionHint => 'tmp, log';

  @override
  String get addExtension => 'Añadir';

  @override
  String get conflictAskEveryTime => 'Preguntar siempre';

  @override
  String get conflictAskEveryTimeDesc =>
      'Mostrar un diálogo cuando el archivo de destino ya exista';

  @override
  String get conflictKeepBoth => 'Conservar ambos';

  @override
  String get conflictKeepBothDesc =>
      'Renombrar el archivo entrante para no sobrescribir';

  @override
  String get conflictReplace => 'Reemplazar';

  @override
  String get conflictReplaceDesc => 'Sobrescribir el archivo existente';

  @override
  String get conflictSkip => 'Omitir';

  @override
  String get conflictSkipDesc => 'Dejar el archivo donde está';

  @override
  String get appearanceDark => 'Oscuro';

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
  String get settingsSaved => 'Ajustes guardados';

  @override
  String get commonSave => 'Guardar';

  @override
  String get commonCancel => 'Cancelar';

  @override
  String get commonDelete => 'Eliminar';

  @override
  String get commonEdit => 'Editar';

  @override
  String get commonClose => 'Cerrar';

  @override
  String get commonConfirm => 'Confirmar';

  @override
  String get commonApply => 'Aplicar';

  @override
  String get commonRun => 'Ejecutar';

  @override
  String get commonPause => 'Pausar';

  @override
  String get commonResume => 'Reanudar';

  @override
  String get commonRetry => 'Reintentar';

  @override
  String get commonLoading => 'Cargando...';

  @override
  String get commonError => 'Algo salió mal';

  @override
  String get commonSuccess => 'Éxito';

  @override
  String get commonWarning => 'Advertencia';

  @override
  String get commonYes => 'Sí';

  @override
  String get commonNo => 'No';

  @override
  String get commonComingSoon => 'Próximamente';

  @override
  String commonFiles(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count archivos',
      one: '1 archivo',
    );
    return '$_temp0';
  }

  @override
  String get shortcutCommandPalette => 'Paleta de comandos';

  @override
  String get shortcutSearch => 'Buscar';

  @override
  String get helpTitle => 'Guía rápida';

  @override
  String get helpBody =>
      'Agrega una carpeta, crea una regla y Sortify organizará los archivos nuevos automáticamente.';

  @override
  String get filesUnit => 'MB';

  @override
  String get today => 'Hoy';

  @override
  String get yesterday => 'Ayer';
}
