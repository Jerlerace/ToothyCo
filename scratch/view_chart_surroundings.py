with open('lib/homepage_unified/homepage_unified_widget.dart', 'r', encoding='utf-8') as f:
    content = f.read()

lines = content.split('\n')
print("--- BEFORE CHART ROW ---")
for idx in range(1345, 1356):
    print(f"{idx+1}: {lines[idx]}")

print("--- AFTER CHART ROW ---")
for idx in range(1835, 1846):
    print(f"{idx+1}: {lines[idx]}")
