%reading the csv file with a specific format
formatSpec = '%d%d%f%f%f%f';
dt = readtable('2014\postions.csv', 'Delimiter',',', ...
    'Format', formatSpec);
teams = unique(dt.teamID);

dtc = table();
%iterate though all the teams to calculate their filtered speed, normalized
%speed and difference of speed. Then all of these teams are combined again
%in the dtc table.
for idx = 1:length(teams)
    td = dt(dt.teamID == teams(idx),:);
    td = sortrows(td, 'posixTime');
    td.fSpd = filtfilt([1 1 1]/3, 1, td.spdkn); %zero phased filtered down speed
    td.nSpd = zeros(height(td),1); %moving normalization speed over vmax
    td.dfSpd = zeros(height(td),1); %difference compare to previous filtered speed
    vmax = 0;
    for jdx = 2:height(td)
        vmax = max(vmax, td.fSpd(jdx));
        td.nSpd(jdx) = td.fSpd(jdx) / vmax; %major code perf bottleneck
        td.dfSpd(jdx) = td.fSpd(jdx-1) - td.fSpd(jdx); %major code perf bottleneck
    end
    dtc = [dtc;td];%this is slow...
end