% to switch off warning of nchoose k, use these two commands 
% [a, MSGID] = lastwarn();
% warning('off', MSGID)

%clc;
%clearvars;
%numberOfCores=1; (non-disjoint)- sim-8.00905E-5,6.5225834E-4,0.0017620781,0.04429455, App. 3.727930e-06,1.478366e-04,6.589366e-04,4.248217e-02
                  % disjoint- sim 1.4139423E-6,3.7066056E-5,2.1583446E-4,0.03265252, App. 4.193580e-06,1.660662e-04,7.390562e-04,4.689953e-02
numberOfSlots =100;
bandwidthPerClass = [3 4 6];
policy =2; % 1 => First-fit; 2 => Random-fit
modelType = 0; %0 => normal; 1 => RaaS with degrag
 
network_type=5; % 0=>a single link; 1=> 2-hop (KSP=1); 2 => 5 hops, 3=> special network ; 4 => 6-Node Ring; and 5 => NSFNET, 6=> Atlanta, 7=>10-hps
nr_ksp=2;
WoSC =1 ; % 0 => without (1) or with (0)  spectrum conversion

Apprx= 'App'; % 'App' , 'Algo' , 'uniform'  
initialLoad = 100; %[15 20 25 30 35]; %[20 25 30 40 50]; %[0.0012 0.012 0.12 0.6 1.2];% %[8 12 16 20]; % [50 75 100 150 200]; %  [100 150 200 250 300]; % [0.1,0.6,1.2,7.2]; % %   [12 16 20 24]; %     [10 20]; %   %       

oneD=1 ; % 0 => macroState (n), 1 => overall occupancy, 1D
classes=length(bandwidthPerClass);
serviceRate = 1; % per class
%defragRate = 0; % defragmentation rate 


totalRun = length(initialLoad);
% FBProbability=zeros(1,totalRun);
% RBProbability=zeros(1,totalRun);
%defragBlockingProbability=zeros(1,totalRun);

if (classes<5)
    [macroSystemStates, occupancyPerMacroState]= GenerateMacroStates(numberOfSlots,bandwidthPerClass);
else
    disp('reduce the number of classes')
end


%[systemStates,bp,tran]= TSgenerateStates(numberOfSlots,bandwidthPerClass);% only works for 1 core
numberOfMacroStates=length(macroSystemStates(:,1))
%defragStates=systemStates;

oneDsystemStates={};
avgCallClassPer1Dstate={}; % finding expected number of connections per class in a microstate
%if (oneD)
    % find number valid 1D states
    k=1;
    oneDsystemStates{k}=0;
    avgCallClassPer1Dstate{k,1}=zeros(1,classes);
    for i=1: numberOfSlots
       index2 = find(occupancyPerMacroState==i);
         if(~isempty(index2))
            k = k+1;
            oneDsystemStates{k}=i;
            tempConnections=zeros(1,classes);
            for p=1:length(index2)
                tempConnections= tempConnections+ macroSystemStates(index2(p),:);
            end
            avgCallClassPer1Dstate{k,1}=tempConnections/length(index2);
        end
    end
    numberOfStates= length(oneDsystemStates);
    oneDsystemStates = cell2mat(oneDsystemStates);  
    avgCallClassPer1Dstate = cell2mat(avgCallClassPer1Dstate);
    

freeSlicesPer1Dstate=numberOfSlots-oneDsystemStates;
PoA_links={};
% represent network, and calculate stationary probabilities for each state
[numberOfLinks,numberOfRoutes,linksOnRoutes,which_routes_use_link,routesPerODpair,which_odPair_use_route,max_hop,route_1stOr2nd] = Network(network_type,nr_ksp);

if strcmp(Apprx,'App')
    % P_m_n for one link PoA_2links,,PoA_4links,PoA_5links
    if(policy==1)
      [probOfStateInNB,probOfStateInFB,probOfStateInRB,numOfNonFBstates,numOfFBstates,numOfRBstates]= GetProbOfTransitOfClassesFF(macroSystemStates,bandwidthPerClass,numberOfSlots,oneD, occupancyPerMacroState,oneDsystemStates);
    else
      [probOfStateInNB,probOfStateInFB,probOfStateInRB,numOfNonFBstates,numOfFBstates,numOfRBstates]= GetProbOfTransitOfClasses(macroSystemStates,bandwidthPerClass,numberOfSlots,oneD, occupancyPerMacroState,oneDsystemStates);
    end
    % approximations for P_m_n for two links, and P_m_n_l for three links
    
    %[PoA_2links,PoA_3links]= P_n_m_ApprxRF(bandwidthPerClass,oneDsystemStates,probOfStateInNB);  
    
    if(WoSC==1 && modelType==0)
        for p=1:max_hop
            PoA_links{p}=probOfStateInNB.^p;
        end
        
    else
        if (WoSC==0 && modelType==0)
            for p=1:max_hop
                PoA_links{p}=probOfStateInNB;
            end
        end
    end
else
    % needs to be corrected
    if strcmp(Apprx,'Algo')
       % if you want to calculate using Algo.
        %%exact calculation
%         if(policy==2 && numberOfSlots< 15)
%             %only valid if WoSC=1
%            [P_m_n,P_m_n_l,DF_m_n,DF_m_n_l]= P_n_m_RandomFit(numberOfSlots,bandwidthPerClass,macroSystemStates,occupancyPerMacroState,oneDsystemStates,oneD,probOfStateInFB);
%         else
            %valid if WoSC=0 and 1
          [PoA_2links,PoA_3links,DF_m_n,DF_m_n_l]= P_n_m_AnyFit(WoSC,policy,numberOfSlots,bandwidthPerClass,macroSystemStates,occupancyPerMacroState,oneDsystemStates,oneD,probOfStateInFB);
       % end
    else
        [probOfStateInNB,probOfStateInFB,PoA_2links,PoA_3links,DF_m_n,DF_m_n_l]= P_n_m_ApprxUniform(WoSC,numberOfSlots,bandwidthPerClass,oneDsystemStates,oneD,oneDsystemStates);
    end
end


%betaDF=zeros(numberOfStates,classes);
nrOfODpairs=length(routesPerODpair);
overallBPapproax=zeros(1,totalRun);
overallBPclassApproax=zeros(1,totalRun);
%ep_ini=0.00000001;
%epsilon_perRun=[ep_ini,10*ep_ini,100*ep_ini,1000*ep_ini,10000*ep_ini];

%combos= nchoosek(1:1:numberOfCores,numberOfCoresObserved);
for runNo = 1 : totalRun
    arrivalRatePerClassPerOD = (initialLoad(runNo))/(length(bandwidthPerClass)*nrOfODpairs);%    sum(bandwidthPerClass); %;%      % +100*(runNo-1)
    %arrivalRate = classes*arrivalRatePerClass;
    
    %Initialization Process
    %Initialize ALFA_j(m)
    alfa={};
    for k=1:numberOfLinks
        which_paths=which_routes_use_link{k};
        %sum_alfa_paths= length(which_paths)*arrivalRatePerClassPerOD;
        if(nr_ksp==1)
           sum_alfa_paths= length(which_paths)*arrivalRatePerClassPerOD;
        else
            sum_alfa_paths=0;
            for j =1: length(which_paths)
                if(route_1stOr2nd(which_paths(j))==1)
                sum_alfa_paths=sum_alfa_paths+ arrivalRatePerClassPerOD;
                end
            end
        end
        for c=1:classes 
            temp_vector_alfa = zeros(1,numberOfStates);
            for state=1:numberOfStates 
                if(numberOfSlots >=oneDsystemStates(state)+bandwidthPerClass(c)) % we can also change to other policy, e.g., least-load: numberOfSlots >=occupancyPerState(state)+bandwidthPerClass(c)+threshold value
                  temp_vector_alfa(state)=sum_alfa_paths*probOfStateInNB(state,c);
                end
            end
            alfa{k,c}=temp_vector_alfa;
        end
    end

    %Lr and Lr_prim initialization
    Lr=0;
    Lr_all=0;
    Lr_prim_all=0;
    Lr_all(1:nrOfODpairs,1:classes)=0;
    Lr_prim_all(1:nrOfODpairs,1:classes)=Inf;
    Lr(1:numberOfRoutes,1:classes)=1; % just for multiplication
   
    while max(max(abs(Lr_all - Lr_prim_all)))> 0.00000001% epsilon_perRun(runNo) % epsilon 0.00000001
           
        Lr_prim_all=Lr_all;
           stateProbabilities={};
           % calculate state probabilities for each link
           %BPperLinkperClass=zeros(numberOfLinks,classes);
           %avgOccupiedSlots={};
           for k=1:numberOfLinks
               lambdaPerStateApprox=[];
               for c=1:classes
                 lambdaPerStateApprox=[lambdaPerStateApprox,transpose(alfa{k,c})] ;
               end
               [transitionRateMatrix,blockingStates] = TRMgenerationSDMapprox(lambdaPerStateApprox,serviceRate,macroSystemStates,oneD,oneDsystemStates,bandwidthPerClass,oneDsystemStates,avgCallClassPer1Dstate);
                stateProbabilities{k}=CalculateStateProbabilities(transitionRateMatrix) ;   
           end

           % claculate Pr_Xr_Xj for all routes in a given link and state
           Pr_Xr_Xj_routes={};
           for r=1:numberOfRoutes
               path=linksOnRoutes{r};
               path_length=length(path); % reduced path
               if(path_length>1)
                   for link_ind=1:path_length
                       temp_path=path;
                       link_nr=temp_path(link_ind);

                       %Remove the link we are considering (link K)
                            temp_path(find(temp_path==link_nr,1))=[]; 

                           Pr_Xr_Xj_routes{r,link_nr}(:,:)= Calculate_Pr_Xr_Xj(bandwidthPerClass,freeSlicesPer1Dstate,PoA_links{path_length},stateProbabilities,path_length,temp_path);
                           %Pr_Xr_Xj_error{r,link_nr}(:,:)=Pr_Xr_Xj_error_route;
                           if(sum(sum(Pr_Xr_Xj_routes{r,link_nr}(:,:)<0))>0 )
                              disp('error in pr_Xr_Xj_route');
                              Pr_Xr_Xj_routes(Pr_Xr_Xj_routes{r,link_nr}(:,:)<0)=0;
                           end
                   end
               else
                   Pr_Xr_Xj_routes{r,path(1)}(:,:)=PoA_links{path_length};
               end                   
           end
           % calculate blocking probabilities of all s-d pair flows for primary path
           for odPair=1:nrOfODpairs
                %for route_index=1:length(routesPerODpair{odPair}(1,:))
                    path=linksOnRoutes{routesPerODpair{odPair}(1,1)}; % route_index=1
                    [blockingPerClass] = CalculateApproxBPInEONs(stateProbabilities,Pr_Xr_Xj_routes{routesPerODpair{odPair}(1,1),path(1)}(:,:),bandwidthPerClass,freeSlicesPer1Dstate,path);
                    Lr(routesPerODpair{odPair}(1,1),:)=blockingPerClass;
           end
           % calculate state dependent arrival rates
            %Compute ALFA_j(m)
            for k=1:numberOfLinks
                %For every link present in the network

                    %For every path which traverses link K
                    %Initialize Pr_Xr_Xj in every iteration
                    pr_Xr_Xj_c=zeros(numberOfStates,classes);
                    
                    for g=1:length(which_routes_use_link{k})
                        %Take first path which traverses link k
                        pr_Xr_Xj_c_temp=zeros(numberOfStates,classes);
                         % find whether this route is primary or one of alternate routes 
                        temp_routes=routesPerODpair{which_odPair_use_route(which_routes_use_link{k}(g))}; % all routes belonging to the same od pair
                        index1=find(which_routes_use_link{k}(g)==temp_routes,1);
                        if(index1>1)
                            ksp_mul_factor=ones(1,classes);
                            for route_index=1:index1-1
                                ksp_mul_factor=ksp_mul_factor.*Lr(temp_routes(route_index),:);
                            end

                            for state1=1:numberOfStates
                                pr_Xr_Xj_c_temp(state1,:)=Pr_Xr_Xj_routes{which_routes_use_link{k}(g),k}(state1,:).*ksp_mul_factor;
                            end
                        else
                            pr_Xr_Xj_c_temp=Pr_Xr_Xj_routes{which_routes_use_link{k}(g),k}(:,:);
                        end
                        pr_Xr_Xj_c= pr_Xr_Xj_c + pr_Xr_Xj_c_temp;
                    end
                    lambdaPerStatePerClass = arrivalRatePerClassPerOD*pr_Xr_Xj_c;
                    for c=1:classes
                        alfa{k,c}=transpose(lambdaPerStatePerClass(:,c)); % check if it assigns correctly or not    
                    end
            end
           
           
           
           % calculate blocking probabilities of all s-d pair flows
           
           for odPair=1:nrOfODpairs
                Lr_all(odPair,1:classes)=Lr(routesPerODpair{odPair}(1,1),:); % blocking on first route
                for route_index=2:length(routesPerODpair{odPair}(1,:))
                    path=linksOnRoutes{routesPerODpair{odPair}(1,route_index)};
                    [blockingPerClass] = CalculateApproxBPInEONs(stateProbabilities,Pr_Xr_Xj_routes{routesPerODpair{odPair}(1,route_index),path(1)}(:,:),bandwidthPerClass,freeSlicesPer1Dstate,path);
                    Lr(routesPerODpair{odPair}(1,route_index),:)=blockingPerClass;
                    Lr_all(odPair,:)=blockingPerClass.*Lr_all(odPair,:);
                end
           end
           
    end
    
%     for odPair=1:nrOfODpairs
%         for route=1:length(routesPerODpair{odPair}(1,:))
%             path=linksOnRoutes{route};
%             RBperClass = CalculateApproxRBPInEONs(stateProbabilities,bandwidthPerClass,numberOfSlots-occupancyPerState,path);
%             RBProbability(runNo)=RBProbability(runNo)+sum(RBperClass);
%         end
%     end
  
%     for c=1:classes
%           overallBPclassApproax(runNo)=  sum(Lr(:,c))/(nrOfODpairs);
%     end
    %RBProbability(runNo)=RBProbability(runNo)/(nrOfODpairs*classes);
    overallBPapproax(runNo) = sum(sum(Lr_all))/(nrOfODpairs*classes);
    %FBProbability(runNo)=overallBPapproax(runNo)-RBProbability(runNo);
end

% fprintf('\n%s','class blocking probabilities= ');
% for c=1:classes
%     fprintf('%d ,',sum(Lr(:,c))/(numberOfRoutes));
% end

% fprintf('\n%s','Resource-BP Approax = ')
% for k=1:totalRun
%     fprintf('%d,',RBProbability(k));   
% end
% fprintf('\n%s','Fragmentation-BP Approax = ')
% for k=1:totalRun
%     fprintf('%d,',FBProbability(k));   
% end
fprintf('\n%s','overallBlockingProbability Approax1 = ')
for k=1:totalRun
    fprintf('%d,',overallBPapproax(k));   
end



    




    
