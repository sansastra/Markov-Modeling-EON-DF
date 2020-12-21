function [stateOccupancyPattern,transitionStatesForClasses,connectionNonBlockingStates,...
    resourceBlockingStates,fragmentationBlockingStates,connectionsPerClassPerState]= FirstFit(totalNumberOfSlots,bandwidthPerClass)
%Free =0; Used =1; 
classes= length(bandwidthPerClass);
guardBand =2;
% initialize slot occupancy pattern
stateMatrixColumnLength = totalNumberOfSlots+1; % ist index will determine if its a normal, fragmentation, or resource blocking states
stateOccupancyPattern= zeros(1,stateMatrixColumnLength);
stateOccupancyPattern(totalNumberOfSlots+1)=-1;
connectionsPerClassPerState = zeros(1, classes);
%initialState = stateOccupancyPattern;
oldLength=0;    
   % Evaluate all possible connection incoming requests
transitionStatesForClasses=[];
connectionNonBlockingStates = [];
resourceBlockingStates=[];
fragmentationBlockingStates =[];
while(length(stateOccupancyPattern(:,1))> oldLength)
    
    begin = oldLength+1;
    oldLength = length(stateOccupancyPattern(:,1));
    for k =begin : oldLength
        connectionNonBlockingStatesTemp = zeros(1,classes);  
        resourceBlockingStatesTemp = zeros(1,classes);
        fragmentationBlockingStatesTemp = zeros(1,classes);
        for c =1: classes         
            check = 0; % assume class c is not blocked
            for i = 1: (totalNumberOfSlots - bandwidthPerClass(c)+1) 
                occupancyPattern = stateOccupancyPattern(k,:);
                counter=0;
                for start = i: i+bandwidthPerClass(c)-1
                    if(occupancyPattern(start)==0)
                        counter = counter+ 1;
                    end
                end
                if(counter == bandwidthPerClass(c))
                    check =1;
                   occupancyPattern(i)=guardBand;
                   for m = i+1 : i+bandwidthPerClass(c)-guardBand
                       occupancyPattern(m)=1;
                   end
                   occupancyPattern(m+1)=guardBand;
                   [trueOrFalse, index1] = OccupancyPatternFound(occupancyPattern,stateOccupancyPattern,1);
                   if (trueOrFalse)                      
                       stateOccupancyPattern = [stateOccupancyPattern; occupancyPattern]; 
                       % only for random (de)allocation
                        transitionStatesForClasses(k,length(stateOccupancyPattern(:,1)),c)=c; % 1 for arrival  
                       % keep track of connections per states 
                        tempConnectionsPerClass = zeros(1, classes);
                        tempConnectionsPerClass(1,c)= 1;
                        connectionsPerClassPerState = [connectionsPerClassPerState; + connectionsPerClassPerState(k,:)+ tempConnectionsPerClass];
                   else %if(k~= index1) % no need of if statement
                        transitionStatesForClasses(k,index1,c)=c;
                       %end
                       
                   end
                  % if(check)% firstFit % no need of this if statement
                       break;
                 %  end
                end
            end 
            if (check)
                connectionNonBlockingStatesTemp(c)=1;
            
            else if(sum(stateOccupancyPattern(k,:)==0)<bandwidthPerClass(c))
                    resourceBlockingStatesTemp(c)=1;
                else 
                    fragmentationBlockingStatesTemp(c)= 1;
                end
            end
        end
         connectionNonBlockingStates = [connectionNonBlockingStates;connectionNonBlockingStatesTemp];  
         resourceBlockingStates = [resourceBlockingStates;resourceBlockingStatesTemp];
         fragmentationBlockingStates= [fragmentationBlockingStates;fragmentationBlockingStatesTemp];
    end 
    
    % Evaluate all possible connection leaving-requests
   % if(length(stateOccupancyPattern(:,1))> oldLength)  
    temp =length(stateOccupancyPattern(:,1));
    for k=begin: temp
        increment =0;
        connectionOccupationStates = ConnectionFound(guardBand,bandwidthPerClass,totalNumberOfSlots,stateOccupancyPattern(k,:));
        for c=1: classes
            occupancyPattern = stateOccupancyPattern(k,:);
            count=sum(connectionOccupationStates(c,:)~=0);
            cnt=0;
            while(count>cnt)
                occupancyPatternTemp =  occupancyPattern;
                cnt = cnt+1;
                s = connectionOccupationStates(c,cnt);
                for i = s : s+bandwidthPerClass(c)-1
                     occupancyPatternTemp(i)=0;
                end
                [trueOrFalse, index1] = OccupancyPatternFound(occupancyPatternTemp,stateOccupancyPattern,1);
                if (trueOrFalse)
                    increment = increment+1;                                    
                  %  transitionStatesForClasses(length(stateOccupancyPattern(:,1)),k,c)=c; % 2 for departure
                   stateOccupancyPattern = [stateOccupancyPattern; occupancyPatternTemp]; 
                   transitionStatesForClasses(k,length(stateOccupancyPattern(:,1)),c)=-c; % 1 for arrival 
                   % keep track of connections per states 
                   tempConnectionsPerClass = zeros(1, classes);
                   tempConnectionsPerClass(1,c)= -1;
                   connectionsPerClassPerState = [connectionsPerClassPerState; + connectionsPerClassPerState(k,:)+ tempConnectionsPerClass];
                else if(k ~= index1)
                     transitionStatesForClasses(k,index1,c)=-c; 
                    end
                end
            end
        end
    end
 end
%end

%numberOfStatesOLD =length(stateOccupancyPattern(:,1))


%transitionStatesForClasses 
%connectionOccupationStates = zeros(numberOfStatesOLD,classes);
% for i=1: numberOfStatesOLD
%      singleStateOccupancyPattern = stateOccupancyPattern(i,:);
%      connectionOccupationStatesTemp = ConnectionFound(guardBand,bandwidthPerClass,totalNumberOfSlots,singleStateOccupancyPattern );
%      for c=1:classes
%          if (nnz(connectionOccupationStatesTemp(c))>0)
%              connectionOccupationStates(i,c)=1;
%          end
%      end
% end
end
% Generate defragmentation states




       
       
    