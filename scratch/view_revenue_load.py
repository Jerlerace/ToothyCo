with open('lib/admin/a_d_m_i_n_lastpages/p_revenue_view/p_revenue_view_widget.dart', 'r', encoding='utf-8') as f:
    content = f.read()

lines = content.split('\n')

def print_lines(title, start, end):
    print(f"--- {title} ---")
    for idx in range(start - 1, min(len(lines), end)):
        print(f"{idx+1}: {lines[idx]}")

print_lines("Initial Load (around line 43)", 30, 70)
print_lines("ChoiceChips (around line 152)", 140, 200)
