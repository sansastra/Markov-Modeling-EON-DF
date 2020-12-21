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

 
network_type=1; % 0=>a single link; 1=> 2-hop (KSP=1); 2 => 5 hops, 3=> special network ; 4 => 6-Node Ring; and 5 => NSFNET, 6=>atlanta, 7=>10-hops
nr_ksp=1;
DF =1 ; % => without (0) or with (1)  Defragmentation
Apprx= 'App'; % 'App' , 'Algo' , 'uniform'  
initialLoad = [10 15 20 25 30];%[100 150 200 250 300]; %  %[20 25 30 40 50]; %[0.0012 0.012 0.12 0.6 1.2];%[50 75 100 150 200];% [50 75 100 150 200]; %  [100 150 200 250 300];   

oneD=1 ; % 0 => macroState (n), 1 => overall occupancy, 1D
classes=length(bandwidthPerClass);
serviceRate = 1; % per class
%defragRate = 0; % defragmentation rate 


totalRun = length(initialLoad);


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
                tempConnections= tempConnections+macroSystemStates(index2(p),:);
            end
            avgCallClassPer1Dstate{k,1}=tempConnections/length(index2);
        end
    end
    numberOfStates= length(oneDsystemStates);
    oneDsystemStates = cell2mat(oneDsystemStates);  
    avgCallClassPer1Dstate = cell2mat(avgCallClassPer1Dstate);
    
freeSlicesPer1Dstate=numberOfSlots-oneDsystemStates;

% P_m_n for one link
if(policy==1)
  [probOfStateInNB_1,probOfStateInFB,probOfStateInRB,numOfNonFBstates,numOfFBstates,numOfRBstates]= GetProbOfTransitOfClassesFF(macroSystemStates,bandwidthPerClass,numberOfSlots,oneD, occupancyPerMacroState,oneDsystemStates);
else
  [probOfStateInNB_1,probOfStateInFB,probOfStateInRB,numOfNonFBstates,numOfFBstates,numOfRBstates]= GetProbOfTransitOfClasses(macroSystemStates,bandwidthPerClass,numberOfSlots,oneD, occupancyPerMacroState,oneDsystemStates);
end
% P_m_n for two links max, and P_m_n_l for three links
%[P_m_n,P_m_n_l,DF_m_n,DF_m_n_l]= P_n_m_ApprxRF(numberOfSlots,bandwidthPerClass,oneDsystemStates,oneD,probOfStateInNB,probOfStateInFB,occupancyPerState);

% %%%%exact calculation
% if(policy==2 && numberOfSlots< 15)
%    [P_m_n,P_m_n_l,DF_m_n,DF_m_n_l]= P_n_m_RandomFit(numberOfSlots,bandwidthPerClass,macroSystemStates,occupancyPerMacroState,oneDsystemStates,oneD,probOfStateInFB);
% else
%    [P_m_n,P_m_n_l,DF_m_n,DF_m_n_l]= P_n_m_AnyFit(policy,numberOfSlots,bandwidthPerClass,macroSystemStates,occupancyPerMacroState,oneDsystemStates,oneD,probOfStateInFB);
% end

% represent network, and calculate stationary probabilities for each state
[numberOfLinks,numberOfRoutes,linksOnRoutes,which_routes_use_link,routesPerODpair,which_odPair_use_route,max_hop] = Network(network_type,nr_ksp);

nrOfODpairs=length(routesPerODpair);
overallBPapproax=zeros(1,totalRun);
overallBPclassApproax=zeros(1,totalRun);
%combos= nchoosek(1:1:numberOfCores,numberOfCoresObserved);
for runNo = 1 : totalRun
    arrivalRatePerClassPerOD = (initialLoad(runNo))/(length(bandwidthPerClass)*nrOfODpairs);
    
    %Initialization Process
    %Initialize ALFA_j(m)
    alfa={};
    for k=1:numberOfLinks
        which_paths=which_routes_use_link{k};
        sum_alfa_paths= length(which_paths)*arrivalRatePerClassPerOD;
        for c=1:classes 
            temp_vector_alfa = zeros(1,numberOfStates);
            for state=1:numberOfStates 
                if(numberOfSlots >=oneDsystemStates(state)+bandwidthPerClass(c)) % we can also change to other policy, e.g., least-load: numberOfSlots >=occupancyPerState(state)+bandwidthPerClass(c)+threshold value
                  temp_vector_alfa(state)=sum_alfa_paths*probOfStateInNB_1(state,c);
                end
            end
            alfa{k,c}=temp_vector_alfa;
        end
    end

    %Lr and Lr_prim initialization

    %Lr and Lr_prim initialization
    Lr=0;
    Lr_all=0;
    Lr_prim_all=0;
    Lr_all(1:nrOfODpairs,1:classes)=0;
    Lr_prim_all(1:nrOfODpairs,1:classes)=Inf;
    Lr(1:numberOfRoutes,1:classes)=1; % 1 for multiplication
    
  
    while max(max(abs(Lr_all - Lr_prim_all)))>0.00000001 % epsilon
   
        
           Lr_prim_all=Lr_all;
           stateProbabilities={};
           %idleSlotProb = zeros(1, numberOfLinks);
           probOfStateInNB={};
           probOfStateInFB={};
           avgOccupiedSlots={};
           % calculate state probabilities for each link
           
           for link_nr=1:numberOfLinks
               lambdaPerStateApprox=zeros(numberOfStates,classes);
               for c=1:classes
                 lambdaPerStateApprox(:,c)=transpose(alfa{link_nr,c}) ;
               end
               [transitionRateMatrix,blockingStates] = TRMgenerationSDMapprox(lambdaPerStateApprox,serviceRate,macroSystemStates,oneD,oneDsystemStates,bandwidthPerClass,oneDsystemStates,avgCallClassPer1Dstate);
                stateProbabilities{link_nr}=CalculateStateProbabilities(transitionRateMatrix) ;
           
              % update probability of acceptance
              avgOccupiedSlots{link_nr}=sum(oneDsystemStates.*transpose(stateProbabilities{link_nr}));
              %idleSlotProb(link_nr) =avgOccupiedSlots{link_nr}/numberOfSlots;
              [probOfStateInNB{link_nr},probOfStateInFB{link_nr},probOfStateInRB]= GetProbOfTransitOfClassesApproxDF(bandwidthPerClass,numberOfSlots,oneDsystemStates,numOfNonFBstates,numOfFBstates,numOfRBstates,avgOccupiedSlots{link_nr});
              %enable next line if without DF and disable upper line
              %[probOfStateInNB{link_nr},probOfStateInFB{link_nr},probOfStateInRB]= GetProbOfTransitOfClassesApprox2(bandwidthPerClass,numberOfSlots,oneDsystemStates,numOfNonFBstates,numOfFBstates,numOfRBstates,avgOccupiedSlots{link_nr});
              
           end
           PoA_links={};
           
            for p=1:max_hop
                for link_nr=1:numberOfLinks
                    PoA_links{p,link_nr}=(probOfStateInNB{link_nr}).^p;
                end
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

                            temp_path(find(temp_path==link_nr))=[]; 
                            temp_PoA_links={};
                            for p=1:1:path_length-1
                                temp_PoA_links{p}= PoA_links{path_length,temp_path(p)};
                            end
                           temp_PoA_links{path_length}=PoA_links{path_length,link_nr};% put the PoA of given link at last;
                           [Pr_Xr_Xj_routes{r,link_nr}(:,:)]= Calculate_Pr_Xr_Xj_App2(bandwidthPerClass,freeSlicesPer1Dstate,temp_PoA_links,stateProbabilities,path_length,temp_path);
                           %Pr_Xr_Xj_error{r,link_nr}(:,:)=Pr_Xr_Xj_error_route;
                           if(sum(sum(Pr_Xr_Xj_routes{r,link_nr}(:,:)<0))>0 )
                              disp('error in pr_Xr_Xj_route');
                              Pr_Xr_Xj_routes(Pr_Xr_Xj_routes{r,link_nr}(:,:)<0)=0;
                           end
                   end
               else
                   Pr_Xr_Xj_routes{r,path(1)}(:,:)=PoA_links{path_length,path(1)};
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
    

  
%     for c=1:classes
%           overallBPclassApproax(runNo)=  sum(Lr(:,c))/(numberOfRoutes);
%     end
    overallBPapproax(runNo) = sum(sum(Lr_all))/(nrOfODpairs*classes);
end

% fprintf('\n%s','class blocking probabilities= ');
% for c=1:classes
%     fprintf('%d ,',sum(Lr(:,c))/(numberOfRoutes));
% end
fprintf('\n%s','overallBlockingProbability Approax2 = ')
for k=1:totalRun
    fprintf('%d,',overallBPapproax(k));   
end


% y=1:1:20;
% C=20;
% m=0;
% for i=1:20
%     l=10;
%     y(i)=exp(-(l/C)*abs((log(i/l))));
% end
% plot(y)

    
%     lambdaPerStateApprox=arrivalRatePerClassPerOD*(probOfStateInNB); %probOfStateInNB; % obtained by approximation
%     lambdaDFPerStateApprox=arrivalRatePerClassPerOD*(probOfStateInNB+probOfStateInFB);%probOfStateInFB; % obtained by approximation
%      % genrate transition rate matrix and find state probabilities for estimate
%     switch modelType
%         case 0
%             [transitionRateMatrix,blockingStates] = TRMgenerationSDMapprox(lambdaPerStateApprox,serviceRate,macroSystemStates,oneD,occupancyPerState,bandwidthPerClass,oneDsystemStates);
%             
%         case 1
%             [transitionRateMatrix,blockingStates] = TRMgenerationSDMapprox(lambdaDFPerStateApprox,serviceRate,macroSystemStates,0,occupancyPerState,bandwidthPerClass,oneDsystemStates);
%             %TRMgenerationSDMapproxDFWoB(lambdaPerStateApprox,lambdaDFPerStateApprox,arrivalRatePerClass,serviceRate,defragRate,systemStates);
%     end
%     stateProbabilities=CalculateStateProbabilities(transitionRateMatrix) ;
%     
%     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     % calulate state dependent arrivals on links in a 2-hop network 0----1----2
%      % flow1=> 0-1-2; and flow2=>1-2
%     
%     
%     stateProbabilities1=stateProbabilities;
%     stateProbabilities2=stateProbabilities;
%     blockingPerClass_old1=ones(1,classes);
%     blockingPerClass1= zeros(1,classes);
%     blockingPerClass_old2=ones(1,classes);
%     blockingPerClass2= zeros(1,classes);
%     %numberOfLinks=2;
%     while(max(max(abs(blockingPerClass_old1-blockingPerClass1),abs(blockingPerClass_old2-blockingPerClass2)))>0.00001)
%         blockingPerClass_old1=blockingPerClass1;
%         blockingPerClass_old2=blockingPerClass2;
%         % for link1 (0---1)
%         numberOfHopsFlow1=2;
%         numberOfHopsFlow2=1; % for flow2
%         ProbOfCallSetup = FindStateDependentLambda(bandwidthPerClass,macroSystemStates,P_m_n,stateProbabilities2,numberOfHopsFlow1,oneD,oneDsystemStates);
%         lambdaPerStatePerClass1 = ProbOfCallSetup*arrivalRatePerClassPerOD;
%         [transitionRateMatrix,blockingStates] = TRMgenerationSDMapprox(lambdaPerStatePerClass1,serviceRate,macroSystemStates,oneD,occupancyPerState,bandwidthPerClass,oneDsystemStates);
%         
%         % for link2 (1---2)(2 O-D flows passes through this link)
%        
%         ProbOfCallSetup = FindStateDependentLambda(bandwidthPerClass,macroSystemStates,P_m_n,stateProbabilities1,numberOfHopsFlow1,oneD,oneDsystemStates);
%         lambdaPerStatePerClass1 = ProbOfCallSetup*arrivalRatePerClassPerOD;
%         lambdaPerStatePerClass2 = lambdaPerStatePerClass1 + probOfStateInNB*arrivalRatePerClassPerOD;
%         % state probabilities for link1
%         stateProbabilities1=CalculateStateProbabilities(transitionRateMatrix) ;
%         % state probabilities for link2
%         [transitionRateMatrix,blockingStates] = TRMgenerationSDMapprox(lambdaPerStatePerClass2,serviceRate,macroSystemStates,oneD,occupancyPerState,bandwidthPerClass,oneDsystemStates);
%         stateProbabilities2=CalculateStateProbabilities(transitionRateMatrix) ;
%         
%         % blocking probability for flow1 (0-1-2) %%%%%%%%%%%%%%%%%%%%%%%%%%%
%         blockingPerClass1 = CalculateApproxBPInEONs(stateProbabilities1,stateProbabilities2,P_m_n,bandwidthPerClass,numberOfSlots-occupancyPerState,numberOfHopsFlow1);
%        % blocking probability for flow2 (1-2) %%%%%%%%%%%%%%%%%%%%%%%%%%%
%         blockingPerClass2 = CalculateApproxBPInEONs(stateProbabilities2,stateProbabilities2,probOfStateInNB,bandwidthPerClass,numberOfSlots-occupancyPerState,numberOfHopsFlow2);
%         
%     end
%     
%     sum(blockingPerClass1+blockingPerClass2)*100/4
   
   
%     while(max(abs(blockingPerClass_old-blockingPerClass))>0.001)
%         blockingPerClass_old=blockingPerClass;
%         % for link2 (1---2)
%         ProbOfCallSetup = FindStateDependentLambda(bandwidthPerClass,macroSystemStates,P_m_n,stateProbabilities1,numberOfHopsFlow1); % flow1 call setup rate on link 2
%         
%         lambdaPerStatePerClass1 = (ProbOfCallSetup+probOfStateInNB)*arrivalRatePerClass; % probOfStateInNB is the call setup probability for single hop flow 2
%         [transitionRateMatrix,blockingStates] = TRMgenerationSDMapprox(lambdaPerStatePerClass1,serviceRate,macroSystemStates,oneD,occupancyPerState,bandwidthPerClass,oneDsystemStates);
%         stateProbabilities1=CalculateStateProbabilities(transitionRateMatrix) ;
%         
%        
%         % find blocking probabilities
%     end



    
