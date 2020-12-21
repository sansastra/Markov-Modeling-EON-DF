function [connectionsPerClassPerState,occupancy]= GenerateMacroStates(totalCapacity,bandwidthPerClass)
classes=length(bandwidthPerClass);

% generate states
if(classes<5)
    numberOfStates  = GetMaxNumberOfMacroStates(totalCapacity,1,bandwidthPerClass); % numberOfCores=1
%     max_nr_calls=zeros(1,classes);
%     for c=1:classes
%         max_nr_calls(c)=floor(totalCapacity/bandwidthPerClass(c));
%     end
    
    oldLength=0;    
    occupancy=zeros(1,numberOfStates); 
    % count connections per class per state
    connectionsPerClassPerState = zeros(numberOfStates, classes); 
    totalStates=1;
    % Evaluate all possible connection incoming requests
    while(totalStates> oldLength)
        begin = oldLength+1;
        oldLength = totalStates;
        for k =begin : oldLength          
            for c =1: classes
                occupancyPattern = connectionsPerClassPerState(k,:);
                counter= bandwidthPerClass*((occupancyPattern)');
                occupancyPattern(c)=occupancyPattern(c)+1;
                if(counter+bandwidthPerClass(c) <=totalCapacity)
                    stateFound = ismember(connectionsPerClassPerState(1:totalStates,:),occupancyPattern,'rows');
                    index1 = find(stateFound == 1,1); %  states with same no. of connections 
                    if(isempty(index1))
                        totalStates=totalStates+1;
                       connectionsPerClassPerState(totalStates,:)= occupancyPattern; 
                       occupancy(totalStates)=occupancyPattern*bandwidthPerClass';
                   end
                end
            end

        end 

        % Evaluate all possible connection leaving-requests
        %not needed
    end
else
    
    oldLength=0;    
    occupancy(1)=0;
    % count connections per class per state
    connectionsPerClassPerState{1} = zeros(1, classes); 
    totalStates=1;
    % Evaluate all possible connection incoming requests
    while(totalStates> oldLength)
        begin = oldLength+1;
        oldLength = totalStates;
        for k =begin : oldLength          
            for c =1: classes
                occupancyPattern = connectionsPerClassPerState{k,:};
                counter= bandwidthPerClass*((occupancyPattern)');
                occupancyPattern(c)=occupancyPattern(c)+1;
                if(counter+bandwidthPerClass(c) <=totalCapacity)
                    matrixTemp=cell2mat(connectionsPerClassPerState);
                    stateFound = ismember(matrixTemp(:,:),occupancyPattern,'rows');
                    index1 = find(stateFound == 1,1); %  states with same no. of connections 
                    if(isempty(index1))
                        totalStates=totalStates+1;
                       connectionsPerClassPerState{totalStates,:}= occupancyPattern; 
                       occupancy(totalStates)=occupancyPattern*bandwidthPerClass';
                    end
                end
            end

        end 

    end
    connectionsPerClassPerState=cell2mat(connectionsPerClassPerState);
end