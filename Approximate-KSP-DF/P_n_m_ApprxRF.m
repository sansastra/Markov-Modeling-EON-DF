function [PoA_2links,PoA_3links]= P_n_m_ApprxRF(bandwidthPerClass,oneDsystemStates,probOfStateInNB)

classes=length(bandwidthPerClass);
numberOfStates=length(oneDsystemStates);

PoA_2links=zeros(numberOfStates,numberOfStates,classes);
PoA_3links=zeros(numberOfStates,numberOfStates,numberOfStates,classes);
%PoA_4links=zeros(numberOfStates,numberOfStates,numberOfStates,numberOfStates,classes);
%PoA_5links= probOfStateInNB; %array exceeds limit; zeros(numberOfStates,numberOfStates,numberOfStates,numberOfStates,numberOfStates,classes,'single');   




for c=1:classes
    PoA_2links(:,:,c)=(probOfStateInNB(:,c))'.*probOfStateInNB(:,c); % multiplies right to left
    for m3=1: numberOfStates
        PoA_3links(:,:,m3,c)= PoA_2links(:,:,c)*probOfStateInNB(m3,c); 
    end
%     for m4=1:numberOfStates
%         PoA_4links(:,:,:,m4,c)= PoA_3links(:,:,:,c)*probOfStateInNB(m4,c);
%     end
%     for m5=1:numberOfStates
%         PoA_5links{m5,c}= PoA_4links(:,:,:,:,c)*probOfStateInNB(m4,c);
%     end    
end
             
end