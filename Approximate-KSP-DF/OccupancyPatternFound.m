function [trueOrFalse,counter] = OccupancyPatternFound(occupancyPattern,stateOccupancyPattern,start)
counter=0;
trueOrFalse=1; % found =0, notfound=1
for i=start:length(stateOccupancyPattern(:,1))
    temp= eq(occupancyPattern, stateOccupancyPattern(i,:));
    if (sum(temp)==length(occupancyPattern))
        trueOrFalse = 0;
        counter =i;
        break;
        % put break once it is found 
    end
end
% if(counter>1)
%     disp('same state more than once found');
% end
end