with open('lib/homepage_unified/homepage_unified_widget.dart', 'r', encoding='utf-8') as f:
    content = f.read()

lines = content.split('\n')
print("--- START ---")
for idx in range(1340, 1375):
    print(f"{idx+1}: {lines[idx]}")

print("--- END ---")
for idx in range(1815, 1850):
    print(f"{idx+1}: {lines[idx]}")
