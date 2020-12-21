function [stateOccupancyPattern,transitionForRoutesForClasses,fbStates,rbStates,possibleStatesTransitionForClasses,...
    defragStates,allPossibleTransitionsDF,allPossibleTransitionsDepart,connectionsForDefragStates]= FirstFit(DF,totalNumberOfSlots,bandwidthPerClass,routes)

classes=length(bandwidthPerClass);
numberOfRoutes=length(routes(:,1));
numberOfLinks = length(routes(1,:));
%Free =0; Used =1 and followd by remaingBandValue; 
remainingBand =-1;
stateOccupancyPattern={};
% initialize slot occupancy pattern 
for i=1:numberOfLinks 
    stateOccupancyPattern{i}(:,:)= zeros(1,totalNumberOfSlots);
end
validLinks={};
routeLength=zeros(1,numberOfRoutes);
denomFragMeasure=0; % to divide frag measure
for odPair=1:numberOfRoutes
    validLinks{odPair}=find(routes(odPair,:)==1);
    routeLength(odPair)=sum(routes(odPair,:));
    for c=1:classes
        denomFragMeasure=denomFragMeasure+routeLength(odPair)*(totalNumberOfSlots-bandwidthPerClass(c)+1);
    end

end
% find out: in a given state, how many possible transition can happen due
% to arrivals of a class request
possibleStatesTransitionForClasses = [];
oldLength=0;    

% determines if a transition is possible from one state to another   
transitionForRoutesForClasses=[];

% find if a state is a blocking state for class c due to less resources
%blockingStates=[];
fnbStates=zeros(1,numberOfRoutes*classes);% fragmentation states where DF could be possible
rbStates=zeros(1,numberOfRoutes*classes);
connectionsPerRoutePerClass=zeros(1,numberOfRoutes*classes);
fragmentMeasure(1) = 0; % to measure fragmentation
% count connections per class per state
%connectionsPerClassPerState = zeros(1, classes); % last column indicates if a normal state is a defragmentated state or not

% Evaluate all possible connection incoming requests

    while(length(stateOccupancyPattern{1}(:,1))> oldLength)
        begin = oldLength+1;
        oldLength = length(stateOccupancyPattern{1}(:,1));
        for loop =begin : oldLength
            nomFragMeasure=0;
            for odPair=1:numberOfRoutes 
                for c =1: classes
                    clm1=(odPair-1)*classes+c;
                    tempOccupancy=stateOccupancyPattern{validLinks{odPair}(1,1)}(loop,:); % just created for start of concatenation
                    for link=2:routeLength(odPair)
                        tempOccupancy=[tempOccupancy;stateOccupancyPattern{validLinks{odPair}(1,link)}(loop,:)];  
                    end
                    % find if FB or RB
                    numOfFreeConsSlots= min(sum(tempOccupancy==0,2)); % find minimum free slots over all routing links
                        tempOccupancy=all(tempOccupancy==0,1);% column-wise check if all elements are zero
                        tempOccupancy=~tempOccupancy;
                        b = diff([0 tempOccupancy==0 0]);
                       max_res = find(b==-1) - find(b==1);
                       % MATLAB® evaluates compound expressions from left to right, adhering to operator precedence rules. 
                       if ((isempty(max_res)) || (max(max_res)<bandwidthPerClass(c))) % | => logical or
                           %blockingStates(loop,odPair,c)=1;
                           if(numOfFreeConsSlots<bandwidthPerClass(c))
                               rbStates(loop,clm1)=1;
                               fnbStates(loop,clm1)=0;
                           else % a fb state 
                               fnbStates(loop,clm1)=1;
                               rbStates(loop,clm1)=0;                               
                           end
                           possibleStatesTransitionForClasses(loop,odPair,c)=0;
                       else
%                            if(max_res<bandwidthPerClass(c))
%                              blockingStates(loop,odPair,c)=1;
%                              possibleStatesTransitionForClasses(loop,odPair,c)=0;
%                            else
                               %blockingStates(loop,odPair,c)=0;
                               rbStates(loop,clm1)=0;
                               fnbStates(loop,clm1)=0;
                               %possibleStatesTransitionForClasses(loop,odPair,c)=0;
                               xx= find(tempOccupancy==0);                      
                               valid=0;
                               index1=0;
                               for p=1:length(xx)-bandwidthPerClass(c)+1
                                   if (xx(p+bandwidthPerClass(c)-1)==xx(p)+bandwidthPerClass(c)-1) % finds if contiguos free slice
                                       valid=valid +1; 
                                       index1(valid)=xx(p);
                                       break;
                                   end
                               end
                               nomFragMeasure=nomFragMeasure+routeLength(odPair)*valid;
                               possibleStatesTransitionForClasses(loop,odPair,c)=1;
                               for i=1: 1
                                   stateOccupancyTemp=zeros(numberOfLinks,totalNumberOfSlots);
                                   for link=1:numberOfLinks %occupancy of all links forms a vector                                   
                                       if(routes(odPair,link)==0)
                                           stateOccupancyTemp(link,:)=stateOccupancyPattern{link}(loop,:);
                                       else
                                           stateOccupancyTemp(link,:)=stateOccupancyPattern{link}(loop,:);
                                           stateOccupancyTemp(link,index1(i))=odPair;
                                           stateOccupancyTemp(link,index1(i)+1:index1(i)+bandwidthPerClass(c)-1)=remainingBand;
                                       end
                                   end

                                   counter = OccupancyVectorFound(stateOccupancyTemp,stateOccupancyPattern,numberOfLinks);
                                   if(counter) % occupancy vector found
                                      transitionForRoutesForClasses(loop,counter,odPair,c)=c; % 1 for arrival                      
                                      transitionForRoutesForClasses(counter,loop,odPair,c)=-c; % 2 for departure      
                                   else % create new states
                                       for link=1:numberOfLinks
                                           stateOccupancyPattern{link}(length(stateOccupancyPattern{link}(:,1))+1,:)=stateOccupancyTemp(link,:);
                                       end
                                       connectionsPerRoutePerClass=[connectionsPerRoutePerClass;connectionsPerRoutePerClass(loop,:)];
                                       connectionsPerRoutePerClass(length(connectionsPerRoutePerClass(:,1)),clm1)=connectionsPerRoutePerClass(length(connectionsPerRoutePerClass(:,1)),(odPair-1)*classes+c)+1;
                                       % only for random (de)allocation
                                       transitionForRoutesForClasses(loop,length(stateOccupancyPattern{1}(:,1)),odPair,c)=c; % 1 for arrival                      
                                       transitionForRoutesForClasses(length(stateOccupancyPattern{1}(:,1)),loop,odPair,c)=-c; % 2 for departure
                                       fnbStates=[fnbStates;zeros(1,numberOfRoutes*classes)];
                                       rbStates=[rbStates;zeros(1,numberOfRoutes*classes)];
                                   end
                               end
                          % end

                        end
                    end 
            end 
            fragmentMeasure(loop)=1-nomFragMeasure/denomFragMeasure;
            
             % Evaluate all possible connection leaving-requests     
            for odPair=1:numberOfRoutes 
                occupancyPattern = stateOccupancyPattern{validLinks{odPair}(1,1)}(loop,:); 
                index1=find(occupancyPattern==odPair);
                for c =1: classes % find connection location                   
                    validIndex=zeros(1,length(index1)) ;
                    for i=1:length(index1)
                        if(index1(i)+bandwidthPerClass(c)<=totalNumberOfSlots)
                            if((sum(occupancyPattern(index1(i)+1:index1(i)+bandwidthPerClass(c))==remainingBand)==bandwidthPerClass(c)-1)&&(occupancyPattern(index1(i)+bandwidthPerClass(c))~=remainingBand))
                               validIndex(i)= index1(i); 
                            end
                        else
                            if(sum(occupancyPattern(index1(i)+1:totalNumberOfSlots)==remainingBand)==bandwidthPerClass(c)-1 )
                               validIndex(i)= index1(i); 
                            end
                        end
                    end
                    validIndex=validIndex(find(validIndex>0));

                    for i=1:length(validIndex)
                        stateOccupancyTemp=zeros(numberOfLinks,totalNumberOfSlots);
                        for link=1:numberOfLinks %occupancy of all links forms a vector                                   
                            if(routes(odPair,link)==0)
                               stateOccupancyTemp(link,:)=stateOccupancyPattern{link}(loop,:);
                            else
                               stateOccupancyTemp(link,:)=stateOccupancyPattern{link}(loop,:);
                               stateOccupancyTemp(link,validIndex(i):validIndex(i)+bandwidthPerClass(c)-1)=0;
                            end
                        end
                        counter = OccupancyVectorFound(stateOccupancyTemp,stateOccupancyPattern,numberOfLinks);
                        if(counter) % occupancy vector found
                            transitionForRoutesForClasses(loop,counter,odPair,c)=-c; % 2 for departure      
                        else % create a new state
 
                            for link=1:numberOfLinks
                               stateOccupancyPattern{link}(length(stateOccupancyPattern{link}(:,1))+1,:)=stateOccupancyTemp(link,:);
                            end
                            % only for random (de)allocation
                            transitionForRoutesForClasses(loop,length(stateOccupancyPattern{1}(:,1)),odPair,c)=-c; % for departure 
                            clm1=(odPair-1)*classes+c;
                            connectionsPerRoutePerClass=[connectionsPerRoutePerClass;connectionsPerRoutePerClass(loop,:)]; % remove a connection
                            connectionsPerRoutePerClass(length(connectionsPerRoutePerClass(:,1)),clm1)=connectionsPerRoutePerClass(length(connectionsPerRoutePerClass(:,1)),(odPair-1)*classes+c)-1; 
                            fnbStates=[fnbStates;zeros(1,numberOfRoutes*classes)];
                            rbStates=[rbStates;zeros(1,numberOfRoutes*classes)];
                        end
                    end
                end
            end
        end 
    end
 numberOfOriginalStates = length(stateOccupancyPattern{1}(:,1));
 
%columnLength = length(stateOccupancyPattern(1,:));

allPossibleTransitionsDF = zeros(numberOfOriginalStates,1); % 1 for RSD state equivalent to empty state 

%connectionsForDefragmentationStates = zeros(numberOfOriginalStates,classes);

defragStates=0;
connectionsForDefragStates=zeros(1,2*numberOfRoutes*classes);
allPossibleTransitionsDepart=zeros(length(allPossibleTransitionsDF),numberOfRoutes*classes);

if(DF==0)
    fbStates=fnbStates;
else
    fbStates=zeros(numberOfOriginalStates,numberOfRoutes*classes); % actual FB states in DF
% generate DF states corresponding to FB states
 temp=find(sum(fnbStates(:,:),2)>0);
 for oo = 1: length(temp)
     for odPair = 1: numberOfRoutes
        for c=1: classes
%            if(isempty(temp)||temp(ii)>numberOfOriginalStates)
%                disp('error')
%            end
           
           if(fnbStates(temp(oo),(odPair-1)*classes+c)==1)
               loop=temp(oo);
               clm1=(odPair-1)*classes+c;
               tempConnectionsPerClass = connectionsPerRoutePerClass(loop,:);
               tempConnectionsPerClass(clm1)= tempConnectionsPerClass(clm1)+1; % 0 for DaaS model; and 1 for DaaS-Delay model
               defragStateFound = ismember(connectionsPerRoutePerClass(:,:),tempConnectionsPerClass,'rows');
               index2 = find(defragStateFound == 1); %  states with same no. of connections 
               if(~isempty(index2)) % it means the DF state is a valid one, after DF target states are present
                  tempConnectionsPerClass=zeros(1,numberOfRoutes*classes);
                  tempConnectionsPerClass(clm1)=1;
                  tempConnectionsPerClassDF = [connectionsPerRoutePerClass(loop,:),tempConnectionsPerClass];% serving and waiting connection in a possible DF state
                  [defragStateFound,index1] = ismember(tempConnectionsPerClassDF,connectionsForDefragStates,'rows');
                  if(defragStateFound)   
                     transitionForRoutesForClasses(loop,index1+numberOfOriginalStates-1,odPair,c)=c; % from fragmented state to defragmented, -1 because we added dummy RSD state for ismember
                  else
                       defragStates=defragStates+1;
                       connectionsForDefragStates =[connectionsForDefragStates;tempConnectionsPerClassDF];
                       %normalOrDefragOrSecurity=[normalOrDefragOrSecurity;1];
                       index1 = numberOfOriginalStates+defragStates; %length(normalOrDefragOrSecurity);
                       transitionForRoutesForClasses(loop,index1,odPair,c)=c; % from fragmented state to defragmented
                       tempNumberOfTransitions = 0;
                       % find minimum fragmented states
                       leastFragMeasures=10; % a random higher value 
                       for j = 1: length(index2) 
                           leastFragMeasures=min(leastFragMeasures,fragmentMeasure(index2(j)));
                       end
                       for j = 1: length(index2) % only information we need is to have same type of connection in these states
                           if(leastFragMeasures==fragmentMeasure(index2(j))) % if  RSD target states are only defragmented states
                             transitionForRoutesForClasses(index1,index2(j),1,1)=1; % transition from RSD to regular states
                             % count all possibility of transitions 
                             tempNumberOfTransitions = tempNumberOfTransitions +1;
                           end
                       end
                       %tempNumberOfTransitions = length(index2); % this is commented when only non-fragmented states are chosen
                       allPossibleTransitionsDF = [allPossibleTransitionsDF;tempNumberOfTransitions];
                  end
               else
                   fbStates(loop,clm1)=1;% these regular states are FB states, where DF is not possible
               end
           end
        end
   end
end


% delete extra unused defrag states
 connectionsForDefragStates= connectionsForDefragStates(2:defragStates+1,:);
   
   % map transitions due to arrivals and departure in RSD states
 
oldLength=0;    
% Evaluate all possible connection arrival, here departure leads to  defragmented states
while(defragStates> oldLength)
    begin = oldLength+1;
    oldLength = defragStates;
    for i =begin : oldLength       %1:oldLength %   
        allPossibleTransitionsDepart(i+numberOfOriginalStates,:)=zeros(1,numberOfRoutes*classes);
        for odPair=1:numberOfRoutes
           for c = 1:classes
           % due to arrival 
               clm1=(odPair-1)*classes+c;
               connectionsForDefragStatesTemp = connectionsForDefragStates(i,:);
               connectionsForDefragStatesTemp(clm1+numberOfRoutes*classes)= connectionsForDefragStatesTemp(clm1+numberOfRoutes*classes)+1; % add in waiting connections

               [defragStateFound,index1] = ismember(connectionsForDefragStatesTemp,connectionsForDefragStates,'rows');
               if(defragStateFound)              
                  transitionForRoutesForClasses(i+numberOfOriginalStates,index1+numberOfOriginalStates,odPair,c)= c; % for arrival in RSD state
                  rbStates(i+numberOfOriginalStates,clm1)=0;
               else
                   tempConnectionsPerClass=connectionsForDefragStatesTemp(1:numberOfRoutes*classes)+connectionsForDefragStatesTemp(numberOfRoutes*classes+1:2*numberOfRoutes*classes);
                   % generate all transitions from a security state to normal states
                   defragStateFound = ismember(connectionsPerRoutePerClass(:,:),tempConnectionsPerClass,'rows');
                   index2 = find(defragStateFound == 1); %  states with same no. of connections 
                   if(~isempty(index2)) % there must be atleast a state which can be reached after defragmentation
                       defragStates=defragStates+1;
                       rbStates(i+numberOfOriginalStates,clm1)=0;
                       connectionsForDefragStates =[connectionsForDefragStates;connectionsForDefragStatesTemp];
                       %normalOrDefragOrSecurity=[normalOrDefragOrSecurity;1];
                       index1 = numberOfOriginalStates+defragStates; %length(normalOrDefragOrSecurity);
                       transitionForRoutesForClasses(i+numberOfOriginalStates,index1,odPair,c)=c; % from an RSD state to another RSD due to arrival
                       tempNumberOfTransitions = 0;
                       % find minimum fragmented states
                       leastFragMeasures=10;
                       for j = 1: length(index2) 
                           leastFragMeasures=min(leastFragMeasures,fragmentMeasure(index2(j)));
                       end
                       for j = 1: length(index2) % only information we need is to have same type of connection in these states
                           if(leastFragMeasures==fragmentMeasure(index2(j))) % if  RSD target states are only defragmented states
                             transitionForRoutesForClasses(index1,index2(j),1,1)=1; % transition from RSD to regular non-fragmented states
                             % count all possibility of transitions 
                             tempNumberOfTransitions = tempNumberOfTransitions +1;
                           end
                       end
                       %tempNumberOfTransitions = length(index2); % this is commented when only non-fragmented states are chosen
                       allPossibleTransitionsDF = [allPossibleTransitionsDF;tempNumberOfTransitions];
                      % allPossibleTransitionsDepart=[allPossibleTransitionsDepart;0];
                   else
                       rbStates(i+numberOfOriginalStates,clm1)=1;
                   end
               end
           % due to departure

               connectionsForDefragStatesTemp = connectionsForDefragStates(i,:);
               connectionsForDefragStatesTemp(clm1)= connectionsForDefragStatesTemp(clm1)-1;
               if(connectionsForDefragStatesTemp(clm1)>=0)                        
                   tempConnectionsPerClass=connectionsForDefragStatesTemp(1:numberOfRoutes*classes)+connectionsForDefragStatesTemp(numberOfRoutes*classes+1:2*numberOfRoutes*classes);
                   % generate all transitions from a security state to normal states
                   defragStateFound = ismember(connectionsPerRoutePerClass(:,:),tempConnectionsPerClass,'rows');
                   index2 = find(defragStateFound == 1); %  states with same no. of connections 
                   index1=i+numberOfOriginalStates; % from RSD state to regular state due to departure

                   tempNumberOfTransitions = zeros(1,numberOfRoutes*classes);
                   % find minimum fragmented states
                       leastFragMeasures=10;
                       for j = 1: length(index2) 
                           leastFragMeasures=min(leastFragMeasures,fragmentMeasure(index2(j)));
                       end
                       for j = 1: length(index2) % only information we need is to have same type of connection in these states
                           if(leastFragMeasures==fragmentMeasure(index2(j))) % if  RSD target states are only defragmented states
                              transitionForRoutesForClasses(index1,index2(j),odPair,c)=-c; % transition from RSD to regular states
                             % count all possibility of transitions 
                              tempNumberOfTransitions(clm1) = tempNumberOfTransitions(clm1) +1;
                           end
                       end
                   %tempNumberOfTransitions = length(index2); % this is commented when only non-fragmented states are chosen
                   allPossibleTransitionsDepart(i+numberOfOriginalStates,clm1)=tempNumberOfTransitions(clm1);
               end     
           end
        end
    end
end
fbStates=[fbStates;zeros(defragStates,numberOfRoutes*classes)];   
end