function    stateProbabilities=CalculateStateProbabilities(transitionRateMatrix) 
    numberOfStates= length(transitionRateMatrix(1,:));
    index1=find(diag(transitionRateMatrix)==0);
    tempRow= ones(1,numberOfStates);
    for i=1: length(index1)
        tempRow(index1(i))=0;
    end
    temptransitionRateMatrix = [transpose(transitionRateMatrix);tempRow];
     %temptransitionRateMatrix = [temptransitionRateMatrix ;ones(1,numberOfMacroStates)];
     index1=find(diag(temptransitionRateMatrix)==0);
     if(~isempty(index1))
         temptransitionRateMatrix(index1(1),:)=[];
     else
         temptransitionRateMatrix = temptransitionRateMatrix(2:numberOfStates+1,:);
     end

    % solve equation Ax=b
    b = zeros(numberOfStates,1);
    b(numberOfStates) = 1;
    [stateProbabilities] = lsqr(temptransitionRateMatrix,b,1e-9,100000000);
    
    if(sum(stateProbabilities<0))
       % disp('error in state Probabilities')
        index1=find(stateProbabilities<0);
        for i=1:length(index1)
            stateProbabilities(index1(i))=1e-10;
        end
    end
end