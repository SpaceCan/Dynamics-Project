tf=1;
while tf==1
    %menu text list
    list = {'Inner Planet Solar System Simulation', 'Three Body System Simulation', 'Earth and Moon Simulation', 'Random Simulation'};
    %display the dialog box
    %cancel or <esc> closes the dialog
    [indx,tf] = listdlg('ListString',list, 'Name','Dynamics Final Project: Main Menu','PromptString',{'Please select a scenario:'},'ListSize',[350,100],'SelectionMode','single');
    %allow for multiple selections
   
    Nindx=numel(indx);
    
    for iindx=1:Nindx
    %do each option selected
    iopt=indx(iindx);
        if iopt==1
            load('Inner_Planets.mat')
            tf=0;
        end

        if iopt==2
            load('Figure_8.mat')
        end

        if iopt==3
            load('Earth_Moon.mat')
        end

        if iopt==4
            load('Random.mat')
        end
    end
end