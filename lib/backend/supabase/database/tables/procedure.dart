import '../database.dart';

class ProcedureTable extends SupabaseTable<ProcedureRow> {
  @override
  String get tableName => 'Procedure';

  @override
  ProcedureRow createRow(Map<String, dynamic> data) => ProcedureRow(data);
}

class ProcedureRow extends SupabaseDataRow {
  ProcedureRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => ProcedureTable();

  String? get procedureId => getField<String>('procedure_id');
  set procedureId(String? value) => setField<String>('procedure_id', value);

  String get procedureName => getField<String>('procedure_name') ?? '';
  set procedureName(String value) => setField<String>('procedure_name', value);

  String? get procedureDescription => getField<String>('procedure_description');
  set procedureDescription(String? value) =>
      setField<String>('procedure_description', value);

  DateTime get createdAt => getField<DateTime>('created_at') ?? DateTime.now();
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);

  String get updatedBy => getField<String>('updated_by') ?? '';
  set updatedBy(String value) => setField<String>('updated_by', value);

  String? get category => getField<String>('category');
  set category(String? value) => setField<String>('category', value);

  String? get timeDuration => getField<String>('timeDuration');
  set timeDuration(String? value) => setField<String>('timeDuration', value);

  int? get pricing => getField<int>('pricing');
  set pricing(int? value) => setField<int>('pricing', value);

  String? get status => getField<String>('status');
  set status(String? value) => setField<String>('status', value);
}
