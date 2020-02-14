function create_html_for_directory(outputdirectory)

%outputdirectory = 'F:\Dropbox\AED_PeelHarvey\Presentations\2018\Peel_WQ_Model_v5_2016_2017_3D_Murray_N_Test\Regions\';


dirlist = dir(outputdirectory);

for i = 3:length(dirlist)
    mdir = dir([outputdirectory,dirlist(i).name,'\*.png']);
    
    filename = [outputdirectory,'\',dirlist(i).name];
    
    import mlreportgen.dom.*

    d = Document(filename,'html-file');
    %p = Document(filename,'docx');
    
    for j = 1:length(mdir)
        
        plot1 = Image([outputdirectory,dirlist(i).name,'\',mdir(j).name]);
        %plot2 = Image([outputdirectory,dirlist(i).name,'\',mdir(j).name]);

        append(d,plot1);
        %append(p,plot2);
        
    end
    
    close(d);
    %close(p);
end