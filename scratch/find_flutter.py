import os

print("PATH entries:")
for p in os.environ.get('PATH', '').split(os.pathsep):
    if 'flutter' in p.lower():
        print(f"Found in PATH: {p}")

standard_paths = [
    r"C:\flutter\bin\flutter.bat",
    r"C:\src\flutter\bin\flutter.bat",
    r"D:\flutter\bin\flutter.bat",
    r"D:\src\flutter\bin\flutter.bat",
    os.path.expanduser(r"~\flutter\bin\flutter.bat"),
    os.path.expanduser(r"~\AppData\Local\Android\Sdk\flutter\bin\flutter.bat")
]

for sp in standard_paths:
    if os.path.exists(sp):
        print(f"Exists: {sp}")
