%% CombinePDF()合并pdf文件编目后生成附件文件：使用示例·1
%
% by Dr. Guan Guoqiang @ SCUT on 2021/4/20

%% 初始化
clear
wrkDir1 = 'testPDFs1';
% 检查示例1的工作目录是否存在
fprintf('[1] 检查示例1的工作目录...\n')
if exist(wrkDir1,'dir')
    fprintf('[2] 存在工作目录%s，调用Combine()...\n',wrkDir1)
else
    error('示例目录\testPDFs1\不存在！')
    return
end

%% 选定同一目录下的多个pdf文件，在新建的output目录中生成编目的laTeX代码
fprintf('[3] 从\\%s目录中选定需要合并生成附件的多个pdf文件\n',wrkDir1)
CombinePDF(0)

%% 输出
fprintf('[4] 在\\%s\\output中生成test1.tex文件，请另行编译生成test1.pdf文件\n',wrkDir1)