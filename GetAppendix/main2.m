%% CombinePDF()合并pdf文件编目后生成附件文件：使用示例2
% 在同一目录下选取多个pdf文件并载入目录列表，按目录列表匹对相应的pdf文件名后编目生成附件材料
%
% by Dr. Guan Guoqiang @ SCUT on 2021/4/20

%% 初始化
clear
wrkDir2 = 'testPDFs2';
% 检查示例1的工作目录是否存在
fprintf('[1] 检查示例1的工作目录...\n')
if exist(wrkDir2,'dir')
    fprintf('[2] 存在工作目录%s，调用CombinePDF()...\n',wrkDir2)
else
    error('示例目录\testPDFs1\不存在！')
    return
end

%% 选定同一目录下的多个pdf文件，在新建的output目录中生成编目的laTeX代码
fprintf('[3] 从\\%s目录中选定需要合并生成附件的多个pdf文件\n',wrkDir2)
fprintf('[4] 从\\%s目录中载入SortedNames变量\n',wrkDir2)
load(strcat(wrkDir2,'/SortedNames.mat'),'SortedNames')
CombinePDF(1,SortedNames)

%% 输出
fprintf('[5] 在\\%s\\output中生成test1.tex文件，请另行编译生成test1.pdf文件\n',wrkDir2)