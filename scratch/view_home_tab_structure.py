with open('lib/homepage_unified/homepage_unified_widget.dart', 'r', encoding='utf-8') as f:
    content = f.read()

lines = content.split('\n')
for idx in range(198, 400):
    print(f"{idx+1}: {lines[idx]}")
