function [argout1,argout2] = imports(importer, prompt)
%% 按importer程序导入根据对话窗中多选的文件
% 输出参数1为胞向量（列向量），其中各元素为导入数据的表变量
% 输出参数2为各导入数据的合并表

% 检查输入参数
if ~nargin >= 1
    fprintf('[错误] imports()需指定导入文件函数！\n')
    return
end
if ~exist('prompt', 'var')
    prompt = '选取需要合并的文件 ...';
end

% 指定数据文件，获取其文件完整路径向量
[File, Path] = uigetfile('*.*', prompt, 'Multiselect', 'on');
File = reshape(File,[length(File),1]); % 确保文件名以列向量形式存放
fullpaths = strcat(Path, File);
% 确保fullpaths为胞向量（这是由于当只导入一个文件时，fullpaths为字符变量）
if ~iscell(fullpaths)
    fullpaths = cellstr(fullpaths);
end

% 分别读入数据
argout1 = cellfun(@(x) importer(x), fullpaths, 'UniformOutput', false);
% 合并导入文件
argout2 = vertcat(argout1{:});
