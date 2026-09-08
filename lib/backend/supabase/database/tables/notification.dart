import '../database.dart';

class NotificationTable extends SupabaseTable<NotificationRow> {
  @override
  String get tableName => 'Notification';

  @override
  NotificationRow createRow(Map<String, dynamic> data) =>
      NotificationRow(data);
}

class NotificationRow extends SupabaseDataRow {
  NotificationRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => NotificationTable();

  String? get notificationId => getField<String>('notification_id');
  set notificationId(String? value) =>
      setField<String>('notification_id', value);

  String get userId => getField<String>('user_id') ?? '';
  set userId(String value) => setField<String>('user_id', value);

  String get title => getField<String>('title') ?? '';
  set title(String value) => setField<String>('title', value);

  String get body => getField<String>('body') ?? '';
  set body(String value) => setField<String>('body', value);

  String get type => getField<String>('type') ?? '';
  set type(String value) => setField<String>('type', value);

  String? get referenceId => getField<String>('reference_id');
  set referenceId(String? value) => setField<String>('reference_id', value);

  bool? get isRead => getField<bool>('is_read');
  set isRead(bool? value) => setField<bool>('is_read', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);
}
