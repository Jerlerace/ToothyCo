with open('lib/admin/a_d_m_i_n_lastpages/p_revenue_view/p_revenue_view_widget.dart', 'r', encoding='utf-8') as f:
    content = f.read()

lines = content.split('\n')
print("--- BEFORE LINE 1000 ---")
for idx in range(980, 1015):
    print(f"{idx+1}: {lines[idx]}")

print("--- AFTER LINE 1610 ---")
for idx in range(1600, 1636):
    print(f"{idx+1}: {lines[idx]}")
