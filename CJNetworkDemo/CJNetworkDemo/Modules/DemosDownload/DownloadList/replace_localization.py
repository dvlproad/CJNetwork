'''
Author: dvlproad
Date: 2025-03-09 02:19:26
LastEditors: dvlproad
LastEditTime: 2025-03-09 02:24:41
Description: 
'''
# Usage:
# 处理单个文件：
# python replace_localization.py /path/to/file.m
# 处理整个目录（包含子目录）：
# python replace_localization.py /path/to/directory
# 只处理当前目录（不处理子目录）：
# python replace_localization.py /path/to/directory --current-dir-only

import os
import re

def replace_localization(file_path):
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # 替换 @"xxx" -> NSLocalizedStringFromTable(@"xxx", @"LocalizableDownloader", nil)
    content = re.sub(r'@"(.*?)"', r'NSLocalizedStringFromTable(@"\1", @"LocalizableDownloader", nil)', content)
    
    # 替换 :@"xxx", -> :NSLocalizedStringFromTable(@"xxx", @"LocalizableDownloader", nil),
    content = re.sub(r':@"(.*?)",', r':NSLocalizedStringFromTable(@"\1", @"LocalizableDownloader", nil),', content)
    
    # 替换 :@"xxx"] -> :NSLocalizedStringFromTable(@"xxx", @"LocalizableDownloader", nil)]
    content = re.sub(r':@"(.*?)"]', r':NSLocalizedStringFromTable(@"\1", @"LocalizableDownloader", nil)]', content)
    
    with open(file_path, 'w', encoding='utf-8') as f:
        f.write(content)

def process_files(target, current_directory_only=False):
    if os.path.isfile(target):
        replace_localization(target)
        print(f"Processed file: {target}")
    elif os.path.isdir(target):
        for root, _, files in os.walk(target):
            if current_directory_only and root != target:
                continue
            for file in files:
                if file.endswith(('.m', '.h')):
                    file_path = os.path.join(root, file)
                    replace_localization(file_path)
                    print(f"Processed file: {file_path}")
    else:
        print("Invalid path. Please provide a valid file or directory.")

if __name__ == "__main__":
    import argparse
    parser = argparse.ArgumentParser(description="Process files for localization replacement.")
    parser.add_argument("target", help="File or directory to process")
    parser.add_argument("--current-dir-only", action="store_true", help="Only process files in the specified directory, not subdirectories")
    args = parser.parse_args()
    process_files(args.target, args.current_dir_only)
