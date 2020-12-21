function [numberOfLinks,numberOfRoutes,link_routes,which_routes_use_link,routesPerODpair,which_odPair_use_route,max_hop,route_1stOr2nd] = Network(network_type,nr_ksp)    
switch network_type
    case 0 % unidirectional link
%          if(nr_ksp==1)
%              network = [0,1;
%                        0,0];
%              routes{1}=[1,2];
%          else
             numberOfRoutes=nr_ksp;
             numberOfLinks=nr_ksp;
             routesPerODpair{1}(1,1)=1;
             max_hop=1;
               for ksp=1:nr_ksp
                   link_routes{ksp}=ksp;
                   which_routes_use_link{ksp}=ksp;
                   routesPerODpair{1}(1,ksp)=ksp;
                   which_odPair_use_route(ksp)=1;
                   route_1stOr2nd=1;
               end 
             return;
%         end
    case 1 % 2-hop
        network = [0,1,0;
                   0,0,1;
                   0,0,0];
         if(nr_ksp==1)      
             routes{1}=[1,2];
             routes{2}=[2,3];
             routes{3}=[1,2,3];
             route_1stOr2nd=1;
         else % ksp>=2
              disp('there is no other routes');
         end
    case 2 % 5-hops
        network = [0,1,0,0,0,0;
                   0,0,1,0,0,0;
                   0,0,0,1,0,0;
                   0,0,0,0,1,0;
                   0,0,0,0,0,1;
                   0,0,0,0,0,0];
               
         if(nr_ksp==1)      
             routes{1}=[1,2];
             routes{2}=[1,2,3];
             routes{3}=[1,2,3,4];
             routes{4}=[1,2,3,4,5];
             routes{5}=[1,2,3,4,5,6];
             routes{6}=[2,3];
             routes{7}=[2,3,4];
             routes{8}=[2,3,4,5];
             routes{9}=[2,3,4,5,6];
             routes{10}=[3,4];
             routes{11}=[3,4,5];
             routes{12}=[3,4,5,6];
             routes{13}=[4,5];
             routes{14}=[4,5,6];
             routes{15}=[5,6];
             route_1stOr2nd=1;
         else % ksp>=2
              disp('there is no other routes');
         end     
    case 3 % special network
        network = [0,1,1;
                   0,0,0;
                   0,1,0];
         if(nr_ksp==1)      
             routes{1}=[1,2];
             routes{2}=[1,3];
             routes{3}=[3,2];
             
             route_1stOr2nd=[1,1,1]; % identifies whether a route is primary of secondary
         else % ksp=2
             routes{1}=[1,2];
             routes{2}=[1,3,2];
             routes{3}=[1,3];
             routes{4}=[3,2];
             
             route_1stOr2nd=[1,2,1,1];
         end
    case 4 % 6-node ring
        network = [0,1,0,0,0,1;
                   1,0,1,0,0,0;
                   0,1,0,1,0,0;
                   0,0,1,0,1,0;
                   0,0,0,1,0,1;
                   1,0,0,0,1,0];
         routes{1}=[0,1]+1;
         routes{2}=[0,1,2]+1;
         routes{3}=[0,1,2,3]+1;
         routes{4}=[0,5]+1;
         routes{5}=[0,5,4]+1;
         routes{6}=[1,2]+1;
         routes{7}=[1,2,3]+1;
         routes{8}=[1,2,3,4]+1;
         routes{9}=[1,0]+1;
         routes{10}=[1,0,5]+1;
         routes{11}=[2,3]+1;
         routes{12}=[2,3,4]+1;
         routes{13}=[2,3,4,5]+1;
         routes{14}=[2,1]+1;
         routes{15}=[2,1,0]+1;
         routes{16}=[3,4]+1;
         routes{17}=[3,4,5]+1;
         routes{18}=[3,4,5,0]+1;
         routes{19}=[3,2]+1;
         routes{20}=[3,2,1]+1;
         routes{21}=[4,5]+1;
         routes{22}=[4,5,0]+1;
         routes{23}=[4,5,0,1]+1;
         routes{24}=[4,3]+1;
         routes{25}=[4,3,2]+1;
         routes{26}=[5,0]+1;
         routes{27}=[5,0,1]+1;
         routes{28}=[5,0,1,2]+1;
         routes{29}=[5,4]+1;
         routes{30}=[5,4,3]+1;   
         route_1stOr2nd=1;
    case 5 % nsfnet
        network =[0,1,1,0,0,0,0,1,0,0,0,0,0,0;
                  1,0,1,1,0,0,0,0,0,0,0,0,0,0;
                  1,1,0,0,0,1,0,0,0,0,0,0,0,0;
                  0,1,0,0,1,0,0,0,0,0,1,0,0,0;
                  0,0,0,1,0,1,1,0,0,0,0,0,0,0;
                  0,0,1,0,1,0,0,0,0,1,0,0,1,0;
                  0,0,0,0,1,0,0,1,0,0,0,0,0,0;
                  1,0,0,0,0,0,1,0,1,0,0,0,0,0;
                  0,0,0,0,0,0,0,1,0,1,0,1,0,1;
                  0,0,0,0,0,1,0,0,1,0,0,0,0,0;
                  0,0,0,1,0,0,0,0,0,0,0,1,0,1;
                  0,0,0,0,0,0,0,0,1,0,1,0,1,0;
                  0,0,0,0,0,1,0,0,0,0,0,1,0,1;
                  0,0,0,0,0,0,0,0,1,0,1,0,1,0];
              if(nr_ksp==1)
                  route_name='nsf-k1.txt';
                  route_1stOr2nd=ones(1,182);
              else
                  route_name='nsf-k2-disjoint.txt'; %  nsf-k2.txt
                  route_1stOr2nd=ones(1,364);
                  route_1stOr2nd(2:2:364)=2;
              end
              myFileName = sprintf(route_name);
              filename=myFileName;
              dir = 'H:\PhD Work\MatlabCode\Theoretical\Approximate-KSP\';
              filename = strcat(dir,filename);
              %fprintf('%s \n',filename);
              fid = fopen(filename);
              tline = fgetl(fid);
              %tlines = cell(0,1);
              routes={};
              
              while ischar(tline)
                    routes{end+1} = str2num(tline)+1; % Convert the string to the  numeric value, 1 is added since node numbering starts from 0 in nsf-file
                    tline = fgetl(fid);
              end
              fclose(fid);
              
       case 6 % atlanta
        network =[0,0,0,0,0,1,1,1,0,0,0,0,0,0,0;
                  0,0,1,0,1,1,0,0,0,0,0,0,0,0,0;
                  0,1,0,0,1,0,0,1,0,0,0,0,0,0,0;
                  0,0,0,0,1,1,0,0,0,0,0,0,0,0,0;
                  0,1,1,1,0,0,0,0,0,0,0,0,0,0,0;
                  1,1,0,1,0,0,0,0,0,0,0,0,1,0,0;
                  1,0,0,0,0,0,0,0,0,1,0,0,0,1,0;
                  1,0,1,0,0,0,0,0,1,0,0,0,0,0,1;
                  0,0,0,0,0,0,0,1,0,1,0,1,0,0,1;
                  0,0,0,0,0,0,1,0,1,0,0,1,0,0,0;
                  0,0,0,0,0,0,0,0,0,0,0,0,1,1,0;
                  0,0,0,0,0,0,0,0,1,1,0,0,0,0,0;
                  0,0,0,0,0,1,0,0,0,0,1,0,0,1,0;
                  0,0,0,0,0,0,1,0,0,0,1,0,1,0,0;
                  0,0,0,0,0,0,0,1,1,0,0,0,0,0,0];
              if(nr_ksp==1)
                  route_name='atlanta-k1.txt';
                  route_1stOr2nd=ones(1,210);
              else
                  route_name='atlanta-k2.txt'; %  nsf-k2.txt
                  route_1stOr2nd=ones(1,420);
                  route_1stOr2nd(2:2:420)=2;
              end
              myFileName = sprintf(route_name);
              filename=myFileName;
              dir = 'H:\PhD Work\MatlabCode\Theoretical\Approximate-KSP\';
              filename = strcat(dir,filename);
              %fprintf('%s \n',filename);
              fid = fopen(filename);
              tline = fgetl(fid);
              %tlines = cell(0,1);
              routes={};
              
              while ischar(tline)
                    routes{end+1} = str2num(tline); % Convert the string to the  numeric value, 1 is not added since node numbering starts from 1 in atlanta-file
                    tline = fgetl(fid);
              end
              fclose(fid);
    case 7   % 10-hops
        network = [0,1,0,0,0,0,0,0,0,0,0;
                   0,0,1,0,0,0,0,0,0,0,0;
                   0,0,0,1,0,0,0,0,0,0,0;
                   0,0,0,0,1,0,0,0,0,0,0;
                   0,0,0,0,0,1,0,0,0,0,0;
                   0,0,0,0,0,0,1,0,0,0,0;
                   0,0,0,0,0,0,0,1,0,0,0;
                   0,0,0,0,0,0,0,0,1,0,0;
                   0,0,0,0,0,0,0,0,0,1,0;
                   0,0,0,0,0,0,0,0,0,0,1;
                   0,0,0,0,0,0,0,0,0,0,0];
               
               if(nr_ksp==1)
                  route_name='link-10hops.txt';
              else
                  disp('no k2');
              end
              myFileName = sprintf(route_name);
              filename=myFileName;
              dir = 'H:\PhD Work\MatlabCode\Theoretical\Approximate-KSP\';
              filename = strcat(dir,filename);
              %fprintf('%s \n',filename);
              fid = fopen(filename);
              tline = fgetl(fid);
              %tlines = cell(0,1);
              routes={};
              
              while ischar(tline)
                    routes{end+1} = str2num(tline)+1; % Convert the string to the  numeric value, 1 is added since node numbering starts from 0 in 10hops-file
                    tline = fgetl(fid);
              end
              fclose(fid);
                   
end


numberOfNodes=length(network(1,:)) ;

% represent links by numbers
links=zeros(numberOfNodes,numberOfNodes);
k=1;
for i=1:numberOfNodes
    for j=1: numberOfNodes
        if(i~=j && network(i,j)==1)
            links(i,j)=k;
            k=k+1;
        end
    end
end
numberOfLinks= k-1;
%path1=path+1; 
%routes={};
numberOfRoutes=length(routes);

route_length = zeros(1,numberOfRoutes);
link_routes{1}=[];
routesPerODpair{1}(1,1)=1;
od_pairs=[routes{1}(1,1),routes{1}(1,length(routes{1}))];
which_odPair_use_route=zeros(1,numberOfRoutes); % defines which odpair belongs to each route
max_hop=1;
for k=1:numberOfRoutes 
    temp_route=routes{k}(1,:);
    link_route=[];
    temp_od_pairs=[routes{k}(1,1),routes{k}(1,length(routes{k}))];
    index1= find(ismember(od_pairs(:,:),temp_od_pairs,'rows')==1,1);
    if(index1) % if od pair exists
        which_odPair_use_route(k)=index1;
        if (isempty(find(k==routesPerODpair{index1}(1,:),1)))
            routesPerODpair{index1}(1,length(routesPerODpair{index1})+1)=k;
        end
    else
        od_pairs= [od_pairs;temp_od_pairs];
        routesPerODpair{length(od_pairs(:,1))}(1,1)=k;
        which_odPair_use_route(k)=length(od_pairs(:,1));
    end

    for w=1:(length(temp_route)-1)
        link_route=[link_route,links(temp_route(w),temp_route(w+1))];
    end
    % put link numbers that this route traverses
    link_routes{k}=link_route;
    %Check how long current route is
    route_length(k)=length(link_route);
    max_hop=max(max_hop,route_length(k));
end
%avgHops=sum(route_length)/numberOfRoutes
%Check which routes use specified links
%Memory initialization
for k=1:numberOfLinks
    which_routes_use_link{k}=[];
end
for r=1:numberOfRoutes
    path=link_routes{r};
    for w=1:length(path)
%         if(path(w)==0)
%             disp('stop');
%         end
        which_routes_use_link{path(w)}=[which_routes_use_link{path(w)},r];
    end
end
end

