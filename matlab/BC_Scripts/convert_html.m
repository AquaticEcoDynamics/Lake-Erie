function convert_html(base_dir)
%base_dir = 'Images_All\';

%dirlist = dir(base_dir);

%for i = 3:length(dirlist)
    %outputdir = [base_dir,dirlist(i).name,'\'];
    
    create_html_for_directory(base_dir)
    
%end