%clc; 
% Number of slots
%clearvars;
%tic;
totalNumberOfSlots=20;
bandwidthPerClass = [3,4]; % including guard band so bandwidth must be > 2

serviceRate = 1.0;
defragServiceRate=10;
policy =1; % 1 for first fit, and 2 for randomtFit 
DF =0 ; % 0 => without DF,; 1=> with DF 


routes=[1]; %1-hop [1]; 2-hop=> [1,0;0,1;1,1]; 3-node-3-link ring => [1,0,0;0,1,0;0,0,1;1,1,0;0,1,1;1,0,1];
numberOfRoutes=length(routes(:,1));
numberOfLinks = length(routes(1,:));

initialLoad = [0.1,0.6,1.2,2.4,3.6];%[0.001,0.008,0.05,0.1,0.15]; % 2-hop->[0.05,0.1,0.15,0.2,0.25]; 3-ring-> [0.001,0.008,0.05,0.1,0.15];

totalRunNo=length(initialLoad);
classes=length(bandwidthPerClass);
%guardBand =2;
stateMatrixColumnLength = totalNumberOfSlots+1;
if(policy==1)
    [stateOccupancyPattern,transitionsForClasses,fbStates,rbStates,possibleStatesTransitionForClasses,...
            numberOfDefragStates,allPossibleTransitionsDF,allPossibleTransitionsDepart,connectionsForDefragStates]= FirstFit(DF,totalNumberOfSlots,bandwidthPerClass,routes);
else if(policy==2)
        [stateOccupancyPattern,transitionsForClasses,fbStates,rbStates,possibleStatesTransitionForClasses,...
            numberOfDefragStates,allPossibleTransitionsDF,allPossibleTransitionsDepart,connectionsForDefragStates]= RandomFit(DF,totalNumberOfSlots,bandwidthPerClass,routes);
    end
end

numberOfOriginalStates = length(stateOccupancyPattern{1}(:,1));
numberOfStates=numberOfOriginalStates+numberOfDefragStates

% Calculate Transition rate matrix

overallBlockingProbability=zeros(classes,totalRunNo);
totalRBprobability= zeros(1,totalRunNo);
totalFBprobability = zeros(1,totalRunNo);
avgQueueLength= zeros(1,totalRunNo);
avgWaitTime= zeros(1,totalRunNo);
for runNo=1:totalRunNo
loadPerLink =  initialLoad(runNo); %initialLoad*runNo;

% for unioform distribution
arrivalRatePerClass= loadPerLink/(classes*numberOfRoutes); %sum(bandwidthPerClass);


transitionRateMatrix = TRMGenerationNetworkDF(arrivalRatePerClass,serviceRate,defragServiceRate,numberOfRoutes,numberOfOriginalStates,...
                                                        transitionsForClasses,possibleStatesTransitionForClasses,allPossibleTransitionsDF,allPossibleTransitionsDepart,connectionsForDefragStates);
   
    
%transitionRateMatrix = TransitionRateMatrixGeneration(arrivalRatePerClass,serviceRate,transitionStatesForClasses);

%transitionRateMatrix
% if(simulation==1)
%     stateProbabilities = MCMC(transitionRateMatrix); 
% else
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

% temptransitionRateMatrix = transpose(transitionRateMatrix);
% temptransitionRateMatrix = [temptransitionRateMatrix ;ones(1,numberOfStates)];
% index1=find(diag(temptransitionRateMatrix)==0,1);
% 
%  if(index1||index2)
%      temptransitionRateMatrix(index1,:)=[];
%  else
%      index2=find(diag(temptransitionRateMatrix)==-0,1);
%      if(index2)
%          temptransitionRateMatrix(index2,:)=[];
%      else
%          temptransitionRateMatrix = temptransitionRateMatrix(2:numberOfStates+1,:);
%      end
%  end


% solve equation Ax=b
b = [zeros(numberOfStates-1,1);1];
[stateProbabilities] = lsqr(temptransitionRateMatrix,b,1e-8,1000000);
if(sum(stateProbabilities<0))%-0.0000000001))
    disp('error in state Probabilities')
    index1=find(stateProbabilities<0);
    for i=1:length(index1)
        %fprintf('%d,',stateProbabilities(index1(i))); 
        stateProbabilities(index1(i))=0.0000000000001;
    end
end
%end

% calculate average que length and average waiting time  
   if(modelType)
      sum1=0;
        for n=1:numberOfDefragStates 
            for r =1: numberOfRoutes
                sum1=sum1+(connectionsForDefragStates(n,numberOfRoutes*classes+(r-1)*classes+1:numberOfRoutes*classes+r*classes)*transpose(bandwidthPerClass))*stateProbabilities(n+numberOfOriginalStates);
            end
        end
        avgQueueLength(runNo)=sum1/sum(stateProbabilities(numberOfOriginalStates+1:n+numberOfOriginalStates));
        avgWaitTime(runNo)= avgQueueLength(runNo)/initialLoad(runNo); %sum1/lambda, if service rate !=1
   end
 
% find blocking probabilities
%%% find state probabilities of NB and Blocking States

% occupancyPerState=connectionsPerClassPerState*transpose(bandwidthPerClass);
% uniqueStates=unique(occupancyPerState);
% uniqueError= zeros(1,length(uniqueStates));
% for i=2:length(uniqueStates)
%     index1= find(uniqueStates(i)==occupancyPerState);
%     A=zeros(1,length(index1));
%     for j=1:length(index1)
%         A(j)=stateProbabilities(index1(j));
%         %%% print to check 
%         if(uniqueStates(i)==8)
%            fprintf('%d,',A(j));
%         end
%     end
%     uniqueError(i)= var(A);
% end
% fprintf('\n%s','unique Error = ')
% for k=1:length(uniqueError)
%     fprintf('%d,',uniqueError(k));   
% end  

%%%%%% calculate probability of acceptance p_k(x)

% occupancyPerState=connectionsPerClassPerState*transpose(bandwidthPerClass);
% uniqueStates=unique(occupancyPerState);
% exactProb= zeros(classes,length(uniqueStates));
% approxProb=zeros(classes,length(uniqueStates));
% for i=1:length(uniqueStates)
%     index1= find(uniqueStates(i)==occupancyPerState);
%     
%     for k=1: classes 
%         A=0;
%         for j=1:length(index1)
%             if(connectionNonBlockingStates(index1(j),k))
%                exactProb(k,i)= exactProb(k,i)+stateProbabilities(index1(j));
%                approxProb(k,i)=approxProb(k,i)+1;
%             end
%             A = A+stateProbabilities(index1(j));
%         end
%         exactProb(k,i)= exactProb(k,i)/A;
%         approxProb(k,i)=approxProb(k,i)/length(index1);
%     end
% end
% fprintf('\n%s','Exact probability of acceptance = ')
% for s=1:length(uniqueStates)
%     fprintf('%d,',sum(exactProb(:,s))/classes);   
% end 
% fprintf('\n%s','Approx probability of acceptance = ')
% for s=1:length(uniqueStates)
%     fprintf('%d,',sum(approxProb(:,s))/classes);   
% end 
    
blockingProbabilityPerClass= zeros(1,numberOfRoutes*classes);
RBprobabilityPerClass= zeros(1,numberOfRoutes*classes);
FBprobabilityPerClass= zeros(1,numberOfRoutes*classes);
for c =1: numberOfRoutes*classes
%     sum1=0; 
%     for r=1:numberOfRoutes
%            
%         for n =1: numberOfStates
%                 if(blockingStates(n,r,c)==1)
%                     sum1 =sum1+ stateProbabilities(n);
%                 end 
%         end
%     end
%     blockingProbabilityPerClass(c)= sum1/numberOfRoutes;

    sum1=0;
    sum2=0;
    
    for n =1: numberOfStates
            if(rbStates(n,c)==1)
                sum1 =sum1+ stateProbabilities(n);
            else if(fbStates(n,c)==1)
                    sum2 = sum2 + stateProbabilities(n);
                end
            end 
           
    end
    RBprobabilityPerClass(c)= sum1;
    FBprobabilityPerClass(c)=sum2 ;
    
    blockingProbabilityPerClass(c) =RBprobabilityPerClass(c)+FBprobabilityPerClass(c);    
end
overallBlockingProbability(runNo) = sum(blockingProbabilityPerClass)/c;
totalRBprobability(runNo) = sum(RBprobabilityPerClass)/c;
totalFBprobability(runNo) = sum(FBprobabilityPerClass)/c;
end



%toc;

fprintf('\n%s','totalResourceBlockingProbability= ')
for k=1:totalRunNo
    fprintf('%d,',totalRBprobability(k));   
end
fprintf('\n%s','totalFragmentationBlockingProbability= ')
for k=1:totalRunNo
    fprintf('%d,',totalFBprobability(k));   
end

fprintf('\n%s','overallBlockingProbabilityDF = ')
for k=1:totalRunNo
    fprintf('%d,',overallBlockingProbability(k));   
end

fprintf('\n%s','Average Queue Length = ')
for k=1:totalRunNo
    fprintf('%d,',avgQueueLength(k));   
end

fprintf('\n%s','Average Waiting Time = ')
for k=1:totalRunNo
    fprintf('%d,',avgWaitTime(k));   
end

% fprintf('\n%s','overallBlockingProbabilityPerClass = ')
% for c=1:classes
%     for k=1:totalRunNo
%         fprintf('%d,',overallBlockingProbabilityPerClass(c,k));   
%     end
%     fprintf('\n')
% end
