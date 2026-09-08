with open('lib/admin/a_d_m_i_n_lastpages/p_revenue_view/p_revenue_view_widget.dart', 'r', encoding='utf-8') as f:
    content = f.read()

lines = content.split('\n')
for idx, line in enumerate(lines):
    for keyword in ['localRevenueList', 'Period Comparison', '0.856', 'Jan', 'vs. previous period']:
        if keyword in line:
            if idx > 800 and idx < 2200:
                print(f"Line {idx+1} ({keyword}): {line.strip()}")
