import '../database.dart';

class PatientTable extends SupabaseTable<PatientRow> {
  @override
  String get tableName => 'Patient';

  @override
  PatientRow createRow(Map<String, dynamic> data) => PatientRow(data);
}

class PatientRow extends SupabaseDataRow {
  PatientRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => PatientTable();

  String get patientId => getField<String>('patient_id') ?? '';
  set patientId(String value) => setField<String>('patient_id', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);

  String? get allergies => getField<String>('allergies');
  set allergies(String? value) => setField<String>('allergies', value);

  String? get medicalConditions => getField<String>('medical_conditions');
  set medicalConditions(String? value) =>
      setField<String>('medical_conditions', value);

  String? get bloodType => getField<String>('blood_type');
  set bloodType(String? value) => setField<String>('blood_type', value);

  String? get emergencyContactName =>
      getField<String>('emergency_contact_name');
  set emergencyContactName(String? value) =>
      setField<String>('emergency_contact_name', value);

  String? get emergencyContactPhone =>
      getField<String>('emergency_contact_phone');
  set emergencyContactPhone(String? value) =>
      setField<String>('emergency_contact_phone', value);
}
