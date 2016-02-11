addpath('/autofs/cluster/transcend/scripts/MEG/Matlab_scripts/core_scripts/');

%% Subjects

% subject={'002901';
%     '010401';
%     '014002';
%     '038301';
%     '040701';
%     '042201';
%     '042301';
%     '042401';
%     '043202';
%     '050901';
%     '051301';
%     '051901';
%     'AC003';
%     'AC013';
%     'AC023';
%     'AC047';
%     'AC050';
%     'AC053';
%     'AC054';
%     'AC058';
%     'AC061';
%     'AC063';
%     'AC065';
%    % 'AC067';
%     'AC068';
%     'AC069';
%     'AC070';
%     'AC072';
%     'AC073';
%     'AC075';
%     'AC076';
%     'AC077'};
%  visitNo=[2;1;2;1;1;1;1;1;1;1;1;1;1;1;1;1;2;1;1;1;1;2;2;1;1;1;1;1;1;1;1];
subject={'AC065'};
visitNo=[2];

%% Processing


    % for i=2
    for i=1:length(subject),
  
    try
    fprintf('Processing single subject %s\n',subject{i});
 vibCortex(subject{i},96,'tacrvib',visitNo(i));
    catch
    fprintf('Subject Failed ! %s\n',subject{i});
    %failed_subjects{counter,1}= subject{i};   
    
    end
    end


