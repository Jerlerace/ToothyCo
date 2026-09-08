import '../database.dart';

class DentistAvailabilityTable extends SupabaseTable<DentistAvailabilityRow> {
  @override
  String get tableName => 'Dentist_Availability';

  @override
  DentistAvailabilityRow createRow(Map<String, dynamic> data) =>
      DentistAvailabilityRow(data);
}

class DentistAvailabilityRow extends SupabaseDataRow {
  DentistAvailabilityRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => DentistAvailabilityTable();

  String? get daId => getField<String>('da_id');
  set daId(String? value) => setField<String>('da_id', value);

  String get dentistId => getField<String>('dentist_id') ?? '';
  set dentistId(String value) => setField<String>('dentist_id', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);

  String get day => getField<String>('day') ?? 'Monday';
  set day(String value) => setField<String>('day', value);

  PostgresTime get startTime => getField<PostgresTime>('start_time') ?? PostgresTime(DateTime.now());
  set startTime(PostgresTime value) =>
      setField<PostgresTime>('start_time', value);

  PostgresTime get endTime => getField<PostgresTime>('end_time') ?? PostgresTime(DateTime.now());
  set endTime(PostgresTime value) => setField<PostgresTime>('end_time', value);

  bool? get isAvail => getField<bool>('is_avail');
  set isAvail(bool? value) => setField<bool>('is_avail', value);
}
