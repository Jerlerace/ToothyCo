import '../database.dart';

class PaymentsTable extends SupabaseTable<PaymentsRow> {
  @override
  String get tableName => 'Payments';

  @override
  PaymentsRow createRow(Map<String, dynamic> data) => PaymentsRow(data);
}

class PaymentsRow extends SupabaseDataRow {
  PaymentsRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => PaymentsTable();

  String? get id => getField<String>('id');
  set id(String? value) => setField<String>('id', value);

  int? get amount => getField<int>('amount');
  set amount(int? value) => setField<int>('amount', value);

  String? get status => getField<String>('status');
  set status(String? value) => setField<String>('status', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  String? get paidFor => getField<String>('paid_for');
  set paidFor(String? value) => setField<String>('paid_for', value);

  String? get paidBy => getField<String>('paid_by');
  set paidBy(String? value) => setField<String>('paid_by', value);

  String? get appointmentId => getField<String>('appointment_id');
  set appointmentId(String? value) =>
      setField<String>('appointment_id', value);

  String? get procedureId => getField<String>('procedure_id');
  set procedureId(String? value) => setField<String>('procedure_id', value);
}
