with open('lib/homepage_unified/homepage_unified_widget.dart', 'r', encoding='utf-8') as f:
    content = f.read()

lines = content.split('\n')
print("--- Text fields in Admin Workflow Section (289-2132) ---")
for idx in range(288, 2132):
    line = lines[idx]
    if 'Text(' in line:
        # print the next line or the line itself
        print(f"Line {idx+1}: {line.strip()} | {lines[idx+1].strip()}")
