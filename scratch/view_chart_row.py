with open('lib/homepage_unified/homepage_unified_widget.dart', 'r', encoding='utf-8') as f:
    content = f.read()

lines = content.split('\n')
months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']
for idx, line in enumerate(lines):
    if any(f"'{m}'" in line or f'"{m}"' in line for m in months):
        if idx > 1200 and idx < 1900:
            print(f"Line {idx+1}: {line.strip()}")
