function connectionOccupationStates = ConnectionFound(guardBand,bandwidthPerClass,totalNumberOfSlots,singleStateOccupancyPattern )
classes = length(bandwidthPerClass);
% assuming that 1st connection has lowest bandwidth
size = floor(totalNumberOfSlots/bandwidthPerClass(1));
connectionOccupationStates = zeros(classes,size);
n= 1;     
for c = 1: classes
    found =0;
    for s=1:totalNumberOfSlots
        if ((singleStateOccupancyPattern(n,s)==guardBand)&&(s+bandwidthPerClass(c)-1 <= totalNumberOfSlots))
            count = 1;
            while (singleStateOccupancyPattern(n,s+count)~=guardBand && (singleStateOccupancyPattern(n,s+count)==1))
                    count=count+1;
                    if(s+count>totalNumberOfSlots)
                        break;
                end
            end
            if(count+1==bandwidthPerClass(c))
                found = found + 1;              
                connectionOccupationStates(c,found)=s;
            else
                if(s+count<totalNumberOfSlots)
                    s= s+count;
                end
            end
        end
    end
end   
end