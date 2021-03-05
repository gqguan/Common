%% 按中文描述字段将5分制或2分制统一转化为百分制
% 输入：in_cell_array为五或两分制成绩矩阵，当表示多个同学时以行向量表示各人的各项分数
%       weights为数值行向量，多项分数中各项的权重
% 输出：out_cell_array与输入参数in_cell_array具有相同数据结构
%      avg为数值列向量，其中各行表示各人的平均百分制成绩
function [out_cell_array,avg] = ConvertScale(in_cell_array,weights)
    % 缺省值
    if ~exist('weights','var')
        weights = ones(1,size(in_cell_array,2));
    else
        if class(weights) == 'double'
            if ~all(size(weight) == [1,size(in_cell_array,2)])
                fprintf('[注意] ConvertScale()的输入参数weight因向量尺寸不符而忽略！\n')
                weights = ones(1,size(in_cell_array,2));
            end
        else
            fprintf('[注意] ConvertScale()的输入参数weight因数据类型不符而忽略！\n')
            weights = ones(1,size(in_cell_array,2));
        end
    end
    % 初值
    out_cell_array = in_cell_array;
    % 将相应字段替换为百分制表示的字段
    out_cell_array(strcmp(in_cell_array, 'A')) = {'95'};
    out_cell_array(strcmp(in_cell_array, 'B')) = {'85'};
    out_cell_array(strcmp(in_cell_array, 'C')) = {'75'};
    out_cell_array(strcmp(in_cell_array, 'D')) = {'65'};
    out_cell_array(strcmp(in_cell_array, 'E')) = {'55'};
    out_cell_array(strcmp(in_cell_array, 'F')) = {'0'};
    out_cell_array(strcmp(in_cell_array, '优秀')) = {'95'};
    out_cell_array(strcmp(in_cell_array, '良好')) = {'85'};
    out_cell_array(strcmp(in_cell_array, '中等')) = {'75'};
    out_cell_array(strcmp(in_cell_array, '合格')) = {'65'};
    out_cell_array(strcmp(in_cell_array, '及格')) = {'65'};
    out_cell_array(strcmp(in_cell_array, '不合格')) = {'55'};
    out_cell_array(strcmp(in_cell_array, '不及格')) = {'55'};
    out_cell_array(strcmp(in_cell_array, '通过')) = {'80'};
    out_cell_array(strcmp(in_cell_array, '不通过')) = {'50'};
    % 权重归一化
    weights = weights/sum(weights);
    % 计算各行加权平均分
    out_double_array = cellfun(@(x) str2double(x), out_cell_array);
    avg = out_double_array*weights';