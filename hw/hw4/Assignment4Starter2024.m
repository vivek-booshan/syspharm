clear all;
close all;

%% Distribution Parameters 

NumberOfSubjects = 1000;
% Size of the populations - by making this a parameter, we can easily test 
%   the code with small numbers that run quickly, and then run it with 
%   larger populations once we're satisfied that it's working.

meanwt = 43;
sdwt = 19.7;
cutoffwt = 12; % Minumum weight; set to 0 to only remove nonpositives

%% PART ONE - GENERATE NORMAL DISTRIBUTION (for comparison only)
    
% Generate Normal Distribution for the given mean and SD
x = [1:1:150]; % x = weight (kg); y = density
y = 1/(sdwt*sqrt(2*pi()))*exp((-(x(:)-meanwt).^2)/(2*sdwt^2));


%% PART TWO - GENERATE VIRTUAL POPULATION (using random numbers)

% Initiate Random Numbers (helpful to make results reproducible)
rng(0,'simdTwister');

xtemp = sdwt.*randn(NumberOfSubjects,1)+meanwt; 
% This gives us a first attempt; next we must identify weights below 
% the cutoff and replace them
a=length(xtemp(xtemp<=cutoffwt)); % count people below x lb
i = 0;
cycle = 1;
while a>0 % if there are any nonpositives, replace them
    fprintf ('series %i, cycle %i, negs %i\n',i,1,a);
    xtemp(xtemp<=cutoffwt)=sdwt.*randn(a,1)+meanwt;        
    a=length(xtemp(xtemp<=cutoffwt)); 
    cycle = cycle + 1;
    i = i + 1;
end % check again for nonpositives and loop if nec.
xdist = xtemp; % This is the final weight distribution

% Output the means, SDs of the simulated population(s)
simmean = mean(xdist);
simSD = std(xdist);
fprintf('Simulated population, input mean %4.1f, simulated mean %4.1f; input SD %4.1f, simulated SD %4.1f \n',meanwt,simmean,sdwt,simSD)

xtemp = round(xdist); % xdist here is the list of patient weights for subpopulation i
for j = 1:length(x)
    ysamp(j) = length(xtemp(xtemp==x(j)))/NumberOfSubjects;
end

%% VISUALIZATION

% Overlay normal distributions and the sample distribution
f1 = figure;
    title('Distribution of weights');    
    ylabel('density');
    xlabel('weight (kg)'); % note how we only need one x-axis label
    hold on;
    plot (x,ysamp,'LineWidth',2);
    plot (x,y,'LineWidth',1.5); 
    lgd = legend('Sample','Normal Distrib');
    lgd.Location = 'best';
    lgd.Title.String = ['Population ' string(NumberOfSubjects)];
    set(f1, 'Position',[0 0 600 300])
    filename = strcat('Q5A_1_',string(NumberOfSubjects),'.png');
    exportgraphics(f1,filename,'Resolution',300);

% Boxplot
% Another way of visualizing the sample populations on one panel.
f2 = figure;
    hold on;
    title('Weight distribution - boxplot')
    ylabel('Weight (kg)')
    % bf2 = boxchart(xdist);
    bf2 = boxplot(xdist,'Labels',string(NumberOfSubjects));
    set(bf2,'LineWidth', 2)
    xlim(gca,[.5 1.5]);
    set(f2, 'Position',[0 0 200 600])
    filename = strcat('Q5A_2_',string(NumberOfSubjects),'.png');
    exportgraphics(f2,filename,'Resolution',300);

patientID = (1:NumberOfSubjects)';
Weights = xdist;
save(strcat('WeightDistribs_',string(NumberOfSubjects),'.mat'),'patientID','Weights');







