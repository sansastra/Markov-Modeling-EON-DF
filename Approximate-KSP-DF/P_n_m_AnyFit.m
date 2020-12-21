function [P_m_n,P_m_n_l,DF_m_n,DF_m_n_l]= P_n_m_AnyFit(WoSC,policy,numberOfSlots,bandwidthPerClass,macroSystemStates,occupiedSlotsPerMacroState,oneDsystemStates,oneD,probOfStateInFB)

classes= length(bandwidthPerClass);

if(policy==1)
  [stateOccupancyPattern,transitionStatesForClasses,connectionNonBlockingStates,...
    resourceBlockingStates,fragmentationBlockingStates,connectionsPerClassPerState]= FirstFit(numberOfSlots,bandwidthPerClass);
else if(policy==2)
        [stateOccupancyPattern,transitionStatesForClasses,connectionNonBlockingStates,...
    resourceBlockingStates,fragmentationBlockingStates,possibleStatesTransitionForClasses,connectionsPerClassPerState]= RandomFit(numberOfSlots,bandwidthPerClass);
    end
end
stateOccupancyPattern= stateOccupancyPattern(:,1:numberOfSlots); % remove last -1 
ocuupancyPerState= sum(stateOccupancyPattern~=0,2);
stateOccupancyPattern= logical(stateOccupancyPattern);
stateOccupancyPatternTemp{1,:}= stateOccupancyPattern(1,:);
 if(oneD)
    numberOfStates =length(oneDsystemStates);
    for i=2: numberOfStates
        index1= find(oneDsystemStates(i)==ocuupancyPerState); 
        tempLength=length(index1);
        P1= false(tempLength,numberOfSlots); %zeros(tempLength,numberOfSlots);
        for j=1: length(index1)
            P1(j,:)=stateOccupancyPattern(index1(j),:);
        end
        stateOccupancyPatternTemp{i,:}= P1;
    end
    %%stateOccupancyPattern=stateOccupancyPatternTemp;
    
    P_m_n=zeros(numberOfStates,numberOfStates,classes);
    P_m_n_l=zeros(numberOfStates,numberOfStates,numberOfStates,classes);
    DF_m_n=zeros(numberOfStates,numberOfStates,classes);
    DF_m_n_l=zeros(numberOfStates,numberOfStates,classes);
    
    if(WoSC==1)
        % three links store orbit of occupancy of all states
        store_or={};
        store_or{1,1,1,1}= false(1,numberOfSlots); %zeros(1,numberOfSlots);
        for i= 1:numberOfStates
            K=size(stateOccupancyPatternTemp{i,:},1);
            for j=1:numberOfStates
                L=size(stateOccupancyPatternTemp{j,:},1) ;    
                    for k=1:K
                        for l=1:L    
                            max_cons1=bitor(stateOccupancyPatternTemp{i,:}(k,:),stateOccupancyPatternTemp{j,:}(l,:));
                            store_or{i,j,k,l}=max_cons1;
                            b = diff([false max_cons1==false false]);
                            max_res = max(find(b==-1) - find(b==1));
                            if(isempty(max_res))
                               max_res=0; %P_m_n(i,j,1)=P_m_n(i,j,1)+1;
                            end
                            xx =max_res>=bandwidthPerClass;
                            for c=1:classes
                                P_m_n(i,j,c)=P_m_n(i,j,c)+xx(c); % max_res+1 is done so that m=0 is saved at index=1
                            end

                        end
                    end

                P_m_n(i,j,:)=P_m_n(i,j,:)/(K*L);
                DF_m_n(i,j,1:classes)= probOfStateInFB(i,:).*probOfStateInFB(j,:);
                % calculate P_m_n_l for 3 links
                 for l3=1:numberOfStates 
                     M=size(stateOccupancyPatternTemp{l3,:},1);
                    for k=1:K
                        for l=1: L  
                            for m= 1: M
                                max_cons1=bitor(store_or{i,j,k,l}(1,:),stateOccupancyPatternTemp{l3,:}(m,:));

                                b = diff([0 max_cons1==0 0]);
                                max_res = max(find(b==-1) - find(b==1));
                                if(isempty(max_res))
                                   max_res=0; %P_m_n_l(i,j,l3,1)=P_m_n_l(i,j,l3,1)+1;
                                end
                                xx =max_res>=bandwidthPerClass;
                                for c=1:classes
                                    P_m_n_l(i,j,l3,c)=P_m_n_l(i,j,l3,c)+xx(c); % max_res+1 is done so that m=0 is saved at index=1
                                end

                            end
                        end
                    end
                    P_m_n_l(i,j,l3,:)=P_m_n_l(i,j,l3,:)/(K*L*M);
                    DF_m_n_l(i,j,l3,1:classes)= probOfStateInFB(i,:).*probOfStateInFB(j,:).*probOfStateInFB(l3,:);
                end         
            end
        end
    else % if spectrum conversion is allowed
        % three links store orbit of occupancy of all states
         % ztore max
        max_cons_class= zeros(numberOfStates,classes);
        max_cons_class(1,:) =1;
        for i= 2:numberOfStates
            K=size(stateOccupancyPatternTemp{i,:},1);
            
            for k=1:K
                max_cons1=stateOccupancyPatternTemp{i,:}(k,:);    
                b = diff([false max_cons1==false false]);
                max_res1 = max(find(b==-1) - find(b==1));
                if(isempty(max_res1))
                   max_res1=0; %P_m_n(i,j,1)=P_m_n(i,j,1)+1;
                end
                for c=1:classes
                    if (max_res1>=bandwidthPerClass(c))
                    max_cons_class(i,c) =max_cons_class(i,c)+1;
                    end
                end
            end
        end
        for i= 1:numberOfStates
            for j=1:numberOfStates
                P_m_n(i,j,:)=(max_cons_class(i,:).*max_cons_class(j,:))/(size(stateOccupancyPatternTemp{i,:},1)*size(stateOccupancyPatternTemp{j,:},1));
                DF_m_n(i,j,1:classes)= probOfStateInFB(i,:).*probOfStateInFB(j,:);
                % calculate P_m_n_l for 3 links
                 for l3=1:numberOfStates 
                     P_m_n_l(i,j,l3,:)=((max_cons_class(i,:).*max_cons_class(j,:)).*max_cons_class(l3,:))/(size(stateOccupancyPatternTemp{i,:},1)*size(stateOccupancyPatternTemp{j,:},1)*size(stateOccupancyPatternTemp{l3,:},1));
                     DF_m_n_l(i,j,l3,1:classes)= probOfStateInFB(i,:).*probOfStateInFB(j,:).*probOfStateInFB(l3,:); 
                 end         
            end
        end
    end

 else
    
     % need to change this code since P_m_n and P_m_n_l now represents probability of acceptance
     
  numberOfStates = length(macroSystemStates(:,1)); % state is Macrostate, representing connections per class
  
    for i=2: numberOfStates
        index1= ismember(macroSystemStates(i,:),connectionsPerClassPerState(:,:),'rows'); 
        tempLength=length(index1);
        P1= zeros(tempLength,numberOfSlots);
        for j=1: length(index1)
            P1(j,:)=stateOccupancyPattern(index1(j),:);
        end
        stateOccupancyPatternTemp{i,:}= P1;
    end
   %%% stateOccupancyPattern=stateOccupancyPatternTemp;
    
    P_m_n=zeros(numberOfStates,numberOfStates,bandwidthPerClass(classes));
    P_m_n_l=zeros(numberOfStates,numberOfStates,numberOfStates,bandwidthPerClass(classes));
    DF_m_n=zeros(numberOfStates,numberOfStates,classes);
    DF_m_n_l=zeros(numberOfStates,numberOfStates,classes);
    % three links store orbit of occupancy of all states
    store_or={};
    store_or{1,1,1,1}=zeros(1,numberOfSlots);
    for i= 1:numberOfStates
        for j=1:numberOfStates
            for k=1:size(stateOccupancyPatternTemp{i,:},1)

                for l=1: size(stateOccupancyPatternTemp{j,:},1)     
                    max_cons1=bitor(stateOccupancyPatternTemp{i,:}(k,:),stateOccupancyPatternTemp{j,:}(l,:));
                    store_or{i,j,k,l}=max_cons1;
                    b = diff([0 max_cons1==0 0]);
                    max_res = max(find(b==-1) - find(b==1));
                    if(isempty(max_res))
                        max_res=0;
                    end
                    if(max_res<bandwidthPerClass(classes))
                        P_m_n(i,j,max_res+1)=P_m_n(i,j,max_res+1)+1; % max_res+1 is done so that m=0 is saved at index=1
                    end
                end
            end
            P_m_n(i,j,:)=P_m_n(i,j,:)/(size(stateOccupancyPatternTemp{i,:},1)*size(stateOccupancyPatternTemp{j,:},1));
            DF_m_n(i,j,1:classes)= probOfStateInFB(i,:).*probOfStateInFB(j,:);
            % calculate P_m_n_l for 3 links
             for l3=1:numberOfStates 
                for k=1:size(stateOccupancyPatternTemp{i,:},1)
                    for l=1: size(stateOccupancyPatternTemp{j,:},1)  
                        for m= 1:size(stateOccupancyPatternTemp{l3,:},1)  
                            max_cons1=bitor(store_or{i,j,k,l}(1,:),stateOccupancyPatternTemp{l3,:}(m,:));
                            
                            b = diff([0 max_cons1==0 0]);
                            max_res = max(find(b==-1) - find(b==1));
                            if(isempty(max_res))
                                max_res=0;
                            end
                            if(max_res<bandwidthPerClass(classes))
                                P_m_n_l(i,j,l3,max_res+1)=P_m_n_l(i,j,l3,max_res+1)+1; % max_res+1 is done so that m=0 is saved at index=1
                            end
                        end
                    end
                end
                P_m_n_l(i,j,l3,:)=P_m_n_l(i,j,l3,:)/(size(stateOccupancyPatternTemp{i,:},1)*size(stateOccupancyPatternTemp{j,:},1)*size(stateOccupancyPatternTemp{l3,:},1));
                DF_m_n_l(i,j,l3,1:classes)= probOfStateInFB(i,:).*probOfStateInFB(j,:).*probOfStateInFB(l3,:);
            end         
        end
    end
end
end
    
%             if(K==L)
%                 for k=1:K
%                     B= repmat(stateOccupancyPatternTemp{i,:}(k,:),L,1);
%                     max_cons=bitor(B,stateOccupancyPatternTemp{j,:}(:,:));
%                     for l=1:L
%                         store_or{i,j,k,l}=max_cons(l,:);
%                         b = diff([false max_cons(l,:)==false false]);
%                         max_1 = max(find(b==-1) - find(b==1));
%                         if(isempty(max_1))
%                             P_m_n(i,j,1)=P_m_n(i,j,1)+1; % max_res=0 
%                         else if(max_1<bandwidthPerClass(classes))
%                                 P_m_n(i,j,max_res+1)=P_m_n(i,j,max_res+1)+1; % max_res+1 is done so that m=0 is saved at index=1
%                             end
%                         end
%                     end
%                 end
%             else    