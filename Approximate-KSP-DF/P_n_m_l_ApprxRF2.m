function [P_m_n,P_m_n_l,DF_m_n,DF_m_n_l]= P_n_m_l_ApprxRF2(modelType,numberOfSlots,bandwidthPerClass,oneDsystemStates,oneD,probOfStateInNB1,probOfStateInFB1,...
                                                           probOfStateInNB2,probOfStateInFB2,probOfStateInNB3,probOfStateInFB3)
                                

classes=length(bandwidthPerClass);
numberOfStates=length(oneDsystemStates);
P_m_n=0;
DF_m_n=0;
P_m_n_l=zeros(numberOfStates,numberOfStates,numberOfStates,classes);
DF_m_n_l=zeros(numberOfStates,numberOfStates,numberOfStates,classes);


for m1=1:numberOfStates
    for m2=1:numberOfStates
        P_m_n=probOfStateInNB1(m1,:).*probOfStateInNB2(m2,:);
        %DF_m_n=(probOfStateInFB1(m1,:)).*probOfStateInFB2(m2,:);
        for m3=1:numberOfStates
            P_m_n_l(m1,m2,m3,:)=P_m_n.*probOfStateInNB3(m3,:);
            %DF_m_n_l(m1,m2,m3,:)=DF_m_n.*probOfStateInFB3(m3,:);
        end
    end
end

if(modelType==1)
    for c=1:classes
        for m1=1:numberOfStates
            for m2=1:numberOfStates
                xx=[probOfStateInFB1(m1,c),probOfStateInFB2(m2,c)];
                index1= find(xx>0);
                if(~isempty(index1))
                    if(length(index1)==1)
                       DF_m_n=xx(index1(1));
                    else
                        DF_m_n=xx(1)*xx(2);
                    end
                    for m3=1:numberOfStates
                        if(probOfStateInFB3(m3,c)>0)
                           DF_m_n_l(m1,m2,m3,c)=DF_m_n*probOfStateInFB3(m3,c);
                        end
                    end
                end
            end
        end
    end
end

% for c=1:classes
%     P_m_n=(probOfStateInNB1(:,c))'.*probOfStateInNB2(:,c);
%     DF_m_n=(probOfStateInFB1(:,c))'.*probOfStateInFB2(:,c);
%    for m3=1: numberOfStates
%         P_m_n_l(:,:,m3,c)= P_m_n*probOfStateInNB3(m3,c);
%         DF_m_n_l(:,:,m3,c)= DF_m_n*probOfStateInFB3(m3,c);
%    end
% end
% end