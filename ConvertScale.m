%% �����������ֶν�5���ƻ�2����ͳһת��Ϊ�ٷ���
function [out_cell_array,avg] = ConvertScale(in_cell_array)
    out_cell_array = in_cell_array;
    out_cell_array(find(strcmp(in_cell_array, 'A'))) = {'95'};
    out_cell_array(find(strcmp(in_cell_array, 'B'))) = {'85'};
    out_cell_array(find(strcmp(in_cell_array, 'C'))) = {'75'};
    out_cell_array(find(strcmp(in_cell_array, 'D'))) = {'65'};
    out_cell_array(find(strcmp(in_cell_array, 'E'))) = {'55'};
    out_cell_array(find(strcmp(in_cell_array, 'F'))) = {'0'};
    out_cell_array(find(strcmp(in_cell_array, '����'))) = {'95'};
    out_cell_array(find(strcmp(in_cell_array, '����'))) = {'85'};
    out_cell_array(find(strcmp(in_cell_array, '�е�'))) = {'75'};
    out_cell_array(find(strcmp(in_cell_array, '�ϸ�'))) = {'65'};
    out_cell_array(find(strcmp(in_cell_array, '����'))) = {'65'};
    out_cell_array(find(strcmp(in_cell_array, '���ϸ�'))) = {'55'};
    out_cell_array(find(strcmp(in_cell_array, '������'))) = {'55'};
    out_cell_array(find(strcmp(in_cell_array, 'ͨ��'))) = {'80'};
    out_cell_array(find(strcmp(in_cell_array, '��ͨ��'))) = {'50'};
    % �������ƽ����
    avg = mean(cellfun(@(x) str2num(x), out_cell_array),2);
end