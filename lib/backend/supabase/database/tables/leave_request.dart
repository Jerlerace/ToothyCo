import '../database.dart';

class LeaveRequestTable extends SupabaseTable<LeaveRequestRow> {
  @override
  String get tableName => 'Leave_Request';

  @override
  LeaveRequestRow createRow(Map<String, dynamic> data) =>
      LeaveRequestRow(data);
}

class LeaveRequestRow extends SupabaseDataRow {
  LeaveRequestRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => LeaveRequestTable();

  String? get requestId => getField<String>('request_id');
  set requestId(String? value) => setField<String>('request_id', value);

  String get dentistId => getField<String>('dentist_id') ?? '';
  set dentistId(String value) => setField<String>('dentist_id', value);

  DateTime get startDate => getField<DateTime>('start_date') ?? DateTime.now();
  set startDate(DateTime value) => setField<DateTime>('start_date', value);

  DateTime get endDate => getField<DateTime>('end_date') ?? DateTime.now();
  set endDate(DateTime value) => setField<DateTime>('end_date', value);

  String? get reason => getField<String>('reason');
  set reason(String? value) => setField<String>('reason', value);

  String get status => getField<String>('status') ?? 'Pending';
  set status(String value) => setField<String>('status', value);

  String? get reviewedBy => getField<String>('reviewed_by');
  set reviewedBy(String? value) => setField<String>('reviewed_by', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);
}
