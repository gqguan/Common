function out = CombinePDF(opt, SortedNames)
%% 合并pdf文件编目
%
% by Dr. Guan Guoqiang @ SCUT on 2020-07-20

%% 初始化
if ~exist('EditDist.m','file')
    cprintf('err','【错误】找不到所需程序EditDist.m！\n')
    return
end
% % 检查工作空间有无课表
% if ~exist('db_Curriculum','var')
%     fprintf('从database.mat中载入db_Curriculum\n')
%     load('database.mat','db_Curriculum')
% else
%     fprintf('使用当前工作空间中的变量db_Curriculum\n')
% end
% Courses = db_Curriculum.Name;
FileProp = struct('UID',[],'Name',[]);
FileProps = FileProp;

%% 打开文件选择窗，批量导入需要处理的文件
[FileNames, PathName] = uigetfile('*.pdf', '选择PDF文件（文件名为文件内容） ...', 'Multiselect', 'on');
% Note:
% When only one file is selected, uigetfile() will return the char variable
% and lead to the error in [FullPath{:}]. Use cellstr() to ensure the
% variable be as cell objects.
FileNames = cellstr(FileNames);
PathName = cellstr(PathName);
% Get the number of selected file in the dialog windows
FileNum = length(FileNames);

%% 按列表顺序处理相应的pdf文件
if ~isfolder([PathName{:},'output'])
    mkdir([PathName{:},'output'])
end
switch opt
    case(0) % 按读入文件顺序合并
        for iSN = 1:FileNum
            FileProp.UID = sprintf('appx_%d.pdf',iSN);
            FileProp.Name = FileNames{iSN};
            copyfile([PathName{:},FileProp.Name], [PathName{:},'output\',FileProp.UID]);
            FileProp.Name(regexp(FileProp.Name,'_')) = []; % 下划线会导致latex代码编译出错
            FileProp.Name = FileProp.Name(1:end-4);
            FileProps(iSN) = FileProp;
        end
    case(1)
        if ~exist('SortedNames','var')
            cprintf('err','【错误】未输入文件列表参数！\n')
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
        % 列出缺教纲的课程名单
        out = SortedNames(Idxes == 0,:);

        % 由文件名识别文件内容，并将文件名另存为统一的文件名（避免出现不可识别的文件名问题）
        for iSN = 1:NumList
            FileProp.UID = sprintf('appx_%d.pdf',iSN);
            if Idxes(iSN) ~= 0 % 跳过不匹配的课程
                FileProp.Name = FileNames{Idxes(iSN)};
                copyfile([PathName{:},FileProp.Name], [PathName{:},'output\',FileProp.UID])
                FileProp.Name = strcat(SortedNames(iSN,1),"：",SortedNames(iSN,2)); 
                FileProp.Name(regexp(FileProp.Name,'_')) = []; % 下划线会导致latex代码编译出错
                FileProps(iSN) = FileProp;
            end
        end
end

%% 生成tex源代码
cd([PathName{:},'output'])
% 打开文件
fileID = fopen('test1.tex','w','native','UTF-8');
fprintf(fileID,'\\documentclass[UTF8]{ctexart}\n');
fprintf(fileID,'\\usepackage{fancyhdr,pdfpages,tocloft}\n');
fprintf(fileID,'\\usepackage[margin=0.5in,bottom=0.75in,top=0.75in]{geometry}\n');
fprintf(fileID,'\\usepackage[pagebackref]{hyperref}\n');
fprintf(fileID,'\\fancyhead{}\n');
fprintf(fileID,'\\lfoot{课程教学大纲汇编（非公共课）}\n');
fprintf(fileID,'\\cfoot{}\n');
fprintf(fileID,'\\rfoot{\\thepage}\n');
fprintf(fileID,'\\renewcommand{\\headrulewidth}{0pt}\n');
fprintf(fileID,'\\begin{document}\n');
fprintf(fileID,'\\title{附件材料}\n');
fprintf(fileID,'\\author{华南理工大学能源化学工程专业}\n');
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
