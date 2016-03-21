minT = min(dtc.posixTime);
maxT = max(dtc.posixTime);
step = 600; %10 minutes

upDt = dtc(dtc.posixTime == minT,:);%updated data table

load coast
figure(1)
colormap jet
pastPoint = minT;
figIdx = 1;
myTeamId = 149;

for idx = minT:step:maxT
    query = dtc(dtc.posixTime > pastPoint & dtc.posixTime <= idx,:); %selects positions to update latest known positions
    query = sortrows(query, 'posixTime');
    for jdx = 1:height(query)
        if height(upDt(upDt.teamID == query.teamID(jdx),:)) == 0
            upDt = [upDt;query(jdx,:)];
        else
            upDt(upDt.teamID == query.teamID(jdx),:) = query(jdx,:);
        end
    end
    pastPoint = idx;
    figure(1);
    %hold on
    clf(1)
    axesm('mapprojection','mercator', ...
        'angleunits','degrees',...
        'aspect','normal',...
        'origin',[44 -86 0],...
        'flatlimit',[-2.6 2.2],...
        'flonlimit',[-2.6 2.2],...
        'frame','on')
    caxis([0 1])
    colorbar('east')
    dt = datetime(idx, 'ConvertFrom', 'posixtime' );
    date = datestr(dt); 
    title(strcat('Normalized speed on ', date))
    plotm(lat,long)
    scatterm(upDt.lat, upDt.lon, 20, upDt.nSpd, 'filled')
    if height(upDt(upDt.teamID == myTeamId,:)) > 0
        mine = upDt(upDt.teamID == myTeamId,:);
        scatterm(mine.lat, mine.lon, 20, 'm', 'filled');
    end
    %hold off
    drawnow;
    saveas(1,strcat('2014\',int2str(figIdx),'.jpg'));
    figIdx=figIdx+1;
end