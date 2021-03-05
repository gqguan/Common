%% �����������ֶν�5���ƻ�2����ͳһת��Ϊ�ٷ���
% ���룺in_cell_arrayΪ��������Ƴɼ����󣬵���ʾ���ͬѧʱ����������ʾ���˵ĸ������
%       weightsΪ��ֵ����������������и����Ȩ��
% �����out_cell_array���������in_cell_array������ͬ���ݽṹ
%      avgΪ��ֵ�����������и��б�ʾ���˵�ƽ���ٷ��Ƴɼ�
function [out_cell_array,avg] = ConvertScale(in_cell_array,weights)
    % ȱʡֵ
    if ~exist('weights','var')
        weights = ones(1,size(in_cell_array,2));
    else
        if class(weights) == 'double'
            if ~all(size(weight) == [1,size(in_cell_array,2)])
                fprintf('[ע��] ConvertScale()���������weight�������ߴ粻�������ԣ�\n')
                weights = ones(1,size(in_cell_array,2));
            end
        else
            fprintf('[ע��] ConvertScale()���������weight���������Ͳ��������ԣ�\n')
            weights = ones(1,size(in_cell_array,2));
        end
    end
    % ��ֵ
    out_cell_array = in_cell_array;
    % ����Ӧ�ֶ��滻Ϊ�ٷ��Ʊ�ʾ���ֶ�
    out_cell_array(strcmp(in_cell_array, 'A')) = {'95'};
    out_cell_array(strcmp(in_cell_array, 'B')) = {'85'};
    out_cell_array(strcmp(in_cell_array, 'C')) = {'75'};
    out_cell_array(strcmp(in_cell_array, 'D')) = {'65'};
    out_cell_array(strcmp(in_cell_array, 'E')) = {'55'};
    out_cell_array(strcmp(in_cell_array, 'F')) = {'0'};
    out_cell_array(strcmp(in_cell_array, '����')) = {'95'};
    out_cell_array(strcmp(in_cell_array, '����')) = {'85'};
    out_cell_array(strcmp(in_cell_array, '�е�')) = {'75'};
    out_cell_array(strcmp(in_cell_array, '�ϸ�')) = {'65'};
    out_cell_array(strcmp(in_cell_array, '����')) = {'65'};
    out_cell_array(strcmp(in_cell_array, '���ϸ�')) = {'55'};
    out_cell_array(strcmp(in_cell_array, '������')) = {'55'};
    out_cell_array(strcmp(in_cell_array, 'ͨ��')) = {'80'};
    out_cell_array(strcmp(in_cell_array, '��ͨ��')) = {'50'};
    % Ȩ�ع�һ��
    weights = weights/sum(weights);
    % ������м�Ȩƽ����
    out_double_array = cellfun(@(x) str2double(x), out_cell_array);
    avg = out_double_array*weights';