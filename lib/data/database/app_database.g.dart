// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $SettingsTable extends Settings
    with TableInfo<$SettingsTable, SettingRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<SettingRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  SettingRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SettingRow(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $SettingsTable createAlias(String alias) {
    return $SettingsTable(attachedDatabase, alias);
  }
}

class SettingRow extends DataClass implements Insertable<SettingRow> {
  final String key;
  final String value;
  const SettingRow({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  SettingsCompanion toCompanion(bool nullToAbsent) {
    return SettingsCompanion(key: Value(key), value: Value(value));
  }

  factory SettingRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SettingRow(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  SettingRow copyWith({String? key, String? value}) =>
      SettingRow(key: key ?? this.key, value: value ?? this.value);
  SettingRow copyWithCompanion(SettingsCompanion data) {
    return SettingRow(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SettingRow(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SettingRow &&
          other.key == this.key &&
          other.value == this.value);
}

class SettingsCompanion extends UpdateCompanion<SettingRow> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const SettingsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SettingsCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<SettingRow> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SettingsCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return SettingsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettingsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PositionsTable extends Positions
    with TableInfo<$PositionsTable, PositionRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PositionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _slotMeta = const VerificationMeta('slot');
  @override
  late final GeneratedColumn<int> slot = GeneratedColumn<int>(
    'slot',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _subunitMeta = const VerificationMeta(
    'subunit',
  );
  @override
  late final GeneratedColumn<String> subunit = GeneratedColumn<String>(
    'subunit',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Подразделение'),
  );
  @override
  late final GeneratedColumnWithTypeConverter<RankCategory, int> category =
      GeneratedColumn<int>(
        'category',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<RankCategory>($PositionsTable.$convertercategory);
  static const VerificationMeta _crewMeta = const VerificationMeta('crew');
  @override
  late final GeneratedColumn<String> crew = GeneratedColumn<String>(
    'crew',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _tariffRankMeta = const VerificationMeta(
    'tariffRank',
  );
  @override
  late final GeneratedColumn<int> tariffRank = GeneratedColumn<int>(
    'tariff_rank',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    slot,
    title,
    subunit,
    category,
    crew,
    tariffRank,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'positions';
  @override
  VerificationContext validateIntegrity(
    Insertable<PositionRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('slot')) {
      context.handle(
        _slotMeta,
        slot.isAcceptableOrUnknown(data['slot']!, _slotMeta),
      );
    } else if (isInserting) {
      context.missing(_slotMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('subunit')) {
      context.handle(
        _subunitMeta,
        subunit.isAcceptableOrUnknown(data['subunit']!, _subunitMeta),
      );
    }
    if (data.containsKey('crew')) {
      context.handle(
        _crewMeta,
        crew.isAcceptableOrUnknown(data['crew']!, _crewMeta),
      );
    }
    if (data.containsKey('tariff_rank')) {
      context.handle(
        _tariffRankMeta,
        tariffRank.isAcceptableOrUnknown(data['tariff_rank']!, _tariffRankMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PositionRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PositionRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      slot: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}slot'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      subunit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}subunit'],
      )!,
      category: $PositionsTable.$convertercategory.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}category'],
        )!,
      ),
      crew: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}crew'],
      ),
      tariffRank: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}tariff_rank'],
      ),
    );
  }

  @override
  $PositionsTable createAlias(String alias) {
    return $PositionsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<RankCategory, int, int> $convertercategory =
      const EnumIndexConverter<RankCategory>(RankCategory.values);
}

class PositionRow extends DataClass implements Insertable<PositionRow> {
  final int id;

  /// Порядковый номер по штату.
  final int slot;
  final String title;

  /// Подразделение/взвод — свободный текст (любая структура части).
  final String subunit;
  final RankCategory category;

  /// Расчёт/машина внутри огневого взвода (напр. «КМ-1»), может быть пустым.
  final String? crew;

  /// Тарифный разряд должности (1–50) для расчёта оклада по должности (ОВД).
  final int? tariffRank;
  const PositionRow({
    required this.id,
    required this.slot,
    required this.title,
    required this.subunit,
    required this.category,
    this.crew,
    this.tariffRank,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['slot'] = Variable<int>(slot);
    map['title'] = Variable<String>(title);
    map['subunit'] = Variable<String>(subunit);
    {
      map['category'] = Variable<int>(
        $PositionsTable.$convertercategory.toSql(category),
      );
    }
    if (!nullToAbsent || crew != null) {
      map['crew'] = Variable<String>(crew);
    }
    if (!nullToAbsent || tariffRank != null) {
      map['tariff_rank'] = Variable<int>(tariffRank);
    }
    return map;
  }

  PositionsCompanion toCompanion(bool nullToAbsent) {
    return PositionsCompanion(
      id: Value(id),
      slot: Value(slot),
      title: Value(title),
      subunit: Value(subunit),
      category: Value(category),
      crew: crew == null && nullToAbsent ? const Value.absent() : Value(crew),
      tariffRank: tariffRank == null && nullToAbsent
          ? const Value.absent()
          : Value(tariffRank),
    );
  }

  factory PositionRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PositionRow(
      id: serializer.fromJson<int>(json['id']),
      slot: serializer.fromJson<int>(json['slot']),
      title: serializer.fromJson<String>(json['title']),
      subunit: serializer.fromJson<String>(json['subunit']),
      category: $PositionsTable.$convertercategory.fromJson(
        serializer.fromJson<int>(json['category']),
      ),
      crew: serializer.fromJson<String?>(json['crew']),
      tariffRank: serializer.fromJson<int?>(json['tariffRank']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'slot': serializer.toJson<int>(slot),
      'title': serializer.toJson<String>(title),
      'subunit': serializer.toJson<String>(subunit),
      'category': serializer.toJson<int>(
        $PositionsTable.$convertercategory.toJson(category),
      ),
      'crew': serializer.toJson<String?>(crew),
      'tariffRank': serializer.toJson<int?>(tariffRank),
    };
  }

  PositionRow copyWith({
    int? id,
    int? slot,
    String? title,
    String? subunit,
    RankCategory? category,
    Value<String?> crew = const Value.absent(),
    Value<int?> tariffRank = const Value.absent(),
  }) => PositionRow(
    id: id ?? this.id,
    slot: slot ?? this.slot,
    title: title ?? this.title,
    subunit: subunit ?? this.subunit,
    category: category ?? this.category,
    crew: crew.present ? crew.value : this.crew,
    tariffRank: tariffRank.present ? tariffRank.value : this.tariffRank,
  );
  PositionRow copyWithCompanion(PositionsCompanion data) {
    return PositionRow(
      id: data.id.present ? data.id.value : this.id,
      slot: data.slot.present ? data.slot.value : this.slot,
      title: data.title.present ? data.title.value : this.title,
      subunit: data.subunit.present ? data.subunit.value : this.subunit,
      category: data.category.present ? data.category.value : this.category,
      crew: data.crew.present ? data.crew.value : this.crew,
      tariffRank: data.tariffRank.present
          ? data.tariffRank.value
          : this.tariffRank,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PositionRow(')
          ..write('id: $id, ')
          ..write('slot: $slot, ')
          ..write('title: $title, ')
          ..write('subunit: $subunit, ')
          ..write('category: $category, ')
          ..write('crew: $crew, ')
          ..write('tariffRank: $tariffRank')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, slot, title, subunit, category, crew, tariffRank);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PositionRow &&
          other.id == this.id &&
          other.slot == this.slot &&
          other.title == this.title &&
          other.subunit == this.subunit &&
          other.category == this.category &&
          other.crew == this.crew &&
          other.tariffRank == this.tariffRank);
}

class PositionsCompanion extends UpdateCompanion<PositionRow> {
  final Value<int> id;
  final Value<int> slot;
  final Value<String> title;
  final Value<String> subunit;
  final Value<RankCategory> category;
  final Value<String?> crew;
  final Value<int?> tariffRank;
  const PositionsCompanion({
    this.id = const Value.absent(),
    this.slot = const Value.absent(),
    this.title = const Value.absent(),
    this.subunit = const Value.absent(),
    this.category = const Value.absent(),
    this.crew = const Value.absent(),
    this.tariffRank = const Value.absent(),
  });
  PositionsCompanion.insert({
    this.id = const Value.absent(),
    required int slot,
    required String title,
    this.subunit = const Value.absent(),
    required RankCategory category,
    this.crew = const Value.absent(),
    this.tariffRank = const Value.absent(),
  }) : slot = Value(slot),
       title = Value(title),
       category = Value(category);
  static Insertable<PositionRow> custom({
    Expression<int>? id,
    Expression<int>? slot,
    Expression<String>? title,
    Expression<String>? subunit,
    Expression<int>? category,
    Expression<String>? crew,
    Expression<int>? tariffRank,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (slot != null) 'slot': slot,
      if (title != null) 'title': title,
      if (subunit != null) 'subunit': subunit,
      if (category != null) 'category': category,
      if (crew != null) 'crew': crew,
      if (tariffRank != null) 'tariff_rank': tariffRank,
    });
  }

  PositionsCompanion copyWith({
    Value<int>? id,
    Value<int>? slot,
    Value<String>? title,
    Value<String>? subunit,
    Value<RankCategory>? category,
    Value<String?>? crew,
    Value<int?>? tariffRank,
  }) {
    return PositionsCompanion(
      id: id ?? this.id,
      slot: slot ?? this.slot,
      title: title ?? this.title,
      subunit: subunit ?? this.subunit,
      category: category ?? this.category,
      crew: crew ?? this.crew,
      tariffRank: tariffRank ?? this.tariffRank,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (slot.present) {
      map['slot'] = Variable<int>(slot.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (subunit.present) {
      map['subunit'] = Variable<String>(subunit.value);
    }
    if (category.present) {
      map['category'] = Variable<int>(
        $PositionsTable.$convertercategory.toSql(category.value),
      );
    }
    if (crew.present) {
      map['crew'] = Variable<String>(crew.value);
    }
    if (tariffRank.present) {
      map['tariff_rank'] = Variable<int>(tariffRank.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PositionsCompanion(')
          ..write('id: $id, ')
          ..write('slot: $slot, ')
          ..write('title: $title, ')
          ..write('subunit: $subunit, ')
          ..write('category: $category, ')
          ..write('crew: $crew, ')
          ..write('tariffRank: $tariffRank')
          ..write(')'))
        .toString();
  }
}

class $PersonnelTable extends Personnel
    with TableInfo<$PersonnelTable, PersonRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PersonnelTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _positionIdMeta = const VerificationMeta(
    'positionId',
  );
  @override
  late final GeneratedColumn<int> positionId = GeneratedColumn<int>(
    'position_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES positions (id)',
    ),
  );
  static const VerificationMeta _lastNameMeta = const VerificationMeta(
    'lastName',
  );
  @override
  late final GeneratedColumn<String> lastName = GeneratedColumn<String>(
    'last_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _firstNameMeta = const VerificationMeta(
    'firstName',
  );
  @override
  late final GeneratedColumn<String> firstName = GeneratedColumn<String>(
    'first_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _middleNameMeta = const VerificationMeta(
    'middleName',
  );
  @override
  late final GeneratedColumn<String> middleName = GeneratedColumn<String>(
    'middle_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _rankMeta = const VerificationMeta('rank');
  @override
  late final GeneratedColumn<String> rank = GeneratedColumn<String>(
    'rank',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  @override
  late final GeneratedColumnWithTypeConverter<PersonnelStatus, int> status =
      GeneratedColumn<int>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        defaultValue: const Constant(0),
      ).withConverter<PersonnelStatus>($PersonnelTable.$converterstatus);
  static const VerificationMeta _personalNumberMeta = const VerificationMeta(
    'personalNumber',
  );
  @override
  late final GeneratedColumn<String> personalNumber = GeneratedColumn<String>(
    'personal_number',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _phoneMeta = const VerificationMeta('phone');
  @override
  late final GeneratedColumn<String> phone = GeneratedColumn<String>(
    'phone',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _addressMeta = const VerificationMeta(
    'address',
  );
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
    'address',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  late final GeneratedColumnWithTypeConverter<MaritalStatus?, int>
  maritalStatus = GeneratedColumn<int>(
    'marital_status',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  ).withConverter<MaritalStatus?>($PersonnelTable.$convertermaritalStatusn);
  static const VerificationMeta _childrenCountMeta = const VerificationMeta(
    'childrenCount',
  );
  @override
  late final GeneratedColumn<int> childrenCount = GeneratedColumn<int>(
    'children_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _birthDateMeta = const VerificationMeta(
    'birthDate',
  );
  @override
  late final GeneratedColumn<DateTime> birthDate = GeneratedColumn<DateTime>(
    'birth_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _contractStartMeta = const VerificationMeta(
    'contractStart',
  );
  @override
  late final GeneratedColumn<DateTime> contractStart =
      GeneratedColumn<DateTime>(
        'contract_start',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _contractEndMeta = const VerificationMeta(
    'contractEnd',
  );
  @override
  late final GeneratedColumn<DateTime> contractEnd = GeneratedColumn<DateTime>(
    'contract_end',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _qualificationMeta = const VerificationMeta(
    'qualification',
  );
  @override
  late final GeneratedColumn<String> qualification = GeneratedColumn<String>(
    'qualification',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _qualificationDateMeta = const VerificationMeta(
    'qualificationDate',
  );
  @override
  late final GeneratedColumn<DateTime> qualificationDate =
      GeneratedColumn<DateTime>(
        'qualification_date',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _serviceStartMeta = const VerificationMeta(
    'serviceStart',
  );
  @override
  late final GeneratedColumn<DateTime> serviceStart = GeneratedColumn<DateTime>(
    'service_start',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isVeteranMeta = const VerificationMeta(
    'isVeteran',
  );
  @override
  late final GeneratedColumn<bool> isVeteran = GeneratedColumn<bool>(
    'is_veteran',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_veteran" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _allowanceSpecialMeta = const VerificationMeta(
    'allowanceSpecial',
  );
  @override
  late final GeneratedColumn<int> allowanceSpecial = GeneratedColumn<int>(
    'allowance_special',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _allowanceSecrecyMeta = const VerificationMeta(
    'allowanceSecrecy',
  );
  @override
  late final GeneratedColumn<int> allowanceSecrecy = GeneratedColumn<int>(
    'allowance_secrecy',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _allowanceRiskMeta = const VerificationMeta(
    'allowanceRisk',
  );
  @override
  late final GeneratedColumn<int> allowanceRisk = GeneratedColumn<int>(
    'allowance_risk',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _allowanceFizoMeta = const VerificationMeta(
    'allowanceFizo',
  );
  @override
  late final GeneratedColumn<int> allowanceFizo = GeneratedColumn<int>(
    'allowance_fizo',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _allowanceAchieveMeta = const VerificationMeta(
    'allowanceAchieve',
  );
  @override
  late final GeneratedColumn<int> allowanceAchieve = GeneratedColumn<int>(
    'allowance_achieve',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _regionalCoefMeta = const VerificationMeta(
    'regionalCoef',
  );
  @override
  late final GeneratedColumn<double> regionalCoef = GeneratedColumn<double>(
    'regional_coef',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(1.0),
  );
  static const VerificationMeta _premiumPercentMeta = const VerificationMeta(
    'premiumPercent',
  );
  @override
  late final GeneratedColumn<int> premiumPercent = GeneratedColumn<int>(
    'premium_percent',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _leaveLimitMainMeta = const VerificationMeta(
    'leaveLimitMain',
  );
  @override
  late final GeneratedColumn<int> leaveLimitMain = GeneratedColumn<int>(
    'leave_limit_main',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(40),
  );
  static const VerificationMeta _leaveLimitAdditionalMeta =
      const VerificationMeta('leaveLimitAdditional');
  @override
  late final GeneratedColumn<int> leaveLimitAdditional = GeneratedColumn<int>(
    'leave_limit_additional',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(7),
  );
  static const VerificationMeta _leaveLimitVeteranMeta = const VerificationMeta(
    'leaveLimitVeteran',
  );
  @override
  late final GeneratedColumn<int> leaveLimitVeteran = GeneratedColumn<int>(
    'leave_limit_veteran',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isArchivedMeta = const VerificationMeta(
    'isArchived',
  );
  @override
  late final GeneratedColumn<bool> isArchived = GeneratedColumn<bool>(
    'is_archived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_archived" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    positionId,
    lastName,
    firstName,
    middleName,
    rank,
    status,
    personalNumber,
    phone,
    address,
    maritalStatus,
    childrenCount,
    birthDate,
    contractStart,
    contractEnd,
    qualification,
    qualificationDate,
    serviceStart,
    isVeteran,
    allowanceSpecial,
    allowanceSecrecy,
    allowanceRisk,
    allowanceFizo,
    allowanceAchieve,
    regionalCoef,
    premiumPercent,
    leaveLimitMain,
    leaveLimitAdditional,
    leaveLimitVeteran,
    isArchived,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'personnel';
  @override
  VerificationContext validateIntegrity(
    Insertable<PersonRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('position_id')) {
      context.handle(
        _positionIdMeta,
        positionId.isAcceptableOrUnknown(data['position_id']!, _positionIdMeta),
      );
    }
    if (data.containsKey('last_name')) {
      context.handle(
        _lastNameMeta,
        lastName.isAcceptableOrUnknown(data['last_name']!, _lastNameMeta),
      );
    } else if (isInserting) {
      context.missing(_lastNameMeta);
    }
    if (data.containsKey('first_name')) {
      context.handle(
        _firstNameMeta,
        firstName.isAcceptableOrUnknown(data['first_name']!, _firstNameMeta),
      );
    }
    if (data.containsKey('middle_name')) {
      context.handle(
        _middleNameMeta,
        middleName.isAcceptableOrUnknown(data['middle_name']!, _middleNameMeta),
      );
    }
    if (data.containsKey('rank')) {
      context.handle(
        _rankMeta,
        rank.isAcceptableOrUnknown(data['rank']!, _rankMeta),
      );
    }
    if (data.containsKey('personal_number')) {
      context.handle(
        _personalNumberMeta,
        personalNumber.isAcceptableOrUnknown(
          data['personal_number']!,
          _personalNumberMeta,
        ),
      );
    }
    if (data.containsKey('phone')) {
      context.handle(
        _phoneMeta,
        phone.isAcceptableOrUnknown(data['phone']!, _phoneMeta),
      );
    }
    if (data.containsKey('address')) {
      context.handle(
        _addressMeta,
        address.isAcceptableOrUnknown(data['address']!, _addressMeta),
      );
    }
    if (data.containsKey('children_count')) {
      context.handle(
        _childrenCountMeta,
        childrenCount.isAcceptableOrUnknown(
          data['children_count']!,
          _childrenCountMeta,
        ),
      );
    }
    if (data.containsKey('birth_date')) {
      context.handle(
        _birthDateMeta,
        birthDate.isAcceptableOrUnknown(data['birth_date']!, _birthDateMeta),
      );
    }
    if (data.containsKey('contract_start')) {
      context.handle(
        _contractStartMeta,
        contractStart.isAcceptableOrUnknown(
          data['contract_start']!,
          _contractStartMeta,
        ),
      );
    }
    if (data.containsKey('contract_end')) {
      context.handle(
        _contractEndMeta,
        contractEnd.isAcceptableOrUnknown(
          data['contract_end']!,
          _contractEndMeta,
        ),
      );
    }
    if (data.containsKey('qualification')) {
      context.handle(
        _qualificationMeta,
        qualification.isAcceptableOrUnknown(
          data['qualification']!,
          _qualificationMeta,
        ),
      );
    }
    if (data.containsKey('qualification_date')) {
      context.handle(
        _qualificationDateMeta,
        qualificationDate.isAcceptableOrUnknown(
          data['qualification_date']!,
          _qualificationDateMeta,
        ),
      );
    }
    if (data.containsKey('service_start')) {
      context.handle(
        _serviceStartMeta,
        serviceStart.isAcceptableOrUnknown(
          data['service_start']!,
          _serviceStartMeta,
        ),
      );
    }
    if (data.containsKey('is_veteran')) {
      context.handle(
        _isVeteranMeta,
        isVeteran.isAcceptableOrUnknown(data['is_veteran']!, _isVeteranMeta),
      );
    }
    if (data.containsKey('allowance_special')) {
      context.handle(
        _allowanceSpecialMeta,
        allowanceSpecial.isAcceptableOrUnknown(
          data['allowance_special']!,
          _allowanceSpecialMeta,
        ),
      );
    }
    if (data.containsKey('allowance_secrecy')) {
      context.handle(
        _allowanceSecrecyMeta,
        allowanceSecrecy.isAcceptableOrUnknown(
          data['allowance_secrecy']!,
          _allowanceSecrecyMeta,
        ),
      );
    }
    if (data.containsKey('allowance_risk')) {
      context.handle(
        _allowanceRiskMeta,
        allowanceRisk.isAcceptableOrUnknown(
          data['allowance_risk']!,
          _allowanceRiskMeta,
        ),
      );
    }
    if (data.containsKey('allowance_fizo')) {
      context.handle(
        _allowanceFizoMeta,
        allowanceFizo.isAcceptableOrUnknown(
          data['allowance_fizo']!,
          _allowanceFizoMeta,
        ),
      );
    }
    if (data.containsKey('allowance_achieve')) {
      context.handle(
        _allowanceAchieveMeta,
        allowanceAchieve.isAcceptableOrUnknown(
          data['allowance_achieve']!,
          _allowanceAchieveMeta,
        ),
      );
    }
    if (data.containsKey('regional_coef')) {
      context.handle(
        _regionalCoefMeta,
        regionalCoef.isAcceptableOrUnknown(
          data['regional_coef']!,
          _regionalCoefMeta,
        ),
      );
    }
    if (data.containsKey('premium_percent')) {
      context.handle(
        _premiumPercentMeta,
        premiumPercent.isAcceptableOrUnknown(
          data['premium_percent']!,
          _premiumPercentMeta,
        ),
      );
    }
    if (data.containsKey('leave_limit_main')) {
      context.handle(
        _leaveLimitMainMeta,
        leaveLimitMain.isAcceptableOrUnknown(
          data['leave_limit_main']!,
          _leaveLimitMainMeta,
        ),
      );
    }
    if (data.containsKey('leave_limit_additional')) {
      context.handle(
        _leaveLimitAdditionalMeta,
        leaveLimitAdditional.isAcceptableOrUnknown(
          data['leave_limit_additional']!,
          _leaveLimitAdditionalMeta,
        ),
      );
    }
    if (data.containsKey('leave_limit_veteran')) {
      context.handle(
        _leaveLimitVeteranMeta,
        leaveLimitVeteran.isAcceptableOrUnknown(
          data['leave_limit_veteran']!,
          _leaveLimitVeteranMeta,
        ),
      );
    }
    if (data.containsKey('is_archived')) {
      context.handle(
        _isArchivedMeta,
        isArchived.isAcceptableOrUnknown(data['is_archived']!, _isArchivedMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PersonRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PersonRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      positionId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}position_id'],
      ),
      lastName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_name'],
      )!,
      firstName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}first_name'],
      )!,
      middleName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}middle_name'],
      )!,
      rank: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}rank'],
      )!,
      status: $PersonnelTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}status'],
        )!,
      ),
      personalNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}personal_number'],
      ),
      phone: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone'],
      ),
      address: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}address'],
      ),
      maritalStatus: $PersonnelTable.$convertermaritalStatusn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}marital_status'],
        ),
      ),
      childrenCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}children_count'],
      )!,
      birthDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}birth_date'],
      ),
      contractStart: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}contract_start'],
      ),
      contractEnd: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}contract_end'],
      ),
      qualification: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}qualification'],
      ),
      qualificationDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}qualification_date'],
      ),
      serviceStart: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}service_start'],
      ),
      isVeteran: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_veteran'],
      )!,
      allowanceSpecial: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}allowance_special'],
      )!,
      allowanceSecrecy: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}allowance_secrecy'],
      )!,
      allowanceRisk: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}allowance_risk'],
      )!,
      allowanceFizo: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}allowance_fizo'],
      )!,
      allowanceAchieve: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}allowance_achieve'],
      )!,
      regionalCoef: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}regional_coef'],
      )!,
      premiumPercent: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}premium_percent'],
      )!,
      leaveLimitMain: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}leave_limit_main'],
      )!,
      leaveLimitAdditional: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}leave_limit_additional'],
      )!,
      leaveLimitVeteran: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}leave_limit_veteran'],
      )!,
      isArchived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_archived'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $PersonnelTable createAlias(String alias) {
    return $PersonnelTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<PersonnelStatus, int, int> $converterstatus =
      const EnumIndexConverter<PersonnelStatus>(PersonnelStatus.values);
  static JsonTypeConverter2<MaritalStatus, int, int> $convertermaritalStatus =
      const EnumIndexConverter<MaritalStatus>(MaritalStatus.values);
  static JsonTypeConverter2<MaritalStatus?, int?, int?>
  $convertermaritalStatusn = JsonTypeConverter2.asNullable(
    $convertermaritalStatus,
  );
}

class PersonRow extends DataClass implements Insertable<PersonRow> {
  final int id;
  final int? positionId;
  final String lastName;
  final String firstName;
  final String middleName;
  final String rank;
  final PersonnelStatus status;
  final String? personalNumber;
  final String? phone;
  final String? address;
  final MaritalStatus? maritalStatus;
  final int childrenCount;
  final DateTime? birthDate;
  final DateTime? contractStart;
  final DateTime? contractEnd;
  final String? qualification;
  final DateTime? qualificationDate;

  /// Дата начала военной службы — якорь для расчёта выслуги лет
  /// (не путать с [contractStart]: срочная/училище тоже входят).
  final DateTime? serviceStart;
  final bool isVeteran;

  /// Надбавка за особые условия военной службы, % от оклада по должности.
  final int allowanceSpecial;

  /// Надбавка за работу со сведениями, составляющими гостайну, % от ОВД.
  final int allowanceSecrecy;

  /// Надбавка за выполнение задач с риском для жизни, % от ОВД.
  final int allowanceRisk;

  /// Надбавка за физическую подготовленность, % от ОВД.
  final int allowanceFizo;

  /// Надбавка за особые достижения в службе, % от ОВД.
  final int allowanceAchieve;

  /// Районный коэффициент (1.0 — нет; 1.15, 1.5, 2.0 и т.п.).
  final double regionalCoef;

  /// Ежемесячная премия, % от оклада месячного содержания (ОМДС).
  /// По умолчанию 0 — командир задаёт сам.
  final int premiumPercent;
  final int leaveLimitMain;
  final int leaveLimitAdditional;
  final int leaveLimitVeteran;
  final bool isArchived;
  final DateTime createdAt;
  final DateTime updatedAt;
  const PersonRow({
    required this.id,
    this.positionId,
    required this.lastName,
    required this.firstName,
    required this.middleName,
    required this.rank,
    required this.status,
    this.personalNumber,
    this.phone,
    this.address,
    this.maritalStatus,
    required this.childrenCount,
    this.birthDate,
    this.contractStart,
    this.contractEnd,
    this.qualification,
    this.qualificationDate,
    this.serviceStart,
    required this.isVeteran,
    required this.allowanceSpecial,
    required this.allowanceSecrecy,
    required this.allowanceRisk,
    required this.allowanceFizo,
    required this.allowanceAchieve,
    required this.regionalCoef,
    required this.premiumPercent,
    required this.leaveLimitMain,
    required this.leaveLimitAdditional,
    required this.leaveLimitVeteran,
    required this.isArchived,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    if (!nullToAbsent || positionId != null) {
      map['position_id'] = Variable<int>(positionId);
    }
    map['last_name'] = Variable<String>(lastName);
    map['first_name'] = Variable<String>(firstName);
    map['middle_name'] = Variable<String>(middleName);
    map['rank'] = Variable<String>(rank);
    {
      map['status'] = Variable<int>(
        $PersonnelTable.$converterstatus.toSql(status),
      );
    }
    if (!nullToAbsent || personalNumber != null) {
      map['personal_number'] = Variable<String>(personalNumber);
    }
    if (!nullToAbsent || phone != null) {
      map['phone'] = Variable<String>(phone);
    }
    if (!nullToAbsent || address != null) {
      map['address'] = Variable<String>(address);
    }
    if (!nullToAbsent || maritalStatus != null) {
      map['marital_status'] = Variable<int>(
        $PersonnelTable.$convertermaritalStatusn.toSql(maritalStatus),
      );
    }
    map['children_count'] = Variable<int>(childrenCount);
    if (!nullToAbsent || birthDate != null) {
      map['birth_date'] = Variable<DateTime>(birthDate);
    }
    if (!nullToAbsent || contractStart != null) {
      map['contract_start'] = Variable<DateTime>(contractStart);
    }
    if (!nullToAbsent || contractEnd != null) {
      map['contract_end'] = Variable<DateTime>(contractEnd);
    }
    if (!nullToAbsent || qualification != null) {
      map['qualification'] = Variable<String>(qualification);
    }
    if (!nullToAbsent || qualificationDate != null) {
      map['qualification_date'] = Variable<DateTime>(qualificationDate);
    }
    if (!nullToAbsent || serviceStart != null) {
      map['service_start'] = Variable<DateTime>(serviceStart);
    }
    map['is_veteran'] = Variable<bool>(isVeteran);
    map['allowance_special'] = Variable<int>(allowanceSpecial);
    map['allowance_secrecy'] = Variable<int>(allowanceSecrecy);
    map['allowance_risk'] = Variable<int>(allowanceRisk);
    map['allowance_fizo'] = Variable<int>(allowanceFizo);
    map['allowance_achieve'] = Variable<int>(allowanceAchieve);
    map['regional_coef'] = Variable<double>(regionalCoef);
    map['premium_percent'] = Variable<int>(premiumPercent);
    map['leave_limit_main'] = Variable<int>(leaveLimitMain);
    map['leave_limit_additional'] = Variable<int>(leaveLimitAdditional);
    map['leave_limit_veteran'] = Variable<int>(leaveLimitVeteran);
    map['is_archived'] = Variable<bool>(isArchived);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  PersonnelCompanion toCompanion(bool nullToAbsent) {
    return PersonnelCompanion(
      id: Value(id),
      positionId: positionId == null && nullToAbsent
          ? const Value.absent()
          : Value(positionId),
      lastName: Value(lastName),
      firstName: Value(firstName),
      middleName: Value(middleName),
      rank: Value(rank),
      status: Value(status),
      personalNumber: personalNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(personalNumber),
      phone: phone == null && nullToAbsent
          ? const Value.absent()
          : Value(phone),
      address: address == null && nullToAbsent
          ? const Value.absent()
          : Value(address),
      maritalStatus: maritalStatus == null && nullToAbsent
          ? const Value.absent()
          : Value(maritalStatus),
      childrenCount: Value(childrenCount),
      birthDate: birthDate == null && nullToAbsent
          ? const Value.absent()
          : Value(birthDate),
      contractStart: contractStart == null && nullToAbsent
          ? const Value.absent()
          : Value(contractStart),
      contractEnd: contractEnd == null && nullToAbsent
          ? const Value.absent()
          : Value(contractEnd),
      qualification: qualification == null && nullToAbsent
          ? const Value.absent()
          : Value(qualification),
      qualificationDate: qualificationDate == null && nullToAbsent
          ? const Value.absent()
          : Value(qualificationDate),
      serviceStart: serviceStart == null && nullToAbsent
          ? const Value.absent()
          : Value(serviceStart),
      isVeteran: Value(isVeteran),
      allowanceSpecial: Value(allowanceSpecial),
      allowanceSecrecy: Value(allowanceSecrecy),
      allowanceRisk: Value(allowanceRisk),
      allowanceFizo: Value(allowanceFizo),
      allowanceAchieve: Value(allowanceAchieve),
      regionalCoef: Value(regionalCoef),
      premiumPercent: Value(premiumPercent),
      leaveLimitMain: Value(leaveLimitMain),
      leaveLimitAdditional: Value(leaveLimitAdditional),
      leaveLimitVeteran: Value(leaveLimitVeteran),
      isArchived: Value(isArchived),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory PersonRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PersonRow(
      id: serializer.fromJson<int>(json['id']),
      positionId: serializer.fromJson<int?>(json['positionId']),
      lastName: serializer.fromJson<String>(json['lastName']),
      firstName: serializer.fromJson<String>(json['firstName']),
      middleName: serializer.fromJson<String>(json['middleName']),
      rank: serializer.fromJson<String>(json['rank']),
      status: $PersonnelTable.$converterstatus.fromJson(
        serializer.fromJson<int>(json['status']),
      ),
      personalNumber: serializer.fromJson<String?>(json['personalNumber']),
      phone: serializer.fromJson<String?>(json['phone']),
      address: serializer.fromJson<String?>(json['address']),
      maritalStatus: $PersonnelTable.$convertermaritalStatusn.fromJson(
        serializer.fromJson<int?>(json['maritalStatus']),
      ),
      childrenCount: serializer.fromJson<int>(json['childrenCount']),
      birthDate: serializer.fromJson<DateTime?>(json['birthDate']),
      contractStart: serializer.fromJson<DateTime?>(json['contractStart']),
      contractEnd: serializer.fromJson<DateTime?>(json['contractEnd']),
      qualification: serializer.fromJson<String?>(json['qualification']),
      qualificationDate: serializer.fromJson<DateTime?>(
        json['qualificationDate'],
      ),
      serviceStart: serializer.fromJson<DateTime?>(json['serviceStart']),
      isVeteran: serializer.fromJson<bool>(json['isVeteran']),
      allowanceSpecial: serializer.fromJson<int>(json['allowanceSpecial']),
      allowanceSecrecy: serializer.fromJson<int>(json['allowanceSecrecy']),
      allowanceRisk: serializer.fromJson<int>(json['allowanceRisk']),
      allowanceFizo: serializer.fromJson<int>(json['allowanceFizo']),
      allowanceAchieve: serializer.fromJson<int>(json['allowanceAchieve']),
      regionalCoef: serializer.fromJson<double>(json['regionalCoef']),
      premiumPercent: serializer.fromJson<int>(json['premiumPercent']),
      leaveLimitMain: serializer.fromJson<int>(json['leaveLimitMain']),
      leaveLimitAdditional: serializer.fromJson<int>(
        json['leaveLimitAdditional'],
      ),
      leaveLimitVeteran: serializer.fromJson<int>(json['leaveLimitVeteran']),
      isArchived: serializer.fromJson<bool>(json['isArchived']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'positionId': serializer.toJson<int?>(positionId),
      'lastName': serializer.toJson<String>(lastName),
      'firstName': serializer.toJson<String>(firstName),
      'middleName': serializer.toJson<String>(middleName),
      'rank': serializer.toJson<String>(rank),
      'status': serializer.toJson<int>(
        $PersonnelTable.$converterstatus.toJson(status),
      ),
      'personalNumber': serializer.toJson<String?>(personalNumber),
      'phone': serializer.toJson<String?>(phone),
      'address': serializer.toJson<String?>(address),
      'maritalStatus': serializer.toJson<int?>(
        $PersonnelTable.$convertermaritalStatusn.toJson(maritalStatus),
      ),
      'childrenCount': serializer.toJson<int>(childrenCount),
      'birthDate': serializer.toJson<DateTime?>(birthDate),
      'contractStart': serializer.toJson<DateTime?>(contractStart),
      'contractEnd': serializer.toJson<DateTime?>(contractEnd),
      'qualification': serializer.toJson<String?>(qualification),
      'qualificationDate': serializer.toJson<DateTime?>(qualificationDate),
      'serviceStart': serializer.toJson<DateTime?>(serviceStart),
      'isVeteran': serializer.toJson<bool>(isVeteran),
      'allowanceSpecial': serializer.toJson<int>(allowanceSpecial),
      'allowanceSecrecy': serializer.toJson<int>(allowanceSecrecy),
      'allowanceRisk': serializer.toJson<int>(allowanceRisk),
      'allowanceFizo': serializer.toJson<int>(allowanceFizo),
      'allowanceAchieve': serializer.toJson<int>(allowanceAchieve),
      'regionalCoef': serializer.toJson<double>(regionalCoef),
      'premiumPercent': serializer.toJson<int>(premiumPercent),
      'leaveLimitMain': serializer.toJson<int>(leaveLimitMain),
      'leaveLimitAdditional': serializer.toJson<int>(leaveLimitAdditional),
      'leaveLimitVeteran': serializer.toJson<int>(leaveLimitVeteran),
      'isArchived': serializer.toJson<bool>(isArchived),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  PersonRow copyWith({
    int? id,
    Value<int?> positionId = const Value.absent(),
    String? lastName,
    String? firstName,
    String? middleName,
    String? rank,
    PersonnelStatus? status,
    Value<String?> personalNumber = const Value.absent(),
    Value<String?> phone = const Value.absent(),
    Value<String?> address = const Value.absent(),
    Value<MaritalStatus?> maritalStatus = const Value.absent(),
    int? childrenCount,
    Value<DateTime?> birthDate = const Value.absent(),
    Value<DateTime?> contractStart = const Value.absent(),
    Value<DateTime?> contractEnd = const Value.absent(),
    Value<String?> qualification = const Value.absent(),
    Value<DateTime?> qualificationDate = const Value.absent(),
    Value<DateTime?> serviceStart = const Value.absent(),
    bool? isVeteran,
    int? allowanceSpecial,
    int? allowanceSecrecy,
    int? allowanceRisk,
    int? allowanceFizo,
    int? allowanceAchieve,
    double? regionalCoef,
    int? premiumPercent,
    int? leaveLimitMain,
    int? leaveLimitAdditional,
    int? leaveLimitVeteran,
    bool? isArchived,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => PersonRow(
    id: id ?? this.id,
    positionId: positionId.present ? positionId.value : this.positionId,
    lastName: lastName ?? this.lastName,
    firstName: firstName ?? this.firstName,
    middleName: middleName ?? this.middleName,
    rank: rank ?? this.rank,
    status: status ?? this.status,
    personalNumber: personalNumber.present
        ? personalNumber.value
        : this.personalNumber,
    phone: phone.present ? phone.value : this.phone,
    address: address.present ? address.value : this.address,
    maritalStatus: maritalStatus.present
        ? maritalStatus.value
        : this.maritalStatus,
    childrenCount: childrenCount ?? this.childrenCount,
    birthDate: birthDate.present ? birthDate.value : this.birthDate,
    contractStart: contractStart.present
        ? contractStart.value
        : this.contractStart,
    contractEnd: contractEnd.present ? contractEnd.value : this.contractEnd,
    qualification: qualification.present
        ? qualification.value
        : this.qualification,
    qualificationDate: qualificationDate.present
        ? qualificationDate.value
        : this.qualificationDate,
    serviceStart: serviceStart.present ? serviceStart.value : this.serviceStart,
    isVeteran: isVeteran ?? this.isVeteran,
    allowanceSpecial: allowanceSpecial ?? this.allowanceSpecial,
    allowanceSecrecy: allowanceSecrecy ?? this.allowanceSecrecy,
    allowanceRisk: allowanceRisk ?? this.allowanceRisk,
    allowanceFizo: allowanceFizo ?? this.allowanceFizo,
    allowanceAchieve: allowanceAchieve ?? this.allowanceAchieve,
    regionalCoef: regionalCoef ?? this.regionalCoef,
    premiumPercent: premiumPercent ?? this.premiumPercent,
    leaveLimitMain: leaveLimitMain ?? this.leaveLimitMain,
    leaveLimitAdditional: leaveLimitAdditional ?? this.leaveLimitAdditional,
    leaveLimitVeteran: leaveLimitVeteran ?? this.leaveLimitVeteran,
    isArchived: isArchived ?? this.isArchived,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  PersonRow copyWithCompanion(PersonnelCompanion data) {
    return PersonRow(
      id: data.id.present ? data.id.value : this.id,
      positionId: data.positionId.present
          ? data.positionId.value
          : this.positionId,
      lastName: data.lastName.present ? data.lastName.value : this.lastName,
      firstName: data.firstName.present ? data.firstName.value : this.firstName,
      middleName: data.middleName.present
          ? data.middleName.value
          : this.middleName,
      rank: data.rank.present ? data.rank.value : this.rank,
      status: data.status.present ? data.status.value : this.status,
      personalNumber: data.personalNumber.present
          ? data.personalNumber.value
          : this.personalNumber,
      phone: data.phone.present ? data.phone.value : this.phone,
      address: data.address.present ? data.address.value : this.address,
      maritalStatus: data.maritalStatus.present
          ? data.maritalStatus.value
          : this.maritalStatus,
      childrenCount: data.childrenCount.present
          ? data.childrenCount.value
          : this.childrenCount,
      birthDate: data.birthDate.present ? data.birthDate.value : this.birthDate,
      contractStart: data.contractStart.present
          ? data.contractStart.value
          : this.contractStart,
      contractEnd: data.contractEnd.present
          ? data.contractEnd.value
          : this.contractEnd,
      qualification: data.qualification.present
          ? data.qualification.value
          : this.qualification,
      qualificationDate: data.qualificationDate.present
          ? data.qualificationDate.value
          : this.qualificationDate,
      serviceStart: data.serviceStart.present
          ? data.serviceStart.value
          : this.serviceStart,
      isVeteran: data.isVeteran.present ? data.isVeteran.value : this.isVeteran,
      allowanceSpecial: data.allowanceSpecial.present
          ? data.allowanceSpecial.value
          : this.allowanceSpecial,
      allowanceSecrecy: data.allowanceSecrecy.present
          ? data.allowanceSecrecy.value
          : this.allowanceSecrecy,
      allowanceRisk: data.allowanceRisk.present
          ? data.allowanceRisk.value
          : this.allowanceRisk,
      allowanceFizo: data.allowanceFizo.present
          ? data.allowanceFizo.value
          : this.allowanceFizo,
      allowanceAchieve: data.allowanceAchieve.present
          ? data.allowanceAchieve.value
          : this.allowanceAchieve,
      regionalCoef: data.regionalCoef.present
          ? data.regionalCoef.value
          : this.regionalCoef,
      premiumPercent: data.premiumPercent.present
          ? data.premiumPercent.value
          : this.premiumPercent,
      leaveLimitMain: data.leaveLimitMain.present
          ? data.leaveLimitMain.value
          : this.leaveLimitMain,
      leaveLimitAdditional: data.leaveLimitAdditional.present
          ? data.leaveLimitAdditional.value
          : this.leaveLimitAdditional,
      leaveLimitVeteran: data.leaveLimitVeteran.present
          ? data.leaveLimitVeteran.value
          : this.leaveLimitVeteran,
      isArchived: data.isArchived.present
          ? data.isArchived.value
          : this.isArchived,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PersonRow(')
          ..write('id: $id, ')
          ..write('positionId: $positionId, ')
          ..write('lastName: $lastName, ')
          ..write('firstName: $firstName, ')
          ..write('middleName: $middleName, ')
          ..write('rank: $rank, ')
          ..write('status: $status, ')
          ..write('personalNumber: $personalNumber, ')
          ..write('phone: $phone, ')
          ..write('address: $address, ')
          ..write('maritalStatus: $maritalStatus, ')
          ..write('childrenCount: $childrenCount, ')
          ..write('birthDate: $birthDate, ')
          ..write('contractStart: $contractStart, ')
          ..write('contractEnd: $contractEnd, ')
          ..write('qualification: $qualification, ')
          ..write('qualificationDate: $qualificationDate, ')
          ..write('serviceStart: $serviceStart, ')
          ..write('isVeteran: $isVeteran, ')
          ..write('allowanceSpecial: $allowanceSpecial, ')
          ..write('allowanceSecrecy: $allowanceSecrecy, ')
          ..write('allowanceRisk: $allowanceRisk, ')
          ..write('allowanceFizo: $allowanceFizo, ')
          ..write('allowanceAchieve: $allowanceAchieve, ')
          ..write('regionalCoef: $regionalCoef, ')
          ..write('premiumPercent: $premiumPercent, ')
          ..write('leaveLimitMain: $leaveLimitMain, ')
          ..write('leaveLimitAdditional: $leaveLimitAdditional, ')
          ..write('leaveLimitVeteran: $leaveLimitVeteran, ')
          ..write('isArchived: $isArchived, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    positionId,
    lastName,
    firstName,
    middleName,
    rank,
    status,
    personalNumber,
    phone,
    address,
    maritalStatus,
    childrenCount,
    birthDate,
    contractStart,
    contractEnd,
    qualification,
    qualificationDate,
    serviceStart,
    isVeteran,
    allowanceSpecial,
    allowanceSecrecy,
    allowanceRisk,
    allowanceFizo,
    allowanceAchieve,
    regionalCoef,
    premiumPercent,
    leaveLimitMain,
    leaveLimitAdditional,
    leaveLimitVeteran,
    isArchived,
    createdAt,
    updatedAt,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PersonRow &&
          other.id == this.id &&
          other.positionId == this.positionId &&
          other.lastName == this.lastName &&
          other.firstName == this.firstName &&
          other.middleName == this.middleName &&
          other.rank == this.rank &&
          other.status == this.status &&
          other.personalNumber == this.personalNumber &&
          other.phone == this.phone &&
          other.address == this.address &&
          other.maritalStatus == this.maritalStatus &&
          other.childrenCount == this.childrenCount &&
          other.birthDate == this.birthDate &&
          other.contractStart == this.contractStart &&
          other.contractEnd == this.contractEnd &&
          other.qualification == this.qualification &&
          other.qualificationDate == this.qualificationDate &&
          other.serviceStart == this.serviceStart &&
          other.isVeteran == this.isVeteran &&
          other.allowanceSpecial == this.allowanceSpecial &&
          other.allowanceSecrecy == this.allowanceSecrecy &&
          other.allowanceRisk == this.allowanceRisk &&
          other.allowanceFizo == this.allowanceFizo &&
          other.allowanceAchieve == this.allowanceAchieve &&
          other.regionalCoef == this.regionalCoef &&
          other.premiumPercent == this.premiumPercent &&
          other.leaveLimitMain == this.leaveLimitMain &&
          other.leaveLimitAdditional == this.leaveLimitAdditional &&
          other.leaveLimitVeteran == this.leaveLimitVeteran &&
          other.isArchived == this.isArchived &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class PersonnelCompanion extends UpdateCompanion<PersonRow> {
  final Value<int> id;
  final Value<int?> positionId;
  final Value<String> lastName;
  final Value<String> firstName;
  final Value<String> middleName;
  final Value<String> rank;
  final Value<PersonnelStatus> status;
  final Value<String?> personalNumber;
  final Value<String?> phone;
  final Value<String?> address;
  final Value<MaritalStatus?> maritalStatus;
  final Value<int> childrenCount;
  final Value<DateTime?> birthDate;
  final Value<DateTime?> contractStart;
  final Value<DateTime?> contractEnd;
  final Value<String?> qualification;
  final Value<DateTime?> qualificationDate;
  final Value<DateTime?> serviceStart;
  final Value<bool> isVeteran;
  final Value<int> allowanceSpecial;
  final Value<int> allowanceSecrecy;
  final Value<int> allowanceRisk;
  final Value<int> allowanceFizo;
  final Value<int> allowanceAchieve;
  final Value<double> regionalCoef;
  final Value<int> premiumPercent;
  final Value<int> leaveLimitMain;
  final Value<int> leaveLimitAdditional;
  final Value<int> leaveLimitVeteran;
  final Value<bool> isArchived;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  const PersonnelCompanion({
    this.id = const Value.absent(),
    this.positionId = const Value.absent(),
    this.lastName = const Value.absent(),
    this.firstName = const Value.absent(),
    this.middleName = const Value.absent(),
    this.rank = const Value.absent(),
    this.status = const Value.absent(),
    this.personalNumber = const Value.absent(),
    this.phone = const Value.absent(),
    this.address = const Value.absent(),
    this.maritalStatus = const Value.absent(),
    this.childrenCount = const Value.absent(),
    this.birthDate = const Value.absent(),
    this.contractStart = const Value.absent(),
    this.contractEnd = const Value.absent(),
    this.qualification = const Value.absent(),
    this.qualificationDate = const Value.absent(),
    this.serviceStart = const Value.absent(),
    this.isVeteran = const Value.absent(),
    this.allowanceSpecial = const Value.absent(),
    this.allowanceSecrecy = const Value.absent(),
    this.allowanceRisk = const Value.absent(),
    this.allowanceFizo = const Value.absent(),
    this.allowanceAchieve = const Value.absent(),
    this.regionalCoef = const Value.absent(),
    this.premiumPercent = const Value.absent(),
    this.leaveLimitMain = const Value.absent(),
    this.leaveLimitAdditional = const Value.absent(),
    this.leaveLimitVeteran = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  });
  PersonnelCompanion.insert({
    this.id = const Value.absent(),
    this.positionId = const Value.absent(),
    required String lastName,
    this.firstName = const Value.absent(),
    this.middleName = const Value.absent(),
    this.rank = const Value.absent(),
    this.status = const Value.absent(),
    this.personalNumber = const Value.absent(),
    this.phone = const Value.absent(),
    this.address = const Value.absent(),
    this.maritalStatus = const Value.absent(),
    this.childrenCount = const Value.absent(),
    this.birthDate = const Value.absent(),
    this.contractStart = const Value.absent(),
    this.contractEnd = const Value.absent(),
    this.qualification = const Value.absent(),
    this.qualificationDate = const Value.absent(),
    this.serviceStart = const Value.absent(),
    this.isVeteran = const Value.absent(),
    this.allowanceSpecial = const Value.absent(),
    this.allowanceSecrecy = const Value.absent(),
    this.allowanceRisk = const Value.absent(),
    this.allowanceFizo = const Value.absent(),
    this.allowanceAchieve = const Value.absent(),
    this.regionalCoef = const Value.absent(),
    this.premiumPercent = const Value.absent(),
    this.leaveLimitMain = const Value.absent(),
    this.leaveLimitAdditional = const Value.absent(),
    this.leaveLimitVeteran = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
  }) : lastName = Value(lastName);
  static Insertable<PersonRow> custom({
    Expression<int>? id,
    Expression<int>? positionId,
    Expression<String>? lastName,
    Expression<String>? firstName,
    Expression<String>? middleName,
    Expression<String>? rank,
    Expression<int>? status,
    Expression<String>? personalNumber,
    Expression<String>? phone,
    Expression<String>? address,
    Expression<int>? maritalStatus,
    Expression<int>? childrenCount,
    Expression<DateTime>? birthDate,
    Expression<DateTime>? contractStart,
    Expression<DateTime>? contractEnd,
    Expression<String>? qualification,
    Expression<DateTime>? qualificationDate,
    Expression<DateTime>? serviceStart,
    Expression<bool>? isVeteran,
    Expression<int>? allowanceSpecial,
    Expression<int>? allowanceSecrecy,
    Expression<int>? allowanceRisk,
    Expression<int>? allowanceFizo,
    Expression<int>? allowanceAchieve,
    Expression<double>? regionalCoef,
    Expression<int>? premiumPercent,
    Expression<int>? leaveLimitMain,
    Expression<int>? leaveLimitAdditional,
    Expression<int>? leaveLimitVeteran,
    Expression<bool>? isArchived,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (positionId != null) 'position_id': positionId,
      if (lastName != null) 'last_name': lastName,
      if (firstName != null) 'first_name': firstName,
      if (middleName != null) 'middle_name': middleName,
      if (rank != null) 'rank': rank,
      if (status != null) 'status': status,
      if (personalNumber != null) 'personal_number': personalNumber,
      if (phone != null) 'phone': phone,
      if (address != null) 'address': address,
      if (maritalStatus != null) 'marital_status': maritalStatus,
      if (childrenCount != null) 'children_count': childrenCount,
      if (birthDate != null) 'birth_date': birthDate,
      if (contractStart != null) 'contract_start': contractStart,
      if (contractEnd != null) 'contract_end': contractEnd,
      if (qualification != null) 'qualification': qualification,
      if (qualificationDate != null) 'qualification_date': qualificationDate,
      if (serviceStart != null) 'service_start': serviceStart,
      if (isVeteran != null) 'is_veteran': isVeteran,
      if (allowanceSpecial != null) 'allowance_special': allowanceSpecial,
      if (allowanceSecrecy != null) 'allowance_secrecy': allowanceSecrecy,
      if (allowanceRisk != null) 'allowance_risk': allowanceRisk,
      if (allowanceFizo != null) 'allowance_fizo': allowanceFizo,
      if (allowanceAchieve != null) 'allowance_achieve': allowanceAchieve,
      if (regionalCoef != null) 'regional_coef': regionalCoef,
      if (premiumPercent != null) 'premium_percent': premiumPercent,
      if (leaveLimitMain != null) 'leave_limit_main': leaveLimitMain,
      if (leaveLimitAdditional != null)
        'leave_limit_additional': leaveLimitAdditional,
      if (leaveLimitVeteran != null) 'leave_limit_veteran': leaveLimitVeteran,
      if (isArchived != null) 'is_archived': isArchived,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
    });
  }

  PersonnelCompanion copyWith({
    Value<int>? id,
    Value<int?>? positionId,
    Value<String>? lastName,
    Value<String>? firstName,
    Value<String>? middleName,
    Value<String>? rank,
    Value<PersonnelStatus>? status,
    Value<String?>? personalNumber,
    Value<String?>? phone,
    Value<String?>? address,
    Value<MaritalStatus?>? maritalStatus,
    Value<int>? childrenCount,
    Value<DateTime?>? birthDate,
    Value<DateTime?>? contractStart,
    Value<DateTime?>? contractEnd,
    Value<String?>? qualification,
    Value<DateTime?>? qualificationDate,
    Value<DateTime?>? serviceStart,
    Value<bool>? isVeteran,
    Value<int>? allowanceSpecial,
    Value<int>? allowanceSecrecy,
    Value<int>? allowanceRisk,
    Value<int>? allowanceFizo,
    Value<int>? allowanceAchieve,
    Value<double>? regionalCoef,
    Value<int>? premiumPercent,
    Value<int>? leaveLimitMain,
    Value<int>? leaveLimitAdditional,
    Value<int>? leaveLimitVeteran,
    Value<bool>? isArchived,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
  }) {
    return PersonnelCompanion(
      id: id ?? this.id,
      positionId: positionId ?? this.positionId,
      lastName: lastName ?? this.lastName,
      firstName: firstName ?? this.firstName,
      middleName: middleName ?? this.middleName,
      rank: rank ?? this.rank,
      status: status ?? this.status,
      personalNumber: personalNumber ?? this.personalNumber,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      maritalStatus: maritalStatus ?? this.maritalStatus,
      childrenCount: childrenCount ?? this.childrenCount,
      birthDate: birthDate ?? this.birthDate,
      contractStart: contractStart ?? this.contractStart,
      contractEnd: contractEnd ?? this.contractEnd,
      qualification: qualification ?? this.qualification,
      qualificationDate: qualificationDate ?? this.qualificationDate,
      serviceStart: serviceStart ?? this.serviceStart,
      isVeteran: isVeteran ?? this.isVeteran,
      allowanceSpecial: allowanceSpecial ?? this.allowanceSpecial,
      allowanceSecrecy: allowanceSecrecy ?? this.allowanceSecrecy,
      allowanceRisk: allowanceRisk ?? this.allowanceRisk,
      allowanceFizo: allowanceFizo ?? this.allowanceFizo,
      allowanceAchieve: allowanceAchieve ?? this.allowanceAchieve,
      regionalCoef: regionalCoef ?? this.regionalCoef,
      premiumPercent: premiumPercent ?? this.premiumPercent,
      leaveLimitMain: leaveLimitMain ?? this.leaveLimitMain,
      leaveLimitAdditional: leaveLimitAdditional ?? this.leaveLimitAdditional,
      leaveLimitVeteran: leaveLimitVeteran ?? this.leaveLimitVeteran,
      isArchived: isArchived ?? this.isArchived,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (positionId.present) {
      map['position_id'] = Variable<int>(positionId.value);
    }
    if (lastName.present) {
      map['last_name'] = Variable<String>(lastName.value);
    }
    if (firstName.present) {
      map['first_name'] = Variable<String>(firstName.value);
    }
    if (middleName.present) {
      map['middle_name'] = Variable<String>(middleName.value);
    }
    if (rank.present) {
      map['rank'] = Variable<String>(rank.value);
    }
    if (status.present) {
      map['status'] = Variable<int>(
        $PersonnelTable.$converterstatus.toSql(status.value),
      );
    }
    if (personalNumber.present) {
      map['personal_number'] = Variable<String>(personalNumber.value);
    }
    if (phone.present) {
      map['phone'] = Variable<String>(phone.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (maritalStatus.present) {
      map['marital_status'] = Variable<int>(
        $PersonnelTable.$convertermaritalStatusn.toSql(maritalStatus.value),
      );
    }
    if (childrenCount.present) {
      map['children_count'] = Variable<int>(childrenCount.value);
    }
    if (birthDate.present) {
      map['birth_date'] = Variable<DateTime>(birthDate.value);
    }
    if (contractStart.present) {
      map['contract_start'] = Variable<DateTime>(contractStart.value);
    }
    if (contractEnd.present) {
      map['contract_end'] = Variable<DateTime>(contractEnd.value);
    }
    if (qualification.present) {
      map['qualification'] = Variable<String>(qualification.value);
    }
    if (qualificationDate.present) {
      map['qualification_date'] = Variable<DateTime>(qualificationDate.value);
    }
    if (serviceStart.present) {
      map['service_start'] = Variable<DateTime>(serviceStart.value);
    }
    if (isVeteran.present) {
      map['is_veteran'] = Variable<bool>(isVeteran.value);
    }
    if (allowanceSpecial.present) {
      map['allowance_special'] = Variable<int>(allowanceSpecial.value);
    }
    if (allowanceSecrecy.present) {
      map['allowance_secrecy'] = Variable<int>(allowanceSecrecy.value);
    }
    if (allowanceRisk.present) {
      map['allowance_risk'] = Variable<int>(allowanceRisk.value);
    }
    if (allowanceFizo.present) {
      map['allowance_fizo'] = Variable<int>(allowanceFizo.value);
    }
    if (allowanceAchieve.present) {
      map['allowance_achieve'] = Variable<int>(allowanceAchieve.value);
    }
    if (regionalCoef.present) {
      map['regional_coef'] = Variable<double>(regionalCoef.value);
    }
    if (premiumPercent.present) {
      map['premium_percent'] = Variable<int>(premiumPercent.value);
    }
    if (leaveLimitMain.present) {
      map['leave_limit_main'] = Variable<int>(leaveLimitMain.value);
    }
    if (leaveLimitAdditional.present) {
      map['leave_limit_additional'] = Variable<int>(leaveLimitAdditional.value);
    }
    if (leaveLimitVeteran.present) {
      map['leave_limit_veteran'] = Variable<int>(leaveLimitVeteran.value);
    }
    if (isArchived.present) {
      map['is_archived'] = Variable<bool>(isArchived.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PersonnelCompanion(')
          ..write('id: $id, ')
          ..write('positionId: $positionId, ')
          ..write('lastName: $lastName, ')
          ..write('firstName: $firstName, ')
          ..write('middleName: $middleName, ')
          ..write('rank: $rank, ')
          ..write('status: $status, ')
          ..write('personalNumber: $personalNumber, ')
          ..write('phone: $phone, ')
          ..write('address: $address, ')
          ..write('maritalStatus: $maritalStatus, ')
          ..write('childrenCount: $childrenCount, ')
          ..write('birthDate: $birthDate, ')
          ..write('contractStart: $contractStart, ')
          ..write('contractEnd: $contractEnd, ')
          ..write('qualification: $qualification, ')
          ..write('qualificationDate: $qualificationDate, ')
          ..write('serviceStart: $serviceStart, ')
          ..write('isVeteran: $isVeteran, ')
          ..write('allowanceSpecial: $allowanceSpecial, ')
          ..write('allowanceSecrecy: $allowanceSecrecy, ')
          ..write('allowanceRisk: $allowanceRisk, ')
          ..write('allowanceFizo: $allowanceFizo, ')
          ..write('allowanceAchieve: $allowanceAchieve, ')
          ..write('regionalCoef: $regionalCoef, ')
          ..write('premiumPercent: $premiumPercent, ')
          ..write('leaveLimitMain: $leaveLimitMain, ')
          ..write('leaveLimitAdditional: $leaveLimitAdditional, ')
          ..write('leaveLimitVeteran: $leaveLimitVeteran, ')
          ..write('isArchived: $isArchived, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }
}

class $AwardsTable extends Awards with TableInfo<$AwardsTable, AwardRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AwardsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _personnelIdMeta = const VerificationMeta(
    'personnelId',
  );
  @override
  late final GeneratedColumn<int> personnelId = GeneratedColumn<int>(
    'personnel_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES personnel (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<AwardKind, int> kind =
      GeneratedColumn<int>(
        'kind',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<AwardKind>($AwardsTable.$converterkind);
  static const VerificationMeta _degreeMeta = const VerificationMeta('degree');
  @override
  late final GeneratedColumn<String> degree = GeneratedColumn<String>(
    'degree',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _awardDateMeta = const VerificationMeta(
    'awardDate',
  );
  @override
  late final GeneratedColumn<DateTime> awardDate = GeneratedColumn<DateTime>(
    'award_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    personnelId,
    name,
    kind,
    degree,
    awardDate,
    note,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'awards';
  @override
  VerificationContext validateIntegrity(
    Insertable<AwardRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('personnel_id')) {
      context.handle(
        _personnelIdMeta,
        personnelId.isAcceptableOrUnknown(
          data['personnel_id']!,
          _personnelIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_personnelIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('degree')) {
      context.handle(
        _degreeMeta,
        degree.isAcceptableOrUnknown(data['degree']!, _degreeMeta),
      );
    }
    if (data.containsKey('award_date')) {
      context.handle(
        _awardDateMeta,
        awardDate.isAcceptableOrUnknown(data['award_date']!, _awardDateMeta),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AwardRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AwardRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      personnelId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}personnel_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      kind: $AwardsTable.$converterkind.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}kind'],
        )!,
      ),
      degree: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}degree'],
      ),
      awardDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}award_date'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
    );
  }

  @override
  $AwardsTable createAlias(String alias) {
    return $AwardsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<AwardKind, int, int> $converterkind =
      const EnumIndexConverter<AwardKind>(AwardKind.values);
}

class AwardRow extends DataClass implements Insertable<AwardRow> {
  final int id;
  final int personnelId;
  final String name;
  final AwardKind kind;
  final String? degree;
  final DateTime? awardDate;
  final String? note;
  const AwardRow({
    required this.id,
    required this.personnelId,
    required this.name,
    required this.kind,
    this.degree,
    this.awardDate,
    this.note,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['personnel_id'] = Variable<int>(personnelId);
    map['name'] = Variable<String>(name);
    {
      map['kind'] = Variable<int>($AwardsTable.$converterkind.toSql(kind));
    }
    if (!nullToAbsent || degree != null) {
      map['degree'] = Variable<String>(degree);
    }
    if (!nullToAbsent || awardDate != null) {
      map['award_date'] = Variable<DateTime>(awardDate);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    return map;
  }

  AwardsCompanion toCompanion(bool nullToAbsent) {
    return AwardsCompanion(
      id: Value(id),
      personnelId: Value(personnelId),
      name: Value(name),
      kind: Value(kind),
      degree: degree == null && nullToAbsent
          ? const Value.absent()
          : Value(degree),
      awardDate: awardDate == null && nullToAbsent
          ? const Value.absent()
          : Value(awardDate),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
    );
  }

  factory AwardRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AwardRow(
      id: serializer.fromJson<int>(json['id']),
      personnelId: serializer.fromJson<int>(json['personnelId']),
      name: serializer.fromJson<String>(json['name']),
      kind: $AwardsTable.$converterkind.fromJson(
        serializer.fromJson<int>(json['kind']),
      ),
      degree: serializer.fromJson<String?>(json['degree']),
      awardDate: serializer.fromJson<DateTime?>(json['awardDate']),
      note: serializer.fromJson<String?>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'personnelId': serializer.toJson<int>(personnelId),
      'name': serializer.toJson<String>(name),
      'kind': serializer.toJson<int>($AwardsTable.$converterkind.toJson(kind)),
      'degree': serializer.toJson<String?>(degree),
      'awardDate': serializer.toJson<DateTime?>(awardDate),
      'note': serializer.toJson<String?>(note),
    };
  }

  AwardRow copyWith({
    int? id,
    int? personnelId,
    String? name,
    AwardKind? kind,
    Value<String?> degree = const Value.absent(),
    Value<DateTime?> awardDate = const Value.absent(),
    Value<String?> note = const Value.absent(),
  }) => AwardRow(
    id: id ?? this.id,
    personnelId: personnelId ?? this.personnelId,
    name: name ?? this.name,
    kind: kind ?? this.kind,
    degree: degree.present ? degree.value : this.degree,
    awardDate: awardDate.present ? awardDate.value : this.awardDate,
    note: note.present ? note.value : this.note,
  );
  AwardRow copyWithCompanion(AwardsCompanion data) {
    return AwardRow(
      id: data.id.present ? data.id.value : this.id,
      personnelId: data.personnelId.present
          ? data.personnelId.value
          : this.personnelId,
      name: data.name.present ? data.name.value : this.name,
      kind: data.kind.present ? data.kind.value : this.kind,
      degree: data.degree.present ? data.degree.value : this.degree,
      awardDate: data.awardDate.present ? data.awardDate.value : this.awardDate,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AwardRow(')
          ..write('id: $id, ')
          ..write('personnelId: $personnelId, ')
          ..write('name: $name, ')
          ..write('kind: $kind, ')
          ..write('degree: $degree, ')
          ..write('awardDate: $awardDate, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, personnelId, name, kind, degree, awardDate, note);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AwardRow &&
          other.id == this.id &&
          other.personnelId == this.personnelId &&
          other.name == this.name &&
          other.kind == this.kind &&
          other.degree == this.degree &&
          other.awardDate == this.awardDate &&
          other.note == this.note);
}

class AwardsCompanion extends UpdateCompanion<AwardRow> {
  final Value<int> id;
  final Value<int> personnelId;
  final Value<String> name;
  final Value<AwardKind> kind;
  final Value<String?> degree;
  final Value<DateTime?> awardDate;
  final Value<String?> note;
  const AwardsCompanion({
    this.id = const Value.absent(),
    this.personnelId = const Value.absent(),
    this.name = const Value.absent(),
    this.kind = const Value.absent(),
    this.degree = const Value.absent(),
    this.awardDate = const Value.absent(),
    this.note = const Value.absent(),
  });
  AwardsCompanion.insert({
    this.id = const Value.absent(),
    required int personnelId,
    required String name,
    required AwardKind kind,
    this.degree = const Value.absent(),
    this.awardDate = const Value.absent(),
    this.note = const Value.absent(),
  }) : personnelId = Value(personnelId),
       name = Value(name),
       kind = Value(kind);
  static Insertable<AwardRow> custom({
    Expression<int>? id,
    Expression<int>? personnelId,
    Expression<String>? name,
    Expression<int>? kind,
    Expression<String>? degree,
    Expression<DateTime>? awardDate,
    Expression<String>? note,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (personnelId != null) 'personnel_id': personnelId,
      if (name != null) 'name': name,
      if (kind != null) 'kind': kind,
      if (degree != null) 'degree': degree,
      if (awardDate != null) 'award_date': awardDate,
      if (note != null) 'note': note,
    });
  }

  AwardsCompanion copyWith({
    Value<int>? id,
    Value<int>? personnelId,
    Value<String>? name,
    Value<AwardKind>? kind,
    Value<String?>? degree,
    Value<DateTime?>? awardDate,
    Value<String?>? note,
  }) {
    return AwardsCompanion(
      id: id ?? this.id,
      personnelId: personnelId ?? this.personnelId,
      name: name ?? this.name,
      kind: kind ?? this.kind,
      degree: degree ?? this.degree,
      awardDate: awardDate ?? this.awardDate,
      note: note ?? this.note,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (personnelId.present) {
      map['personnel_id'] = Variable<int>(personnelId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (kind.present) {
      map['kind'] = Variable<int>(
        $AwardsTable.$converterkind.toSql(kind.value),
      );
    }
    if (degree.present) {
      map['degree'] = Variable<String>(degree.value);
    }
    if (awardDate.present) {
      map['award_date'] = Variable<DateTime>(awardDate.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AwardsCompanion(')
          ..write('id: $id, ')
          ..write('personnelId: $personnelId, ')
          ..write('name: $name, ')
          ..write('kind: $kind, ')
          ..write('degree: $degree, ')
          ..write('awardDate: $awardDate, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }
}

class $LeavesTable extends Leaves with TableInfo<$LeavesTable, LeaveRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LeavesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _personnelIdMeta = const VerificationMeta(
    'personnelId',
  );
  @override
  late final GeneratedColumn<int> personnelId = GeneratedColumn<int>(
    'personnel_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES personnel (id) ON DELETE CASCADE',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<LeaveType, int> type =
      GeneratedColumn<int>(
        'type',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<LeaveType>($LeavesTable.$convertertype);
  @override
  late final GeneratedColumnWithTypeConverter<LeaveStatus, int> status =
      GeneratedColumn<int>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        defaultValue: const Constant(0),
      ).withConverter<LeaveStatus>($LeavesTable.$converterstatus);
  static const VerificationMeta _daysGrantedMeta = const VerificationMeta(
    'daysGranted',
  );
  @override
  late final GeneratedColumn<int> daysGranted = GeneratedColumn<int>(
    'days_granted',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _includesTravelMeta = const VerificationMeta(
    'includesTravel',
  );
  @override
  late final GeneratedColumn<bool> includesTravel = GeneratedColumn<bool>(
    'includes_travel',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("includes_travel" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _travelDaysMeta = const VerificationMeta(
    'travelDays',
  );
  @override
  late final GeneratedColumn<int> travelDays = GeneratedColumn<int>(
    'travel_days',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _startDateMeta = const VerificationMeta(
    'startDate',
  );
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
    'start_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _endDateMeta = const VerificationMeta(
    'endDate',
  );
  @override
  late final GeneratedColumn<DateTime> endDate = GeneratedColumn<DateTime>(
    'end_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _actualReturnDateMeta = const VerificationMeta(
    'actualReturnDate',
  );
  @override
  late final GeneratedColumn<DateTime> actualReturnDate =
      GeneratedColumn<DateTime>(
        'actual_return_date',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _orderNumberMeta = const VerificationMeta(
    'orderNumber',
  );
  @override
  late final GeneratedColumn<String> orderNumber = GeneratedColumn<String>(
    'order_number',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _destinationMeta = const VerificationMeta(
    'destination',
  );
  @override
  late final GeneratedColumn<String> destination = GeneratedColumn<String>(
    'destination',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    personnelId,
    type,
    status,
    daysGranted,
    includesTravel,
    travelDays,
    startDate,
    endDate,
    actualReturnDate,
    orderNumber,
    destination,
    note,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'leaves';
  @override
  VerificationContext validateIntegrity(
    Insertable<LeaveRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('personnel_id')) {
      context.handle(
        _personnelIdMeta,
        personnelId.isAcceptableOrUnknown(
          data['personnel_id']!,
          _personnelIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_personnelIdMeta);
    }
    if (data.containsKey('days_granted')) {
      context.handle(
        _daysGrantedMeta,
        daysGranted.isAcceptableOrUnknown(
          data['days_granted']!,
          _daysGrantedMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_daysGrantedMeta);
    }
    if (data.containsKey('includes_travel')) {
      context.handle(
        _includesTravelMeta,
        includesTravel.isAcceptableOrUnknown(
          data['includes_travel']!,
          _includesTravelMeta,
        ),
      );
    }
    if (data.containsKey('travel_days')) {
      context.handle(
        _travelDaysMeta,
        travelDays.isAcceptableOrUnknown(data['travel_days']!, _travelDaysMeta),
      );
    }
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    }
    if (data.containsKey('end_date')) {
      context.handle(
        _endDateMeta,
        endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta),
      );
    }
    if (data.containsKey('actual_return_date')) {
      context.handle(
        _actualReturnDateMeta,
        actualReturnDate.isAcceptableOrUnknown(
          data['actual_return_date']!,
          _actualReturnDateMeta,
        ),
      );
    }
    if (data.containsKey('order_number')) {
      context.handle(
        _orderNumberMeta,
        orderNumber.isAcceptableOrUnknown(
          data['order_number']!,
          _orderNumberMeta,
        ),
      );
    }
    if (data.containsKey('destination')) {
      context.handle(
        _destinationMeta,
        destination.isAcceptableOrUnknown(
          data['destination']!,
          _destinationMeta,
        ),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LeaveRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LeaveRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      personnelId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}personnel_id'],
      )!,
      type: $LeavesTable.$convertertype.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}type'],
        )!,
      ),
      status: $LeavesTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}status'],
        )!,
      ),
      daysGranted: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}days_granted'],
      )!,
      includesTravel: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}includes_travel'],
      )!,
      travelDays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}travel_days'],
      )!,
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_date'],
      ),
      endDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}end_date'],
      ),
      actualReturnDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}actual_return_date'],
      ),
      orderNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}order_number'],
      ),
      destination: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}destination'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
    );
  }

  @override
  $LeavesTable createAlias(String alias) {
    return $LeavesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<LeaveType, int, int> $convertertype =
      const EnumIndexConverter<LeaveType>(LeaveType.values);
  static JsonTypeConverter2<LeaveStatus, int, int> $converterstatus =
      const EnumIndexConverter<LeaveStatus>(LeaveStatus.values);
}

class LeaveRow extends DataClass implements Insertable<LeaveRow> {
  final int id;
  final int personnelId;
  final LeaveType type;
  final LeaveStatus status;
  final int daysGranted;
  final bool includesTravel;
  final int travelDays;
  final DateTime? startDate;
  final DateTime? endDate;
  final DateTime? actualReturnDate;
  final String? orderNumber;
  final String? destination;
  final String? note;
  const LeaveRow({
    required this.id,
    required this.personnelId,
    required this.type,
    required this.status,
    required this.daysGranted,
    required this.includesTravel,
    required this.travelDays,
    this.startDate,
    this.endDate,
    this.actualReturnDate,
    this.orderNumber,
    this.destination,
    this.note,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['personnel_id'] = Variable<int>(personnelId);
    {
      map['type'] = Variable<int>($LeavesTable.$convertertype.toSql(type));
    }
    {
      map['status'] = Variable<int>(
        $LeavesTable.$converterstatus.toSql(status),
      );
    }
    map['days_granted'] = Variable<int>(daysGranted);
    map['includes_travel'] = Variable<bool>(includesTravel);
    map['travel_days'] = Variable<int>(travelDays);
    if (!nullToAbsent || startDate != null) {
      map['start_date'] = Variable<DateTime>(startDate);
    }
    if (!nullToAbsent || endDate != null) {
      map['end_date'] = Variable<DateTime>(endDate);
    }
    if (!nullToAbsent || actualReturnDate != null) {
      map['actual_return_date'] = Variable<DateTime>(actualReturnDate);
    }
    if (!nullToAbsent || orderNumber != null) {
      map['order_number'] = Variable<String>(orderNumber);
    }
    if (!nullToAbsent || destination != null) {
      map['destination'] = Variable<String>(destination);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    return map;
  }

  LeavesCompanion toCompanion(bool nullToAbsent) {
    return LeavesCompanion(
      id: Value(id),
      personnelId: Value(personnelId),
      type: Value(type),
      status: Value(status),
      daysGranted: Value(daysGranted),
      includesTravel: Value(includesTravel),
      travelDays: Value(travelDays),
      startDate: startDate == null && nullToAbsent
          ? const Value.absent()
          : Value(startDate),
      endDate: endDate == null && nullToAbsent
          ? const Value.absent()
          : Value(endDate),
      actualReturnDate: actualReturnDate == null && nullToAbsent
          ? const Value.absent()
          : Value(actualReturnDate),
      orderNumber: orderNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(orderNumber),
      destination: destination == null && nullToAbsent
          ? const Value.absent()
          : Value(destination),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
    );
  }

  factory LeaveRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LeaveRow(
      id: serializer.fromJson<int>(json['id']),
      personnelId: serializer.fromJson<int>(json['personnelId']),
      type: $LeavesTable.$convertertype.fromJson(
        serializer.fromJson<int>(json['type']),
      ),
      status: $LeavesTable.$converterstatus.fromJson(
        serializer.fromJson<int>(json['status']),
      ),
      daysGranted: serializer.fromJson<int>(json['daysGranted']),
      includesTravel: serializer.fromJson<bool>(json['includesTravel']),
      travelDays: serializer.fromJson<int>(json['travelDays']),
      startDate: serializer.fromJson<DateTime?>(json['startDate']),
      endDate: serializer.fromJson<DateTime?>(json['endDate']),
      actualReturnDate: serializer.fromJson<DateTime?>(
        json['actualReturnDate'],
      ),
      orderNumber: serializer.fromJson<String?>(json['orderNumber']),
      destination: serializer.fromJson<String?>(json['destination']),
      note: serializer.fromJson<String?>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'personnelId': serializer.toJson<int>(personnelId),
      'type': serializer.toJson<int>($LeavesTable.$convertertype.toJson(type)),
      'status': serializer.toJson<int>(
        $LeavesTable.$converterstatus.toJson(status),
      ),
      'daysGranted': serializer.toJson<int>(daysGranted),
      'includesTravel': serializer.toJson<bool>(includesTravel),
      'travelDays': serializer.toJson<int>(travelDays),
      'startDate': serializer.toJson<DateTime?>(startDate),
      'endDate': serializer.toJson<DateTime?>(endDate),
      'actualReturnDate': serializer.toJson<DateTime?>(actualReturnDate),
      'orderNumber': serializer.toJson<String?>(orderNumber),
      'destination': serializer.toJson<String?>(destination),
      'note': serializer.toJson<String?>(note),
    };
  }

  LeaveRow copyWith({
    int? id,
    int? personnelId,
    LeaveType? type,
    LeaveStatus? status,
    int? daysGranted,
    bool? includesTravel,
    int? travelDays,
    Value<DateTime?> startDate = const Value.absent(),
    Value<DateTime?> endDate = const Value.absent(),
    Value<DateTime?> actualReturnDate = const Value.absent(),
    Value<String?> orderNumber = const Value.absent(),
    Value<String?> destination = const Value.absent(),
    Value<String?> note = const Value.absent(),
  }) => LeaveRow(
    id: id ?? this.id,
    personnelId: personnelId ?? this.personnelId,
    type: type ?? this.type,
    status: status ?? this.status,
    daysGranted: daysGranted ?? this.daysGranted,
    includesTravel: includesTravel ?? this.includesTravel,
    travelDays: travelDays ?? this.travelDays,
    startDate: startDate.present ? startDate.value : this.startDate,
    endDate: endDate.present ? endDate.value : this.endDate,
    actualReturnDate: actualReturnDate.present
        ? actualReturnDate.value
        : this.actualReturnDate,
    orderNumber: orderNumber.present ? orderNumber.value : this.orderNumber,
    destination: destination.present ? destination.value : this.destination,
    note: note.present ? note.value : this.note,
  );
  LeaveRow copyWithCompanion(LeavesCompanion data) {
    return LeaveRow(
      id: data.id.present ? data.id.value : this.id,
      personnelId: data.personnelId.present
          ? data.personnelId.value
          : this.personnelId,
      type: data.type.present ? data.type.value : this.type,
      status: data.status.present ? data.status.value : this.status,
      daysGranted: data.daysGranted.present
          ? data.daysGranted.value
          : this.daysGranted,
      includesTravel: data.includesTravel.present
          ? data.includesTravel.value
          : this.includesTravel,
      travelDays: data.travelDays.present
          ? data.travelDays.value
          : this.travelDays,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      actualReturnDate: data.actualReturnDate.present
          ? data.actualReturnDate.value
          : this.actualReturnDate,
      orderNumber: data.orderNumber.present
          ? data.orderNumber.value
          : this.orderNumber,
      destination: data.destination.present
          ? data.destination.value
          : this.destination,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LeaveRow(')
          ..write('id: $id, ')
          ..write('personnelId: $personnelId, ')
          ..write('type: $type, ')
          ..write('status: $status, ')
          ..write('daysGranted: $daysGranted, ')
          ..write('includesTravel: $includesTravel, ')
          ..write('travelDays: $travelDays, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('actualReturnDate: $actualReturnDate, ')
          ..write('orderNumber: $orderNumber, ')
          ..write('destination: $destination, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    personnelId,
    type,
    status,
    daysGranted,
    includesTravel,
    travelDays,
    startDate,
    endDate,
    actualReturnDate,
    orderNumber,
    destination,
    note,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LeaveRow &&
          other.id == this.id &&
          other.personnelId == this.personnelId &&
          other.type == this.type &&
          other.status == this.status &&
          other.daysGranted == this.daysGranted &&
          other.includesTravel == this.includesTravel &&
          other.travelDays == this.travelDays &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.actualReturnDate == this.actualReturnDate &&
          other.orderNumber == this.orderNumber &&
          other.destination == this.destination &&
          other.note == this.note);
}

class LeavesCompanion extends UpdateCompanion<LeaveRow> {
  final Value<int> id;
  final Value<int> personnelId;
  final Value<LeaveType> type;
  final Value<LeaveStatus> status;
  final Value<int> daysGranted;
  final Value<bool> includesTravel;
  final Value<int> travelDays;
  final Value<DateTime?> startDate;
  final Value<DateTime?> endDate;
  final Value<DateTime?> actualReturnDate;
  final Value<String?> orderNumber;
  final Value<String?> destination;
  final Value<String?> note;
  const LeavesCompanion({
    this.id = const Value.absent(),
    this.personnelId = const Value.absent(),
    this.type = const Value.absent(),
    this.status = const Value.absent(),
    this.daysGranted = const Value.absent(),
    this.includesTravel = const Value.absent(),
    this.travelDays = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.actualReturnDate = const Value.absent(),
    this.orderNumber = const Value.absent(),
    this.destination = const Value.absent(),
    this.note = const Value.absent(),
  });
  LeavesCompanion.insert({
    this.id = const Value.absent(),
    required int personnelId,
    required LeaveType type,
    this.status = const Value.absent(),
    required int daysGranted,
    this.includesTravel = const Value.absent(),
    this.travelDays = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.actualReturnDate = const Value.absent(),
    this.orderNumber = const Value.absent(),
    this.destination = const Value.absent(),
    this.note = const Value.absent(),
  }) : personnelId = Value(personnelId),
       type = Value(type),
       daysGranted = Value(daysGranted);
  static Insertable<LeaveRow> custom({
    Expression<int>? id,
    Expression<int>? personnelId,
    Expression<int>? type,
    Expression<int>? status,
    Expression<int>? daysGranted,
    Expression<bool>? includesTravel,
    Expression<int>? travelDays,
    Expression<DateTime>? startDate,
    Expression<DateTime>? endDate,
    Expression<DateTime>? actualReturnDate,
    Expression<String>? orderNumber,
    Expression<String>? destination,
    Expression<String>? note,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (personnelId != null) 'personnel_id': personnelId,
      if (type != null) 'type': type,
      if (status != null) 'status': status,
      if (daysGranted != null) 'days_granted': daysGranted,
      if (includesTravel != null) 'includes_travel': includesTravel,
      if (travelDays != null) 'travel_days': travelDays,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (actualReturnDate != null) 'actual_return_date': actualReturnDate,
      if (orderNumber != null) 'order_number': orderNumber,
      if (destination != null) 'destination': destination,
      if (note != null) 'note': note,
    });
  }

  LeavesCompanion copyWith({
    Value<int>? id,
    Value<int>? personnelId,
    Value<LeaveType>? type,
    Value<LeaveStatus>? status,
    Value<int>? daysGranted,
    Value<bool>? includesTravel,
    Value<int>? travelDays,
    Value<DateTime?>? startDate,
    Value<DateTime?>? endDate,
    Value<DateTime?>? actualReturnDate,
    Value<String?>? orderNumber,
    Value<String?>? destination,
    Value<String?>? note,
  }) {
    return LeavesCompanion(
      id: id ?? this.id,
      personnelId: personnelId ?? this.personnelId,
      type: type ?? this.type,
      status: status ?? this.status,
      daysGranted: daysGranted ?? this.daysGranted,
      includesTravel: includesTravel ?? this.includesTravel,
      travelDays: travelDays ?? this.travelDays,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      actualReturnDate: actualReturnDate ?? this.actualReturnDate,
      orderNumber: orderNumber ?? this.orderNumber,
      destination: destination ?? this.destination,
      note: note ?? this.note,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (personnelId.present) {
      map['personnel_id'] = Variable<int>(personnelId.value);
    }
    if (type.present) {
      map['type'] = Variable<int>(
        $LeavesTable.$convertertype.toSql(type.value),
      );
    }
    if (status.present) {
      map['status'] = Variable<int>(
        $LeavesTable.$converterstatus.toSql(status.value),
      );
    }
    if (daysGranted.present) {
      map['days_granted'] = Variable<int>(daysGranted.value);
    }
    if (includesTravel.present) {
      map['includes_travel'] = Variable<bool>(includesTravel.value);
    }
    if (travelDays.present) {
      map['travel_days'] = Variable<int>(travelDays.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<DateTime>(endDate.value);
    }
    if (actualReturnDate.present) {
      map['actual_return_date'] = Variable<DateTime>(actualReturnDate.value);
    }
    if (orderNumber.present) {
      map['order_number'] = Variable<String>(orderNumber.value);
    }
    if (destination.present) {
      map['destination'] = Variable<String>(destination.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LeavesCompanion(')
          ..write('id: $id, ')
          ..write('personnelId: $personnelId, ')
          ..write('type: $type, ')
          ..write('status: $status, ')
          ..write('daysGranted: $daysGranted, ')
          ..write('includesTravel: $includesTravel, ')
          ..write('travelDays: $travelDays, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('actualReturnDate: $actualReturnDate, ')
          ..write('orderNumber: $orderNumber, ')
          ..write('destination: $destination, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }
}

class $TripsTable extends Trips with TableInfo<$TripsTable, TripRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TripsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _personnelIdMeta = const VerificationMeta(
    'personnelId',
  );
  @override
  late final GeneratedColumn<int> personnelId = GeneratedColumn<int>(
    'personnel_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES personnel (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _destinationMeta = const VerificationMeta(
    'destination',
  );
  @override
  late final GeneratedColumn<String> destination = GeneratedColumn<String>(
    'destination',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _purposeMeta = const VerificationMeta(
    'purpose',
  );
  @override
  late final GeneratedColumn<String> purpose = GeneratedColumn<String>(
    'purpose',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  @override
  late final GeneratedColumnWithTypeConverter<TripStatus, int> status =
      GeneratedColumn<int>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        defaultValue: const Constant(0),
      ).withConverter<TripStatus>($TripsTable.$converterstatus);
  static const VerificationMeta _startDateMeta = const VerificationMeta(
    'startDate',
  );
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
    'start_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _endDateMeta = const VerificationMeta(
    'endDate',
  );
  @override
  late final GeneratedColumn<DateTime> endDate = GeneratedColumn<DateTime>(
    'end_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _actualReturnDateMeta = const VerificationMeta(
    'actualReturnDate',
  );
  @override
  late final GeneratedColumn<DateTime> actualReturnDate =
      GeneratedColumn<DateTime>(
        'actual_return_date',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _orderNumberMeta = const VerificationMeta(
    'orderNumber',
  );
  @override
  late final GeneratedColumn<String> orderNumber = GeneratedColumn<String>(
    'order_number',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _serviceCoefMeta = const VerificationMeta(
    'serviceCoef',
  );
  @override
  late final GeneratedColumn<double> serviceCoef = GeneratedColumn<double>(
    'service_coef',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(1.0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    personnelId,
    destination,
    purpose,
    status,
    startDate,
    endDate,
    actualReturnDate,
    orderNumber,
    note,
    serviceCoef,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'trips';
  @override
  VerificationContext validateIntegrity(
    Insertable<TripRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('personnel_id')) {
      context.handle(
        _personnelIdMeta,
        personnelId.isAcceptableOrUnknown(
          data['personnel_id']!,
          _personnelIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_personnelIdMeta);
    }
    if (data.containsKey('destination')) {
      context.handle(
        _destinationMeta,
        destination.isAcceptableOrUnknown(
          data['destination']!,
          _destinationMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_destinationMeta);
    }
    if (data.containsKey('purpose')) {
      context.handle(
        _purposeMeta,
        purpose.isAcceptableOrUnknown(data['purpose']!, _purposeMeta),
      );
    }
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    }
    if (data.containsKey('end_date')) {
      context.handle(
        _endDateMeta,
        endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta),
      );
    }
    if (data.containsKey('actual_return_date')) {
      context.handle(
        _actualReturnDateMeta,
        actualReturnDate.isAcceptableOrUnknown(
          data['actual_return_date']!,
          _actualReturnDateMeta,
        ),
      );
    }
    if (data.containsKey('order_number')) {
      context.handle(
        _orderNumberMeta,
        orderNumber.isAcceptableOrUnknown(
          data['order_number']!,
          _orderNumberMeta,
        ),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('service_coef')) {
      context.handle(
        _serviceCoefMeta,
        serviceCoef.isAcceptableOrUnknown(
          data['service_coef']!,
          _serviceCoefMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TripRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TripRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      personnelId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}personnel_id'],
      )!,
      destination: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}destination'],
      )!,
      purpose: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}purpose'],
      )!,
      status: $TripsTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}status'],
        )!,
      ),
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_date'],
      ),
      endDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}end_date'],
      ),
      actualReturnDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}actual_return_date'],
      ),
      orderNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}order_number'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      serviceCoef: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}service_coef'],
      )!,
    );
  }

  @override
  $TripsTable createAlias(String alias) {
    return $TripsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<TripStatus, int, int> $converterstatus =
      const EnumIndexConverter<TripStatus>(TripStatus.values);
}

class TripRow extends DataClass implements Insertable<TripRow> {
  final int id;
  final int personnelId;
  final String destination;
  final String purpose;
  final TripStatus status;
  final DateTime? startDate;
  final DateTime? endDate;
  final DateTime? actualReturnDate;
  final String? orderNumber;
  final String? note;

  /// Коэффициент льготного исчисления выслуги (1.0 — обычная; 1.5/2/3 —
  /// боевые/особые). Командировки с коэф. > 1 идут в льготную выслугу.
  final double serviceCoef;
  const TripRow({
    required this.id,
    required this.personnelId,
    required this.destination,
    required this.purpose,
    required this.status,
    this.startDate,
    this.endDate,
    this.actualReturnDate,
    this.orderNumber,
    this.note,
    required this.serviceCoef,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['personnel_id'] = Variable<int>(personnelId);
    map['destination'] = Variable<String>(destination);
    map['purpose'] = Variable<String>(purpose);
    {
      map['status'] = Variable<int>($TripsTable.$converterstatus.toSql(status));
    }
    if (!nullToAbsent || startDate != null) {
      map['start_date'] = Variable<DateTime>(startDate);
    }
    if (!nullToAbsent || endDate != null) {
      map['end_date'] = Variable<DateTime>(endDate);
    }
    if (!nullToAbsent || actualReturnDate != null) {
      map['actual_return_date'] = Variable<DateTime>(actualReturnDate);
    }
    if (!nullToAbsent || orderNumber != null) {
      map['order_number'] = Variable<String>(orderNumber);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['service_coef'] = Variable<double>(serviceCoef);
    return map;
  }

  TripsCompanion toCompanion(bool nullToAbsent) {
    return TripsCompanion(
      id: Value(id),
      personnelId: Value(personnelId),
      destination: Value(destination),
      purpose: Value(purpose),
      status: Value(status),
      startDate: startDate == null && nullToAbsent
          ? const Value.absent()
          : Value(startDate),
      endDate: endDate == null && nullToAbsent
          ? const Value.absent()
          : Value(endDate),
      actualReturnDate: actualReturnDate == null && nullToAbsent
          ? const Value.absent()
          : Value(actualReturnDate),
      orderNumber: orderNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(orderNumber),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      serviceCoef: Value(serviceCoef),
    );
  }

  factory TripRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TripRow(
      id: serializer.fromJson<int>(json['id']),
      personnelId: serializer.fromJson<int>(json['personnelId']),
      destination: serializer.fromJson<String>(json['destination']),
      purpose: serializer.fromJson<String>(json['purpose']),
      status: $TripsTable.$converterstatus.fromJson(
        serializer.fromJson<int>(json['status']),
      ),
      startDate: serializer.fromJson<DateTime?>(json['startDate']),
      endDate: serializer.fromJson<DateTime?>(json['endDate']),
      actualReturnDate: serializer.fromJson<DateTime?>(
        json['actualReturnDate'],
      ),
      orderNumber: serializer.fromJson<String?>(json['orderNumber']),
      note: serializer.fromJson<String?>(json['note']),
      serviceCoef: serializer.fromJson<double>(json['serviceCoef']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'personnelId': serializer.toJson<int>(personnelId),
      'destination': serializer.toJson<String>(destination),
      'purpose': serializer.toJson<String>(purpose),
      'status': serializer.toJson<int>(
        $TripsTable.$converterstatus.toJson(status),
      ),
      'startDate': serializer.toJson<DateTime?>(startDate),
      'endDate': serializer.toJson<DateTime?>(endDate),
      'actualReturnDate': serializer.toJson<DateTime?>(actualReturnDate),
      'orderNumber': serializer.toJson<String?>(orderNumber),
      'note': serializer.toJson<String?>(note),
      'serviceCoef': serializer.toJson<double>(serviceCoef),
    };
  }

  TripRow copyWith({
    int? id,
    int? personnelId,
    String? destination,
    String? purpose,
    TripStatus? status,
    Value<DateTime?> startDate = const Value.absent(),
    Value<DateTime?> endDate = const Value.absent(),
    Value<DateTime?> actualReturnDate = const Value.absent(),
    Value<String?> orderNumber = const Value.absent(),
    Value<String?> note = const Value.absent(),
    double? serviceCoef,
  }) => TripRow(
    id: id ?? this.id,
    personnelId: personnelId ?? this.personnelId,
    destination: destination ?? this.destination,
    purpose: purpose ?? this.purpose,
    status: status ?? this.status,
    startDate: startDate.present ? startDate.value : this.startDate,
    endDate: endDate.present ? endDate.value : this.endDate,
    actualReturnDate: actualReturnDate.present
        ? actualReturnDate.value
        : this.actualReturnDate,
    orderNumber: orderNumber.present ? orderNumber.value : this.orderNumber,
    note: note.present ? note.value : this.note,
    serviceCoef: serviceCoef ?? this.serviceCoef,
  );
  TripRow copyWithCompanion(TripsCompanion data) {
    return TripRow(
      id: data.id.present ? data.id.value : this.id,
      personnelId: data.personnelId.present
          ? data.personnelId.value
          : this.personnelId,
      destination: data.destination.present
          ? data.destination.value
          : this.destination,
      purpose: data.purpose.present ? data.purpose.value : this.purpose,
      status: data.status.present ? data.status.value : this.status,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      actualReturnDate: data.actualReturnDate.present
          ? data.actualReturnDate.value
          : this.actualReturnDate,
      orderNumber: data.orderNumber.present
          ? data.orderNumber.value
          : this.orderNumber,
      note: data.note.present ? data.note.value : this.note,
      serviceCoef: data.serviceCoef.present
          ? data.serviceCoef.value
          : this.serviceCoef,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TripRow(')
          ..write('id: $id, ')
          ..write('personnelId: $personnelId, ')
          ..write('destination: $destination, ')
          ..write('purpose: $purpose, ')
          ..write('status: $status, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('actualReturnDate: $actualReturnDate, ')
          ..write('orderNumber: $orderNumber, ')
          ..write('note: $note, ')
          ..write('serviceCoef: $serviceCoef')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    personnelId,
    destination,
    purpose,
    status,
    startDate,
    endDate,
    actualReturnDate,
    orderNumber,
    note,
    serviceCoef,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TripRow &&
          other.id == this.id &&
          other.personnelId == this.personnelId &&
          other.destination == this.destination &&
          other.purpose == this.purpose &&
          other.status == this.status &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.actualReturnDate == this.actualReturnDate &&
          other.orderNumber == this.orderNumber &&
          other.note == this.note &&
          other.serviceCoef == this.serviceCoef);
}

class TripsCompanion extends UpdateCompanion<TripRow> {
  final Value<int> id;
  final Value<int> personnelId;
  final Value<String> destination;
  final Value<String> purpose;
  final Value<TripStatus> status;
  final Value<DateTime?> startDate;
  final Value<DateTime?> endDate;
  final Value<DateTime?> actualReturnDate;
  final Value<String?> orderNumber;
  final Value<String?> note;
  final Value<double> serviceCoef;
  const TripsCompanion({
    this.id = const Value.absent(),
    this.personnelId = const Value.absent(),
    this.destination = const Value.absent(),
    this.purpose = const Value.absent(),
    this.status = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.actualReturnDate = const Value.absent(),
    this.orderNumber = const Value.absent(),
    this.note = const Value.absent(),
    this.serviceCoef = const Value.absent(),
  });
  TripsCompanion.insert({
    this.id = const Value.absent(),
    required int personnelId,
    required String destination,
    this.purpose = const Value.absent(),
    this.status = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.actualReturnDate = const Value.absent(),
    this.orderNumber = const Value.absent(),
    this.note = const Value.absent(),
    this.serviceCoef = const Value.absent(),
  }) : personnelId = Value(personnelId),
       destination = Value(destination);
  static Insertable<TripRow> custom({
    Expression<int>? id,
    Expression<int>? personnelId,
    Expression<String>? destination,
    Expression<String>? purpose,
    Expression<int>? status,
    Expression<DateTime>? startDate,
    Expression<DateTime>? endDate,
    Expression<DateTime>? actualReturnDate,
    Expression<String>? orderNumber,
    Expression<String>? note,
    Expression<double>? serviceCoef,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (personnelId != null) 'personnel_id': personnelId,
      if (destination != null) 'destination': destination,
      if (purpose != null) 'purpose': purpose,
      if (status != null) 'status': status,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (actualReturnDate != null) 'actual_return_date': actualReturnDate,
      if (orderNumber != null) 'order_number': orderNumber,
      if (note != null) 'note': note,
      if (serviceCoef != null) 'service_coef': serviceCoef,
    });
  }

  TripsCompanion copyWith({
    Value<int>? id,
    Value<int>? personnelId,
    Value<String>? destination,
    Value<String>? purpose,
    Value<TripStatus>? status,
    Value<DateTime?>? startDate,
    Value<DateTime?>? endDate,
    Value<DateTime?>? actualReturnDate,
    Value<String?>? orderNumber,
    Value<String?>? note,
    Value<double>? serviceCoef,
  }) {
    return TripsCompanion(
      id: id ?? this.id,
      personnelId: personnelId ?? this.personnelId,
      destination: destination ?? this.destination,
      purpose: purpose ?? this.purpose,
      status: status ?? this.status,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      actualReturnDate: actualReturnDate ?? this.actualReturnDate,
      orderNumber: orderNumber ?? this.orderNumber,
      note: note ?? this.note,
      serviceCoef: serviceCoef ?? this.serviceCoef,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (personnelId.present) {
      map['personnel_id'] = Variable<int>(personnelId.value);
    }
    if (destination.present) {
      map['destination'] = Variable<String>(destination.value);
    }
    if (purpose.present) {
      map['purpose'] = Variable<String>(purpose.value);
    }
    if (status.present) {
      map['status'] = Variable<int>(
        $TripsTable.$converterstatus.toSql(status.value),
      );
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<DateTime>(endDate.value);
    }
    if (actualReturnDate.present) {
      map['actual_return_date'] = Variable<DateTime>(actualReturnDate.value);
    }
    if (orderNumber.present) {
      map['order_number'] = Variable<String>(orderNumber.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (serviceCoef.present) {
      map['service_coef'] = Variable<double>(serviceCoef.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TripsCompanion(')
          ..write('id: $id, ')
          ..write('personnelId: $personnelId, ')
          ..write('destination: $destination, ')
          ..write('purpose: $purpose, ')
          ..write('status: $status, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('actualReturnDate: $actualReturnDate, ')
          ..write('orderNumber: $orderNumber, ')
          ..write('note: $note, ')
          ..write('serviceCoef: $serviceCoef')
          ..write(')'))
        .toString();
  }
}

class $WeaponsTable extends Weapons with TableInfo<$WeaponsTable, WeaponRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WeaponsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _personnelIdMeta = const VerificationMeta(
    'personnelId',
  );
  @override
  late final GeneratedColumn<int> personnelId = GeneratedColumn<int>(
    'personnel_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES personnel (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<WeaponType, int> type =
      GeneratedColumn<int>(
        'type',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<WeaponType>($WeaponsTable.$convertertype);
  static const VerificationMeta _serialNumberMeta = const VerificationMeta(
    'serialNumber',
  );
  @override
  late final GeneratedColumn<String> serialNumber = GeneratedColumn<String>(
    'serial_number',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _inventoryNumberMeta = const VerificationMeta(
    'inventoryNumber',
  );
  @override
  late final GeneratedColumn<String> inventoryNumber = GeneratedColumn<String>(
    'inventory_number',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _assignedDateMeta = const VerificationMeta(
    'assignedDate',
  );
  @override
  late final GeneratedColumn<DateTime> assignedDate = GeneratedColumn<DateTime>(
    'assigned_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    personnelId,
    name,
    type,
    serialNumber,
    inventoryNumber,
    assignedDate,
    note,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'weapons';
  @override
  VerificationContext validateIntegrity(
    Insertable<WeaponRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('personnel_id')) {
      context.handle(
        _personnelIdMeta,
        personnelId.isAcceptableOrUnknown(
          data['personnel_id']!,
          _personnelIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_personnelIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('serial_number')) {
      context.handle(
        _serialNumberMeta,
        serialNumber.isAcceptableOrUnknown(
          data['serial_number']!,
          _serialNumberMeta,
        ),
      );
    }
    if (data.containsKey('inventory_number')) {
      context.handle(
        _inventoryNumberMeta,
        inventoryNumber.isAcceptableOrUnknown(
          data['inventory_number']!,
          _inventoryNumberMeta,
        ),
      );
    }
    if (data.containsKey('assigned_date')) {
      context.handle(
        _assignedDateMeta,
        assignedDate.isAcceptableOrUnknown(
          data['assigned_date']!,
          _assignedDateMeta,
        ),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WeaponRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WeaponRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      personnelId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}personnel_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      type: $WeaponsTable.$convertertype.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}type'],
        )!,
      ),
      serialNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}serial_number'],
      ),
      inventoryNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}inventory_number'],
      ),
      assignedDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}assigned_date'],
      ),
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
    );
  }

  @override
  $WeaponsTable createAlias(String alias) {
    return $WeaponsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<WeaponType, int, int> $convertertype =
      const EnumIndexConverter<WeaponType>(WeaponType.values);
}

class WeaponRow extends DataClass implements Insertable<WeaponRow> {
  final int id;
  final int personnelId;
  final String name;
  final WeaponType type;
  final String? serialNumber;
  final String? inventoryNumber;
  final DateTime? assignedDate;
  final String? note;
  const WeaponRow({
    required this.id,
    required this.personnelId,
    required this.name,
    required this.type,
    this.serialNumber,
    this.inventoryNumber,
    this.assignedDate,
    this.note,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['personnel_id'] = Variable<int>(personnelId);
    map['name'] = Variable<String>(name);
    {
      map['type'] = Variable<int>($WeaponsTable.$convertertype.toSql(type));
    }
    if (!nullToAbsent || serialNumber != null) {
      map['serial_number'] = Variable<String>(serialNumber);
    }
    if (!nullToAbsent || inventoryNumber != null) {
      map['inventory_number'] = Variable<String>(inventoryNumber);
    }
    if (!nullToAbsent || assignedDate != null) {
      map['assigned_date'] = Variable<DateTime>(assignedDate);
    }
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    return map;
  }

  WeaponsCompanion toCompanion(bool nullToAbsent) {
    return WeaponsCompanion(
      id: Value(id),
      personnelId: Value(personnelId),
      name: Value(name),
      type: Value(type),
      serialNumber: serialNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(serialNumber),
      inventoryNumber: inventoryNumber == null && nullToAbsent
          ? const Value.absent()
          : Value(inventoryNumber),
      assignedDate: assignedDate == null && nullToAbsent
          ? const Value.absent()
          : Value(assignedDate),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
    );
  }

  factory WeaponRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WeaponRow(
      id: serializer.fromJson<int>(json['id']),
      personnelId: serializer.fromJson<int>(json['personnelId']),
      name: serializer.fromJson<String>(json['name']),
      type: $WeaponsTable.$convertertype.fromJson(
        serializer.fromJson<int>(json['type']),
      ),
      serialNumber: serializer.fromJson<String?>(json['serialNumber']),
      inventoryNumber: serializer.fromJson<String?>(json['inventoryNumber']),
      assignedDate: serializer.fromJson<DateTime?>(json['assignedDate']),
      note: serializer.fromJson<String?>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'personnelId': serializer.toJson<int>(personnelId),
      'name': serializer.toJson<String>(name),
      'type': serializer.toJson<int>($WeaponsTable.$convertertype.toJson(type)),
      'serialNumber': serializer.toJson<String?>(serialNumber),
      'inventoryNumber': serializer.toJson<String?>(inventoryNumber),
      'assignedDate': serializer.toJson<DateTime?>(assignedDate),
      'note': serializer.toJson<String?>(note),
    };
  }

  WeaponRow copyWith({
    int? id,
    int? personnelId,
    String? name,
    WeaponType? type,
    Value<String?> serialNumber = const Value.absent(),
    Value<String?> inventoryNumber = const Value.absent(),
    Value<DateTime?> assignedDate = const Value.absent(),
    Value<String?> note = const Value.absent(),
  }) => WeaponRow(
    id: id ?? this.id,
    personnelId: personnelId ?? this.personnelId,
    name: name ?? this.name,
    type: type ?? this.type,
    serialNumber: serialNumber.present ? serialNumber.value : this.serialNumber,
    inventoryNumber: inventoryNumber.present
        ? inventoryNumber.value
        : this.inventoryNumber,
    assignedDate: assignedDate.present ? assignedDate.value : this.assignedDate,
    note: note.present ? note.value : this.note,
  );
  WeaponRow copyWithCompanion(WeaponsCompanion data) {
    return WeaponRow(
      id: data.id.present ? data.id.value : this.id,
      personnelId: data.personnelId.present
          ? data.personnelId.value
          : this.personnelId,
      name: data.name.present ? data.name.value : this.name,
      type: data.type.present ? data.type.value : this.type,
      serialNumber: data.serialNumber.present
          ? data.serialNumber.value
          : this.serialNumber,
      inventoryNumber: data.inventoryNumber.present
          ? data.inventoryNumber.value
          : this.inventoryNumber,
      assignedDate: data.assignedDate.present
          ? data.assignedDate.value
          : this.assignedDate,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WeaponRow(')
          ..write('id: $id, ')
          ..write('personnelId: $personnelId, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('serialNumber: $serialNumber, ')
          ..write('inventoryNumber: $inventoryNumber, ')
          ..write('assignedDate: $assignedDate, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    personnelId,
    name,
    type,
    serialNumber,
    inventoryNumber,
    assignedDate,
    note,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WeaponRow &&
          other.id == this.id &&
          other.personnelId == this.personnelId &&
          other.name == this.name &&
          other.type == this.type &&
          other.serialNumber == this.serialNumber &&
          other.inventoryNumber == this.inventoryNumber &&
          other.assignedDate == this.assignedDate &&
          other.note == this.note);
}

class WeaponsCompanion extends UpdateCompanion<WeaponRow> {
  final Value<int> id;
  final Value<int> personnelId;
  final Value<String> name;
  final Value<WeaponType> type;
  final Value<String?> serialNumber;
  final Value<String?> inventoryNumber;
  final Value<DateTime?> assignedDate;
  final Value<String?> note;
  const WeaponsCompanion({
    this.id = const Value.absent(),
    this.personnelId = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.serialNumber = const Value.absent(),
    this.inventoryNumber = const Value.absent(),
    this.assignedDate = const Value.absent(),
    this.note = const Value.absent(),
  });
  WeaponsCompanion.insert({
    this.id = const Value.absent(),
    required int personnelId,
    required String name,
    required WeaponType type,
    this.serialNumber = const Value.absent(),
    this.inventoryNumber = const Value.absent(),
    this.assignedDate = const Value.absent(),
    this.note = const Value.absent(),
  }) : personnelId = Value(personnelId),
       name = Value(name),
       type = Value(type);
  static Insertable<WeaponRow> custom({
    Expression<int>? id,
    Expression<int>? personnelId,
    Expression<String>? name,
    Expression<int>? type,
    Expression<String>? serialNumber,
    Expression<String>? inventoryNumber,
    Expression<DateTime>? assignedDate,
    Expression<String>? note,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (personnelId != null) 'personnel_id': personnelId,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (serialNumber != null) 'serial_number': serialNumber,
      if (inventoryNumber != null) 'inventory_number': inventoryNumber,
      if (assignedDate != null) 'assigned_date': assignedDate,
      if (note != null) 'note': note,
    });
  }

  WeaponsCompanion copyWith({
    Value<int>? id,
    Value<int>? personnelId,
    Value<String>? name,
    Value<WeaponType>? type,
    Value<String?>? serialNumber,
    Value<String?>? inventoryNumber,
    Value<DateTime?>? assignedDate,
    Value<String?>? note,
  }) {
    return WeaponsCompanion(
      id: id ?? this.id,
      personnelId: personnelId ?? this.personnelId,
      name: name ?? this.name,
      type: type ?? this.type,
      serialNumber: serialNumber ?? this.serialNumber,
      inventoryNumber: inventoryNumber ?? this.inventoryNumber,
      assignedDate: assignedDate ?? this.assignedDate,
      note: note ?? this.note,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (personnelId.present) {
      map['personnel_id'] = Variable<int>(personnelId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (type.present) {
      map['type'] = Variable<int>(
        $WeaponsTable.$convertertype.toSql(type.value),
      );
    }
    if (serialNumber.present) {
      map['serial_number'] = Variable<String>(serialNumber.value);
    }
    if (inventoryNumber.present) {
      map['inventory_number'] = Variable<String>(inventoryNumber.value);
    }
    if (assignedDate.present) {
      map['assigned_date'] = Variable<DateTime>(assignedDate.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WeaponsCompanion(')
          ..write('id: $id, ')
          ..write('personnelId: $personnelId, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('serialNumber: $serialNumber, ')
          ..write('inventoryNumber: $inventoryNumber, ')
          ..write('assignedDate: $assignedDate, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }
}

class $ServicePeriodsTable extends ServicePeriods
    with TableInfo<$ServicePeriodsTable, ServicePeriodRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ServicePeriodsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _personnelIdMeta = const VerificationMeta(
    'personnelId',
  );
  @override
  late final GeneratedColumn<int> personnelId = GeneratedColumn<int>(
    'personnel_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES personnel (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _startDateMeta = const VerificationMeta(
    'startDate',
  );
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
    'start_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endDateMeta = const VerificationMeta(
    'endDate',
  );
  @override
  late final GeneratedColumn<DateTime> endDate = GeneratedColumn<DateTime>(
    'end_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _coefficientMeta = const VerificationMeta(
    'coefficient',
  );
  @override
  late final GeneratedColumn<double> coefficient = GeneratedColumn<double>(
    'coefficient',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(1.5),
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    personnelId,
    startDate,
    endDate,
    coefficient,
    note,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'service_periods';
  @override
  VerificationContext validateIntegrity(
    Insertable<ServicePeriodRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('personnel_id')) {
      context.handle(
        _personnelIdMeta,
        personnelId.isAcceptableOrUnknown(
          data['personnel_id']!,
          _personnelIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_personnelIdMeta);
    }
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('end_date')) {
      context.handle(
        _endDateMeta,
        endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta),
      );
    }
    if (data.containsKey('coefficient')) {
      context.handle(
        _coefficientMeta,
        coefficient.isAcceptableOrUnknown(
          data['coefficient']!,
          _coefficientMeta,
        ),
      );
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ServicePeriodRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ServicePeriodRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      personnelId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}personnel_id'],
      )!,
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_date'],
      )!,
      endDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}end_date'],
      ),
      coefficient: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}coefficient'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      )!,
    );
  }

  @override
  $ServicePeriodsTable createAlias(String alias) {
    return $ServicePeriodsTable(attachedDatabase, alias);
  }
}

class ServicePeriodRow extends DataClass
    implements Insertable<ServicePeriodRow> {
  final int id;
  final int personnelId;
  final DateTime startDate;

  /// Конец периода; null — по настоящее время.
  final DateTime? endDate;

  /// Коэффициент льготного исчисления (1.5, 2.0, 3.0).
  final double coefficient;
  final String note;
  const ServicePeriodRow({
    required this.id,
    required this.personnelId,
    required this.startDate,
    this.endDate,
    required this.coefficient,
    required this.note,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['personnel_id'] = Variable<int>(personnelId);
    map['start_date'] = Variable<DateTime>(startDate);
    if (!nullToAbsent || endDate != null) {
      map['end_date'] = Variable<DateTime>(endDate);
    }
    map['coefficient'] = Variable<double>(coefficient);
    map['note'] = Variable<String>(note);
    return map;
  }

  ServicePeriodsCompanion toCompanion(bool nullToAbsent) {
    return ServicePeriodsCompanion(
      id: Value(id),
      personnelId: Value(personnelId),
      startDate: Value(startDate),
      endDate: endDate == null && nullToAbsent
          ? const Value.absent()
          : Value(endDate),
      coefficient: Value(coefficient),
      note: Value(note),
    );
  }

  factory ServicePeriodRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ServicePeriodRow(
      id: serializer.fromJson<int>(json['id']),
      personnelId: serializer.fromJson<int>(json['personnelId']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      endDate: serializer.fromJson<DateTime?>(json['endDate']),
      coefficient: serializer.fromJson<double>(json['coefficient']),
      note: serializer.fromJson<String>(json['note']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'personnelId': serializer.toJson<int>(personnelId),
      'startDate': serializer.toJson<DateTime>(startDate),
      'endDate': serializer.toJson<DateTime?>(endDate),
      'coefficient': serializer.toJson<double>(coefficient),
      'note': serializer.toJson<String>(note),
    };
  }

  ServicePeriodRow copyWith({
    int? id,
    int? personnelId,
    DateTime? startDate,
    Value<DateTime?> endDate = const Value.absent(),
    double? coefficient,
    String? note,
  }) => ServicePeriodRow(
    id: id ?? this.id,
    personnelId: personnelId ?? this.personnelId,
    startDate: startDate ?? this.startDate,
    endDate: endDate.present ? endDate.value : this.endDate,
    coefficient: coefficient ?? this.coefficient,
    note: note ?? this.note,
  );
  ServicePeriodRow copyWithCompanion(ServicePeriodsCompanion data) {
    return ServicePeriodRow(
      id: data.id.present ? data.id.value : this.id,
      personnelId: data.personnelId.present
          ? data.personnelId.value
          : this.personnelId,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      coefficient: data.coefficient.present
          ? data.coefficient.value
          : this.coefficient,
      note: data.note.present ? data.note.value : this.note,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ServicePeriodRow(')
          ..write('id: $id, ')
          ..write('personnelId: $personnelId, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('coefficient: $coefficient, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, personnelId, startDate, endDate, coefficient, note);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ServicePeriodRow &&
          other.id == this.id &&
          other.personnelId == this.personnelId &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.coefficient == this.coefficient &&
          other.note == this.note);
}

class ServicePeriodsCompanion extends UpdateCompanion<ServicePeriodRow> {
  final Value<int> id;
  final Value<int> personnelId;
  final Value<DateTime> startDate;
  final Value<DateTime?> endDate;
  final Value<double> coefficient;
  final Value<String> note;
  const ServicePeriodsCompanion({
    this.id = const Value.absent(),
    this.personnelId = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.coefficient = const Value.absent(),
    this.note = const Value.absent(),
  });
  ServicePeriodsCompanion.insert({
    this.id = const Value.absent(),
    required int personnelId,
    required DateTime startDate,
    this.endDate = const Value.absent(),
    this.coefficient = const Value.absent(),
    this.note = const Value.absent(),
  }) : personnelId = Value(personnelId),
       startDate = Value(startDate);
  static Insertable<ServicePeriodRow> custom({
    Expression<int>? id,
    Expression<int>? personnelId,
    Expression<DateTime>? startDate,
    Expression<DateTime>? endDate,
    Expression<double>? coefficient,
    Expression<String>? note,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (personnelId != null) 'personnel_id': personnelId,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (coefficient != null) 'coefficient': coefficient,
      if (note != null) 'note': note,
    });
  }

  ServicePeriodsCompanion copyWith({
    Value<int>? id,
    Value<int>? personnelId,
    Value<DateTime>? startDate,
    Value<DateTime?>? endDate,
    Value<double>? coefficient,
    Value<String>? note,
  }) {
    return ServicePeriodsCompanion(
      id: id ?? this.id,
      personnelId: personnelId ?? this.personnelId,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      coefficient: coefficient ?? this.coefficient,
      note: note ?? this.note,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (personnelId.present) {
      map['personnel_id'] = Variable<int>(personnelId.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<DateTime>(endDate.value);
    }
    if (coefficient.present) {
      map['coefficient'] = Variable<double>(coefficient.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ServicePeriodsCompanion(')
          ..write('id: $id, ')
          ..write('personnelId: $personnelId, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('coefficient: $coefficient, ')
          ..write('note: $note')
          ..write(')'))
        .toString();
  }
}

class $PayRatesTable extends PayRates
    with TableInfo<$PayRatesTable, PayRateRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PayRatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<PayRateKind, int> kind =
      GeneratedColumn<int>(
        'kind',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      ).withConverter<PayRateKind>($PayRatesTable.$converterkind);
  static const VerificationMeta _codeMeta = const VerificationMeta('code');
  @override
  late final GeneratedColumn<String> code = GeneratedColumn<String>(
    'code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<int> amount = GeneratedColumn<int>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [id, kind, code, amount];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pay_rates';
  @override
  VerificationContext validateIntegrity(
    Insertable<PayRateRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('code')) {
      context.handle(
        _codeMeta,
        code.isAcceptableOrUnknown(data['code']!, _codeMeta),
      );
    } else if (isInserting) {
      context.missing(_codeMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PayRateRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PayRateRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      kind: $PayRatesTable.$converterkind.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}kind'],
        )!,
      ),
      code: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}code'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount'],
      )!,
    );
  }

  @override
  $PayRatesTable createAlias(String alias) {
    return $PayRatesTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<PayRateKind, int, int> $converterkind =
      const EnumIndexConverter<PayRateKind>(PayRateKind.values);
}

class PayRateRow extends DataClass implements Insertable<PayRateRow> {
  final int id;

  /// 0 — тарифный разряд (должность), 1 — воинское звание.
  final PayRateKind kind;

  /// Ключ: номер разряда или нормализованное звание.
  final String code;

  /// Оклад в рублях (целые рубли).
  final int amount;
  const PayRateRow({
    required this.id,
    required this.kind,
    required this.code,
    required this.amount,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    {
      map['kind'] = Variable<int>($PayRatesTable.$converterkind.toSql(kind));
    }
    map['code'] = Variable<String>(code);
    map['amount'] = Variable<int>(amount);
    return map;
  }

  PayRatesCompanion toCompanion(bool nullToAbsent) {
    return PayRatesCompanion(
      id: Value(id),
      kind: Value(kind),
      code: Value(code),
      amount: Value(amount),
    );
  }

  factory PayRateRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PayRateRow(
      id: serializer.fromJson<int>(json['id']),
      kind: $PayRatesTable.$converterkind.fromJson(
        serializer.fromJson<int>(json['kind']),
      ),
      code: serializer.fromJson<String>(json['code']),
      amount: serializer.fromJson<int>(json['amount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'kind': serializer.toJson<int>(
        $PayRatesTable.$converterkind.toJson(kind),
      ),
      'code': serializer.toJson<String>(code),
      'amount': serializer.toJson<int>(amount),
    };
  }

  PayRateRow copyWith({
    int? id,
    PayRateKind? kind,
    String? code,
    int? amount,
  }) => PayRateRow(
    id: id ?? this.id,
    kind: kind ?? this.kind,
    code: code ?? this.code,
    amount: amount ?? this.amount,
  );
  PayRateRow copyWithCompanion(PayRatesCompanion data) {
    return PayRateRow(
      id: data.id.present ? data.id.value : this.id,
      kind: data.kind.present ? data.kind.value : this.kind,
      code: data.code.present ? data.code.value : this.code,
      amount: data.amount.present ? data.amount.value : this.amount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PayRateRow(')
          ..write('id: $id, ')
          ..write('kind: $kind, ')
          ..write('code: $code, ')
          ..write('amount: $amount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, kind, code, amount);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PayRateRow &&
          other.id == this.id &&
          other.kind == this.kind &&
          other.code == this.code &&
          other.amount == this.amount);
}

class PayRatesCompanion extends UpdateCompanion<PayRateRow> {
  final Value<int> id;
  final Value<PayRateKind> kind;
  final Value<String> code;
  final Value<int> amount;
  const PayRatesCompanion({
    this.id = const Value.absent(),
    this.kind = const Value.absent(),
    this.code = const Value.absent(),
    this.amount = const Value.absent(),
  });
  PayRatesCompanion.insert({
    this.id = const Value.absent(),
    required PayRateKind kind,
    required String code,
    this.amount = const Value.absent(),
  }) : kind = Value(kind),
       code = Value(code);
  static Insertable<PayRateRow> custom({
    Expression<int>? id,
    Expression<int>? kind,
    Expression<String>? code,
    Expression<int>? amount,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (kind != null) 'kind': kind,
      if (code != null) 'code': code,
      if (amount != null) 'amount': amount,
    });
  }

  PayRatesCompanion copyWith({
    Value<int>? id,
    Value<PayRateKind>? kind,
    Value<String>? code,
    Value<int>? amount,
  }) {
    return PayRatesCompanion(
      id: id ?? this.id,
      kind: kind ?? this.kind,
      code: code ?? this.code,
      amount: amount ?? this.amount,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (kind.present) {
      map['kind'] = Variable<int>(
        $PayRatesTable.$converterkind.toSql(kind.value),
      );
    }
    if (code.present) {
      map['code'] = Variable<String>(code.value);
    }
    if (amount.present) {
      map['amount'] = Variable<int>(amount.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PayRatesCompanion(')
          ..write('id: $id, ')
          ..write('kind: $kind, ')
          ..write('code: $code, ')
          ..write('amount: $amount')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $SettingsTable settings = $SettingsTable(this);
  late final $PositionsTable positions = $PositionsTable(this);
  late final $PersonnelTable personnel = $PersonnelTable(this);
  late final $AwardsTable awards = $AwardsTable(this);
  late final $LeavesTable leaves = $LeavesTable(this);
  late final $TripsTable trips = $TripsTable(this);
  late final $WeaponsTable weapons = $WeaponsTable(this);
  late final $ServicePeriodsTable servicePeriods = $ServicePeriodsTable(this);
  late final $PayRatesTable payRates = $PayRatesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    settings,
    positions,
    personnel,
    awards,
    leaves,
    trips,
    weapons,
    servicePeriods,
    payRates,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'personnel',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('awards', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'personnel',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('leaves', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'personnel',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('trips', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'personnel',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('weapons', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'personnel',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('service_periods', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$SettingsTableCreateCompanionBuilder =
    SettingsCompanion Function({
      required String key,
      required String value,
      Value<int> rowid,
    });
typedef $$SettingsTableUpdateCompanionBuilder =
    SettingsCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<int> rowid,
    });

class $$SettingsTableFilterComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$SettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SettingsTable,
          SettingRow,
          $$SettingsTableFilterComposer,
          $$SettingsTableOrderingComposer,
          $$SettingsTableAnnotationComposer,
          $$SettingsTableCreateCompanionBuilder,
          $$SettingsTableUpdateCompanionBuilder,
          (
            SettingRow,
            BaseReferences<_$AppDatabase, $SettingsTable, SettingRow>,
          ),
          SettingRow,
          PrefetchHooks Function()
        > {
  $$SettingsTableTableManager(_$AppDatabase db, $SettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SettingsCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                Value<int> rowid = const Value.absent(),
              }) => SettingsCompanion.insert(
                key: key,
                value: value,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SettingsTable,
      SettingRow,
      $$SettingsTableFilterComposer,
      $$SettingsTableOrderingComposer,
      $$SettingsTableAnnotationComposer,
      $$SettingsTableCreateCompanionBuilder,
      $$SettingsTableUpdateCompanionBuilder,
      (SettingRow, BaseReferences<_$AppDatabase, $SettingsTable, SettingRow>),
      SettingRow,
      PrefetchHooks Function()
    >;
typedef $$PositionsTableCreateCompanionBuilder =
    PositionsCompanion Function({
      Value<int> id,
      required int slot,
      required String title,
      Value<String> subunit,
      required RankCategory category,
      Value<String?> crew,
      Value<int?> tariffRank,
    });
typedef $$PositionsTableUpdateCompanionBuilder =
    PositionsCompanion Function({
      Value<int> id,
      Value<int> slot,
      Value<String> title,
      Value<String> subunit,
      Value<RankCategory> category,
      Value<String?> crew,
      Value<int?> tariffRank,
    });

final class $$PositionsTableReferences
    extends BaseReferences<_$AppDatabase, $PositionsTable, PositionRow> {
  $$PositionsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$PersonnelTable, List<PersonRow>>
  _personnelRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.personnel,
    aliasName: $_aliasNameGenerator(db.positions.id, db.personnel.positionId),
  );

  $$PersonnelTableProcessedTableManager get personnelRefs {
    final manager = $$PersonnelTableTableManager(
      $_db,
      $_db.personnel,
    ).filter((f) => f.positionId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_personnelRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PositionsTableFilterComposer
    extends Composer<_$AppDatabase, $PositionsTable> {
  $$PositionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get slot => $composableBuilder(
    column: $table.slot,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get subunit => $composableBuilder(
    column: $table.subunit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<RankCategory, RankCategory, int>
  get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get crew => $composableBuilder(
    column: $table.crew,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get tariffRank => $composableBuilder(
    column: $table.tariffRank,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> personnelRefs(
    Expression<bool> Function($$PersonnelTableFilterComposer f) f,
  ) {
    final $$PersonnelTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.personnel,
      getReferencedColumn: (t) => t.positionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PersonnelTableFilterComposer(
            $db: $db,
            $table: $db.personnel,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PositionsTableOrderingComposer
    extends Composer<_$AppDatabase, $PositionsTable> {
  $$PositionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get slot => $composableBuilder(
    column: $table.slot,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get subunit => $composableBuilder(
    column: $table.subunit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get crew => $composableBuilder(
    column: $table.crew,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get tariffRank => $composableBuilder(
    column: $table.tariffRank,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PositionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PositionsTable> {
  $$PositionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get slot =>
      $composableBuilder(column: $table.slot, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get subunit =>
      $composableBuilder(column: $table.subunit, builder: (column) => column);

  GeneratedColumnWithTypeConverter<RankCategory, int> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get crew =>
      $composableBuilder(column: $table.crew, builder: (column) => column);

  GeneratedColumn<int> get tariffRank => $composableBuilder(
    column: $table.tariffRank,
    builder: (column) => column,
  );

  Expression<T> personnelRefs<T extends Object>(
    Expression<T> Function($$PersonnelTableAnnotationComposer a) f,
  ) {
    final $$PersonnelTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.personnel,
      getReferencedColumn: (t) => t.positionId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PersonnelTableAnnotationComposer(
            $db: $db,
            $table: $db.personnel,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PositionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PositionsTable,
          PositionRow,
          $$PositionsTableFilterComposer,
          $$PositionsTableOrderingComposer,
          $$PositionsTableAnnotationComposer,
          $$PositionsTableCreateCompanionBuilder,
          $$PositionsTableUpdateCompanionBuilder,
          (PositionRow, $$PositionsTableReferences),
          PositionRow,
          PrefetchHooks Function({bool personnelRefs})
        > {
  $$PositionsTableTableManager(_$AppDatabase db, $PositionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PositionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PositionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PositionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> slot = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> subunit = const Value.absent(),
                Value<RankCategory> category = const Value.absent(),
                Value<String?> crew = const Value.absent(),
                Value<int?> tariffRank = const Value.absent(),
              }) => PositionsCompanion(
                id: id,
                slot: slot,
                title: title,
                subunit: subunit,
                category: category,
                crew: crew,
                tariffRank: tariffRank,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int slot,
                required String title,
                Value<String> subunit = const Value.absent(),
                required RankCategory category,
                Value<String?> crew = const Value.absent(),
                Value<int?> tariffRank = const Value.absent(),
              }) => PositionsCompanion.insert(
                id: id,
                slot: slot,
                title: title,
                subunit: subunit,
                category: category,
                crew: crew,
                tariffRank: tariffRank,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PositionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({personnelRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (personnelRefs) db.personnel],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (personnelRefs)
                    await $_getPrefetchedData<
                      PositionRow,
                      $PositionsTable,
                      PersonRow
                    >(
                      currentTable: table,
                      referencedTable: $$PositionsTableReferences
                          ._personnelRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$PositionsTableReferences(
                            db,
                            table,
                            p0,
                          ).personnelRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.positionId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$PositionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PositionsTable,
      PositionRow,
      $$PositionsTableFilterComposer,
      $$PositionsTableOrderingComposer,
      $$PositionsTableAnnotationComposer,
      $$PositionsTableCreateCompanionBuilder,
      $$PositionsTableUpdateCompanionBuilder,
      (PositionRow, $$PositionsTableReferences),
      PositionRow,
      PrefetchHooks Function({bool personnelRefs})
    >;
typedef $$PersonnelTableCreateCompanionBuilder =
    PersonnelCompanion Function({
      Value<int> id,
      Value<int?> positionId,
      required String lastName,
      Value<String> firstName,
      Value<String> middleName,
      Value<String> rank,
      Value<PersonnelStatus> status,
      Value<String?> personalNumber,
      Value<String?> phone,
      Value<String?> address,
      Value<MaritalStatus?> maritalStatus,
      Value<int> childrenCount,
      Value<DateTime?> birthDate,
      Value<DateTime?> contractStart,
      Value<DateTime?> contractEnd,
      Value<String?> qualification,
      Value<DateTime?> qualificationDate,
      Value<DateTime?> serviceStart,
      Value<bool> isVeteran,
      Value<int> allowanceSpecial,
      Value<int> allowanceSecrecy,
      Value<int> allowanceRisk,
      Value<int> allowanceFizo,
      Value<int> allowanceAchieve,
      Value<double> regionalCoef,
      Value<int> premiumPercent,
      Value<int> leaveLimitMain,
      Value<int> leaveLimitAdditional,
      Value<int> leaveLimitVeteran,
      Value<bool> isArchived,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });
typedef $$PersonnelTableUpdateCompanionBuilder =
    PersonnelCompanion Function({
      Value<int> id,
      Value<int?> positionId,
      Value<String> lastName,
      Value<String> firstName,
      Value<String> middleName,
      Value<String> rank,
      Value<PersonnelStatus> status,
      Value<String?> personalNumber,
      Value<String?> phone,
      Value<String?> address,
      Value<MaritalStatus?> maritalStatus,
      Value<int> childrenCount,
      Value<DateTime?> birthDate,
      Value<DateTime?> contractStart,
      Value<DateTime?> contractEnd,
      Value<String?> qualification,
      Value<DateTime?> qualificationDate,
      Value<DateTime?> serviceStart,
      Value<bool> isVeteran,
      Value<int> allowanceSpecial,
      Value<int> allowanceSecrecy,
      Value<int> allowanceRisk,
      Value<int> allowanceFizo,
      Value<int> allowanceAchieve,
      Value<double> regionalCoef,
      Value<int> premiumPercent,
      Value<int> leaveLimitMain,
      Value<int> leaveLimitAdditional,
      Value<int> leaveLimitVeteran,
      Value<bool> isArchived,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
    });

final class $$PersonnelTableReferences
    extends BaseReferences<_$AppDatabase, $PersonnelTable, PersonRow> {
  $$PersonnelTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PositionsTable _positionIdTable(_$AppDatabase db) =>
      db.positions.createAlias(
        $_aliasNameGenerator(db.personnel.positionId, db.positions.id),
      );

  $$PositionsTableProcessedTableManager? get positionId {
    final $_column = $_itemColumn<int>('position_id');
    if ($_column == null) return null;
    final manager = $$PositionsTableTableManager(
      $_db,
      $_db.positions,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_positionIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$AwardsTable, List<AwardRow>> _awardsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.awards,
    aliasName: $_aliasNameGenerator(db.personnel.id, db.awards.personnelId),
  );

  $$AwardsTableProcessedTableManager get awardsRefs {
    final manager = $$AwardsTableTableManager(
      $_db,
      $_db.awards,
    ).filter((f) => f.personnelId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_awardsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$LeavesTable, List<LeaveRow>> _leavesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.leaves,
    aliasName: $_aliasNameGenerator(db.personnel.id, db.leaves.personnelId),
  );

  $$LeavesTableProcessedTableManager get leavesRefs {
    final manager = $$LeavesTableTableManager(
      $_db,
      $_db.leaves,
    ).filter((f) => f.personnelId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_leavesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TripsTable, List<TripRow>> _tripsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.trips,
    aliasName: $_aliasNameGenerator(db.personnel.id, db.trips.personnelId),
  );

  $$TripsTableProcessedTableManager get tripsRefs {
    final manager = $$TripsTableTableManager(
      $_db,
      $_db.trips,
    ).filter((f) => f.personnelId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_tripsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$WeaponsTable, List<WeaponRow>> _weaponsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.weapons,
    aliasName: $_aliasNameGenerator(db.personnel.id, db.weapons.personnelId),
  );

  $$WeaponsTableProcessedTableManager get weaponsRefs {
    final manager = $$WeaponsTableTableManager(
      $_db,
      $_db.weapons,
    ).filter((f) => f.personnelId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_weaponsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ServicePeriodsTable, List<ServicePeriodRow>>
  _servicePeriodsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.servicePeriods,
    aliasName: $_aliasNameGenerator(
      db.personnel.id,
      db.servicePeriods.personnelId,
    ),
  );

  $$ServicePeriodsTableProcessedTableManager get servicePeriodsRefs {
    final manager = $$ServicePeriodsTableTableManager(
      $_db,
      $_db.servicePeriods,
    ).filter((f) => f.personnelId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_servicePeriodsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$PersonnelTableFilterComposer
    extends Composer<_$AppDatabase, $PersonnelTable> {
  $$PersonnelTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastName => $composableBuilder(
    column: $table.lastName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get firstName => $composableBuilder(
    column: $table.firstName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get middleName => $composableBuilder(
    column: $table.middleName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get rank => $composableBuilder(
    column: $table.rank,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<PersonnelStatus, PersonnelStatus, int>
  get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get personalNumber => $composableBuilder(
    column: $table.personalNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<MaritalStatus?, MaritalStatus, int>
  get maritalStatus => $composableBuilder(
    column: $table.maritalStatus,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<int> get childrenCount => $composableBuilder(
    column: $table.childrenCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get birthDate => $composableBuilder(
    column: $table.birthDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get contractStart => $composableBuilder(
    column: $table.contractStart,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get contractEnd => $composableBuilder(
    column: $table.contractEnd,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get qualification => $composableBuilder(
    column: $table.qualification,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get qualificationDate => $composableBuilder(
    column: $table.qualificationDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get serviceStart => $composableBuilder(
    column: $table.serviceStart,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isVeteran => $composableBuilder(
    column: $table.isVeteran,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get allowanceSpecial => $composableBuilder(
    column: $table.allowanceSpecial,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get allowanceSecrecy => $composableBuilder(
    column: $table.allowanceSecrecy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get allowanceRisk => $composableBuilder(
    column: $table.allowanceRisk,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get allowanceFizo => $composableBuilder(
    column: $table.allowanceFizo,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get allowanceAchieve => $composableBuilder(
    column: $table.allowanceAchieve,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get regionalCoef => $composableBuilder(
    column: $table.regionalCoef,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get premiumPercent => $composableBuilder(
    column: $table.premiumPercent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get leaveLimitMain => $composableBuilder(
    column: $table.leaveLimitMain,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get leaveLimitAdditional => $composableBuilder(
    column: $table.leaveLimitAdditional,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get leaveLimitVeteran => $composableBuilder(
    column: $table.leaveLimitVeteran,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$PositionsTableFilterComposer get positionId {
    final $$PositionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.positionId,
      referencedTable: $db.positions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PositionsTableFilterComposer(
            $db: $db,
            $table: $db.positions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> awardsRefs(
    Expression<bool> Function($$AwardsTableFilterComposer f) f,
  ) {
    final $$AwardsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.awards,
      getReferencedColumn: (t) => t.personnelId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AwardsTableFilterComposer(
            $db: $db,
            $table: $db.awards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> leavesRefs(
    Expression<bool> Function($$LeavesTableFilterComposer f) f,
  ) {
    final $$LeavesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.leaves,
      getReferencedColumn: (t) => t.personnelId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LeavesTableFilterComposer(
            $db: $db,
            $table: $db.leaves,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> tripsRefs(
    Expression<bool> Function($$TripsTableFilterComposer f) f,
  ) {
    final $$TripsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.trips,
      getReferencedColumn: (t) => t.personnelId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TripsTableFilterComposer(
            $db: $db,
            $table: $db.trips,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> weaponsRefs(
    Expression<bool> Function($$WeaponsTableFilterComposer f) f,
  ) {
    final $$WeaponsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.weapons,
      getReferencedColumn: (t) => t.personnelId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WeaponsTableFilterComposer(
            $db: $db,
            $table: $db.weapons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> servicePeriodsRefs(
    Expression<bool> Function($$ServicePeriodsTableFilterComposer f) f,
  ) {
    final $$ServicePeriodsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.servicePeriods,
      getReferencedColumn: (t) => t.personnelId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ServicePeriodsTableFilterComposer(
            $db: $db,
            $table: $db.servicePeriods,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PersonnelTableOrderingComposer
    extends Composer<_$AppDatabase, $PersonnelTable> {
  $$PersonnelTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastName => $composableBuilder(
    column: $table.lastName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get firstName => $composableBuilder(
    column: $table.firstName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get middleName => $composableBuilder(
    column: $table.middleName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get rank => $composableBuilder(
    column: $table.rank,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get personalNumber => $composableBuilder(
    column: $table.personalNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phone => $composableBuilder(
    column: $table.phone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get address => $composableBuilder(
    column: $table.address,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get maritalStatus => $composableBuilder(
    column: $table.maritalStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get childrenCount => $composableBuilder(
    column: $table.childrenCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get birthDate => $composableBuilder(
    column: $table.birthDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get contractStart => $composableBuilder(
    column: $table.contractStart,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get contractEnd => $composableBuilder(
    column: $table.contractEnd,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get qualification => $composableBuilder(
    column: $table.qualification,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get qualificationDate => $composableBuilder(
    column: $table.qualificationDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get serviceStart => $composableBuilder(
    column: $table.serviceStart,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isVeteran => $composableBuilder(
    column: $table.isVeteran,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get allowanceSpecial => $composableBuilder(
    column: $table.allowanceSpecial,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get allowanceSecrecy => $composableBuilder(
    column: $table.allowanceSecrecy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get allowanceRisk => $composableBuilder(
    column: $table.allowanceRisk,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get allowanceFizo => $composableBuilder(
    column: $table.allowanceFizo,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get allowanceAchieve => $composableBuilder(
    column: $table.allowanceAchieve,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get regionalCoef => $composableBuilder(
    column: $table.regionalCoef,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get premiumPercent => $composableBuilder(
    column: $table.premiumPercent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get leaveLimitMain => $composableBuilder(
    column: $table.leaveLimitMain,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get leaveLimitAdditional => $composableBuilder(
    column: $table.leaveLimitAdditional,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get leaveLimitVeteran => $composableBuilder(
    column: $table.leaveLimitVeteran,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$PositionsTableOrderingComposer get positionId {
    final $$PositionsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.positionId,
      referencedTable: $db.positions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PositionsTableOrderingComposer(
            $db: $db,
            $table: $db.positions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$PersonnelTableAnnotationComposer
    extends Composer<_$AppDatabase, $PersonnelTable> {
  $$PersonnelTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get lastName =>
      $composableBuilder(column: $table.lastName, builder: (column) => column);

  GeneratedColumn<String> get firstName =>
      $composableBuilder(column: $table.firstName, builder: (column) => column);

  GeneratedColumn<String> get middleName => $composableBuilder(
    column: $table.middleName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get rank =>
      $composableBuilder(column: $table.rank, builder: (column) => column);

  GeneratedColumnWithTypeConverter<PersonnelStatus, int> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get personalNumber => $composableBuilder(
    column: $table.personalNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get phone =>
      $composableBuilder(column: $table.phone, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumnWithTypeConverter<MaritalStatus?, int> get maritalStatus =>
      $composableBuilder(
        column: $table.maritalStatus,
        builder: (column) => column,
      );

  GeneratedColumn<int> get childrenCount => $composableBuilder(
    column: $table.childrenCount,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get birthDate =>
      $composableBuilder(column: $table.birthDate, builder: (column) => column);

  GeneratedColumn<DateTime> get contractStart => $composableBuilder(
    column: $table.contractStart,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get contractEnd => $composableBuilder(
    column: $table.contractEnd,
    builder: (column) => column,
  );

  GeneratedColumn<String> get qualification => $composableBuilder(
    column: $table.qualification,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get qualificationDate => $composableBuilder(
    column: $table.qualificationDate,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get serviceStart => $composableBuilder(
    column: $table.serviceStart,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isVeteran =>
      $composableBuilder(column: $table.isVeteran, builder: (column) => column);

  GeneratedColumn<int> get allowanceSpecial => $composableBuilder(
    column: $table.allowanceSpecial,
    builder: (column) => column,
  );

  GeneratedColumn<int> get allowanceSecrecy => $composableBuilder(
    column: $table.allowanceSecrecy,
    builder: (column) => column,
  );

  GeneratedColumn<int> get allowanceRisk => $composableBuilder(
    column: $table.allowanceRisk,
    builder: (column) => column,
  );

  GeneratedColumn<int> get allowanceFizo => $composableBuilder(
    column: $table.allowanceFizo,
    builder: (column) => column,
  );

  GeneratedColumn<int> get allowanceAchieve => $composableBuilder(
    column: $table.allowanceAchieve,
    builder: (column) => column,
  );

  GeneratedColumn<double> get regionalCoef => $composableBuilder(
    column: $table.regionalCoef,
    builder: (column) => column,
  );

  GeneratedColumn<int> get premiumPercent => $composableBuilder(
    column: $table.premiumPercent,
    builder: (column) => column,
  );

  GeneratedColumn<int> get leaveLimitMain => $composableBuilder(
    column: $table.leaveLimitMain,
    builder: (column) => column,
  );

  GeneratedColumn<int> get leaveLimitAdditional => $composableBuilder(
    column: $table.leaveLimitAdditional,
    builder: (column) => column,
  );

  GeneratedColumn<int> get leaveLimitVeteran => $composableBuilder(
    column: $table.leaveLimitVeteran,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$PositionsTableAnnotationComposer get positionId {
    final $$PositionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.positionId,
      referencedTable: $db.positions,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PositionsTableAnnotationComposer(
            $db: $db,
            $table: $db.positions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> awardsRefs<T extends Object>(
    Expression<T> Function($$AwardsTableAnnotationComposer a) f,
  ) {
    final $$AwardsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.awards,
      getReferencedColumn: (t) => t.personnelId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$AwardsTableAnnotationComposer(
            $db: $db,
            $table: $db.awards,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> leavesRefs<T extends Object>(
    Expression<T> Function($$LeavesTableAnnotationComposer a) f,
  ) {
    final $$LeavesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.leaves,
      getReferencedColumn: (t) => t.personnelId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LeavesTableAnnotationComposer(
            $db: $db,
            $table: $db.leaves,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> tripsRefs<T extends Object>(
    Expression<T> Function($$TripsTableAnnotationComposer a) f,
  ) {
    final $$TripsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.trips,
      getReferencedColumn: (t) => t.personnelId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TripsTableAnnotationComposer(
            $db: $db,
            $table: $db.trips,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> weaponsRefs<T extends Object>(
    Expression<T> Function($$WeaponsTableAnnotationComposer a) f,
  ) {
    final $$WeaponsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.weapons,
      getReferencedColumn: (t) => t.personnelId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WeaponsTableAnnotationComposer(
            $db: $db,
            $table: $db.weapons,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> servicePeriodsRefs<T extends Object>(
    Expression<T> Function($$ServicePeriodsTableAnnotationComposer a) f,
  ) {
    final $$ServicePeriodsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.servicePeriods,
      getReferencedColumn: (t) => t.personnelId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ServicePeriodsTableAnnotationComposer(
            $db: $db,
            $table: $db.servicePeriods,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$PersonnelTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PersonnelTable,
          PersonRow,
          $$PersonnelTableFilterComposer,
          $$PersonnelTableOrderingComposer,
          $$PersonnelTableAnnotationComposer,
          $$PersonnelTableCreateCompanionBuilder,
          $$PersonnelTableUpdateCompanionBuilder,
          (PersonRow, $$PersonnelTableReferences),
          PersonRow,
          PrefetchHooks Function({
            bool positionId,
            bool awardsRefs,
            bool leavesRefs,
            bool tripsRefs,
            bool weaponsRefs,
            bool servicePeriodsRefs,
          })
        > {
  $$PersonnelTableTableManager(_$AppDatabase db, $PersonnelTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PersonnelTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PersonnelTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PersonnelTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> positionId = const Value.absent(),
                Value<String> lastName = const Value.absent(),
                Value<String> firstName = const Value.absent(),
                Value<String> middleName = const Value.absent(),
                Value<String> rank = const Value.absent(),
                Value<PersonnelStatus> status = const Value.absent(),
                Value<String?> personalNumber = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> address = const Value.absent(),
                Value<MaritalStatus?> maritalStatus = const Value.absent(),
                Value<int> childrenCount = const Value.absent(),
                Value<DateTime?> birthDate = const Value.absent(),
                Value<DateTime?> contractStart = const Value.absent(),
                Value<DateTime?> contractEnd = const Value.absent(),
                Value<String?> qualification = const Value.absent(),
                Value<DateTime?> qualificationDate = const Value.absent(),
                Value<DateTime?> serviceStart = const Value.absent(),
                Value<bool> isVeteran = const Value.absent(),
                Value<int> allowanceSpecial = const Value.absent(),
                Value<int> allowanceSecrecy = const Value.absent(),
                Value<int> allowanceRisk = const Value.absent(),
                Value<int> allowanceFizo = const Value.absent(),
                Value<int> allowanceAchieve = const Value.absent(),
                Value<double> regionalCoef = const Value.absent(),
                Value<int> premiumPercent = const Value.absent(),
                Value<int> leaveLimitMain = const Value.absent(),
                Value<int> leaveLimitAdditional = const Value.absent(),
                Value<int> leaveLimitVeteran = const Value.absent(),
                Value<bool> isArchived = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => PersonnelCompanion(
                id: id,
                positionId: positionId,
                lastName: lastName,
                firstName: firstName,
                middleName: middleName,
                rank: rank,
                status: status,
                personalNumber: personalNumber,
                phone: phone,
                address: address,
                maritalStatus: maritalStatus,
                childrenCount: childrenCount,
                birthDate: birthDate,
                contractStart: contractStart,
                contractEnd: contractEnd,
                qualification: qualification,
                qualificationDate: qualificationDate,
                serviceStart: serviceStart,
                isVeteran: isVeteran,
                allowanceSpecial: allowanceSpecial,
                allowanceSecrecy: allowanceSecrecy,
                allowanceRisk: allowanceRisk,
                allowanceFizo: allowanceFizo,
                allowanceAchieve: allowanceAchieve,
                regionalCoef: regionalCoef,
                premiumPercent: premiumPercent,
                leaveLimitMain: leaveLimitMain,
                leaveLimitAdditional: leaveLimitAdditional,
                leaveLimitVeteran: leaveLimitVeteran,
                isArchived: isArchived,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int?> positionId = const Value.absent(),
                required String lastName,
                Value<String> firstName = const Value.absent(),
                Value<String> middleName = const Value.absent(),
                Value<String> rank = const Value.absent(),
                Value<PersonnelStatus> status = const Value.absent(),
                Value<String?> personalNumber = const Value.absent(),
                Value<String?> phone = const Value.absent(),
                Value<String?> address = const Value.absent(),
                Value<MaritalStatus?> maritalStatus = const Value.absent(),
                Value<int> childrenCount = const Value.absent(),
                Value<DateTime?> birthDate = const Value.absent(),
                Value<DateTime?> contractStart = const Value.absent(),
                Value<DateTime?> contractEnd = const Value.absent(),
                Value<String?> qualification = const Value.absent(),
                Value<DateTime?> qualificationDate = const Value.absent(),
                Value<DateTime?> serviceStart = const Value.absent(),
                Value<bool> isVeteran = const Value.absent(),
                Value<int> allowanceSpecial = const Value.absent(),
                Value<int> allowanceSecrecy = const Value.absent(),
                Value<int> allowanceRisk = const Value.absent(),
                Value<int> allowanceFizo = const Value.absent(),
                Value<int> allowanceAchieve = const Value.absent(),
                Value<double> regionalCoef = const Value.absent(),
                Value<int> premiumPercent = const Value.absent(),
                Value<int> leaveLimitMain = const Value.absent(),
                Value<int> leaveLimitAdditional = const Value.absent(),
                Value<int> leaveLimitVeteran = const Value.absent(),
                Value<bool> isArchived = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
              }) => PersonnelCompanion.insert(
                id: id,
                positionId: positionId,
                lastName: lastName,
                firstName: firstName,
                middleName: middleName,
                rank: rank,
                status: status,
                personalNumber: personalNumber,
                phone: phone,
                address: address,
                maritalStatus: maritalStatus,
                childrenCount: childrenCount,
                birthDate: birthDate,
                contractStart: contractStart,
                contractEnd: contractEnd,
                qualification: qualification,
                qualificationDate: qualificationDate,
                serviceStart: serviceStart,
                isVeteran: isVeteran,
                allowanceSpecial: allowanceSpecial,
                allowanceSecrecy: allowanceSecrecy,
                allowanceRisk: allowanceRisk,
                allowanceFizo: allowanceFizo,
                allowanceAchieve: allowanceAchieve,
                regionalCoef: regionalCoef,
                premiumPercent: premiumPercent,
                leaveLimitMain: leaveLimitMain,
                leaveLimitAdditional: leaveLimitAdditional,
                leaveLimitVeteran: leaveLimitVeteran,
                isArchived: isArchived,
                createdAt: createdAt,
                updatedAt: updatedAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PersonnelTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                positionId = false,
                awardsRefs = false,
                leavesRefs = false,
                tripsRefs = false,
                weaponsRefs = false,
                servicePeriodsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (awardsRefs) db.awards,
                    if (leavesRefs) db.leaves,
                    if (tripsRefs) db.trips,
                    if (weaponsRefs) db.weapons,
                    if (servicePeriodsRefs) db.servicePeriods,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (positionId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.positionId,
                                    referencedTable: $$PersonnelTableReferences
                                        ._positionIdTable(db),
                                    referencedColumn: $$PersonnelTableReferences
                                        ._positionIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (awardsRefs)
                        await $_getPrefetchedData<
                          PersonRow,
                          $PersonnelTable,
                          AwardRow
                        >(
                          currentTable: table,
                          referencedTable: $$PersonnelTableReferences
                              ._awardsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PersonnelTableReferences(
                                db,
                                table,
                                p0,
                              ).awardsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.personnelId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (leavesRefs)
                        await $_getPrefetchedData<
                          PersonRow,
                          $PersonnelTable,
                          LeaveRow
                        >(
                          currentTable: table,
                          referencedTable: $$PersonnelTableReferences
                              ._leavesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PersonnelTableReferences(
                                db,
                                table,
                                p0,
                              ).leavesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.personnelId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (tripsRefs)
                        await $_getPrefetchedData<
                          PersonRow,
                          $PersonnelTable,
                          TripRow
                        >(
                          currentTable: table,
                          referencedTable: $$PersonnelTableReferences
                              ._tripsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PersonnelTableReferences(
                                db,
                                table,
                                p0,
                              ).tripsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.personnelId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (weaponsRefs)
                        await $_getPrefetchedData<
                          PersonRow,
                          $PersonnelTable,
                          WeaponRow
                        >(
                          currentTable: table,
                          referencedTable: $$PersonnelTableReferences
                              ._weaponsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PersonnelTableReferences(
                                db,
                                table,
                                p0,
                              ).weaponsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.personnelId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (servicePeriodsRefs)
                        await $_getPrefetchedData<
                          PersonRow,
                          $PersonnelTable,
                          ServicePeriodRow
                        >(
                          currentTable: table,
                          referencedTable: $$PersonnelTableReferences
                              ._servicePeriodsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$PersonnelTableReferences(
                                db,
                                table,
                                p0,
                              ).servicePeriodsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.personnelId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$PersonnelTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PersonnelTable,
      PersonRow,
      $$PersonnelTableFilterComposer,
      $$PersonnelTableOrderingComposer,
      $$PersonnelTableAnnotationComposer,
      $$PersonnelTableCreateCompanionBuilder,
      $$PersonnelTableUpdateCompanionBuilder,
      (PersonRow, $$PersonnelTableReferences),
      PersonRow,
      PrefetchHooks Function({
        bool positionId,
        bool awardsRefs,
        bool leavesRefs,
        bool tripsRefs,
        bool weaponsRefs,
        bool servicePeriodsRefs,
      })
    >;
typedef $$AwardsTableCreateCompanionBuilder =
    AwardsCompanion Function({
      Value<int> id,
      required int personnelId,
      required String name,
      required AwardKind kind,
      Value<String?> degree,
      Value<DateTime?> awardDate,
      Value<String?> note,
    });
typedef $$AwardsTableUpdateCompanionBuilder =
    AwardsCompanion Function({
      Value<int> id,
      Value<int> personnelId,
      Value<String> name,
      Value<AwardKind> kind,
      Value<String?> degree,
      Value<DateTime?> awardDate,
      Value<String?> note,
    });

final class $$AwardsTableReferences
    extends BaseReferences<_$AppDatabase, $AwardsTable, AwardRow> {
  $$AwardsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PersonnelTable _personnelIdTable(_$AppDatabase db) =>
      db.personnel.createAlias(
        $_aliasNameGenerator(db.awards.personnelId, db.personnel.id),
      );

  $$PersonnelTableProcessedTableManager get personnelId {
    final $_column = $_itemColumn<int>('personnel_id')!;

    final manager = $$PersonnelTableTableManager(
      $_db,
      $_db.personnel,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_personnelIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$AwardsTableFilterComposer
    extends Composer<_$AppDatabase, $AwardsTable> {
  $$AwardsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<AwardKind, AwardKind, int> get kind =>
      $composableBuilder(
        column: $table.kind,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get degree => $composableBuilder(
    column: $table.degree,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get awardDate => $composableBuilder(
    column: $table.awardDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  $$PersonnelTableFilterComposer get personnelId {
    final $$PersonnelTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.personnelId,
      referencedTable: $db.personnel,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PersonnelTableFilterComposer(
            $db: $db,
            $table: $db.personnel,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AwardsTableOrderingComposer
    extends Composer<_$AppDatabase, $AwardsTable> {
  $$AwardsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get degree => $composableBuilder(
    column: $table.degree,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get awardDate => $composableBuilder(
    column: $table.awardDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  $$PersonnelTableOrderingComposer get personnelId {
    final $$PersonnelTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.personnelId,
      referencedTable: $db.personnel,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PersonnelTableOrderingComposer(
            $db: $db,
            $table: $db.personnel,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AwardsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AwardsTable> {
  $$AwardsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumnWithTypeConverter<AwardKind, int> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get degree =>
      $composableBuilder(column: $table.degree, builder: (column) => column);

  GeneratedColumn<DateTime> get awardDate =>
      $composableBuilder(column: $table.awardDate, builder: (column) => column);

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  $$PersonnelTableAnnotationComposer get personnelId {
    final $$PersonnelTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.personnelId,
      referencedTable: $db.personnel,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PersonnelTableAnnotationComposer(
            $db: $db,
            $table: $db.personnel,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$AwardsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AwardsTable,
          AwardRow,
          $$AwardsTableFilterComposer,
          $$AwardsTableOrderingComposer,
          $$AwardsTableAnnotationComposer,
          $$AwardsTableCreateCompanionBuilder,
          $$AwardsTableUpdateCompanionBuilder,
          (AwardRow, $$AwardsTableReferences),
          AwardRow,
          PrefetchHooks Function({bool personnelId})
        > {
  $$AwardsTableTableManager(_$AppDatabase db, $AwardsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AwardsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AwardsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AwardsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> personnelId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<AwardKind> kind = const Value.absent(),
                Value<String?> degree = const Value.absent(),
                Value<DateTime?> awardDate = const Value.absent(),
                Value<String?> note = const Value.absent(),
              }) => AwardsCompanion(
                id: id,
                personnelId: personnelId,
                name: name,
                kind: kind,
                degree: degree,
                awardDate: awardDate,
                note: note,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int personnelId,
                required String name,
                required AwardKind kind,
                Value<String?> degree = const Value.absent(),
                Value<DateTime?> awardDate = const Value.absent(),
                Value<String?> note = const Value.absent(),
              }) => AwardsCompanion.insert(
                id: id,
                personnelId: personnelId,
                name: name,
                kind: kind,
                degree: degree,
                awardDate: awardDate,
                note: note,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$AwardsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({personnelId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (personnelId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.personnelId,
                                referencedTable: $$AwardsTableReferences
                                    ._personnelIdTable(db),
                                referencedColumn: $$AwardsTableReferences
                                    ._personnelIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$AwardsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AwardsTable,
      AwardRow,
      $$AwardsTableFilterComposer,
      $$AwardsTableOrderingComposer,
      $$AwardsTableAnnotationComposer,
      $$AwardsTableCreateCompanionBuilder,
      $$AwardsTableUpdateCompanionBuilder,
      (AwardRow, $$AwardsTableReferences),
      AwardRow,
      PrefetchHooks Function({bool personnelId})
    >;
typedef $$LeavesTableCreateCompanionBuilder =
    LeavesCompanion Function({
      Value<int> id,
      required int personnelId,
      required LeaveType type,
      Value<LeaveStatus> status,
      required int daysGranted,
      Value<bool> includesTravel,
      Value<int> travelDays,
      Value<DateTime?> startDate,
      Value<DateTime?> endDate,
      Value<DateTime?> actualReturnDate,
      Value<String?> orderNumber,
      Value<String?> destination,
      Value<String?> note,
    });
typedef $$LeavesTableUpdateCompanionBuilder =
    LeavesCompanion Function({
      Value<int> id,
      Value<int> personnelId,
      Value<LeaveType> type,
      Value<LeaveStatus> status,
      Value<int> daysGranted,
      Value<bool> includesTravel,
      Value<int> travelDays,
      Value<DateTime?> startDate,
      Value<DateTime?> endDate,
      Value<DateTime?> actualReturnDate,
      Value<String?> orderNumber,
      Value<String?> destination,
      Value<String?> note,
    });

final class $$LeavesTableReferences
    extends BaseReferences<_$AppDatabase, $LeavesTable, LeaveRow> {
  $$LeavesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PersonnelTable _personnelIdTable(_$AppDatabase db) =>
      db.personnel.createAlias(
        $_aliasNameGenerator(db.leaves.personnelId, db.personnel.id),
      );

  $$PersonnelTableProcessedTableManager get personnelId {
    final $_column = $_itemColumn<int>('personnel_id')!;

    final manager = $$PersonnelTableTableManager(
      $_db,
      $_db.personnel,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_personnelIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$LeavesTableFilterComposer
    extends Composer<_$AppDatabase, $LeavesTable> {
  $$LeavesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<LeaveType, LeaveType, int> get type =>
      $composableBuilder(
        column: $table.type,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<LeaveStatus, LeaveStatus, int> get status =>
      $composableBuilder(
        column: $table.status,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<int> get daysGranted => $composableBuilder(
    column: $table.daysGranted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get includesTravel => $composableBuilder(
    column: $table.includesTravel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get travelDays => $composableBuilder(
    column: $table.travelDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get actualReturnDate => $composableBuilder(
    column: $table.actualReturnDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get orderNumber => $composableBuilder(
    column: $table.orderNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get destination => $composableBuilder(
    column: $table.destination,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  $$PersonnelTableFilterComposer get personnelId {
    final $$PersonnelTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.personnelId,
      referencedTable: $db.personnel,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PersonnelTableFilterComposer(
            $db: $db,
            $table: $db.personnel,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LeavesTableOrderingComposer
    extends Composer<_$AppDatabase, $LeavesTable> {
  $$LeavesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get daysGranted => $composableBuilder(
    column: $table.daysGranted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get includesTravel => $composableBuilder(
    column: $table.includesTravel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get travelDays => $composableBuilder(
    column: $table.travelDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get actualReturnDate => $composableBuilder(
    column: $table.actualReturnDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get orderNumber => $composableBuilder(
    column: $table.orderNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get destination => $composableBuilder(
    column: $table.destination,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  $$PersonnelTableOrderingComposer get personnelId {
    final $$PersonnelTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.personnelId,
      referencedTable: $db.personnel,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PersonnelTableOrderingComposer(
            $db: $db,
            $table: $db.personnel,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LeavesTableAnnotationComposer
    extends Composer<_$AppDatabase, $LeavesTable> {
  $$LeavesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<LeaveType, int> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumnWithTypeConverter<LeaveStatus, int> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get daysGranted => $composableBuilder(
    column: $table.daysGranted,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get includesTravel => $composableBuilder(
    column: $table.includesTravel,
    builder: (column) => column,
  );

  GeneratedColumn<int> get travelDays => $composableBuilder(
    column: $table.travelDays,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumn<DateTime> get actualReturnDate => $composableBuilder(
    column: $table.actualReturnDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get orderNumber => $composableBuilder(
    column: $table.orderNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get destination => $composableBuilder(
    column: $table.destination,
    builder: (column) => column,
  );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  $$PersonnelTableAnnotationComposer get personnelId {
    final $$PersonnelTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.personnelId,
      referencedTable: $db.personnel,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PersonnelTableAnnotationComposer(
            $db: $db,
            $table: $db.personnel,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LeavesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LeavesTable,
          LeaveRow,
          $$LeavesTableFilterComposer,
          $$LeavesTableOrderingComposer,
          $$LeavesTableAnnotationComposer,
          $$LeavesTableCreateCompanionBuilder,
          $$LeavesTableUpdateCompanionBuilder,
          (LeaveRow, $$LeavesTableReferences),
          LeaveRow,
          PrefetchHooks Function({bool personnelId})
        > {
  $$LeavesTableTableManager(_$AppDatabase db, $LeavesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LeavesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LeavesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LeavesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> personnelId = const Value.absent(),
                Value<LeaveType> type = const Value.absent(),
                Value<LeaveStatus> status = const Value.absent(),
                Value<int> daysGranted = const Value.absent(),
                Value<bool> includesTravel = const Value.absent(),
                Value<int> travelDays = const Value.absent(),
                Value<DateTime?> startDate = const Value.absent(),
                Value<DateTime?> endDate = const Value.absent(),
                Value<DateTime?> actualReturnDate = const Value.absent(),
                Value<String?> orderNumber = const Value.absent(),
                Value<String?> destination = const Value.absent(),
                Value<String?> note = const Value.absent(),
              }) => LeavesCompanion(
                id: id,
                personnelId: personnelId,
                type: type,
                status: status,
                daysGranted: daysGranted,
                includesTravel: includesTravel,
                travelDays: travelDays,
                startDate: startDate,
                endDate: endDate,
                actualReturnDate: actualReturnDate,
                orderNumber: orderNumber,
                destination: destination,
                note: note,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int personnelId,
                required LeaveType type,
                Value<LeaveStatus> status = const Value.absent(),
                required int daysGranted,
                Value<bool> includesTravel = const Value.absent(),
                Value<int> travelDays = const Value.absent(),
                Value<DateTime?> startDate = const Value.absent(),
                Value<DateTime?> endDate = const Value.absent(),
                Value<DateTime?> actualReturnDate = const Value.absent(),
                Value<String?> orderNumber = const Value.absent(),
                Value<String?> destination = const Value.absent(),
                Value<String?> note = const Value.absent(),
              }) => LeavesCompanion.insert(
                id: id,
                personnelId: personnelId,
                type: type,
                status: status,
                daysGranted: daysGranted,
                includesTravel: includesTravel,
                travelDays: travelDays,
                startDate: startDate,
                endDate: endDate,
                actualReturnDate: actualReturnDate,
                orderNumber: orderNumber,
                destination: destination,
                note: note,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$LeavesTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({personnelId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (personnelId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.personnelId,
                                referencedTable: $$LeavesTableReferences
                                    ._personnelIdTable(db),
                                referencedColumn: $$LeavesTableReferences
                                    ._personnelIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$LeavesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LeavesTable,
      LeaveRow,
      $$LeavesTableFilterComposer,
      $$LeavesTableOrderingComposer,
      $$LeavesTableAnnotationComposer,
      $$LeavesTableCreateCompanionBuilder,
      $$LeavesTableUpdateCompanionBuilder,
      (LeaveRow, $$LeavesTableReferences),
      LeaveRow,
      PrefetchHooks Function({bool personnelId})
    >;
typedef $$TripsTableCreateCompanionBuilder =
    TripsCompanion Function({
      Value<int> id,
      required int personnelId,
      required String destination,
      Value<String> purpose,
      Value<TripStatus> status,
      Value<DateTime?> startDate,
      Value<DateTime?> endDate,
      Value<DateTime?> actualReturnDate,
      Value<String?> orderNumber,
      Value<String?> note,
      Value<double> serviceCoef,
    });
typedef $$TripsTableUpdateCompanionBuilder =
    TripsCompanion Function({
      Value<int> id,
      Value<int> personnelId,
      Value<String> destination,
      Value<String> purpose,
      Value<TripStatus> status,
      Value<DateTime?> startDate,
      Value<DateTime?> endDate,
      Value<DateTime?> actualReturnDate,
      Value<String?> orderNumber,
      Value<String?> note,
      Value<double> serviceCoef,
    });

final class $$TripsTableReferences
    extends BaseReferences<_$AppDatabase, $TripsTable, TripRow> {
  $$TripsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PersonnelTable _personnelIdTable(_$AppDatabase db) => db.personnel
      .createAlias($_aliasNameGenerator(db.trips.personnelId, db.personnel.id));

  $$PersonnelTableProcessedTableManager get personnelId {
    final $_column = $_itemColumn<int>('personnel_id')!;

    final manager = $$PersonnelTableTableManager(
      $_db,
      $_db.personnel,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_personnelIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TripsTableFilterComposer extends Composer<_$AppDatabase, $TripsTable> {
  $$TripsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get destination => $composableBuilder(
    column: $table.destination,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get purpose => $composableBuilder(
    column: $table.purpose,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<TripStatus, TripStatus, int> get status =>
      $composableBuilder(
        column: $table.status,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get actualReturnDate => $composableBuilder(
    column: $table.actualReturnDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get orderNumber => $composableBuilder(
    column: $table.orderNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get serviceCoef => $composableBuilder(
    column: $table.serviceCoef,
    builder: (column) => ColumnFilters(column),
  );

  $$PersonnelTableFilterComposer get personnelId {
    final $$PersonnelTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.personnelId,
      referencedTable: $db.personnel,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PersonnelTableFilterComposer(
            $db: $db,
            $table: $db.personnel,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TripsTableOrderingComposer
    extends Composer<_$AppDatabase, $TripsTable> {
  $$TripsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get destination => $composableBuilder(
    column: $table.destination,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get purpose => $composableBuilder(
    column: $table.purpose,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get actualReturnDate => $composableBuilder(
    column: $table.actualReturnDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get orderNumber => $composableBuilder(
    column: $table.orderNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get serviceCoef => $composableBuilder(
    column: $table.serviceCoef,
    builder: (column) => ColumnOrderings(column),
  );

  $$PersonnelTableOrderingComposer get personnelId {
    final $$PersonnelTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.personnelId,
      referencedTable: $db.personnel,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PersonnelTableOrderingComposer(
            $db: $db,
            $table: $db.personnel,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TripsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TripsTable> {
  $$TripsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get destination => $composableBuilder(
    column: $table.destination,
    builder: (column) => column,
  );

  GeneratedColumn<String> get purpose =>
      $composableBuilder(column: $table.purpose, builder: (column) => column);

  GeneratedColumnWithTypeConverter<TripStatus, int> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumn<DateTime> get actualReturnDate => $composableBuilder(
    column: $table.actualReturnDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get orderNumber => $composableBuilder(
    column: $table.orderNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<double> get serviceCoef => $composableBuilder(
    column: $table.serviceCoef,
    builder: (column) => column,
  );

  $$PersonnelTableAnnotationComposer get personnelId {
    final $$PersonnelTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.personnelId,
      referencedTable: $db.personnel,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PersonnelTableAnnotationComposer(
            $db: $db,
            $table: $db.personnel,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TripsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TripsTable,
          TripRow,
          $$TripsTableFilterComposer,
          $$TripsTableOrderingComposer,
          $$TripsTableAnnotationComposer,
          $$TripsTableCreateCompanionBuilder,
          $$TripsTableUpdateCompanionBuilder,
          (TripRow, $$TripsTableReferences),
          TripRow,
          PrefetchHooks Function({bool personnelId})
        > {
  $$TripsTableTableManager(_$AppDatabase db, $TripsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TripsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TripsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TripsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> personnelId = const Value.absent(),
                Value<String> destination = const Value.absent(),
                Value<String> purpose = const Value.absent(),
                Value<TripStatus> status = const Value.absent(),
                Value<DateTime?> startDate = const Value.absent(),
                Value<DateTime?> endDate = const Value.absent(),
                Value<DateTime?> actualReturnDate = const Value.absent(),
                Value<String?> orderNumber = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<double> serviceCoef = const Value.absent(),
              }) => TripsCompanion(
                id: id,
                personnelId: personnelId,
                destination: destination,
                purpose: purpose,
                status: status,
                startDate: startDate,
                endDate: endDate,
                actualReturnDate: actualReturnDate,
                orderNumber: orderNumber,
                note: note,
                serviceCoef: serviceCoef,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int personnelId,
                required String destination,
                Value<String> purpose = const Value.absent(),
                Value<TripStatus> status = const Value.absent(),
                Value<DateTime?> startDate = const Value.absent(),
                Value<DateTime?> endDate = const Value.absent(),
                Value<DateTime?> actualReturnDate = const Value.absent(),
                Value<String?> orderNumber = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<double> serviceCoef = const Value.absent(),
              }) => TripsCompanion.insert(
                id: id,
                personnelId: personnelId,
                destination: destination,
                purpose: purpose,
                status: status,
                startDate: startDate,
                endDate: endDate,
                actualReturnDate: actualReturnDate,
                orderNumber: orderNumber,
                note: note,
                serviceCoef: serviceCoef,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$TripsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({personnelId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (personnelId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.personnelId,
                                referencedTable: $$TripsTableReferences
                                    ._personnelIdTable(db),
                                referencedColumn: $$TripsTableReferences
                                    ._personnelIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$TripsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TripsTable,
      TripRow,
      $$TripsTableFilterComposer,
      $$TripsTableOrderingComposer,
      $$TripsTableAnnotationComposer,
      $$TripsTableCreateCompanionBuilder,
      $$TripsTableUpdateCompanionBuilder,
      (TripRow, $$TripsTableReferences),
      TripRow,
      PrefetchHooks Function({bool personnelId})
    >;
typedef $$WeaponsTableCreateCompanionBuilder =
    WeaponsCompanion Function({
      Value<int> id,
      required int personnelId,
      required String name,
      required WeaponType type,
      Value<String?> serialNumber,
      Value<String?> inventoryNumber,
      Value<DateTime?> assignedDate,
      Value<String?> note,
    });
typedef $$WeaponsTableUpdateCompanionBuilder =
    WeaponsCompanion Function({
      Value<int> id,
      Value<int> personnelId,
      Value<String> name,
      Value<WeaponType> type,
      Value<String?> serialNumber,
      Value<String?> inventoryNumber,
      Value<DateTime?> assignedDate,
      Value<String?> note,
    });

final class $$WeaponsTableReferences
    extends BaseReferences<_$AppDatabase, $WeaponsTable, WeaponRow> {
  $$WeaponsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $PersonnelTable _personnelIdTable(_$AppDatabase db) =>
      db.personnel.createAlias(
        $_aliasNameGenerator(db.weapons.personnelId, db.personnel.id),
      );

  $$PersonnelTableProcessedTableManager get personnelId {
    final $_column = $_itemColumn<int>('personnel_id')!;

    final manager = $$PersonnelTableTableManager(
      $_db,
      $_db.personnel,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_personnelIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$WeaponsTableFilterComposer
    extends Composer<_$AppDatabase, $WeaponsTable> {
  $$WeaponsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<WeaponType, WeaponType, int> get type =>
      $composableBuilder(
        column: $table.type,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get serialNumber => $composableBuilder(
    column: $table.serialNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get inventoryNumber => $composableBuilder(
    column: $table.inventoryNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get assignedDate => $composableBuilder(
    column: $table.assignedDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  $$PersonnelTableFilterComposer get personnelId {
    final $$PersonnelTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.personnelId,
      referencedTable: $db.personnel,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PersonnelTableFilterComposer(
            $db: $db,
            $table: $db.personnel,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WeaponsTableOrderingComposer
    extends Composer<_$AppDatabase, $WeaponsTable> {
  $$WeaponsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get serialNumber => $composableBuilder(
    column: $table.serialNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get inventoryNumber => $composableBuilder(
    column: $table.inventoryNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get assignedDate => $composableBuilder(
    column: $table.assignedDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  $$PersonnelTableOrderingComposer get personnelId {
    final $$PersonnelTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.personnelId,
      referencedTable: $db.personnel,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PersonnelTableOrderingComposer(
            $db: $db,
            $table: $db.personnel,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WeaponsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WeaponsTable> {
  $$WeaponsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumnWithTypeConverter<WeaponType, int> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get serialNumber => $composableBuilder(
    column: $table.serialNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get inventoryNumber => $composableBuilder(
    column: $table.inventoryNumber,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get assignedDate => $composableBuilder(
    column: $table.assignedDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  $$PersonnelTableAnnotationComposer get personnelId {
    final $$PersonnelTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.personnelId,
      referencedTable: $db.personnel,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PersonnelTableAnnotationComposer(
            $db: $db,
            $table: $db.personnel,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$WeaponsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WeaponsTable,
          WeaponRow,
          $$WeaponsTableFilterComposer,
          $$WeaponsTableOrderingComposer,
          $$WeaponsTableAnnotationComposer,
          $$WeaponsTableCreateCompanionBuilder,
          $$WeaponsTableUpdateCompanionBuilder,
          (WeaponRow, $$WeaponsTableReferences),
          WeaponRow,
          PrefetchHooks Function({bool personnelId})
        > {
  $$WeaponsTableTableManager(_$AppDatabase db, $WeaponsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WeaponsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WeaponsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WeaponsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> personnelId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<WeaponType> type = const Value.absent(),
                Value<String?> serialNumber = const Value.absent(),
                Value<String?> inventoryNumber = const Value.absent(),
                Value<DateTime?> assignedDate = const Value.absent(),
                Value<String?> note = const Value.absent(),
              }) => WeaponsCompanion(
                id: id,
                personnelId: personnelId,
                name: name,
                type: type,
                serialNumber: serialNumber,
                inventoryNumber: inventoryNumber,
                assignedDate: assignedDate,
                note: note,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int personnelId,
                required String name,
                required WeaponType type,
                Value<String?> serialNumber = const Value.absent(),
                Value<String?> inventoryNumber = const Value.absent(),
                Value<DateTime?> assignedDate = const Value.absent(),
                Value<String?> note = const Value.absent(),
              }) => WeaponsCompanion.insert(
                id: id,
                personnelId: personnelId,
                name: name,
                type: type,
                serialNumber: serialNumber,
                inventoryNumber: inventoryNumber,
                assignedDate: assignedDate,
                note: note,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$WeaponsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({personnelId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (personnelId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.personnelId,
                                referencedTable: $$WeaponsTableReferences
                                    ._personnelIdTable(db),
                                referencedColumn: $$WeaponsTableReferences
                                    ._personnelIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$WeaponsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WeaponsTable,
      WeaponRow,
      $$WeaponsTableFilterComposer,
      $$WeaponsTableOrderingComposer,
      $$WeaponsTableAnnotationComposer,
      $$WeaponsTableCreateCompanionBuilder,
      $$WeaponsTableUpdateCompanionBuilder,
      (WeaponRow, $$WeaponsTableReferences),
      WeaponRow,
      PrefetchHooks Function({bool personnelId})
    >;
typedef $$ServicePeriodsTableCreateCompanionBuilder =
    ServicePeriodsCompanion Function({
      Value<int> id,
      required int personnelId,
      required DateTime startDate,
      Value<DateTime?> endDate,
      Value<double> coefficient,
      Value<String> note,
    });
typedef $$ServicePeriodsTableUpdateCompanionBuilder =
    ServicePeriodsCompanion Function({
      Value<int> id,
      Value<int> personnelId,
      Value<DateTime> startDate,
      Value<DateTime?> endDate,
      Value<double> coefficient,
      Value<String> note,
    });

final class $$ServicePeriodsTableReferences
    extends
        BaseReferences<_$AppDatabase, $ServicePeriodsTable, ServicePeriodRow> {
  $$ServicePeriodsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $PersonnelTable _personnelIdTable(_$AppDatabase db) =>
      db.personnel.createAlias(
        $_aliasNameGenerator(db.servicePeriods.personnelId, db.personnel.id),
      );

  $$PersonnelTableProcessedTableManager get personnelId {
    final $_column = $_itemColumn<int>('personnel_id')!;

    final manager = $$PersonnelTableTableManager(
      $_db,
      $_db.personnel,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_personnelIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ServicePeriodsTableFilterComposer
    extends Composer<_$AppDatabase, $ServicePeriodsTable> {
  $$ServicePeriodsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get coefficient => $composableBuilder(
    column: $table.coefficient,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  $$PersonnelTableFilterComposer get personnelId {
    final $$PersonnelTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.personnelId,
      referencedTable: $db.personnel,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PersonnelTableFilterComposer(
            $db: $db,
            $table: $db.personnel,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ServicePeriodsTableOrderingComposer
    extends Composer<_$AppDatabase, $ServicePeriodsTable> {
  $$ServicePeriodsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get coefficient => $composableBuilder(
    column: $table.coefficient,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  $$PersonnelTableOrderingComposer get personnelId {
    final $$PersonnelTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.personnelId,
      referencedTable: $db.personnel,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PersonnelTableOrderingComposer(
            $db: $db,
            $table: $db.personnel,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ServicePeriodsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ServicePeriodsTable> {
  $$ServicePeriodsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumn<double> get coefficient => $composableBuilder(
    column: $table.coefficient,
    builder: (column) => column,
  );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  $$PersonnelTableAnnotationComposer get personnelId {
    final $$PersonnelTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.personnelId,
      referencedTable: $db.personnel,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PersonnelTableAnnotationComposer(
            $db: $db,
            $table: $db.personnel,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ServicePeriodsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ServicePeriodsTable,
          ServicePeriodRow,
          $$ServicePeriodsTableFilterComposer,
          $$ServicePeriodsTableOrderingComposer,
          $$ServicePeriodsTableAnnotationComposer,
          $$ServicePeriodsTableCreateCompanionBuilder,
          $$ServicePeriodsTableUpdateCompanionBuilder,
          (ServicePeriodRow, $$ServicePeriodsTableReferences),
          ServicePeriodRow,
          PrefetchHooks Function({bool personnelId})
        > {
  $$ServicePeriodsTableTableManager(
    _$AppDatabase db,
    $ServicePeriodsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ServicePeriodsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ServicePeriodsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ServicePeriodsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> personnelId = const Value.absent(),
                Value<DateTime> startDate = const Value.absent(),
                Value<DateTime?> endDate = const Value.absent(),
                Value<double> coefficient = const Value.absent(),
                Value<String> note = const Value.absent(),
              }) => ServicePeriodsCompanion(
                id: id,
                personnelId: personnelId,
                startDate: startDate,
                endDate: endDate,
                coefficient: coefficient,
                note: note,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int personnelId,
                required DateTime startDate,
                Value<DateTime?> endDate = const Value.absent(),
                Value<double> coefficient = const Value.absent(),
                Value<String> note = const Value.absent(),
              }) => ServicePeriodsCompanion.insert(
                id: id,
                personnelId: personnelId,
                startDate: startDate,
                endDate: endDate,
                coefficient: coefficient,
                note: note,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ServicePeriodsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({personnelId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (personnelId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.personnelId,
                                referencedTable: $$ServicePeriodsTableReferences
                                    ._personnelIdTable(db),
                                referencedColumn:
                                    $$ServicePeriodsTableReferences
                                        ._personnelIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ServicePeriodsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ServicePeriodsTable,
      ServicePeriodRow,
      $$ServicePeriodsTableFilterComposer,
      $$ServicePeriodsTableOrderingComposer,
      $$ServicePeriodsTableAnnotationComposer,
      $$ServicePeriodsTableCreateCompanionBuilder,
      $$ServicePeriodsTableUpdateCompanionBuilder,
      (ServicePeriodRow, $$ServicePeriodsTableReferences),
      ServicePeriodRow,
      PrefetchHooks Function({bool personnelId})
    >;
typedef $$PayRatesTableCreateCompanionBuilder =
    PayRatesCompanion Function({
      Value<int> id,
      required PayRateKind kind,
      required String code,
      Value<int> amount,
    });
typedef $$PayRatesTableUpdateCompanionBuilder =
    PayRatesCompanion Function({
      Value<int> id,
      Value<PayRateKind> kind,
      Value<String> code,
      Value<int> amount,
    });

class $$PayRatesTableFilterComposer
    extends Composer<_$AppDatabase, $PayRatesTable> {
  $$PayRatesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<PayRateKind, PayRateKind, int> get kind =>
      $composableBuilder(
        column: $table.kind,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PayRatesTableOrderingComposer
    extends Composer<_$AppDatabase, $PayRatesTable> {
  $$PayRatesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get code => $composableBuilder(
    column: $table.code,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PayRatesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PayRatesTable> {
  $$PayRatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<PayRateKind, int> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get code =>
      $composableBuilder(column: $table.code, builder: (column) => column);

  GeneratedColumn<int> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);
}

class $$PayRatesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PayRatesTable,
          PayRateRow,
          $$PayRatesTableFilterComposer,
          $$PayRatesTableOrderingComposer,
          $$PayRatesTableAnnotationComposer,
          $$PayRatesTableCreateCompanionBuilder,
          $$PayRatesTableUpdateCompanionBuilder,
          (
            PayRateRow,
            BaseReferences<_$AppDatabase, $PayRatesTable, PayRateRow>,
          ),
          PayRateRow,
          PrefetchHooks Function()
        > {
  $$PayRatesTableTableManager(_$AppDatabase db, $PayRatesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PayRatesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PayRatesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PayRatesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<PayRateKind> kind = const Value.absent(),
                Value<String> code = const Value.absent(),
                Value<int> amount = const Value.absent(),
              }) => PayRatesCompanion(
                id: id,
                kind: kind,
                code: code,
                amount: amount,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required PayRateKind kind,
                required String code,
                Value<int> amount = const Value.absent(),
              }) => PayRatesCompanion.insert(
                id: id,
                kind: kind,
                code: code,
                amount: amount,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PayRatesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PayRatesTable,
      PayRateRow,
      $$PayRatesTableFilterComposer,
      $$PayRatesTableOrderingComposer,
      $$PayRatesTableAnnotationComposer,
      $$PayRatesTableCreateCompanionBuilder,
      $$PayRatesTableUpdateCompanionBuilder,
      (PayRateRow, BaseReferences<_$AppDatabase, $PayRatesTable, PayRateRow>),
      PayRateRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$SettingsTableTableManager get settings =>
      $$SettingsTableTableManager(_db, _db.settings);
  $$PositionsTableTableManager get positions =>
      $$PositionsTableTableManager(_db, _db.positions);
  $$PersonnelTableTableManager get personnel =>
      $$PersonnelTableTableManager(_db, _db.personnel);
  $$AwardsTableTableManager get awards =>
      $$AwardsTableTableManager(_db, _db.awards);
  $$LeavesTableTableManager get leaves =>
      $$LeavesTableTableManager(_db, _db.leaves);
  $$TripsTableTableManager get trips =>
      $$TripsTableTableManager(_db, _db.trips);
  $$WeaponsTableTableManager get weapons =>
      $$WeaponsTableTableManager(_db, _db.weapons);
  $$ServicePeriodsTableTableManager get servicePeriods =>
      $$ServicePeriodsTableTableManager(_db, _db.servicePeriods);
  $$PayRatesTableTableManager get payRates =>
      $$PayRatesTableTableManager(_db, _db.payRates);
}
