function [stateOccupancyPattern,transitionStatesForClasses,connectionNonBlockingStates,...
    resourceBlockingStates,fragmentationBlockingStates,possibleStatesTransitionForClasses,connectionsPerClassPerState]= RandomFit(totalNumberOfSlots,bandwidthPerClass)

classes=length(bandwidthPerClass);
%Free =0; Used =1; 
guardBand =2;
% initialize slot occupancy pattern
stateMatrixColumnLength = totalNumberOfSlots+1; % last index will determine if its a normal, fragmentation, or resource blocking states
stateOccupancyPattern= zeros(1,stateMatrixColumnLength);
stateOccupancyPattern(totalNumberOfSlots+1)=-1;
% find out: in a given state, how many possible transition can happen due
% to arrivals of a class request
possibleStatesTransitionForClasses = [];
oldLength=0;    

% determines if a transition is possible from one state to another   
transitionStatesForClasses=[];

% determines if this state can accept a class c request
connectionNonBlockingStates = [];

% find if a state is a blocking state for class c due to less resources
resourceBlockingStates=[];

% find if a state is a blocking state for class c due to fragmentation
fragmentationBlockingStates =[];

% count connections per class per state
connectionsPerClassPerState = zeros(1, classes); % last column indicates if a normal state is a defragmentated state or not

% Evaluate all possible connection incoming requests
while(length(stateOccupancyPattern(:,1))> oldLength)
    
    
    begin = oldLength+1;
    oldLength = length(stateOccupancyPattern(:,1));
    for k =begin : oldLength
        connectionNonBlockingStatesTemp = zeros(1,classes);  
        resourceBlockingStatesTemp = zeros(1,classes);
        fragmentationBlockingStatesTemp = zeros(1,classes);
        possibleStatesTransitionForClassesTemp = zeros(1,classes);
        for c =1: classes
            sum1 =0;
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
                    sum1 =sum1+1;
                    check =1;
                   occupancyPattern(i)=guardBand;
                   for m = i+1 : i+bandwidthPerClass(c)-guardBand
                       occupancyPattern(m)=1;
                   end
                   occupancyPattern(m+1)=guardBand;
                   [trueOrFalse,index1] = OccupancyPatternFound(occupancyPattern,stateOccupancyPattern,1);
                   if (trueOrFalse)                      
                       stateOccupancyPattern = [stateOccupancyPattern; occupancyPattern]; 
                       % only for random (de)allocation
                       transitionStatesForClasses(k,length(stateOccupancyPattern(:,1)),c)=c; % 1 for arrival                      
                       transitionStatesForClasses(length(stateOccupancyPattern(:,1)),k,c)=-c; % 2 for departure
                       
                       % keep track of connections per states 
                       tempConnectionsPerClass = zeros(1, classes);
                       tempConnectionsPerClass(1,c)= 1;
                       connectionsPerClassPerState = [connectionsPerClassPerState; + connectionsPerClassPerState(k,:)+ tempConnectionsPerClass];
                   else
                       % forgot to include the following transitions previously
                       transitionStatesForClasses(k,index1,c)=c; % 1 for arrival                      
                       transitionStatesForClasses(index1,k,c)=-c; % 2 for departure
                   end
                end
            end 
            % check if a connection is blocked or accepted
            if (check)
                connectionNonBlockingStatesTemp(c)=1;
            else if( sum(stateOccupancyPattern(k,:)==0)< bandwidthPerClass(c))
                    resourceBlockingStatesTemp(c)=1;
                else 
                    fragmentationBlockingStatesTemp(c)= 1;
                end
            end
            possibleStatesTransitionForClassesTemp(c)=sum1;
        end
        connectionNonBlockingStates = [connectionNonBlockingStates;connectionNonBlockingStatesTemp];  
        resourceBlockingStates = [resourceBlockingStates;resourceBlockingStatesTemp];
        fragmentationBlockingStates= [fragmentationBlockingStates;fragmentationBlockingStatesTemp];
        possibleStatesTransitionForClasses = [possibleStatesTransitionForClasses;possibleStatesTransitionForClassesTemp];
    end 
    
    % Evaluate all possible connection leaving-requests
    %not needed
end


end







% numberOfStates =length(stateOccupancyPattern(:,1))
% 
% %[stateOccupancyPattern,resourceBlockingStates,fragmentationBlockingStates]
% 
% %find if a connection is present in a state
% connectionOccupationStates = zeros(1: classes);
% for n=2: numberOfStates
%     connectionOccupationStatesTemp = zeros(1:classes);
%     for c = 1: classes
%         for s=1:totalNumberOfSlots
%             if ((stateOccupancyPattern(n,s)==guardBand)&&(s+bandwidthPerClass(c)-1 <= totalNumberOfSlots))
%                 count = 1;
%                 while (stateOccupancyPattern(n,s+count)~=guardBand && (stateOccupancyPattern(n,s+count)==1))
%                         count=count+1;
%                         if(s+count>totalNumberOfSlots)
%                             break;
%                     end
%                 end
%                 if(count+1==bandwidthPerClass(c))
%                     connectionOccupationStatesTemp(c)=1;
%                     break;
%                 else
%                     if(s+count<totalNumberOfSlots)
%                         s= s+count;
%                     end
%                 end
%             end
%         end
%     end
%     connectionOccupationStates = [connectionOccupationStates;connectionOccupationStatesTemp];
%    
% end                  
% 
% %check if everything is correct
% 
%  if(length(connectionNonBlockingStates(:,1))~=(numberOfStates))
%      disp('error1')
%  end
%  if(length(connectionOccupationStates(:,1))~=numberOfStates)
%      disp('error2')
%  end
%  if (length(possibleStatesTransitionForClasses(:,1))~=numberOfStates)
%      disp('error3')
%  end
%  if (length(fragmentationBlockingStates(:,1))~=numberOfStates)
%      disp('error4')
%  end
%  
% 
% %Calculate Transition rate matrix
% totalRunNo=6;
% totalResourceBlockingProbability= zeros(1,totalRunNo);
% totalFragmentationBlockingProbability = zeros(1,totalRunNo);
% for runNo=1:totalRunNo
% loadPerLink=18*runNo;
% % for unioform distribution
% arrivalRatePerClass=(loadPerLink/sum(bandwidthPerClass));
% serviceRate = 1;
% 
% transitionRateMatrix=zeros(numberOfStates, numberOfStates);
% for i=1:numberOfStates
%     for j=i+1:numberOfStates
%         for c=1:classes           
%             if (transitionStatesForClasses(i,j,c)==c)
%                 transitionRateMatrix(i,j)= arrivalRatePerClass/possibleStatesTransitionForClasses(i,c);
%                 transitionRateMatrix(j,i)= serviceRate; % only for random-fit
%             end
%         end
%     end
%     transitionRateMatrix(i,i)= -sum(transitionRateMatrix(i,:));
% end
% temptransitionRateMatrix = transpose(transitionRateMatrix);
% temptransitionRateMatrix = [temptransitionRateMatrix ;ones(1,numberOfStates)];
% temptransitionRateMatrix = temptransitionRateMatrix(2:numberOfStates+1,:);
% 
% % solve equation Ax=b
% b = zeros(numberOfStates-1,1);
% b= [b;1];
% [stateProbabilities] = lsqr(temptransitionRateMatrix,b,1e-6,500);
% 
% % find blocking probabilities
% 
% resourceBlockingProbabilityPerClass= zeros(1,classes);
% fragmentationBlockingProbabilityPerClass= zeros(1,classes);
% for c =1: classes
%     sum1=0;
%     sum2=0;
%     for n =1: numberOfStates
%         if(resourceBlockingStates(n,c)==1)
%             sum1 =sum1+ stateProbabilities(n);
%         else if(fragmentationBlockingStates(n,c)==1)
%                 sum2 = sum2 + stateProbabilities(n);
%             end
%         end
%     end
%     resourceBlockingProbabilityPerClass(c)= sum1;
%     fragmentationBlockingProbabilityPerClass(c)=sum2  ; 
% end
% 
% totalResourceBlockingProbability(runNo) = sum(resourceBlockingProbabilityPerClass)/classes;
% totalFragmentationBlockingProbability(runNo) = sum( fragmentationBlockingProbabilityPerClass)/classes;
% 
% end
% totalResourceBlockingProbability
% totalFragmentationBlockingProbability 


    
    

