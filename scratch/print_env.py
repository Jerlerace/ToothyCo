import os

for k, v in os.environ.items():
    if any(term in k.lower() or term in v.lower() for term in ['flutter', 'dart', 'sdk', 'pub']):
        print(f"{k}: {v}")
