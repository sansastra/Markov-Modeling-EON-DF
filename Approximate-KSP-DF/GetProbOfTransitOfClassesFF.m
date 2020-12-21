function [probOfStateInNB,probOfStateInFB,probOfStateInRB,numOfNonFBstates,numOfFBstates,numOfRBstates]= GetProbOfTransitOfClassesFF(macroSystemStates,bandwidthPerClass,numberOfSlots,oneD, occupancyPerMacroState,oneDsystemStates)

if(oneD)
    numberOfStates =length(oneDsystemStates); % state represent occupied slots
else
    numberOfStates = length(macroSystemStates(:,1)); % state is Macrostate, representing connections per class
end
classes= length(bandwidthPerClass);

probOfStateInNB= zeros(numberOfStates,classes);
probOfStateInFB= zeros(numberOfStates,classes);
probOfStateInRB= zeros(numberOfStates,classes);

numOfNonFBstates=zeros(numberOfStates,classes);
numOfFBstates=zeros(numberOfStates,classes);
numOfRBstates=zeros(numberOfStates,classes);

[stateOccupancyPattern,transitionStatesForClasses,connectionNonBlockingStates,...
    resourceBlockingStates,fragmentationBlockingStates,connectionsPerClassPerState]= FirstFit(numberOfSlots,bandwidthPerClass);
stateOccupancyPattern= stateOccupancyPattern(:,1:numberOfSlots); % remove last -1 
ocuupancyPerState= sum(stateOccupancyPattern~=0,2);

%stateOccupancyPatternTemp{1,:}= stateOccupancyPattern(1,:);
probOfStateInNB(1,:)= ones(1,classes);
probOfStateInFB(1,:)= zeros(1,classes);
probOfStateInRB(1,:)= zeros(1,classes);

numOfNonFBstates(1,:)=ones(1,classes);

if(oneD)
    for i=2: numberOfStates
        index1= find(oneDsystemStates(i)==ocuupancyPerState); 
        tempLength=length(index1);
        %P1= zeros(tempLength,numberOfSlots);
        tempProbOfNB= zeros(1,classes);
        tempProbOfFB= zeros(1,classes);
        tempProbOfRB= zeros(1,classes);
        for j=1: length(index1)
            %P1(j,:)=stateOccupancyPattern(index1(j),:);
            tempProbOfNB=tempProbOfNB +connectionNonBlockingStates(index1(j),:);
            tempProbOfFB=tempProbOfFB +fragmentationBlockingStates(index1(j),:);
            tempProbOfRB=tempProbOfRB +resourceBlockingStates(index1(j),:);
        end
        %stateOccupancyPatternTemp{i,:}= P1;
        probOfStateInNB(i,:)= tempProbOfNB/tempLength;
        probOfStateInFB(i,:)= tempProbOfFB/tempLength;
        probOfStateInRB(i,:)= tempProbOfRB/tempLength;
        
        numOfNonFBstates(i,:)= tempProbOfNB;
        numOfFBstates(i,:)= tempProbOfFB;
        numOfRBstates(i,:)= tempProbOfRB;
    end
else
    for i=2: numberOfStates
        [index1, found]= ismember(connectionsPerClassPerState(:,:),macroSystemStates(i,:),'rows');
        index1 =find(index1==1);
        tempLength=length(index1);
        P1= zeros(tempLength,numberOfSlots);
        tempProbOfNB= zeros(1,classes);
        tempProbOfFB= zeros(1,classes);
        tempProbOfRB= zeros(1,classes);
        for j=1: length(index1)
            P1(j,:)=stateOccupancyPattern(index1(j),:);
            tempProbOfNB=tempProbOfNB +connectionNonBlockingStates(index1(j),:);
            tempProbOfFB=tempProbOfFB +fragmentationBlockingStates(index1(j),:);
            tempProbOfRB=tempProbOfRB +resourceBlockingStates(index1(j),:);
        end
        stateOccupancyPatternTemp{i,:}= P1;
        probOfStateInNB(i,:)= tempProbOfNB/tempLength;
        probOfStateInFB(i,:)= tempProbOfFB/tempLength;
        probOfStateInRB(i,:)= tempProbOfRB/tempLength;
    end
end
    
    