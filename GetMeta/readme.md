# 获取MS-Word文档属性

这里提供两种方法实现
1 先在cmd中运行exiftool.exe生成meta.csv，再用matlab处理
1.1 将docx文件和exiftool.exe放在同一目录
1.2 在cmd中运行：exiftool -r -all -csv *.docx > meta.csv
2 在matlab中调用ActiveX获取文档的属性