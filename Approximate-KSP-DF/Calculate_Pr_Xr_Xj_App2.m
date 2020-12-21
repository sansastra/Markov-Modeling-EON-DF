function [Pr_Xr_Xj_c] = Calculate_Pr_Xr_Xj_App2(bandwidthPerClass,freeSlotsPerState,PoA_links,stateProbabilities,numberOfLinks,path)
numberOfStates=length(freeSlotsPerState);
classes=length(bandwidthPerClass);
runLength=zeros(1,classes);
for c=1:classes
    runLength(c)=sum(freeSlotsPerState>=bandwidthPerClass(c));
end
Pr_Xr_Xj_c=zeros(numberOfStates,classes);

for c=1 : classes 
    for  state1=1:runLength(c)
         Pr_Xr_Xj_c(state1,c)=PoA_links{numberOfLinks}(state1,c);
         for p=1:numberOfLinks-1
             factor1=0;
             for state2=1:1:runLength(c)
                 factor1=factor1+stateProbabilities{path(p)}(state2)*PoA_links{p}(state2,c);
             end
             Pr_Xr_Xj_c(state1,c)=factor1*Pr_Xr_Xj_c(state1,c);
         end
    end
end
Pr_Xr_Xj_c(Pr_Xr_Xj_c>1)=1;

% switch (numberOfLinks)
%      case 1
%          Pr_Xr_Xj_c = Pr_exact_m;
%      case 2
%              for c=1 : classes 
%                 for state1=1:runLength(c) 
%                     for state2=1:runLength(c)
% %                         if(sum(Pr_exact_m(state2,state1,1:bandwidthPerClass(c)))>1)
% %                             disp('error')
% %                         end
%                         Pr_Xr_Xj_c(state1,c)= Pr_Xr_Xj_c(state1,c)+ stateProbabilities{path(1)}(state2)*Pr_exact_m(state2,state1,c); % m=1 to d_k
%                     end
%                     
%                 end
%                 
%              end
%              
%      otherwise
%             % length(path)=2, actually 3
%              

% %              upper_ind=zeros(1,length(path));
% %              for p=1:length(path)
% %                  upper_ind(p)=find(freeSlotsPerState<=(freeSlotsPerState(1)-avgOccupiedSlots{path(p)}),1);
% %              end
% %                     for state2=upper_ind(1)-1:upper_ind(1)
% %                         for state3=upper_ind(2)-1:upper_ind(2)
% %                             Pr_Xr_Xj_c(state1,c)=Pr_Xr_Xj_c(state1,c)+(stateProbabilities{path(1)}(state2))*(stateProbabilities{path(2)}(state3))*Pr_exact_m(state3,state2,state1,c);
% %                         end
% %                     end
% %                     Pr_Xr_Xj_c(state1,c)= min(1,((Pr_Xr_Xj_c(state1,c)/(2^(numberOfLinks-1)))*(runLength(c)^(numberOfLinks-1))));
% % %                     Pr_Xr_Xj_c(state1,c)=Pr_Xr_Xj_c(state1,c)+Pr_Xr_Xj_error_route(state1,c);
% % %                     if(Pr_Xr_Xj_c(state1,c)>1)
% % %                        Pr_Xr_Xj_error_route(state1,c)= Pr_Xr_Xj_c(state1,c)-1;
% % %                        Pr_Xr_Xj_c(state1,c)=1;
% % %                     end     
% %                 end
% %              end
% %             %Pr_Xr_Xj_c(Pr_Xr_Xj_c>1)=1;
%      case 4
%              % length(path)=3, actually 4
%              upper_ind=zeros(1,length(path));
%              for p=1:length(path)
%                  upper_ind(p)=find(freeSlotsPerState<=(freeSlotsPerState(1)-avgOccupiedSlots{path(p)}),1);
%              end
%              for c=1 : classes 
%                 for  state1=1:runLength(c)
%                     for state2=upper_ind(1)-1:upper_ind(1)
%                         for state3=upper_ind(2)-1:upper_ind(2)
%                             for state4=upper_ind(3)-1:upper_ind(3)
%                                 Pr_Xr_Xj_c(state1,c)=Pr_Xr_Xj_c(state1,c)+(stateProbabilities{path(1)}(state2))*(stateProbabilities{path(2)}(state3))*(stateProbabilities{path(3)}(state4))*...
%                                     Pr_exact_m(state4,state3,state2,c)*PoA_link(state1,c);
%                             end
%                         end
%                     end
%                     Pr_Xr_Xj_c(state1,c)= min(1,(Pr_Xr_Xj_c(state1,c)/(2^(numberOfLinks-1))*(runLength(c)^(numberOfLinks-1))));
%                     %Pr_Xr_Xj_c(state1,c)=(Pr_Xr_Xj_c(state1,c)+Pr_Xr_Xj_error_route(1,c))*ksp_mul_factor(c);
%                 end
%              end   
%              %Pr_Xr_Xj_c(Pr_Xr_Xj_c>1)=1;
%      case 5
%             % length(path)=4, actually 5
%              upper_ind=zeros(1,length(path));
%              for p=1:length(path)
%                  upper_ind(p)=find(freeSlotsPerState<=(freeSlotsPerState(1)-avgOccupiedSlots{path(p)}),1);
%              end
%              for c=1 : classes 
%                 for  state1=1:runLength(c)
%                     for state2=upper_ind(1)-1:upper_ind(1)
%                         for state3=upper_ind(2)-1:upper_ind(2)
%                             for state4=upper_ind(3)-1:upper_ind(3)
%                                 for state5=upper_ind(4)-1:upper_ind(4)
%                                     Pr_Xr_Xj_c(state1,c)=Pr_Xr_Xj_c(state1,c)+(stateProbabilities{path(1)}(state2))*(stateProbabilities{path(2)}(state3))*(stateProbabilities{path(3)}(state4))*...
%                                         (stateProbabilities{path(4)}(state5))*Pr_exact_m(state5,state4,state3,c)*PoA_link(state2,c)*PoA_link(state1,c);
%                                 end
%                             end
%                         end
%                     end
%                     Pr_Xr_Xj_c(state1,c)= min(1,(Pr_Xr_Xj_c(state1,c)/(2^(numberOfLinks-1))*(runLength(c)^(numberOfLinks-1))));
%                     %Pr_Xr_Xj_c(state1,c)=(Pr_Xr_Xj_c(state1,c)+Pr_Xr_Xj_error_route(1,c))*ksp_mul_factor(c);
%                 end
%              end   
%              %Pr_Xr_Xj_c(Pr_Xr_Xj_c>1)=1;
%      otherwise
%           disp('more than 5 links'); 
%  
% %             for c=1 : classes 
% %                 for  state1=1:runLength(c)
% %                      Pr_Xr_Xj_c(state1,c)= PoA_link(state1,c);
% %                      for p=1:length(path)
% %                          Pr_Xr_Xj_c(state1,c)=Pr_Xr_Xj_c(state1,c)*(1-BPperLinkperClass(path(p),c));
% % %                    end
% % 
% %                     Pr_Xr_Xj_c(state1,c)=Pr_Xr_Xj_c(state1,c)*ksp_mul_factor(c);
% %                 end
% %             end
% 
% %      case 3
% %              for c=1 : classes 
% %                 for  state1=1:runLength(c) 
% %                     for state2=1:runLength(c)
% %                         for state3=1:runLength(c)
% %                             Pr_Xr_Xj_c(state1,c)= Pr_Xr_Xj_c(state1,c)+ stateProbabilities{path(1)}(state2)*stateProbabilities{path(2)}(state3)...
% %                                                         *Pr_exact_m(state3,state2,state1,c); % m=1 to d_k
% %                         end
% %                     end
% %                     Pr_Xr_Xj_c(state1,c)=Pr_Xr_Xj_c(state1,c)*ksp_mul_factor(c);
% %                 end
% %              end            
% %      case 4
% %              for state1=1:numberOfStates
% %                 for c=1 : classes 
% %                     for state2=1:numberOfStates
% %                         for state3=1:numberOfStates
% %                             for state4=1:numberOfStates
% %                                 Pr_Xr_Xj_c(state1,c)= Pr_Xr_Xj_c(state1,c)+ stateProbabilities{path(1)}(state2)*stateProbabilities{path(2)}(state3)...
% %                                                         *stateProbabilities{path(3)}(state4)*Pr_exact_m(state4,state3,state2,state1,c); % m=1 to d_k
% %                             end
% %                         end
% %                     end
% %                 end
% %                 Pr_Xr_Xj_c(state1,:)=Pr_Xr_Xj_c(state1,:).*ksp_mul_factor;
% %              end  
% %      case 5
% %              for state1=1:numberOfStates
% %                 for c=1 : classes 
% %                     for state2=1:numberOfStates
% %                         for state3=1:numberOfStates
% %                             for state4=1:numberOfStates
% %                                 for state5=1:numberOfStates
% %                                     Pr_Xr_Xj_c(state1,c)= Pr_Xr_Xj_c(state1,c)+ stateProbabilities{path(1)}(state2)*stateProbabilities{path(2)}(state3)...
% %                                                         *stateProbabilities{path(3)}(state4)*stateProbabilities{path(4)}(state5)*(Pr_exact_m5(state5,c)*Pr_exact_m(state4,state3,state2,state1,c)); % m=1 to d_k
% %                                 end
% %                             end
% %                         end
% %                     end
% %                 end
% %                 Pr_Xr_Xj_c(state1,:)=Pr_Xr_Xj_c(state1,:).*ksp_mul_factor;
% %              end          
%     
end

