function Greenhouse
%clear the workspace, command window, and close all windows
clear
clc
close all
%load the data
TerrestrialPlanetsProperties = readtable('Terrestrial Planets Properties.xlsx');

%%%%Equilibrium Temp Calculation%%%%
%Earth's solar radiation flux
fEarth = 1362;
%Stefan-Boltzmann constant
sigma = 0.0000000567;
%finds flux for all planets
fPlanet = fEarth.*((TerrestrialPlanetsProperties{3,2}.^2)./(TerrestrialPlanetsProperties{1:5,2}.^2));
%finds Equilibrium temp for all planets
ET = ((fPlanet.*(1-(TerrestrialPlanetsProperties{1:5,4})))./(4*sigma)).^(0.25);

%%%%Surface Temp Calculation%%%%
%General Radiation absorption
fg = 1;
%Earth's Radiation absorption
fe = 0.73;
%Planet Surface Temps
Tmercury = ((fPlanet(1)*(1-TerrestrialPlanetsProperties{1,4}))/(4*sigma*(1-(fg/2))))^0.25;
Tvenus = ((fPlanet(2)*(1-TerrestrialPlanetsProperties{2,4}))/(4*sigma*(1-(fg/2))))^0.25;
Tearth = ((fEarth*(1-TerrestrialPlanetsProperties{3,4}))/(4*sigma*(1-(fe/2))))^0.25;
Tmoon = ((fPlanet(4)*(1-TerrestrialPlanetsProperties{4,4}))/(4*sigma*(1-(fg/2))))^0.25;
Tmars = ((fPlanet(5)*(1-TerrestrialPlanetsProperties{5,4}))/(4*sigma*(1-(fg/2))))^0.25;
Tplanet = [Tmercury, Tvenus, Tearth, Tmoon, Tmars];

%%%%Upwelling radiation%%%%
UpVenus = (fPlanet(2)*(1-TerrestrialPlanetsProperties{2,4}))/4;
UpEarth = (fEarth*(1-TerrestrialPlanetsProperties{3,4}))/4;
UpMars = (fPlanet(5)*(1-TerrestrialPlanetsProperties{5,4}))/4;
UpPlanet = [UpVenus, UpEarth, UpMars];

%%%%Cloud-top temp%%%%
Ctemp = Tplanet.*(2^(-0.25));

%%%%Jupiter Temperature%%%%
%jupiter's albedo
a = 0.73;
%jupiter's flux
fJupiter = fEarth*(1/(5.21)^2);
%Jupiter's Temp
Tjupiter = ((fJupiter*(1-a))/(4*sigma*(1-(fg/2))))^0.25;

%%%%Observed Temp%%%%
ot = [TerrestrialPlanetsProperties{1:5,5}];

%%%%Plot Information%%%%
Mercury = [ET(1), Tplanet(1), Ctemp(1), ot(1)];
Venus = [ET(2), Tplanet(2), Ctemp(2), ot(2)];
Earth = [ET(3), Tplanet(3), Ctemp(3), ot(3)];
Moon = [ET(4), Tplanet(4), Ctemp(4), ot(4)];
Mars = [ET(5), Tplanet(5), Ctemp(5), ot(5)];


tf=1;
while tf==1
    %menu text list
    list = {'Equilibrium Temperatures', 'Upwelling Radiation', 'Visual Aids', 'Effective Temperature of Jupiter', 'Earth Greenhouse Effect Variations'};
    %display the dialog box
    %cancel or <esc> closes the dialog
    [indx,tf] = listdlg('ListString',list, 'Name','Greenhouse Model: Main Menu','ListSize',[450,150]);
    %allow for multiple selections
    Nindx=numel(indx);
    for iindx=1:Nindx
        %do each option selected
        iopt=indx(iindx);
        if iopt==1
            %List of planet names
            c = categorical({'Mercury', 'Venus', 'Earth', 'Moon', 'Mars'});
            c = reordercats(c,{'Mercury', 'Venus', 'Earth', 'Moon', 'Mars'});
            %Bar Graph of Equilibrium Temp for all planets
            bar(c, ET)
            ylim([0, 500])
            ylabel('Temperature (K)')
            title('Equilibrium Temperature for Terrestrial Bodies')
            text(1:length(ET), ET, num2str(ET,'%4.1f'),'vert', 'bottom', 'horiz', 'center');
        end
        if iopt==2
            %List of category names
            c = categorical({'Venus', 'Earth', 'Mars'});
            c = reordercats(c,{'Venus', 'Earth', 'Mars'});
            %Bar Graph of upwelling radiation for planets
            bar(c, UpPlanet)
            ylim([0, 300])
            ylabel('Temperature (K)')
            title('Fraction of Upwelling Radiation Absorbed by the Atmosphere')
            text(1:length(UpPlanet), UpPlanet, num2str(UpPlanet','%4.1f'),'vert', 'bottom', 'horiz', 'center');
        end
        
        if iopt==3
            tf2=1;
            while tf2==1
                list2 = {'Mercury', 'Venus', 'Earth', 'Moon', 'Mars','All Planet Comparison'};
                [indx2,tf2] = listdlg('ListString',list2, 'Name','Greenhouse Model: Visual Aid Menu','ListSize',[450,150]);
                %allow for multiple selections
                Nindx2=numel(indx2);
                for iindx2=1:Nindx2
                    iopt2=indx2(iindx2);
                    if iopt2==1
                        c = categorical({'Equilibrium Temperature', 'One-Layer Atmosphere Temperature', 'Cloud Top Temperature', 'Observed Temperature'});
                        c = reordercats(c,{'Equilibrium Temperature', 'One-Layer Atmosphere Temperature', 'Cloud Top Temperature', 'Observed Temperature'});
                        bar(c, Mercury)
                        ylim([0, 600])
                        ylabel('Temperature (K)')
                        title('Mercury')
                        text(1:length(Mercury), Mercury, num2str(Mercury','%4.1f'),'vert', 'bottom', 'horiz', 'center');
                    end
                    if iopt2==2
                        c = categorical({'Equilibrium Temperature', 'One-Layer Atmosphere Temperature', 'Cloud Top Temperature', 'Observed Temperature'});
                        c = reordercats(c,{'Equilibrium Temperature', 'One-Layer Atmosphere Temperature', 'Cloud Top Temperature', 'Observed Temperature'});
                        bar(c, Venus)
                        ylim([0, 850])
                        ylabel('Temperature (K)')
                        title('Venus')
                        text(1:length(Venus), Venus, num2str(Venus','%4.1f'),'vert', 'bottom', 'horiz', 'center');
                    end
                    if iopt2==3
                        c = categorical({'Equilibrium Temperature', 'One-Layer Atmosphere Temperature', 'Cloud Top Temperature', 'Observed Temperature'});
                        c = reordercats(c,{'Equilibrium Temperature', 'One-Layer Atmosphere Temperature', 'Cloud Top Temperature', 'Observed Temperature'});
                        bar(c, Earth)
                        ylim([0, 350])
                        ylabel('Temperature (K)')
                        title('Earth')
                        text(1:length(Earth), Earth, num2str(Earth','%4.1f'),'vert', 'bottom', 'horiz', 'center');
                    end
                    if iopt2==4
                        c = categorical({'Equilibrium Temperature', 'One-Layer Atmosphere Temperature', 'Cloud Top Temperature', 'Observed Temperature'});
                        c = reordercats(c,{'Equilibrium Temperature', 'One-Layer Atmosphere Temperature', 'Cloud Top Temperature', 'Observed Temperature'});
                        bar(c, Moon)
                        ylim([0, 400])
                        ylabel('Temperature (K)')
                        title('Moon')
                        text(1:length(Moon), Moon, num2str(Moon','%4.1f'),'vert', 'bottom', 'horiz', 'center');
                    end
                    if iopt2==5
                        c = categorical({'Equilibrium Temperature', 'One-Layer Atmosphere Temperature', 'Cloud Top Temperature', 'Observed Temperature'});
                        c = reordercats(c,{'Equilibrium Temperature', 'One-Layer Atmosphere Temperature', 'Cloud Top Temperature', 'Observed Temperature'});
                        bar(c, Mars)
                        ylim([0, 350])
                        ylabel('Temperature (K)')
                        title('Mars')
                        text(1:length(Mars), Mars, num2str(Mars','%4.1f'),'vert', 'bottom', 'horiz', 'center');
                    end
                    if iopt2==6
                        %List of planet names
                        c = categorical({'Mercury', 'Venus', 'Earth', 'Moon', 'Mars'});
                        c = reordercats(c,{'Mercury', 'Venus', 'Earth', 'Moon', 'Mars'});
                        plot(c, ET,'ro')
                        ylim([0, 800])
                        grid on
                        hold on
                        plot(c, Tplanet,'k*')
                        plot(c, Ctemp,'g*')
                        plot(c, ot,'bo')
                        %plot(c, Mars,'g*')
                        hold off
                        ylabel('Temperature (K)')
                        title('Temperature Comparison for all Planets')
                        legend('Equilibrium Temperature', 'One-Layer Atmosphere Temperature', 'Cloud Top Temperature', 'Observed Temperature')
                    end
                end
            end
        end
        if iopt==4
            bar(Tjupiter)
            ylim([0, 150])
            ylabel('Temperature (K)')
            title('Effective Temperature of Jupiter')
            text(1:length(Tjupiter), Tjupiter, num2str(Tjupiter','%4.1f'),'vert', 'bottom', 'horiz', 'center');
        end
        if iopt ==5
            fVarEarth = ((fEarth*(1-0.28))/4)*0.75;
            VarEarth1 = ((fVarEarth*(1-TerrestrialPlanetsProperties{3,4}))/(4*sigma*(1-(fe/2))))^0.25;
            VarEarth2 = ((fPlanet(3)*(1-TerrestrialPlanetsProperties{3,4}))/(4*sigma*(1-(fg/2))))^0.25;
            c = categorical({'Incoming Radiation Reduced 25%', '100% Terrestrial Absorption', 'Current Earth Model'});
            c = reordercats(c,{'Incoming Radiation Reduced 25%', '100% Terrestrial Absorption', 'Current Earth Model'});
            Var = [VarEarth1, VarEarth2, Tearth];
            bar(c, Var)
            ylim([0, 350])
            ylabel('Surface Temperature (K)')
            title('Earth Variations')
            text(1:length(Var), Var, num2str(Var','%4.1f'),'vert', 'bottom', 'horiz', 'center');
        end
    end
end

end

function TerrestrialPlanetsProperties = importfile(workbookFile, sheetName, dataLines)
%IMPORTFILE Import data from a spreadsheet
%  TERRESTRIALPLANETSPROPERTIES = IMPORTFILE(FILE) reads data from the
%  first worksheet in the Microsoft Excel spreadsheet file named FILE.
%  Returns the data as a table.
%
%  TERRESTRIALPLANETSPROPERTIES = IMPORTFILE(FILE, SHEET) reads from the
%  specified worksheet.
%
%  TERRESTRIALPLANETSPROPERTIES = IMPORTFILE(FILE, SHEET, DATALINES)
%  reads from the specified worksheet for the specified row interval(s).
%  Specify DATALINES as a positive scalar integer or a N-by-2 array of
%  positive scalar integers for dis-contiguous row intervals.
%
%  Example:
%  TerrestrialPlanetsProperties = importfile("E:\MATLAB\Terrestrial Planets Properties.xlsx", "Sheet1", [2, 6]);
%
%  See also READTABLE.
%
% Auto-generated by MATLAB on 05-May-2019 14:15:28

%% Input handling

% If no sheet is specified, read first sheet
if nargin == 1 || isempty(sheetName)
    sheetName = 1;
end

% If row start and end points are not specified, define defaults
if nargin <= 2
    dataLines = [2, 6];
end

%% Setup the Import Options
opts = spreadsheetImportOptions("NumVariables", 5);

% Specify sheet and range
opts.Sheet = sheetName;
opts.DataRange = "A" + dataLines(1, 1) + ":E" + dataLines(1, 2);

% Specify column names and types
opts.VariableNames = ["Planet", "Distance", "Radius", "Albedo", "SurfaceTemp"];
opts.SelectedVariableNames = ["Planet", "Distance", "Radius", "Albedo", "SurfaceTemp"];
opts.VariableTypes = ["string", "double", "string", "double", "double"];
opts = setvaropts(opts, [1, 3], "WhitespaceRule", "preserve");
opts = setvaropts(opts, [1, 3], "EmptyFieldRule", "auto");

% Import the data
TerrestrialPlanetsProperties = readtable(workbookFile, opts, "UseExcel", false);

for idx = 2:size(dataLines, 1)
    opts.DataRange = "A" + dataLines(idx, 1) + ":E" + dataLines(idx, 2);
    tb = readtable(workbookFile, opts, "UseExcel", false);
    TerrestrialPlanetsProperties = [TerrestrialPlanetsProperties; tb]; %#ok<AGROW>
end

end