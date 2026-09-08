import os

def join_file(part1_path):
    # Determine the original filename by stripping '.part1'
    original_path = part1_path[:-6]
    print(f"Reconstructing {original_path}...")
    
    part_num = 1
    parts = []
    while True:
        part_name = f"{original_path}.part{part_num}"
        if os.path.exists(part_name):
            parts.append(part_name)
            part_num += 1
        else:
            break
            
    if not parts:
        print(f"  No parts found for {original_path}!")
        return
        
    with open(original_path, 'wb') as dest:
        for part in parts:
            print(f"  Reading {part}...")
            with open(part, 'rb') as src:
                dest.write(src.read())
                
    print(f"  Successfully reconstructed {original_path}!")

def main():
    root_dir = os.path.dirname(os.path.abspath(__file__))
    print(f"Searching for split APK files in: {root_dir}")
    
    found = False
    for root, dirs, files in os.walk(root_dir):
        # Exclude directories
        if any(x in root for x in ['.git', '.dart_tool', 'build', 'scratch']):
            continue
            
        for file in files:
            if file.lower().endswith('.apk.part1'):
                part1_path = os.path.join(root, file)
                join_file(part1_path)
                found = True
                
    if not found:
        print("No split APK files (*.apk.part1) found.")

if __name__ == "__main__":
    main()
