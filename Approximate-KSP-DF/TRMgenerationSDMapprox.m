function [transitionRateMatrix,blockingStates] = TRMgenerationSDMapprox(arrivalRatesPerState,serviceRate,systemStates,oneD,occupancyPerState,bandwidthPerClass,oneDsystemStates,avgCallClassPer1Dstate)

classes = length(systemStates(1,:));
if(oneD)
    numberOfStates = length(oneDsystemStates);
    %newArrivalRates=zeros(numberOfStates,classes);
    blockingStates=zeros(numberOfStates, classes);
    transitionRateMatrix=zeros(numberOfStates, numberOfStates);
     
    for i=1:numberOfStates % start from 1 => empty state is indexed by 1
            for c=1:classes
                tempState=oneDsystemStates(i)+bandwidthPerClass(c);
                j=find(oneDsystemStates ==tempState);
                if(~isempty(j))
                    transitionRateMatrix(i,j)= arrivalRatesPerState(i,c);
                    
                    transitionRateMatrix(j,i)= avgCallClassPer1Dstate(j,c)*serviceRate; 
                else
                    blockingStates(i,c)=1;
                end
                
                %tempState(c)=tempState(c)-1; instead add sum in a separate loop
            end 
    end
    for i=1:numberOfStates
        if(sum(transitionRateMatrix(i,:))>0)
           transitionRateMatrix(i,i)= -sum(transitionRateMatrix(i,:));
        end
    end
else
    numberOfStates = length(systemStates(:,1));
    blockingStates=zeros(numberOfStates, classes);
    transitionRateMatrix=zeros(numberOfStates, numberOfStates);
    for i=1:numberOfStates  
        for c=1:classes
            tempState=systemStates(i,:);
            tempState(c)=tempState(c)+1;
            [found, index1] = ismember(tempState, systemStates, 'rows');
            if(found)                    
                transitionRateMatrix(i,index1)= arrivalRatesPerState(i,c);                     
                transitionRateMatrix(index1,i)= systemStates(index1,c)*serviceRate; 
            else
                blockingStates(i,c)=1;
            end
            %tempState(c)=tempState(c)-1; instead add sum in a separate loop
        end 
        % add defrag transition also
       
    end
    for i=1:numberOfStates
        if(sum(transitionRateMatrix(i,:))>0)
         transitionRateMatrix(i,i)= -sum(transitionRateMatrix(i,:));
        end
    end
end
end