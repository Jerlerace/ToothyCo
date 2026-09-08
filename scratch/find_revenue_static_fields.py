import re

with open('lib/admin/a_d_m_i_n_lastpages/p_revenue_view/p_revenue_view_widget.dart', 'r', encoding='utf-8') as f:
    content = f.read()

lines = content.split('\n')
for idx, line in enumerate(lines):
    # Match text patterns like $124K, 85.6%, +12.5%, $128,450, etc.
    if re.search(r"('\$[0-9KM,\.]+')|('[0-9\.\+-]+%')|('[A-Za-z\s]*growth[A-Za-z\s]*')|('vs\.\s+previous')", line, re.IGNORECASE):
        print(f"Line {idx+1}: {line.strip()}")
