%% 用ActiveX获取word文档的meta属性
%
% by Dr. Guan Guoqiang @ SCUT on 2020-12-12
%
% 参考
% https://www.mathworks.com/matlabcentral/answers/99160
% https://www.mathworks.com/matlabcentral/answers/519279

item = ["Author" "Last Author" "Create Date" "Last Save Time" ...
    "Total Editing Time" "Number of Words"];

% Connect to Word
hdlActiveX = actxserver('Word.Application');
% hdlActiveX.Visible = true;
% Create a new document
% hdlWordDoc = invoke(hdlActiveX.Documents, 'Add');
% 打开Word文档
filename = 'exm_rp.docx';
docPath = [pwd filesep filename]; % 'C:\Users\gqgua\Documents\Git\GetMeta\exm_rp.docx'
% hdlWordDoc = hdlActiveX.Document.Open(docPath);
hdlWordDoc = invoke(hdlActiveX.Documents, 'Open', docPath);
% make the document visible
% trace(hdlActiveX.Visible);

props = cell(1,length(item));

for i = 1:length(item)
    % Intialize a handle for the built-in properties
    hdl = get(hdlWordDoc.builtInDocumentProperties, 'Item', char(item(i)));
    % Get Author
    props{i} = get(hdl,'Value');
end

% Close objects
hdlWordDoc.Close();
hdlActiveX.Quit();