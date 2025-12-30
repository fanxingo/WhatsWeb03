import json

# 读取上传的文件
file_path = 'artisticfont.txt'
with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

# 解析 Objective-C 数组格式
import re

# 匹配最外层 NSArray 的内容
matches = re.findall(r'@\[\s*(.*?)\s*\]', content, re.DOTALL)

font_arrays = []
for match in matches:
    # 去掉换行和空格
    clean = match.replace('\n', '').replace('\t', '')
    # 分割字符串
    items = re.findall(r'@"(.*?)"', clean)
    if items:
        font_arrays.append(items)

# 转成 JSON
json_data = {"fonts": font_arrays}

# 保存为 JSON 文件
json_output_path = 'fonts_output.json'
with open(json_output_path, 'w', encoding='utf-8') as f:
    json.dump(json_data, f, ensure_ascii=False, indent=2)

json_output_path
