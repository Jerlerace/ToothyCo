with open('lib/admin/a_d_m_i_n_lastpages/p_revenue_view/p_revenue_view_widget.dart', 'r', encoding='utf-8') as f:
    content = f.read()

lines = content.split('\n')
for idx, line in enumerate(lines):
    if any(term in line for term in ['+12.5%', '12.5%', '128,450', '114,200', '128.4K']):
        print(f"Line {idx+1}: {line.strip()}")
