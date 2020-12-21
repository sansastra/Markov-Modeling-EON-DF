function [probOfStateInNonBlocking,probOfStateInFB,probOfStateInRB,numOfNonFBstates,numOfFBstates,numOfRBstates]= GetProbOfTransitOfClasses(systemStates,bandwidthPerClass,numberOfSlots,oneD, occupancyPerState,oneDsystemStates)
if(oneD)
    numberOfStates =length(oneDsystemStates); % state represent occupied slots
else
    numberOfStates = length(systemStates(:,1)); % state is Macrostate, representing connections per class
end
classes= length(bandwidthPerClass);
%numberOfRoutes=2;
numOfNonFBstates= zeros(numberOfStates,classes);
numOfFBstates= zeros(numberOfStates,classes);
numOfRBstates= zeros(numberOfStates,classes);

probOfStateInNonBlocking= zeros(numberOfStates,classes);
probOfStateInFB= zeros(numberOfStates,classes);
probOfStateInRB= zeros(numberOfStates,classes);

if(oneD)
    probOfStateInNonBlocking(1,:)=1;
    probOfStateInRB(numberOfStates,:)=1;
    
    
    numOfNonFBstates(1,:)=1;
    numOfRBstates(numberOfStates,:)=1; % in realility the number of exact states in the last 1D state could be much higher but for probability calculataion it is irrelavent 
    
    for stateNo=2:numberOfStates-1
        E=numberOfSlots -oneDsystemStates(stateNo); %numberOfSlots -occupancyPerState(index1(temp));%numberOfFreeSlots
        index1=find(occupancyPerState==oneDsystemStates(stateNo));
        for c=1:classes 
            totalNF=0;
            totalFB=0;
            totalRB=0;
            for temp= 1: length(index1)
                tempNF=0;
                tempRB =0;
                N = sum(systemStates(index1(temp),:)); % totalConnections
                W = nchoosek(E+N,N); %factorial(E+N)/(factorial(E)*factorial(N)); %factorial(numberOfFreeSlots+sum(systemStates(stateNo,:)))/(factorial(numberOfFreeSlots)*denom);

                % will only work for single core
                if(E>=bandwidthPerClass(c))
                    for i=1:N+1
                        if(E>=i*bandwidthPerClass(c))
                           %tempNF=tempNF+((-1)^(i+1))*(factorial(N+1)/(factorial(N+1-i)*factorial(i))*(factorial(E+N-i*bandwidthPerClass(c))/(factorial(E-i*bandwidthPerClass(c))*factorial(N))));   
                           tempNF=tempNF+((-1)^(i+1))*nchoosek(N+1,i)*nchoosek(E+N-i*bandwidthPerClass(c), N);
                        end
                    end
                    tempFB=uint64(W-tempNF); % subtraction of same number does not result in zero
                    tempFB=double(tempFB);
                else
                    tempFB=0;
                    tempRB=W;
                end
                product=1;
                for p=1: classes %*numberOfRoutes
                    product = product*factorial(systemStates(index1(temp),p));
                end
                totalNF= totalNF+ tempNF*(factorial(N)/product);
                totalFB = totalFB+tempFB*(factorial(N)/product);
                totalRB=totalRB+tempRB*(factorial(N)/product);
            end
            
%             % calculate with another approximation
%             tempNF=0;
%             for i=1:oneDsystemStates(stateNo)+1
%                 if(E>=i*bandwidthPerClass(c))
%                    tempNF=tempNF+((-1)^(i+1))*nchoosek(oneDsystemStates(stateNo)+1,i)*nchoosek(numberOfSlots-i*bandwidthPerClass(c), oneDsystemStates(stateNo));
%                 end
%             end
%             probOfStateInNonBlocking(stateNo,c)=tempNF/nchoosek(numberOfSlots,E);
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            totalStates=totalNF+totalFB+totalRB;
            
            probOfStateInNonBlocking(stateNo,c)=totalNF/totalStates;
            probOfStateInFB(stateNo,c) = totalFB/totalStates;
            probOfStateInRB(stateNo,c) = totalRB/totalStates;
            
            numOfNonFBstates(stateNo,c)=totalNF;
            numOfFBstates(stateNo,c)=totalFB;
            numOfRBstates(stateNo,c)=totalRB;
        end        
    end
else
    for stateNo=1:numberOfStates
        E=numberOfSlots - occupancyPerState(stateNo);%numberOfFreeSlots
        N= sum(systemStates(stateNo,:)); % totalConnections
        totalPerm1 = nchoosek(E+N,N); %factorial(numberOfFreeSlots+sum(systemStates(stateNo,:)))/(factorial(numberOfFreeSlots)*denom);

        for c=1:classes 
            totalNF=0;
            totalRB =0;
            % will only work for single core
            if(E>=bandwidthPerClass(c))
                for i=1:N+1
                    if(E-i*bandwidthPerClass(c)>=0)
                       totalNF=totalNF+((-1)^(i+1))*nchoosek(N+1,i)*nchoosek(E+N-i*bandwidthPerClass(c), N);
                    end
                end
                totalFB=totalPerm1-totalNF;
            else
                totalFB=0;
                totalRB=totalPerm1;
            end
            probOfStateInNonBlocking(stateNo,c)=totalNF/totalPerm1;
            probOfStateInFB(stateNo,c) = totalFB/totalPerm1;
            probOfStateInRB(stateNo,c) = totalRB/totalPerm1;
        end
    end
end
end