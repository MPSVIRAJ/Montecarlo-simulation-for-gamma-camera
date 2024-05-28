clear all
close all


current_path = pwd;                 % Define the current path
subfolderName = 'Geometric_Files';  % Define the subfolder name

% Construct the full path to the Geometry folder
geometricFolderPath = fullfile(current_path, subfolderName);

% Get a list of all .hsb files in the folder
hsb_files = fullfile(geometricFolderPath, '*.hsb');
files = dir(hsb_files);

% Initialize an empty structure array to store results
results = struct([]);

for k = 1:length(files)
    baseFileName = files(k).name;
    fullFileName = fullfile(geometricFolderPath, baseFileName);

    % Open the file for reading
    fid = fopen(fullFileName, 'r');

    % every line contains 15 variables (4 byte each)
    % read 4 byte data and put in array A
    [A,count]=fread(fid,'*single','n');
    
    fclose(fid);
    
    % rearrange the array into a 15 x N_of events matrix
    B=reshape(A,15,[]);
    ntuple=B';
    
    % set the labels for the output variables 
    ntuple_label(1)="source_num";
    ntuple_label(2)="history";
    ntuple_label(3)="xorig";
    ntuple_label(4)="yorig";
    ntuple_label(5)="zorig";
    ntuple_label(6)="a1orig";
    ntuple_label(7)="a2orig";
    ntuple_label(8)="a3orig";
    ntuple_label(9)="eslab";
    ntuple_label(10)="xslab";
    ntuple_label(11)="yslab";
    ntuple_label(12)="zslab";
    ntuple_label(13)="eslabesr";
    ntuple_label(14)="xslabesr";
    ntuple_label(15)="yslabesr";

    % do the histogram of one variable from the ntuple
    % for i=1:15
    %     % figure(i);
    %     histogram(ntuple(:,i));
    %     title(ntuple_label(i));
    %     % pause;
    % end
    
    % fit the histogram with a gaussian
    % figure(20);
    histfit(ntuple(:,14));
    % get the parameters of the fitting curve
    pd_l= fitdist((ntuple(:,14)),'Normal');

    % figure(21);
    histfit(ntuple(:,10));
    % get the parameters of the fitting curve
    pd_wl= fitdist((ntuple(:,10)),'Normal');

    % 2D scatter plot
    % figure(17);
    % scatter(ntuple(:,10),ntuple(:,11),'.')
    % 3D scatter plot
    % figure(18);
    % scatter3(ntuple(:,10),ntuple(:,11),ntuple(:,12),'.')

    %summary of the simulaton
    results(k).fileName = baseFileName;

    results(k).sigma_with_light = pd_l.sigma;
    results(k).FWHM_with_light = 2.355*pd_l.sigma;

    results(k).sigma_without_light = pd_wl.sigma;
    results(k).FWHM_without_light = 2.355*pd_wl.sigma;

    results(k).counts =  size(ntuple,1);
    results(k).sensitivity =  size(ntuple,1)/10000000;
end

% % Define the output file name
% outputFileName = 'results.csv';
% 
% % Construct the full path to the output file
% outputFilePath = fullfile(current_path, outputFileName);
% 
% % Open the file for writing
% fileID = fopen(outputFilePath, 'w');
% if fileID == -1
%     error('Could not open the output file for writing.');
% end
% 
% % Write the header line
% fprintf(fileID, 'FileName\tsigma_with_light\tFWHM_with_light\tsigma_without_light\tFWHM_without_light\tCounts\tsensitivity\n');
% 
% % Write the data from the structure array
% for k = 1:length(results)
%     fprintf(fileID, '%s\t%f\t%f\t%f\t%f\t%d\t%f\n', results(k).fileName, results(k).sigma_with_light, results(k).FWHM_with_light,results(k).sigma_without_light,results(k).FWHM_without_light,results(k).counts,results(k).sensitivity);
% end
% 
% % Close the file
% fclose(fileID);
% 

% Convert the structure to a table
resultsTable = struct2table(results);

% Define the output CSV file path
outputFilePath = fullfile(current_path, 'results.csv');

% Write the table to a CSV file
writetable(resultsTable, outputFilePath);

disp(['Results saved to CSV file: ', outputFilePath]);