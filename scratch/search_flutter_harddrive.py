import os

search_roots = [
    r"C:\src",
    r"C:\flutter",
    r"C:\Users\RemoLaptop15",
    r"D:\src",
    r"D:\flutter"
]

found = False
for root_dir in search_roots:
    if os.path.exists(root_dir):
        print(f"Searching root: {root_dir}")
        for root, dirs, files in os.walk(root_dir):
            if 'flutter.bat' in files:
                print(f"FOUND FLUTTER BAT: {os.path.join(root, 'flutter.bat')}")
                found = True
                break
        if found:
            break
