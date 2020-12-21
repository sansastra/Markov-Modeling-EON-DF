function number  = GetMaxNumberOfMacroStates(numberOfSlots,numberOfCores,bandwidthPerClass)
number=0; % states n=(n1,n2,n3)
classes= length(bandwidthPerClass);
% M={};
% M{1}(1)=floor(numberOfSlots/bandwidthPerClass(1));
% max_m= zeros(1,classes-1);
% max_m(1)=M{1}(1)+1;
% for c=2:classes
%     for i=1:max
%     temp=floor((numberOfSlots-(i-1)*bandwidthPerClass(1))/bandwidthPerClass(2));        
%         M{c}()
M1=floor(numberOfSlots/bandwidthPerClass(1));
M2=zeros(1,M1+1);
 if(classes>1)
     for i=1:M1+1
         M2(i)=floor((numberOfSlots-(i-1)*bandwidthPerClass(1))/bandwidthPerClass(2));
     end
 end
 M3=zeros(M1+1,max(M2)+1);
 if(classes>2)
     for i=1:M1+1
         for j=1:M2(i)+1
             M3(i,j)=floor((numberOfSlots-(i-1)*bandwidthPerClass(1)-(j-1)*bandwidthPerClass(2))/bandwidthPerClass(3));
         end
     end
 end
 M4=zeros(M1+1,max(M2)+1,max(max(M3))+1);
 if(classes>3)
     for i=1:M1+1
         for j=1:M2(i)+1
             for k=1:M3(i,j)+1
                 M4(i,j,k)=floor((numberOfSlots-(i-1)*bandwidthPerClass(1)-(j-1)*bandwidthPerClass(2)-(k-1)*bandwidthPerClass(3))/bandwidthPerClass(4));
             end
         end
     end
 end
 
 switch classes 
     case 1
         number=M1+1;
     case 2
         for n1=1:M1+1
             for n2=1:M2(n1)+1
                number= number+1;
             end
         end
     case 3
         for n1=1:M1+1
             for n2=1:M2(n1)+1
                 for n3=1:M3(n1,n2)+1
                    number= number+1;
                 end
             end
         end
      case 4
         for n1=1:M1+1
             for n2=1:M2(n1)+1
                 for n3=1:M3(n1,n2)+1
                     for n4=1:M4(n1,n2,n3)+1
                         number= number+1;
                     end
                 end
             end
         end
     otherwise
         disp('error: more than 4 classes ')
 end
 number=number^numberOfCores;
return;