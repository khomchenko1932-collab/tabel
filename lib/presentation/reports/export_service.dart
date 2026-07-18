import 'dart:io';

import 'package:excel/excel.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

import '../../core/utils/formatters.dart';
import '../../data/database/app_database.dart';
import '../../data/models/soldier_view.dart';
import '../../domain/entities/enums.dart';
import '../../domain/services/roster_service.dart';

/// Экспорт строевой записки, списка л/с и вооружения в PDF/Excel/текст.
abstract final class ExportService {
  // ── Строевая записка текстом (для мессенджера) ──
  static Future<void> shareStrevoyaText(RosterStats s, DateTime now, {String unitName = ''}) async {
    final b = StringBuffer()
      ..writeln('СТРОЕВАЯ ЗАПИСКА')
      ..writeln(unitName.isEmpty ? '' : unitName)
      ..writeln(Fmt.full(now))
      ..writeln('─────────────────────')
      ..writeln('По штату:   ${s.total}')
      ..writeln('По списку:  ${s.list}')
      ..writeln('Налицо:     ${s.here}')
      ..writeln('─────────────────────');
    for (final st in PersonnelStatus.values) {
      b.writeln('${st.label}: ${s.count(st)}');
    }
    b.writeln('Вакант: ${s.vacant}');
    await SharePlus.instance.share(ShareParams(text: b.toString()));
  }

  // ── Список л/с в PDF ──
  static Future<void> exportRosterPdf(List<SoldierView> roster, RosterStats stats, DateTime now, {String unitName = ''}) async {
    final font = pw.Font.ttf(await rootBundle.load('assets/fonts/Regular.ttf'));
    final bold = pw.Font.ttf(await rootBundle.load('assets/fonts/Bold.ttf'));
    final doc = pw.Document();

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        theme: pw.ThemeData.withFont(base: font, bold: bold),
        build: (context) => [
          pw.Header(
            level: 0,
            child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
              pw.Text('СПИСОК ЛИЧНОГО СОСТАВА', style: pw.TextStyle(font: bold, fontSize: 16)),
              pw.Text('${unitName.isEmpty ? '' : '$unitName · '}по состоянию на ${Fmt.full(now)}',
                  style: const pw.TextStyle(fontSize: 10)),
            ]),
          ),
          pw.TableHelper.fromTextArray(
            headerStyle: pw.TextStyle(font: bold, fontSize: 9),
            cellStyle: const pw.TextStyle(fontSize: 9),
            headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
            cellAlignments: {0: pw.Alignment.center, 4: pw.Alignment.center},
            headers: ['№', 'Фамилия И.О.', 'Должность', 'Подразделение', 'Статус'],
            data: [
              for (final s in roster)
                [
                  s.position.slot.toString(),
                  s.isVacant ? '— вакант —' : s.displayName,
                  s.position.title,
                  s.position.subunit,
                  s.isVacant ? '—' : s.person!.status.label,
                ],
            ],
          ),
          pw.SizedBox(height: 12),
          pw.Text(
            'Итого: по штату ${stats.total} / по списку ${stats.list} / налицо ${stats.here}',
            style: pw.TextStyle(font: bold, fontSize: 11),
          ),
        ],
      ),
    );

    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/spisok_ls_${_stamp(now)}.pdf');
    await file.writeAsBytes(await doc.save());
    await _shareAndCleanup(file);
  }

  // ── Список л/с в Excel ──
  static Future<void> exportRosterExcel(List<SoldierView> roster, DateTime now, {String unitName = ''}) async {
    final excel = Excel.createExcel();
    final sheet = excel[excel.getDefaultSheet()!];
    if (unitName.isNotEmpty) sheet.appendRow([TextCellValue(unitName)]);
    sheet.appendRow([TextCellValue('№'), TextCellValue('Фамилия И.О.'), TextCellValue('Должность'), TextCellValue('Подразделение'), TextCellValue('Расчёт'), TextCellValue('Категория'), TextCellValue('Статус')]);
    for (final s in roster) {
      sheet.appendRow([
        IntCellValue(s.position.slot),
        TextCellValue(s.isVacant ? '— вакант —' : s.displayName),
        TextCellValue(s.position.title),
        TextCellValue(s.position.subunit),
        TextCellValue(s.position.crew ?? ''),
        TextCellValue(s.position.category.label),
        TextCellValue(s.isVacant ? '—' : s.person!.status.label),
      ]);
    }
    await _shareExcel(excel, 'spisok_ls_${_stamp(now)}.xlsx');
  }

  // ── Вооружение в Excel ──
  static Future<void> exportWeaponsExcel(List<({String soldier, WeaponRow weapon})> items, DateTime now) async {
    final excel = Excel.createExcel();
    final sheet = excel[excel.getDefaultSheet()!];
    sheet.appendRow([TextCellValue('Боец'), TextCellValue('Наименование'), TextCellValue('Категория'), TextCellValue('Серийный №'), TextCellValue('Инвентарный №')]);
    for (final it in items) {
      sheet.appendRow([
        TextCellValue(it.soldier),
        TextCellValue(it.weapon.name),
        TextCellValue(it.weapon.type.label),
        TextCellValue(it.weapon.serialNumber ?? ''),
        TextCellValue(it.weapon.inventoryNumber ?? ''),
      ]);
    }
    await _shareExcel(excel, 'vooruzhenie_${_stamp(now)}.xlsx');
  }

  static Future<void> _shareExcel(Excel excel, String filename) async {
    final bytes = excel.encode();
    if (bytes == null) return;
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/$filename');
    await file.writeAsBytes(bytes);
    await _shareAndCleanup(file);
  }

  /// Шэрим и удаляем temp-файл: отчёты содержат ФИО, незачем оставлять
  /// копию в кэше после того, как получатель забрал файл.
  static Future<void> _shareAndCleanup(File file) async {
    try {
      await SharePlus.instance.share(ShareParams(files: [XFile(file.path)]));
    } finally {
      try {
        if (file.existsSync()) file.deleteSync();
      } catch (_) {/* не критично */}
    }
  }

  static String _stamp(DateTime d) =>
      '${d.year}${d.month.toString().padLeft(2, '0')}${d.day.toString().padLeft(2, '0')}';
}
