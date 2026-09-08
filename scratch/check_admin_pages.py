import os

files_to_check = [
    'lib/admin/user_management/dentist_management/p_admin_dentist_requests/p_admin_dentist_requests_widget.dart',
    'lib/admin/user_management/p_user_management/p_user_management_widget.dart',
    'lib/admin/user_management/patient_management/p_patient_management/p_patient_management_widget.dart',
    'lib/admin/user_management/dentist_management/p_dentist_management/p_dentist_management_widget.dart',
    'lib/admin/procedures/p_procedures_view_admin/p_procedures_view_admin_widget.dart'
]

for filepath in files_to_check:
    if os.path.exists(filepath):
        print(f"Exists: {filepath}")
        with open(filepath, 'r', encoding='utf-8') as f:
            content = f.read()
        for line in content.split('\n'):
            if 'class P' in line or 'routeName = ' in line:
                print(f"  {line.strip()}")
    else:
        print(f"NOT FOUND: {filepath}")
