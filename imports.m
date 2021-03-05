function [argout1,argout2] = imports(importer, prompt)
%% ��importer��������ݶԻ����ж�ѡ���ļ�
% �������1Ϊ���������������������и�Ԫ��Ϊ�������ݵı����
% �������2Ϊ���������ݵĺϲ���

% ����������
if ~nargin >= 1
    fprintf('[����] imports()��ָ�������ļ�������\n')
    return
end
if ~exist('prompt', 'var')
    prompt = 'ѡȡ��Ҫ�ϲ����ļ� ...';
end

% ָ�������ļ�����ȡ���ļ�����·������
[File, Path] = uigetfile('*.*', prompt, 'Multiselect', 'on');
File = reshape(File,[length(File),1]); % ȷ���ļ�������������ʽ���
fullpaths = strcat(Path, File);
% ȷ��fullpathsΪ���������������ڵ�ֻ����һ���ļ�ʱ��fullpathsΪ�ַ�������
if ~iscell(fullpaths)
    fullpaths = cellstr(fullpaths);
end

% �ֱ��������
argout1 = cellfun(@(x) importer(x), fullpaths, 'UniformOutput', false);
% �ϲ������ļ�
argout2 = vertcat(argout1{:});
