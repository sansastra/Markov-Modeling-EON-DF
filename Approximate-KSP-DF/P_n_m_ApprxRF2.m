function [P_m_n,P_m_n_l,DF_m_n,DF_m_n_l]= P_n_m_ApprxRF2(modelType,numberOfSlots,bandwidthPerClass,oneDsystemStates,oneD,probOfStateInNB1,probOfStateInFB1,...
                                                                                                               probOfStateInNB2,probOfStateInFB2)
                                

classes=length(bandwidthPerClass);
numberOfStates=length(oneDsystemStates);
P_m_n=zeros(numberOfStates,numberOfStates,classes);
DF_m_n=zeros(numberOfStates,numberOfStates,classes);
P_m_n_l=0;
DF_m_n_l=0;

for m1=1:numberOfStates
    for m2=1:numberOfStates
        P_m_n(m1,m2,1:classes)=probOfStateInNB1(m1,:).*probOfStateInNB2(m2,:);
        %DF_m_n(m1,m2,1:classes)=(probOfStateInFB1(m1,:)).*probOfStateInFB2(m2,:);
    end
end
if(modelType)
    for c=1:classes
        for m1=1:numberOfStates
            for m2=1:numberOfStates
                xx=[probOfStateInFB1(m1,c),probOfStateInFB2(m2,c)];
                index1= find(xx>0);
                if(~isempty(index1))
                    if(length(index1)==1)
                       DF_m_n(m1,m2,c)=xx(index1(1));
                    else
                        DF_m_n(m1,m2,c)=xx(1)*xx(2);
                    end
                end
            end
        end

    end
end

%end
%     for m1=1:numberOfStates
%         for m2=1:numberOfStates
%             for 
%             P_m_n(m1,m2,1:classes)= probOfStateInNB(m1,:).*probOfStateInNB(m2,:);
% 
%             DF_m_n(m1,m2,1:classes)= probOfStateInFB(m1,:).*probOfStateInFB(m2,:);
%             for m3=1:numberOfStates
%                 P_m_n_l(m1,m2,m3,1:classes)= P_m_n(m1,m2,:).*probOfStateInNB(m3,:);
% 
%                 DF_m_n_l(m1,m2,m3,1:classes)= probOfStateInFB(m1,:).*probOfStateInFB(m2,:).*probOfStateInFB(m3,:);
%             end
%         end
%     end
%     
% end
%     
    

%    
end

