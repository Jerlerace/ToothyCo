import '../database.dart';

class DentistTable extends SupabaseTable<DentistRow> {
  @override
  String get tableName => 'Dentist';

  @override
  DentistRow createRow(Map<String, dynamic> data) => DentistRow(data);
}

class DentistRow extends SupabaseDataRow {
  DentistRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => DentistTable();

  String get dentistId => getField<String>('dentist_id') ?? '';
  set dentistId(String value) => setField<String>('dentist_id', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);

  String? get specialization => getField<String>('specialization');
  set specialization(String? value) =>
      setField<String>('specialization', value);

  String? get clinicName => getField<String>('clinic_name');
  set clinicName(String? value) => setField<String>('clinic_name', value);

  String? get clinicLocation => getField<String>('clinic_location');
  set clinicLocation(String? value) =>
      setField<String>('clinic_location', value);

  String? get experience => getField<String>('experience');
  set experience(String? value) => setField<String>('experience', value);

  String? get status => getField<String>('status');
  set status(String? value) => setField<String>('status', value);

  String? get type => getField<String>('type');
  set type(String? value) => setField<String>('type', value);

  String? get dentalSchool => getField<String>('dental_school');
  set dentalSchool(String? value) => setField<String>('dental_school', value);

  String? get graduationYear => getField<String>('graduation_year');
  set graduationYear(String? value) =>
      setField<String>('graduation_year', value);
}
