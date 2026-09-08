log_path = r"C:/Users/RemoLaptop15/.gemini/antigravity/brain/84a34dc3-ffb5-45e8-b483-83f948decfd1/.system_generated/tasks/task-1792.log"

with open(log_path, 'r', encoding='utf-8') as f:
    lines = f.readlines()

our_files = ['homepage_unified_widget.dart', 'p_revenue_view_widget.dart']

print("--- Errors and Warnings in Our Modified Files ---")
found_any = False
for line in lines:
    if any(f in line for f in our_files):
        if 'error -' in line or 'warning -' in line:
            print(line.strip())
            found_any = True

if not found_any:
    print("No errors or warnings found in our modified files!")
