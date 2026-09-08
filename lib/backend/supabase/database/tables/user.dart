import '../database.dart';

class UserTable extends SupabaseTable<UserRow> {
  @override
  String get tableName => 'User';

  @override
  UserRow createRow(Map<String, dynamic> data) => UserRow(data);
}

class UserRow extends SupabaseDataRow {
  UserRow(Map<String, dynamic> data) : super(data);

  @override
  SupabaseTable get table => UserTable();

  String? get userId => getField<String>('user_id');
  set userId(String? value) => setField<String>('user_id', value);

  String? get fullname => getField<String>('fullname');
  set fullname(String? value) => setField<String>('fullname', value);

  String get email => getField<String>('email') ?? '';
  set email(String value) => setField<String>('email', value);

  String? get userType => getField<String>('user_type');
  set userType(String? value) => setField<String>('user_type', value);

  DateTime? get createdAt => getField<DateTime>('created_at');
  set createdAt(DateTime? value) => setField<DateTime>('created_at', value);

  DateTime? get dateOfBirth => getField<DateTime>('date_of_birth');
  set dateOfBirth(DateTime? value) =>
      setField<DateTime>('date_of_birth', value);

  int? get phone => getField<int>('phone');
  set phone(int? value) => setField<int>('phone', value);

  String? get userImgUrl => getField<String>('user_imgUrl');
  set userImgUrl(String? value) => setField<String>('user_imgUrl', value);

  String? get status => getField<String>('status');
  set status(String? value) => setField<String>('status', value);

  String? get address => getField<String>('address');
  set address(String? value) => setField<String>('address', value);
}

