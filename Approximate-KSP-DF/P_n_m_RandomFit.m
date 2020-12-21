function [P_m_n,P_m_n_l,DF_m_n,DF_m_n_l]= P_n_m_RandomFit(numberOfSlots,bandwidthPerClass,connectionsPerMacroState,occupiedSlotsPerMacroState,oneDsystemStates,oneD,probOfStateInFB)

classes=length(bandwidthPerClass);
%Free =0; Used =1,2; 

stateOccupancyPattern= {};
if(oneD)
    remaningBand =2;
    numberOfStates=length(oneDsystemStates);

    stateOccupancyPattern{1,1}=zeros(1,numberOfSlots);
    for stateNr=2:numberOfStates
        freeSlots=numberOfSlots-oneDsystemStates(stateNr);
        index2= find(oneDsystemStates(stateNr)==occupiedSlotsPerMacroState);
        oneDperm1= [];
        for macroState=1:length(index2)
            connectionsPerClass=connectionsPerMacroState(index2(macroState),:);
            spectrumPatterns= zeros(1,sum(connectionsPerClass)+freeSlots);

            i=1;
            product=1;
            for c=1:classes
                spectrumPatterns(i:i+connectionsPerClass(c)-1)=bandwidthPerClass(c);
                i= i+connectionsPerClass(c);
                product=product*factorial(connectionsPerClass(c));
            end
            P= unique(perms(spectrumPatterns),'rows');
            %nrOfPermute= factorial(sum(connectionsPerClass))*nchoosek(freeSlots+sum(connectionsPerClass),freeSlots)/product;
            nrOfPermute=length(P(:,1));
            P1= zeros(nrOfPermute, numberOfSlots);
            for i=1:nrOfPermute
                k=1;
                for j=1:length(P(1,:))
                    index1=find(P(i,j)==bandwidthPerClass,1);
                    if(index1)
                        P1(i,k)=1;
                        P1(i,k+1:k+bandwidthPerClass(index1)-1)=remaningBand;
                        k=k+bandwidthPerClass(index1);
                    else
                        k=k+1;
                    end
                end
            end
            oneDperm1= [oneDperm1;P1];
        end
        stateOccupancyPattern{stateNr,:}=oneDperm1;
    end
    % for links case: prob. of having exact m consecutive free slots on both
    % links for each given pair of connection vector on both the links (n_j1, n_j2) 
    P_m_n=zeros(numberOfStates,numberOfStates,classes); % this gives the prob. that exactaly n continuous and contiguous free channel for each pair of nodes
    P_m_n_l=zeros(numberOfStates,numberOfStates,numberOfStates,classes);
    DF_m_n=zeros(numberOfStates,numberOfStates,classes);
    DF_m_n_l=zeros(numberOfStates,numberOfStates,classes);
    % three links store orbit of occupancy of all states
    store_or={};
    store_or{1,1,1,1}=zeros(1,numberOfSlots);
    for i= 1:numberOfStates
        for j=1:numberOfStates
            for k=1:size(stateOccupancyPattern{i,:},1)

                for l=1: size(stateOccupancyPattern{j,:},1)     
                    max_cons=bitor(stateOccupancyPattern{i,:}(k,:),stateOccupancyPattern{j,:}(l,:));
                    store_or{i,j,k,l}=max_cons;
                    b = diff([0 max_cons==0 0]);
                    max_res = max(find(b==-1) - find(b==1));
                    if(isempty(max_res))
                        max_res=0;
                    end
                    xx =max_res>=bandwidthPerClass ;
                    for c=1: classes
                        P_m_n(i,j,c)=P_m_n(i,j,c)+xx(c); % max_res+1 is done so that m=0 is saved at index=1
                    end
                end
            end
            
            P_m_n(i,j,:)=P_m_n(i,j,:)/(size(stateOccupancyPattern{i,:},1)*size(stateOccupancyPattern{j,:},1));
            DF_m_n(i,j,1:classes)= probOfStateInFB(i,:).*probOfStateInFB(j,:);
            
            % find what is the probability that class-k=1 is accepted
%             fprintf('\n %s%d%s%d%s','(',numberOfSlots-oneDsystemStates(i),',', numberOfSlots-oneDsystemStates(j),')=> ');
%             for c=1: classes
%                fprintf('%d,',1- sum(P_m_n(i,j,1:bandwidthPerClass(c)-1)));
%             end
           
            
            % calculate P_m_n_l for 3 links
            for l3=1:numberOfStates 
                for k=1:size(stateOccupancyPattern{i,:},1)
                    for l=1: size(stateOccupancyPattern{j,:},1)  
                        for m= 1:size(stateOccupancyPattern{l3,:},1)  
                            max_cons=bitor(store_or{i,j,k,l}(1,:),stateOccupancyPattern{l3,:}(m,:));
                            
                            b = diff([0 max_cons==0 0]);
                            max_res = max(find(b==-1) - find(b==1));
                            if(isempty(max_res))
                                max_res=0;
                            end
                            xx =max_res>=bandwidthPerClass ;
                            for c=1:classes
                                P_m_n_l(i,j,l3,c)=P_m_n_l(i,j,l3,c)+xx(c); % max_res+1 is done so that m=0 is saved at index=1
                            end
                        end
                    end
                end
                P_m_n_l(i,j,l3,:)=P_m_n_l(i,j,l3,:)/(size(stateOccupancyPattern{i,:},1)*size(stateOccupancyPattern{j,:},1)*size(stateOccupancyPattern{l3,:},1));
                DF_m_n_l(i,j,l3,1:classes)= probOfStateInFB(i,:).*probOfStateInFB(j,:).*probOfStateInFB(l3,:);
                
%                 fprintf('\n %s%d%s%d%s%d%s','(',numberOfSlots-oneDsystemStates(i),',', numberOfSlots-oneDsystemStates(j),',', numberOfSlots-oneDsystemStates(l3),')=> ');
%                 fprintf('%d,',1- sum(P_m_n_l(i,j,l3,1:bandwidthPerClass(classes))));
            end         
        end
    end
    
    
    
    %%%%%%%%%%%%%%%%%%%% using approximate formula proposed in my paper. This seems to be correct %%%%%%%%%%%%%%%%%%%
%     numberOf1DStates= length(oneDsystemStates);
%     P_m_n=zeros(numberOf1DStates,numberOf1DStates,classes);
%     for i=1: numberOf1DStates
%         E1=numberOfSlots - oneDsystemStates(i);
%         for j=1:numberOf1DStates
%             E2= numberOfSlots - oneDsystemStates(j);
%             
%             for c=1:classes
%                 if min(E1,E2)>=bandwidthPerClass(c)
%                    
%                     validEmpty= bandwidthPerClass(c):1:min(E1,E2); % this is possible values of n in Eq. 
%                     for temp=1:length(validEmpty)
%                        % calculate with another approximation
%                         tempNF=0;
%                         for p=1:numberOfSlots-validEmpty(temp)+1
%                             if(validEmpty(temp)>=p*bandwidthPerClass(c))
%                                tempNF=tempNF+((-1)^(p+1))*nchoosek(numberOfSlots-validEmpty(temp)+1,p)*nchoosek(numberOfSlots-p*bandwidthPerClass(c), numberOfSlots-validEmpty(temp));
%                             end
%                         end
%                         tempNF= tempNF/nchoosek(numberOfSlots,validEmpty(temp));
%                         if(oneDsystemStates(i)>=E2-validEmpty(temp))
%                            P_m_n(i,j,c)= P_m_n(i,j,c)+tempNF* nchoosek(E1,validEmpty(temp))*nchoosek(oneDsystemStates(i),E2-validEmpty(temp))/nchoosek(numberOfSlots,E2);
%                         end
%                     end
%                 end
%             end
%             fprintf('\n %s%d%s%d%s','(',numberOfSlots-oneDsystemStates(i),',', numberOfSlots-oneDsystemStates(j),')=> ');
%             for aa=1:classes
%                 fprintf('%d,',P_m_n(i,j,aa));
%             end
%         end
%         
%     end
%     P_m_n_l=zeros(numberOfStates,numberOfStates,numberOfStates,bandwidthPerClass(classes));
    
    
    
else
    
    % need to change this code since P_m_n and P_m_n_l now represents probability of acceptance
    remaningBand =2;
    numberOfStates=length(occupiedSlotsPerMacroState);

    stateOccupancyPattern{1,1}=zeros(1,numberOfSlots);
    for stateNr=2:numberOfStates
        freeSlots=numberOfSlots-occupiedSlotsPerMacroState(stateNr);
        connectionsPerClass=connectionsPerMacroState(stateNr,:);
        spectrumPatterns= zeros(1,sum(connectionsPerClass)+freeSlots);

        i=1;
        product=1;
        for c=1:classes
            spectrumPatterns(i:i+connectionsPerClass(c)-1)=bandwidthPerClass(c);
            i= i+connectionsPerClass(c);
            product=product*factorial(connectionsPerClass(c));
        end
        P= unique(perms(spectrumPatterns),'rows');
        %nrOfPermute= factorial(sum(connectionsPerClass))*nchoosek(freeSlots+sum(connectionsPerClass),freeSlots)/product;
        nrOfPermute=length(P(:,1));
        P1= zeros(nrOfPermute, numberOfSlots);
        for i=1:nrOfPermute
            k=1;
            for j=1:length(P(1,:))
                index1=find(P(i,j)==bandwidthPerClass,1);
                if(index1)
                    P1(i,k)=1;
                    P1(i,k+1:k+bandwidthPerClass(index1)-1)=remaningBand;
                    k=k+bandwidthPerClass(index1);
                else
                    k=k+1;
                end
            end
        end

        stateOccupancyPattern{stateNr,:}=P1;
    end
    % for links case: prob. of having exact m consecutive free slots on both
    % links for each given pair of connections vector on both the links (n_j1, n_j2) 
    P_m_n=zeros(numberOfStates,numberOfStates,bandwidthPerClass(classes));
    P_m_n_l=zeros(numberOfStates,numberOfStates,numberOfStates,bandwidthPerClass(classes));
    % three links store orbit of occupancy of all states
    store_or={};
    store_or{1,1,1,1}=zeros(1,numberOfSlots);
    for i= 1:numberOfStates
        for j=1:numberOfStates
            for k=1:size(stateOccupancyPattern{i,:},1)

                for l=1: size(stateOccupancyPattern{j,:},1)     
                    max_cons=bitor(stateOccupancyPattern{i,:}(k,:),stateOccupancyPattern{j,:}(l,:));
                    store_or{i,j,k,l}=max_cons;
                    b = diff([0 max_cons==0 0]);
                    max_res = max(find(b==-1) - find(b==1));
                    if(isempty(max_res))
                        max_res=0;
                    end
                    if(max_res<bandwidthPerClass(classes))
                        P_m_n(i,j,max_res+1)=P_m_n(i,j,max_res+1)+1; % max_res+1 is done so that m=0 is saved at index=1
                    end
                end
            end
            P_m_n(i,j,:)=P_m_n(i,j,:)/(size(stateOccupancyPattern{i,:},1)*size(stateOccupancyPattern{j,:},1));
           
            % calculate P_m_n_l for 3 links
            for l3=1:numberOfStates 
                for k=1:size(stateOccupancyPattern{i,:},1)
                    for l=1: size(stateOccupancyPattern{j,:},1)  
                        for m= 1:size(stateOccupancyPattern{l3,:},1)  
                            max_cons=bitor(store_or{i,j,k,l}(1,:),stateOccupancyPattern{l3,:}(m,:));
                            
                            b = diff([0 max_cons==0 0]);
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
                P_m_n_l(i,j,l3,:)=P_m_n_l(i,j,l3,:)/(size(stateOccupancyPattern{i,:},1)*size(stateOccupancyPattern{j,:},1)*size(stateOccupancyPattern{l3,:},1));
            end         
        end
    end
end

end

    
    

