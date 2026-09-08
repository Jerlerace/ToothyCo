with open('lib/admin/a_d_m_i_n_lastpages/p_revenue_view/p_revenue_view_widget.dart', 'r', encoding='utf-8') as f:
    content = f.read()

lines = content.split('\n')
for idx, line in enumerate(lines):
    if 'percent:' in line:
        print(f"Line {idx+1}: {line.strip()}")
