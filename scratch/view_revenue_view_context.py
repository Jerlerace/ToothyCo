with open('lib/admin/a_d_m_i_n_lastpages/p_revenue_view/p_revenue_view_widget.dart', 'r', encoding='utf-8') as f:
    content = f.read()

lines = content.split('\n')

def print_lines(title, start, end):
    print(f"--- {title} ---")
    for idx in range(start - 1, min(len(lines), end)):
        print(f"{idx+1}: {lines[idx]}")

print_lines("Around 1753 (Percent)", 1735, 1775)
print_lines("Around 1653 (Period Comparison)", 1635, 1675)
print_lines("Around 1070 (Jan Column)", 1050, 1090)
