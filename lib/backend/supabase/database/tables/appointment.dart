import '../database.dart';

class AppointmentTable extends SupabaseTable<AppointmentRow> {
  @override
  String get tableName => 'Appointment';

  @override
  AppointmentRow createRow(Map<String, dynamic> data) => AppointmentRow(data);
}

class AppointmentRow extends SupabaseDataRow {
  AppointmentRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => AppointmentTable();

  String? get appointmentId => getField<String>('appointment_id');
  set appointmentId(String? value) => setField<String>('appointment_id', value);

  DateTime get createdAt => getField<DateTime>('created_at') ?? DateTime.now();
  set createdAt(DateTime value) => setField<DateTime>('created_at', value);

  DateTime? get updatedAt => getField<DateTime>('updated_at');
  set updatedAt(DateTime? value) => setField<DateTime>('updated_at', value);

  String? get updatedBy => getField<String>('updated_by');
  set updatedBy(String? value) => setField<String>('updated_by', value);

  String? get status => getField<String>('status');
  set status(String? value) => setField<String>('status', value);

  String? get patientId => getField<String>('patient_id');
  set patientId(String? value) => setField<String>('patient_id', value);

  String? get doctorId => getField<String>('doctor_id');
  set doctorId(String? value) => setField<String>('doctor_id', value);

  String? get procedureId => getField<String>('procedure_id');
  set procedureId(String? value) => setField<String>('procedure_id', value);

  DateTime get appointmentDate => getField<DateTime>('appointment_date') ?? DateTime.now();
  set appointmentDate(DateTime value) =>
      setField<DateTime>('appointment_date', value);

  PostgresTime get appointmentTime =>
      getField<PostgresTime>('appointment_time') ?? PostgresTime(DateTime.now());
  set appointmentTime(PostgresTime value) =>
      setField<PostgresTime>('appointment_time', value);

  String? get notes => getField<String>('notes');
  set notes(String? value) => setField<String>('notes', value);
}
