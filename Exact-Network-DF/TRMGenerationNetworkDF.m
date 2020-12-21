function transitionRateMatrix = TRMGenerationNetworkDF(arrivalRatePerClass,serviceRate,defragServiceRate,numberOfRoutes,numberOfStatesOLD,...
                                                        transitionStatesForClasses,possibleStatesTransitionForClasses,allPossibleTransitionsDF,allPossibleTransitionsDepart,connectionsForDefragStates)
classes = length(transitionStatesForClasses(1,1,1,:));
numberOfStates = length(transitionStatesForClasses(:,1,1,1));
transitionRateMatrix=zeros(numberOfStates, numberOfStates);

for i=1:numberOfStates
    for j=1:numberOfStates
        if(i~=j)
            if(i<=numberOfStatesOLD && j <= numberOfStatesOLD)
                for r=1:numberOfRoutes
                    for c=1:classes 
                        if (transitionStatesForClasses(i,j,r,c)==c)
                            transitionRateMatrix(i,j)=arrivalRatePerClass/possibleStatesTransitionForClasses(i,r,c); 
                        else if(transitionStatesForClasses(i,j,r,c)==-c)
                                transitionRateMatrix(i,j)= serviceRate; 
                             end
                        end
                    end
                end
            else
                if(i>numberOfStatesOLD && j>numberOfStatesOLD)
                    for r=1:numberOfRoutes
                        for c=1:classes 
                           if (transitionStatesForClasses(i,j,r,c)==c)
                            transitionRateMatrix(i,j)=arrivalRatePerClass; % transition between defrag states due to arrival of a class 
%                            else
%                                if(transitionStatesForClasses(i,j,r,c)==-c)
%                                    transitionRateMatrix(i,j)= connectionsForDefragStates(i-numberOfStatesOLD,(odPair-1)*classes+c)*serviceRate; % from defrag state to another defrag state due to departure of a request
%                                end
                           end
                        end
                    end
                else
                    if(i<=numberOfStatesOLD) % and j> numberOfStatesOLD
                        for r=1:numberOfRoutes
                            for c=1:classes 
                               if (transitionStatesForClasses(i,j,r,c)==c)
                                  transitionRateMatrix(i,j)= arrivalRatePerClass; 
                               end
                            end
                        end
                    else %if(i>numberOfStatesOLD) % and j<= numberOfStatesOLD
                        if (transitionStatesForClasses(i,j,1,1)==1) % from defrag states to regular states after defrag 
                                 transitionRateMatrix(i,j)= (defragServiceRate)/allPossibleTransitionsDF(i);
                        else 
                            for r=1:numberOfRoutes
                                for c=1:classes
                                    if (transitionStatesForClasses(i,j,r,c)==-c) % from defrag states to regular states due to departure in defrag states
                                        %if(allPossibleTransitionsDepart(i,c)~=0)
                                            transitionRateMatrix(i,j)= (connectionsForDefragStates(i-numberOfStatesOLD,(r-1)*classes+c)*serviceRate)/allPossibleTransitionsDepart(i,(r-1)*classes+c);
                                    end
                                end
                            end
                        end
                    end
                end

            end
        end

    end
    transitionRateMatrix(i,i)= -sum(transitionRateMatrix(i,:));
end
 
end
