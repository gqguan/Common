function out = CombinePDF(opt, SortedNames)
%% �ϲ�pdf�ļ���Ŀ
%
% by Dr. Guan Guoqiang @ SCUT on 2020-07-20

%% ��ʼ��
if ~exist('EditDist.m','file')
    cprintf('err','�������Ҳ����������EditDist.m��\n')
    return
end
% % ��鹤���ռ����޿α�
% if ~exist('db_Curriculum','var')
%     fprintf('��database.mat������db_Curriculum\n')
%     load('database.mat','db_Curriculum')
% else
%     fprintf('ʹ�õ�ǰ�����ռ��еı���db_Curriculum\n')
% end
% Courses = db_Curriculum.Name;
FileProp = struct('UID',[],'Name',[]);
FileProps = FileProp;

%% ���ļ�ѡ�񴰣�����������Ҫ������ļ�
[FileNames, PathName] = uigetfile('*.pdf', 'ѡ��PDF�ļ����ļ���Ϊ�ļ����ݣ� ...', 'Multiselect', 'on');
% Note:
% When only one file is selected, uigetfile() will return the char variable
% and lead to the error in [FullPath{:}]. Use cellstr() to ensure the
% variable be as cell objects.
FileNames = cellstr(FileNames);
PathName = cellstr(PathName);
% Get the number of selected file in the dialog windows
FileNum = length(FileNames);

%% ���б�˳������Ӧ��pdf�ļ�
if ~isfolder([PathName{:},'output'])
    mkdir([PathName{:},'output'])
end
switch opt
    case(0) % �������ļ�˳��ϲ�
        for iSN = 1:FileNum
            FileProp.UID = sprintf('appx_%d.pdf',iSN);
            FileProp.Name = FileNames{iSN};
            copyfile([PathName{:},FileProp.Name], [PathName{:},'output\',FileProp.UID]);
            FileProp.Name(regexp(FileProp.Name,'_')) = []; % �»��߻ᵼ��latex����������
            FileProp.Name = FileProp.Name(1:end-4);
            FileProps(iSN) = FileProp;
        end
    case(1)
        if ~exist('SortedNames','var')
            cprintf('err','������δ�����ļ��б������\n')
            return
        end
        NumList = length(SortedNames);
        Idxes = zeros(1,NumList);
        for iSN = 1:NumList
            [minOPNum,minIdx] = min(cellfun(@(x)EditDist(x(1:end-4),char(SortedNames(iSN,2))), FileNames));
            similarity = (length(FileNames{minIdx})-length(char(SortedNames(iSN,2))))/minOPNum;
            if similarity > 0.75
                cprintf('Comments','%s - %s (%f)\n', SortedNames(iSN,2), FileNames{minIdx}, similarity)
                Idxes(iSN) = minIdx;
            else
                cprintf('err','%s - %s (%f)\n', SortedNames(iSN,2), FileNames{minIdx}, similarity)
            end
        end
        % �г�ȱ�̸ٵĿγ�����
        out = SortedNames(Idxes == 0,:);

        % ���ļ���ʶ���ļ����ݣ������ļ������Ϊͳһ���ļ�����������ֲ���ʶ����ļ������⣩
        for iSN = 1:NumList
            FileProp.UID = sprintf('appx_%d.pdf',iSN);
            if Idxes(iSN) ~= 0 % ������ƥ��Ŀγ�
                FileProp.Name = FileNames{Idxes(iSN)};
                copyfile([PathName{:},FileProp.Name], [PathName{:},'output\',FileProp.UID])
                FileProp.Name = strcat(SortedNames(iSN,1),"��",SortedNames(iSN,2)); 
                FileProp.Name(regexp(FileProp.Name,'_')) = []; % �»��߻ᵼ��latex����������
                FileProps(iSN) = FileProp;
            end
        end
end

%% ����texԴ����
cd([PathName{:},'output'])
% ���ļ�
fileID = fopen('test1.tex','w','native','UTF-8');
fprintf(fileID,'\\documentclass[UTF8]{ctexart}\n');
fprintf(fileID,'\\usepackage{fancyhdr,pdfpages,tocloft}\n');
fprintf(fileID,'\\usepackage[margin=0.5in,bottom=0.75in,top=0.75in]{geometry}\n');
fprintf(fileID,'\\usepackage[pagebackref]{hyperref}\n');
fprintf(fileID,'\\fancyhead{}\n');
fprintf(fileID,'\\lfoot{�γ̽�ѧ��ٻ�ࣨ�ǹ����Σ�}\n');
fprintf(fileID,'\\cfoot{}\n');
fprintf(fileID,'\\rfoot{\\thepage}\n');
fprintf(fileID,'\\renewcommand{\\headrulewidth}{0pt}\n');
fprintf(fileID,'\\begin{document}\n');
fprintf(fileID,'\\title{��������}\n');
fprintf(fileID,'\\author{��������ѧ��Դ��ѧ����רҵ}\n');
fprintf(fileID,'\\date{2021-6-15}\n');
fprintf(fileID,'\\maketitle\n');
fprintf(fileID,'\\pagenumbering{roman}\n');
fprintf(fileID,'\\tableofcontents\n');
fprintf(fileID,'\\newpage\n');
fprintf(fileID,'\\pagenumbering{arabic}\n');
fprintf(fileID,'\\pagestyle{fancy}\n');

for iSN = 1:FileNum
    if Idxes(iSN) ~= 0
        fprintf(fileID,'\\clearpage\n');
        fprintf(fileID,'\\phantomsection\n');
        fprintf(fileID,'\\addcontentsline{toc}{subsection}{%s}\n',FileProps(iSN).Name);
        fprintf(fileID,'\\includepdf[pages={-},pagecommand={}]{%s}\n',FileProps(iSN).UID);
    end
end
fprintf(fileID,'\\end{document}\n');
fclose(fileID);
