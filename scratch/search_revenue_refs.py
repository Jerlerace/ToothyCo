import os

def search_ref(filepath):
    if os.path.exists(filepath):
        print(f"--- References in {filepath} ---")
        with open(filepath, 'r', encoding='utf-8') as f:
            lines = f.readlines()
        for idx, line in enumerate(lines):
            if 'localRevenueList' in line or 'ChoiceChips' in line:
                print(f"{idx+1}: {line.strip()}")

search_ref('lib/admin/a_d_m_i_n_lastpages/p_revenue_view/p_revenue_view_widget.dart')
search_ref('lib/admin/a_d_m_i_n_lastpages/p_revenue_view/p_revenue_view_model.dart')
