with open('lib/homepage_unified/homepage_unified_widget.dart', 'r', encoding='utf-8') as f:
    content = f.read()

lines = content.split('\n')
for idx, line in enumerate(lines):
    if 'Monthly Revenue' in line or 'Fulfillment Rate' in line or 'Revenue Overview' in line:
        print(f"Line {idx+1}: {line.strip()}")
