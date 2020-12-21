function [probOfStateInNonBlocking,probOfStateInFB,probOfStateInRB]= GetProbOfTransitOfClassesApprox2(bandwidthPerClass,numberOfSlots,oneDsystemStates,numOfNonFBstates,numOfFBstates,numOfRBstates,avgOccupiedSlots)

numberOfStates =length(oneDsystemStates); % state represent occupied slots

classes= length(bandwidthPerClass);

probOfStateInNonBlocking= zeros(numberOfStates,classes);
probOfStateInFB= zeros(numberOfStates,classes);
probOfStateInRB= zeros(numberOfStates,classes);

%if(oneD)
    probOfStateInNonBlocking(1,:)=1;
    probOfStateInRB(numberOfStates,:)=1;
    for stateNo=2:numberOfStates-1
        E=numberOfSlots -oneDsystemStates(stateNo); %numberOfSlots -occupancyPerState(index1(temp));%numberOfFreeSlots
        for c=1:classes 
            if(E>=bandwidthPerClass(c)) 
                totalStates=numOfNonFBstates(stateNo,c)+numOfFBstates(stateNo,c)+numOfRBstates(stateNo,c);
                if(numOfFBstates(stateNo,c)==0)
                    probOfStateInNonBlocking(stateNo,c)=1;
                else
                    probOfStateInNonBlocking(stateNo,c)=numOfNonFBstates(stateNo,c)/totalStates+ (numOfFBstates(stateNo,c)/totalStates)*exp(-((log(oneDsystemStates(stateNo)/avgOccupiedSlots))*(avgOccupiedSlots/numberOfSlots))^2);                    
%                    probOfStateInNonBlocking(stateNo,c)=numOfNonFBstates(stateNo,c)/totalStates+ (numOfFBstates(stateNo,c)/totalStates)*exp(-abs((log(oneDsystemStates(stateNo)/avgOccupiedSlots))*(avgOccupiedSlots/numberOfSlots)));
                    %probOfStateInNonBlocking(stateNo,c)=numOfNonFBstates(stateNo,c)/totalStates+ (numOfFBstates(stateNo,c)/totalStates)*(1/(1+exp((oneDsystemStates(stateNo)/numberOfSlots-avgOccupiedSlots))));                    
                    probOfStateInFB(stateNo,c) =1- probOfStateInNonBlocking(stateNo,c);
                end
                if(probOfStateInNonBlocking(stateNo,c)>1)
                    %fprintf('%s,%d','error in calculation of p_k',probOfStateInNonBlocking(stateNo,c)-1);
                    probOfStateInNonBlocking(stateNo,c)=1;
                    probOfStateInFB(stateNo,c) =0;
                end
            else
                probOfStateInRB(stateNo,c) = 1;
            end
        end        
    end

end
