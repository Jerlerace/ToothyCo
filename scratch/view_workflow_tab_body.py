with open('lib/homepage_unified/homepage_unified_widget.dart', 'r', encoding='utf-8') as f:
    content = f.read()

lines = content.split('\n')

# Let's search for selectIndex == 1
# And let's find the corresponding userType check
in_sel_1 = False
indent = 0
for idx, line in enumerate(lines):
    if '_model.selectedIndex == 1' in line:
        print(f"Line {idx+1}: {line.strip()}")
        # Let's print the next 100 lines to see the structure
        for j in range(idx, idx+120):
            print(f"{j+1}: {lines[j]}")
        break
