import os

for root, dirs, files in os.walk('lib'):
    for file in files:
        if file.endswith('.dart'):
            for keyword in ['user_management', 'dentist_management', 'patient_management', 'procedures', 'dentist_requests']:
                if keyword in file:
                    print(f"Path: {os.path.join(root, file)}")
