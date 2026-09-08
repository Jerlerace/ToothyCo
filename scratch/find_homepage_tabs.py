with open('lib/homepage_unified/homepage_unified_widget.dart', 'r', encoding='utf-8') as f:
    content = f.read()

lines = content.split('\n')

def get_context(line_num):
    print(f"--- Context for Line {line_num} ---")
    start = max(0, line_num - 30)
    end = min(len(lines), line_num + 30)
    for idx in range(start, end):
        print(f"{idx+1}: {lines[idx]}")

get_context(704)
get_context(1156)
