
function [probOfStateInNB,probOfStateInFB,P_m_n,P_m_n_l,DF_m_n,DF_m_n_l]= P_n_m_ApprxUniform(WoSC,numberOfSlots,bandwidthPerClass,oneDsystemStates,oneD,occupancyPerState)
% %%%%%%%%%%%% following methods takes continuous and/or contiguous paths into account %%%%%%%%%%%%%%%%%%%%%%%% 
% finding continuos and contiguous path probability; 
classes=length(bandwidthPerClass);

% if(bandwidthPerClass(1)~=1)
%      disp('this method would not be applicable')
% end
 numberOfStates=length(oneDsystemStates);
 probOfStateInNB = zeros(numberOfStates,classes);
 probOfStateInFB = zeros(numberOfStates,classes);
 p_k_x = zeros(numberOfSlots+1,classes); % Pr[Z_r>=d_k | i] i.e., given i = x occupied slots 
 p_k_x(1,1:classes)=1;
    
% calculate the Pr[Z_r>=d_k_max | x]
for x=2:numberOfSlots+1 % number Of Occupied slots =x-1
    for c=1:classes
        d_k=bandwidthPerClass(c); % d_k = d_k_index -1 factorial()
        for i=1:x % numberOfSlots-(n-1)+1
            if(x-1 <=numberOfSlots -i*(d_k)) 
               p_k_x(x,c) = p_k_x(x,c)+ ((-1)^(i+1))*nchoosek(x,i)*nchoosek(numberOfSlots-i*d_k,x-1);
%                    (factorial(x-n+2)/(factorial(numberOfSlots-n+2-i)*factorial(i)))*...
%                              (factorial(numberOfSlots-i*d_k)/(factorial(n-1-i*d_k)*factorial(numberOfSlots-n+1)));
               %p_k_n(n,d_k_index)+
               %((-1)^(i+1))*nchoosek(numberOfSlots-(n-1)+1,i)*nchoosek(numberOfSlots-i*(d_k_index-1),numberOfSlots-(n-1));  
            else
                break;
            end
            
        end
%         

    end
end
for m1= 1:numberOfStates
    x=occupancyPerState(m1);  % free slots in m1
    probOfStateInNB(m1,:)= p_k_x(x+1,:)/nchoosek(numberOfSlots,x);
    if(probOfStateInNB(m1,:)>1)
        probOfStateInNB(m1,:)=1;
    end
end
    
if (WoSC==1)
%%%%%%%%%%%%%%%%%%%%%%%% Another Method - using exact formula for continuos and contiguous constraint %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% this will only give good result if d_k=1 is also present
 
  % g_n_m- gives probability that there are exactly n continuous (not necessarily contiguous) free slots on both links 
   g_n_m=zeros(numberOfSlots+1,numberOfSlots+1,numberOfSlots+1);   
   g_n_m(:,1,1)=1;
   g_n_m(1,:,1)=1;
   for m1= 2:numberOfSlots+1 % here index represent numberOfFreeSlots+1
         x=m1-1;% free slots in m1 = m1-1
        for m2=2:numberOfSlots+1
            y=m2-1;   
            for n=1:numberOfSlots+1 % n=i represents n=i-1, n-1 represents number of free slots
                if(x>=n-1 && y>=n-1 && numberOfSlots-x>=y-n+1)
                    g_n_m(m1,m2,n)=(factorial(x)/(factorial(n-1)*factorial(x-n+1)))*(factorial(numberOfSlots-x)/(factorial(y-n+1)*factorial(numberOfSlots-x-y+n-1)))/(factorial(numberOfSlots)/(factorial(y)*factorial(numberOfSlots-y)));    
                  %nchoosek(x,n-1)*nchoosek(numberOfSlots-x, y-n+1)/nchoosek(numberOfSlots, y);
                end
                if(g_n_m(m1,m2,n)>1)
                    g_n_m(m1,m2,n)=1;
                    disp('error in approx g-n-m-1');
                end
                
            end
            
%             if sum(g_n_m(m1,m2,:))~=1
%                 fprintf('\n %s,%d','error in approx g-n-m-2',sum(g_n_m(m1,m2,:))-1);
%             end
            if sum(g_n_m(m1,m2,:))>1
                fprintf('\n %s,%d','error in approx g-n-m-3',sum(g_n_m(m1,m2,:))-1);
            end
            %%%%%
            
            
        end
   end 
 
  

   % for three links 
   g_m_n_l=zeros(numberOfSlots+1,numberOfSlots+1,numberOfSlots+1,numberOfSlots+1);
   g_m_n_l(:,:,1,1)=1;
   g_m_n_l(:,1,:,1)=1;
   g_m_n_l(1,:,:,1)=1;
    for m1= 2:numberOfSlots+1
        x=m1-1;
        for m2=2:numberOfSlots+1
            y=m2-1;
            for m3=2:numberOfSlots+1
               % fprintf('\n %s%d%d%d%s','(',m1-1, m2-1,m3-1,')=> ');
                for n=1:numberOfSlots+1 %min(x,y)+1 % n=i represents n= i-1 for m1=1 ; n=1:bandwidthPerClass(classes)
                    if(min(min(x,y),m3-1)>=n-1)
                       for k=n:min(x,y)+1
                           g_m_n_l(m1,m2,m3,n)=g_m_n_l(m1,m2,m3,n) + g_n_m(k,m3,n)*g_n_m(m1,m2,k);
                       end
                    end
                    if(g_m_n_l(m1,m2,m3,n)>1)
                        g_m_n_l(m1,m2,m3,n)=1;
                        disp('error in approx g-n-m-l 1');
                    end
                  %  fprintf('%d,',g_m_n_l(m1,m2,m3,n));
                end
                
%                 if sum(g_m_n_l(m1,m2,m3,:))~=1
%                    fprintf('\n %s,%d','error in approx g-n-m-l-2',sum(g_m_n_l(m1,m2,m3,:))-1);
%                 end
                if sum(g_m_n_l(m1,m2,m3,:))>1
                   fprintf('\n %s,%d','error in approx g-n-m-l-3',sum(g_m_n_l(m1,m2,m3,:))-1);
                end
            end
        end
    end
    
  % calculate Pr[Z_r>=d_k|n]
   
    p_k_n = zeros(numberOfSlots+1,classes); % Pr[Z_r>=d_k | i] i.e., given i = n free continuous slots on both links
    %p_k_n_exact = zeros(numberOfSlots+1,bandwidthPerClass(classes));%Pr[Z_r=d_k | i] i.e., given i = n free continuous slots on both links
    p_k_n(1,1)=0;
    p_k_n(1,2)=0;
    % calculate the Pr[Z_r>=d_k_max | n]
    for n=2:numberOfSlots+1
        for c=1:classes
           if(n-1>=bandwidthPerClass(c)) % yes if number of free slots is more or equal than max_demand then we need to calculate this extra loop
            % calculate an extra Pr[Z_r>=d_k+1 | n]
            d_k=bandwidthPerClass(c); % d_k = d_k_index -1 factorial()
            for i=1:numberOfSlots-n+2 % numberOfSlots-(n-1)+1
                if(i*(d_k)<=(n-1)) 
                   p_k_n(n,c) = p_k_n(n,c)+ ((-1)^(i+1))*(factorial(numberOfSlots-n+2)/(factorial(numberOfSlots-n+2-i)*factorial(i)))*...
                             (factorial(numberOfSlots-i*d_k)/(factorial(n-1-i*d_k)*factorial(numberOfSlots-n+1)));
                   %p_k_n(n,d_k_index)+ ((-1)^(i+1))*nchoosek(numberOfSlots-(n-1)+1,i)*nchoosek(numberOfSlots-i*(d_k_index-1),numberOfSlots-(n-1)); 
                else
                    break;
                end
            end
            p_k_n(n,c) = p_k_n(n,c)/(factorial(numberOfSlots)/(factorial(numberOfSlots-n+1)*factorial(n-1)));   %nchoosek(numberOfSlots,(n-1));%Pr[Z_r>=d_k | n]
            if(p_k_n(n,c)>1)
                p_k_n(n,c)=1;
            end
           end
        end
    end
       
    
    % for links case: prob. of having exact m consecutive free slots on both
    % links for each given pair of connections vector on both the links (n_j1, n_j2) 
   P_m_n=zeros(numberOfStates,numberOfStates,classes);
    
   DF_m_n=zeros(numberOfStates,numberOfStates,classes);  
   % for three links
   P_m_n_l=zeros(numberOfStates,numberOfStates,numberOfStates,classes);
   DF_m_n_l=zeros(numberOfStates,numberOfStates,classes);
   
   freeSlotsPerState=numberOfSlots-occupancyPerState;  
    

   for m1= 1:numberOfStates
        x=freeSlotsPerState(m1); % free slots in m1
        for m2=1:numberOfStates
            y=freeSlotsPerState(m2);
            %DF_m_n(m1,m2,1:classes)= probOfStateInFB(m1,:).*probOfStateInFB(m2,:);
            %%%% new code based on my approximation
            %fprintf('\n %s%d%s%d%s','(',x,',', y,')=> ');
            for c=1:classes
                for n=bandwidthPerClass(c)+1:min(x,y)+1
                    P_m_n(m1,m2,c)=P_m_n(m1,m2,c)+ p_k_n(n,c)*g_n_m(x+1,y+1,n); % if freeSlot=0, index is x+1
                end
            %    fprintf('%d,',P_m_n(m1,m2,c));
%                 if sum(P_m_n(m1,m2,c))>1
%                     disp('error in approx p-n-m');
%                 end
            end
            
            
            %%%%%
            for m3=1:numberOfStates
                z= freeSlotsPerState(m3);
                %%%% new code based on my approximation
                for c=1:classes
                    for n=bandwidthPerClass(c)+1:min(min(x,y),z)+1
                        P_m_n_l(m1,m2,m3,c)=P_m_n_l(m1,m2,m3,c)+ p_k_n(n,c)*g_m_n_l(x+1,y+1,z+1,n);
                    end
%                     if sum(P_m_n_l(m1,m2,m3,c))>1
%                        disp('error in approx P-m-n_l');
%                     end
                end
%                 fprintf('\n %s%d%s%d%s%d%s','(',x,',', y,',', z,')=> ');
%                 fprintf('%d,',1- sum(P_m_n_l(m1,m2,m3,1:bandwidthPerClass(classes))));
                
               
                
                %%%%%%%%%%
                %DF_m_n_l(m1,m2,m3,1:classes)= probOfStateInFB(m1,:).*probOfStateInFB(m2,:).*probOfStateInFB(m3,:);
                
            end
        end
   end  
    
    
   %%%%%%%%%% exact Pr[Zr=d_k\n] calculation]
%     p_k_n = zeros(numberOfSlots+1,bandwidthPerClass(classes)+1); % Pr[Z_r>=d_k | i] i.e., given i = n free continuous slots on both links
%     p_k_n_exact = zeros(numberOfSlots+1,bandwidthPerClass(classes));%Pr[Z_r=d_k | i] i.e., given i = n free continuous slots on both links
%     p_k_n_exact(1,1)=1;
%     % first calculate the Pr[Z_r>=d_k_max | n]
%     for n=2:numberOfSlots+1
%         if(n-1>=bandwidthPerClass(classes)) % yes if number of free slots is more or equal than max_demand then we need to calculate this extra loop
%             % calculate an extra Pr[Z_r>=d_k+1 | n]
%             d_k_index=bandwidthPerClass(classes)+1; % d_k = d_k_index -1 factorial()
%             for i=1:numberOfSlots-(n-1)+1
%                 if(i*(d_k_index-1)<=(n-1)) 
%                    p_k_n(n,d_k_index) = p_k_n(n,d_k_index)+ ((-1)^(i+1))*(factorial(numberOfSlots-(n-1)+1)/(factorial(numberOfSlots-(n-1)+1-i)*factorial(i)))*...
%                              (factorial(numberOfSlots-i*(d_k_index-1))/(factorial(numberOfSlots-i*(d_k_index-1)-numberOfSlots+(n-1))*factorial(numberOfSlots-(n-1))));
%                    %p_k_n(n,d_k_index)+ ((-1)^(i+1))*nchoosek(numberOfSlots-(n-1)+1,i)*nchoosek(numberOfSlots-i*(d_k_index-1),numberOfSlots-(n-1)); 
%                 end
%             end
%             p_k_n(n,d_k_index) = p_k_n(n,d_k_index)/(factorial(numberOfSlots)/(factorial(numberOfSlots-(n-1))*factorial(n-1)));   %nchoosek(numberOfSlots,(n-1));%Pr[Z_r>=d_k | n]
%         end
%         % calculate  Pr[Z_r=d_k | n]
%         
%         for d_k_index =bandwidthPerClass(classes):-1:2 % demand at index 1 is 0
%             if(d_k_index<=n) % d_k_index-1<=n-1
%                 for i=1:numberOfSlots-(n-1)+1
%                     if(i*(d_k_index-1)<=(n-1)) 
%                        p_k_n(n,d_k_index) = p_k_n(n,d_k_index)+ ((-1)^(i+1))*(factorial(numberOfSlots-(n-1)+1)/(factorial(numberOfSlots-(n-1)+1-i)*factorial(i)))*...
%                            (factorial(numberOfSlots-i*(d_k_index-1))/(factorial(numberOfSlots-i*(d_k_index-1)-numberOfSlots+(n-1))*factorial(numberOfSlots-(n-1))));
%                        %p_k_n(n,d_k_index)+ ((-1)^(i+1))*nchoosek(numberOfSlots-(n-1)+1,i)*nchoosek(numberOfSlots-i*(d_k_index-1),numberOfSlots-(n-1)); 
%                     end
%                 end
%                 p_k_n(n,d_k_index) = p_k_n(n,d_k_index)/(factorial(numberOfSlots)/(factorial(numberOfSlots-(n-1))*factorial(n-1))); %nchoosek(numberOfSlots,(n-1));%Pr[Z_r>=d_k | n]
%                 p_k_n_exact(n,d_k_index)= p_k_n(n,d_k_index)- p_k_n(n,d_k_index+1); %Pr[Z_r=d_k | n]= Pr[Z_r>=d_k+1 | n]- Pr[Z_r>=d_k | n]
%                if(p_k_n_exact(n,d_k_index)<1.0000e-10)
%                    p_k_n_exact(n,d_k_index)=0;
%                else
%                    if(p_k_n_exact(n,d_k_index)>1)
%                        p_k_n_exact(n,d_k_index)=1;
%                    end
% 
%                end
%             end
%         end
%     end
else % with spectrum conversion 
    
    
    
   P_m_n=zeros(numberOfStates,numberOfStates,classes);
    
   DF_m_n=zeros(numberOfStates,numberOfStates,classes);  
   % for three links
   P_m_n_l=zeros(numberOfStates,numberOfStates,numberOfStates,classes);
   DF_m_n_l=zeros(numberOfStates,numberOfStates,classes);
    
   for m1= 1:numberOfStates
        for m2=1:numberOfStates
            P_m_n(m1,m2,:)=probOfStateInNB(m1,:).*probOfStateInNB(m2,:);
            %DF_m_n(m1,m2,1:classes)= probOfStateInFB(m1,:).*probOfStateInFB(m2,:);
            for m3=1:numberOfStates
                P_m_n_l(m1,m2,m3,:)=probOfStateInNB(m1,:).*probOfStateInNB(m2,:).*probOfStateInNB(m3,:);
                 
%                     if sum(P_m_n_l(m1,m2,m3,c))>1
%                        disp('error in approx P-m-n_l');
%                     end
            end
            %DF_m_n_l(m1,m2,m3,1:classes)= probOfStateInFB(m1,:).*probOfStateInFB(m2,:).*probOfStateInFB(m3,:);
  
            
        end
   end  
end
end

%     % only continuity 
%     if(oneD)
%    
%     numberOfStates=length(oneDsystemStates);
% 
%     
%     % for links case: prob. of having exact m consecutive free slots on both
%     % links for each given pair of connections vector on both the links (n_j1, n_j2) 
%     P_m_n=zeros(numberOfStates,numberOfStates,classes);
%     
%     DF_m_n=zeros(numberOfStates,numberOfStates,classes);
%    
%    % g_n_m- gives probability that there are exactly n continuous (not necessarily contiguous) free slots on both links 
%    g_n_m=zeros(numberOfStates,numberOfStates,numberOfSlots+1); 
%    
%     for m1= 1:numberOfStates
%         x=numberOfSlots-oneDsystemStates(m1); % free slots in m1
%         for m2=1:numberOfStates
%             y=numberOfSlots-oneDsystemStates(m2);
%             if(x==0 || y==0)
%                 g_n_m(m1,m2,1)=1;
%             else
%                 for n=1:numberOfSlots+1 % n=i represents n=i-1, n-1 represents number of free slots % 
%                     if(x>=n-1 && y>=n-1 && numberOfSlots-x>=y-n+1)
%                         g_n_m(m1,m2,n)=(factorial(x)/(factorial(n-1)*factorial(x-n+1)))*(factorial(numberOfSlots-x)/(factorial(y-n+1)*factorial(numberOfSlots-x-y+n-1)))/(factorial(numberOfSlots)/(factorial(y)*factorial(numberOfSlots-y)));    
%                       %nchoosek(x,n-1)*nchoosek(numberOfSlots-x, y-n+1)/nchoosek(numberOfSlots, y);
%                     end
%                 end
%     %             fprintf('\n %s%d%s%d%s','(',x,',', y,')=> ');
%     %             fprintf('%d,',1- sum(g_n_m(m1,m2,1:bandwidthPerClass(classes))));
%             end
%             for c=1:classes
%                 P_m_n(m1,m2,c)=1-sum(g_n_m(m1,m2,1:bandwidthPerClass(c)));
%                 if(P_m_n(m1,m2,c)<0)
%                     P_m_n(m1,m2,c)=0;
%                 end
%             end
%         end
%     end
%    %P_m_n= g_n_m(:,:,1:bandwidthPerClass(classes));
%    
%   
%    % claculate for three links 
%    p_m_n_l=zeros(numberOfStates,numberOfStates,numberOfStates,bandwidthPerClass(classes));
%    P_m_n_l=zeros(numberOfStates,numberOfStates,numberOfStates,classes);
%    DF_m_n_l=zeros(numberOfStates,numberOfStates,classes);
%    %g_m_n_l=zeros(numberOfStates,numberOfStates,numberOfStates,numberOfSlots+1);
%    
%     for m1= 1:numberOfStates
%         x=numberOfSlots-oneDsystemStates(m1);
%         for m2=1:numberOfStates
%             y=numberOfSlots-oneDsystemStates(m2);
%             DF_m_n(m1,m2,1:classes)= probOfStateInFB(m1,:).*probOfStateInFB(m2,:);
%             for m3=1:numberOfStates
%                 z=numberOfSlots-oneDsystemStates(m3);
%                 if(x==0 || y==0 ||z==0)
%                     p_m_n_l(m1,m2,m3,1)=1;
%                 else
%                     for n=1:bandwidthPerClass(classes) %min(x,y)+1 % n=i represents n= i-1 for m1=1 ; n=1:bandwidthPerClass(classes)
%                         if(min(min(x,y),z)>=n-1)
%                             %this will be true only if d_k=1 is included in the set of demands
%                             index1= find(numberOfSlots-oneDsystemStates>=n-1); % find all states which have more or equal free slots (n-1)
%                             for k=length(index1):-1:1
%                                 n1=numberOfSlots-oneDsystemStates(index1(k))+1; %represents the state k, and the number of freeslots in it
%                                 p_m_n_l(m1,m2,m3,n)=p_m_n_l(m1,m2,m3,n) + g_n_m(index1(k),m3,n)*g_n_m(m1,m2,n1); 
%                             end
%                         end
%                     end
%                      if sum(p_m_n_l(m1,m2,m3,1:bandwidthPerClass(classes)))>1.0000000001
%                          disp('error in approx p-n-m');
%                      end
%                 end
%                 for c=1:classes
%                     P_m_n_l(m1,m2,m3,c)= 1-sum(p_m_n_l(m1,m2,m3,1:bandwidthPerClass(c)));
%                 end
%                 if(P_m_n_l(m1,m2,m3,c)<0)
%                     P_m_n_l(m1,m2,m3,c)=0;
%                 end
%                 DF_m_n_l(m1,m2,m3,1:classes)= probOfStateInFB(m1,:).*probOfStateInFB(m2,:).*probOfStateInFB(m3,:);
%                 
% %                 fprintf('\n %s%d%s%d%s%d%s','(',x,',', y,',',z,')=> ');
% %                 fprintf('%d,',1- sum(P_m_n_l(m1,m2,m3,1:bandwidthPerClass(classes))));
%             end
%         end
%     end
%     
% else
%     
%     numberOfStates=length(occupancyPerState);
% 
%     
%     % for links case: prob. of having exact m consecutive free slots on both
%     % links for each given pair of connections vector on both the links (n_j1, n_j2) 
%     P_m_n=zeros(numberOfStates,numberOfStates,bandwidthPerClass(classes));
%     P_m_n_l=zeros(numberOfStates,numberOfStates,numberOfStates,bandwidthPerClass(classes));
%     DF_m_n=zeros(numberOfStates,numberOfStates,classes);
%     DF_m_n_l=zeros(numberOfStates,numberOfStates,classes);
%     % three links store orbit of occupancy of all states
%     g_n_m=zeros(numberOfStates,numberOfStates,numberOfSlots+1);
%     for m1= 1:numberOfStates
%         x=numberOfSlots-occupancyPerState(m1);
%         for m2=1:numberOfStates
%             y=numberOfSlots-occupancyPerState(m2);
%             for n=1:numberOfSlots+1 % n=i represents n=i-1, n-1 represents number of free slots
%                 if(x>=n-1 && y>=n-1 && numberOfSlots-x>=y-n+1)
%                   g_n_m(m1,m2,n)= (factorial(x)/(factorial(n-1)*factorial(x-n+1)))*(factorial(numberOfSlots-x)/(factorial(y-n+1)*factorial(numberOfSlots-x-y+n-1)))/(factorial(numberOfSlots)/(factorial(y)*factorial(numberOfSlots-y)));      
%                   %nchoosek(x,n-1)*nchoosek(numberOfSlots-x, y-n+1)/nchoosek(numberOfSlots, y);
%                 end
%             end
%         end
%     end
%     P_m_n = g_n_m(:,:,1:bandwidthPerClass(classes));
%     
%     for m1= 1:numberOfStates
%         x=numberOfSlots-occupancyPerState(m1);
%         for m2=1:numberOfStates
%             y=numberOfSlots-occupancyPerState(m2);
%             DF_m_n(m1,m2,1:classes)= probOfStateInFB(m1,:).*probOfStateInFB(m2,:);
%             for m3=1:numberOfStates
%                 for n=1:bandwidthPerClass(classes) % n=i represents n=i-1for m1=1
%                     if(min(x,y)>=n-1)
%                         index1= find(numberOfSlots-occupancyPerState>=n-1); % find all states which has more or equal free slots (n-1)
%                         
%                         for k=length(index1):-1:1
%                             n1=numberOfSlots-occupancyPerState(index1(k))+1; %represents the state k, and the number of freeslots in it
%                             P_m_n_l(m1,m2,m3,n)=P_m_n_l(m1,m2,m3,n) + g_n_m(index1(k),m3,n)*g_n_m(m1,m2,n1);
%                         end
%                     end
%                 end
%                 DF_m_n_l(m1,m2,m3,1:classes)= probOfStateInFB(m1,:).*probOfStateInFB(m2,:).*probOfStateInFB(m3,:);
%                 
%             end
%         end
%     end
% 
%     end
% end