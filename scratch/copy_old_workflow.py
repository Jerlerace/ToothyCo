import os

with open('lib/homepage_unified/homepage_unified_widget.dart', 'r', encoding='utf-8') as f:
    content = f.read()

lines = content.split('\n')
admin_workflow_section = '\n'.join(lines[289:2132])

os.makedirs('scratch', exist_ok=True)
with open('scratch/old_admin_workflow.dart', 'w', encoding='utf-8') as f:
    f.write(admin_workflow_section)

print("Saved old admin workflow section to scratch/old_admin_workflow.dart")
