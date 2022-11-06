%% externally run exiftool.exe to get meta.csv containing the meta data
% e.g., exiftool -csv *.docx > meta.csv

%% initialize
clear
% Check meta.csv if existed
if exist('meta.csv','file') ~= 2
    fprintf('[Error] ��������exiftool����meta.csv��\n')
    return
end
% ����meta.csv
feature('DefaultCharacterSet', 'UTF8'); 
raw = importdata('meta.csv');
tabHeads = raw.textdata(1,:);
metaTab0 = cell2table(raw.textdata(2:end,:), 'VariableNames', tabHeads);
% ��ȡ��Ϣ
idx = ismember(tabHeads, {'FileName','Characters','Creator','CreateDate',...
    'RevisionNumber','TotalEditTime','LastModifiedBy','ZipCRC','ModifyDate'});
metaTab1 = metaTab0(:,idx);
% ת������ʱ���ֶ�
metaTab1.CreateDate = cellfun(@(x)datetime(x(1:end-1), 'InputFormat', ...
    'yyyy:MM:dd HH:mm:ss'), metaTab1.CreateDate);
metaTab1.ModifyDate = cellfun(@(x)datetime(x(1:end-1), 'InputFormat', ...
    'yyyy:MM:dd HH:mm:ss'), metaTab1.ModifyDate);
% % ת��ʱ���ֶ�
% metaTab1.TotalEditTime = cellfun(@(x)getDuration(x), ...
%     metaTab1.TotalEditTime, 'UniformOutput', false);

%% ���ͬԴ�ļ�
Remarks = cell(height(metaTab1),1);
metaTab2 = [metaTab1,table(Remarks)];
seqNum = 0;
for i = 1:height(metaTab2)
    if isempty(metaTab2.Remarks{i}) % ������ȷ��ΪͬԴ��������
        idx = strcmp(metaTab2.ZipCRC(1:end),metaTab2.ZipCRC{i});
        if sum(idx) > 1
            idx = find(idx);
            % �ڱ�ע�б��Ϊ��ͬԴ������
            seqNum = seqNum+1;            
            for j = 1:length(idx)
                metaTab2.Remarks{idx(j)} = sprintf('SS%d',seqNum);
            end
            % ���ҡ���Դ������
            metaTab_SS = metaTab2(idx,:);
            [~,minIdx] = min(metaTab_SS.CreateDate);
            metaTab_SS.Remarks(minIdx) = strcat(metaTab_SS.Remarks(minIdx),'root');
            metaTab2(idx,:) = metaTab_SS;
        end
    end
end

function value = getDuration(strWithUnit)
    value = NaT;
    raw = split(strWithUnit);
    pv.value = str2double(raw{1});
    if length(raw) >= 2
        pv.unit = raw{2};
        switch pv.unit
            case('days')
                value = days(pv.value);
            case('hours')
                value = hours(pv.value);
            case('minutes')
                value = minutes(pv.value);
            case('seconds')
                value = seconds(pv.value);
        end
    end

end