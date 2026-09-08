import '../database.dart';

class HistoryTable extends SupabaseTable<HistoryRow> {
  @override
  String get tableName => 'History';

  @override
  HistoryRow createRow(Map<String, dynamic> data) => HistoryRow(data);
}

class HistoryRow extends SupabaseDataRow {
  HistoryRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => HistoryTable();

  String? get historyId => getField<String>('history_id');
  set historyId(String? value) => setField<String>('history_id', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  String? get patientId => getField<String>('patient_id');
  set patientId(String? value) => setField<String>('patient_id', value);

  String? get dentistId => getField<String>('dentist_id');
  set dentistId(String? value) => setField<String>('dentist_id', value);

  String? get appointmentId => getField<String>('appointment_id');
  set appointmentId(String? value) => setField<String>('appointment_id', value);

  String? get remarks => getField<String>('remarks');
  set remarks(String? value) => setField<String>('remarks', value);

  String? get procedureId => getField<String>('procedure_id');
  set procedureId(String? value) => setField<String>('procedure_id', value);
}
