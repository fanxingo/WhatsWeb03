import re
import os

# 替换成你的 Swift 项目根目录路径
project_root = "."

# 匹配 "Some text".localized(...)，支持带参数或不带参数
pattern = re.compile(r'"((?:[^"\\]|\\.)+?)"\.localized(?:\([^)]*\))?')

# 用 set 自动去重，大小写敏感
found_strings = set()

for root, _, files in os.walk(project_root):
    for file in files:
        if file.endswith(".swift"):
            filepath = os.path.join(root, file)
            with open(filepath, 'r', encoding='utf-8') as f:
                for line in f:
                    # 忽略注释行（完全注释或行中注释的部分）
                    code_part = line.split("//")[0]
                    matches = pattern.findall(code_part)
                    for m in matches:
                        found_strings.add(m)

# 排序后的唯一字符串列表
sorted_strings = sorted(found_strings)

# 输出为 Localizable_template.strings
output_path = os.path.join(project_root, "Localizable_template.strings")
with open(output_path, 'w', encoding='utf-8') as out:
    for key in sorted_strings:
        out.write(f'"{key}" = "{key}";\n')

print(f"✅ 提取完成，共 {len(sorted_strings)} 条，保存至：{output_path}")
