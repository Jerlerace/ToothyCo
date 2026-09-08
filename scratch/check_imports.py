with open('lib/homepage_unified/homepage_unified_widget.dart', 'r', encoding='utf-8') as f:
    content = f.read()

lines = content.split('\n')
for idx, line in enumerate(lines):
    if 'import' in line and any(w in line for w in ['_widget.dart', 'admin', 'user_management', 'dentist_management', 'patient_management', 'procedures_view']):
        print(f"Line {idx+1}: {line}")
