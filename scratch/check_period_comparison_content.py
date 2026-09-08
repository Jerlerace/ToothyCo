with open('lib/admin/a_d_m_i_n_lastpages/p_revenue_view/p_revenue_view_widget.dart', 'r', encoding='utf-8') as f:
    content = f.read()

lines = content.split('\n')

def print_block(title, start, end):
    print(f"--- {title} ---")
    for idx in range(start - 1, min(len(lines), end)):
        print(f"{idx+1}: {lines[idx]}")

print_block("Current Period Column (1715-1768)", 1715, 1768)
print_block("Previous Period Column (1820-1868)", 1820, 1868)
print_block("Target Column (1920-1968)", 1920, 1968)
print_block("Growth Rate Column (2025-2066)", 2025, 2066)
