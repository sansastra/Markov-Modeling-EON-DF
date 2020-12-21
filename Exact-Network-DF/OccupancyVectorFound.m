function [counter] = OccupancyVectorFound(occupancyPattern,stateOccupancyPattern,numberOfLinks)
counter=0; % not found =0, found>0
 
Rloacation={};
for link=1:numberOfLinks
    [index1,found]= ismember(stateOccupancyPattern{link}(:,:),occupancyPattern(link,:),'rows');
    index1 =find(index1==1);
    if(isempty(index1))
        return;
    end
    Rloacation{link}(:)= index1;
end
foundOccupancy=Rloacation{1}(:);
for link=2:numberOfLinks
    tempOccupancy={};
    j=0;
    for i=1:length(foundOccupancy)
        if(find(Rloacation{link}(:)==foundOccupancy(i),1))
           j=j+1; 
           tempOccupancy{1}(j)=foundOccupancy(i);
        end
    end
    if(isempty(tempOccupancy))
        return;
    else
        foundOccupancy=tempOccupancy{1}(:);
    end
end
if(isempty(foundOccupancy))
    return;
else
    counter=foundOccupancy(1);
    if(length(foundOccupancy)>1)
        disp('error in occupancy vector found function')
    end
end
    
end