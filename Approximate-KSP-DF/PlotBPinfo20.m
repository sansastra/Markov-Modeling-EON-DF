% INFOCOM 2020 %%%%%%%%%%%%%
%%%%%%% Probability of Acceptance %%%%
% C=20, d=(3,4,5), load=1.2

% plot probability of acceptance
p_k_x_exact_RF=[1,1,1,1,1,1,9.966144e-01,9.858671e-01,9.547406e-01,8.534895e-01,7.663404e-01,6.532156e-01,4.923878e-01,3.102919e-01,1.444398e-01,5.522086e-02,0,0,0]; %[1,1,9.365904e-01,4.063021e-01,1.632899e-01,0,0,0];
p_k_x_approx1_RF=[1,1,1,1,1,1,9.963370e-01,9.602564e-01,9.134199e-01,8.484848e-01,7.355556e-01,5.908497e-01,4.308390e-01,2.736661e-01,1.326531e-01,4.047619e-02,0,0,0]; %[1,1,9.285714e-01,4.000000e-01,1.500000e-01,0,0,0];
p_k_x_approx2_RF=[1,1,1,1,1,1,9.995614e-01,9.943088e-01,9.858300e-01,9.724614e-01,9.476589e-01,9.130455e-01,8.714825e-01,8.271610e-01,5.336107e-01,2.573269e-01,0,0,0];

p_k_x_exact_FF=[1,1,1,1,1,1,9.990736e-01,9.960082e-01,9.937742e-01,9.859524e-01,9.508236e-01,8.935583e-01,8.081850e-01,7.567169e-01,5.014065e-01,2.532552e-01,0,0,0];%[1,1,9.248534e-01,8.828901e-01,4.625122e-01,0,0,0];
p_k_x_approx1_FF=[1,1,1,1,1,1,9.950980e-01,9.579832e-01,9.162534e-01,8.609113e-01,7.712091e-01,6.610455e-01,5.282359e-01,3.739219e-01,1.985380e-01,6.468798e-02,0,0,0];%[1,1,8.750000e-01,7.142857e-01,3.750000e-01,0,0,0];
p_k_x_approx2_FF=[1,1,1,1,1,1,9.994226e-01,9.940421e-01,9.863725e-01,9.747953e-01,9.547596e-01,9.279239e-01,8.932890e-01,8.506154e-01,5.496202e-01,2.633222e-01,0,0,0];

p_k_x_Uniform=[1.0000,1.0000,0.9952,0.9720,0.9203,0.8399,0.7378,0.6226,0.5018,0.3825,0.2721,0.1778,0.1042,0.0526,0.0211,0.0053,0,0,0];

Kaufmann=[ones(1,14),0.6667,0.3333,0,0,0]; % p_k(x=16)= (1+1+0)/3
Binomial=0.9405*ones(1,19);
Erlang=[0,3:1:20];
%figure;
%plot(Erlang,p_k_x_exact_FF,'rx-',Erlang,p_k_x_approx1_FF,'r>-',Erlang,p_k_x_approx2_FF,'rd-',Erlang,p_k_x_exact_RF,'g.-',Erlang,p_k_x_approx1_RF,'go-',Erlang,p_k_x_approx2_RF,'rp-');
%legend('FF, Exact','FF, App.EES','FF, App.SOC','RF, Exact','RF, App.EES','RF, App.SOC');
%subplot(1,2,1)
% plot(Erlang,p_k_x_exact_RF,'r.-',Erlang,p_k_x_approx1_RF,'go-',Erlang,p_k_x_approx2_RF,'b>-',Erlang,p_k_x_Uniform,'m+-',Erlang,Kaufmann,'kx--',Erlang,Binomial,'c*--');
% legend('Exact','App.EES','App.SOC','App.Uni', 'Kaufmann', 'Binomial');
% xlabel('Number of Occupied Slices (x)');
% ylabel({'Avg. Probability of Acceptance in RF'});
% figure;
% %subplot(1,2,2)
% plot(Erlang,p_k_x_exact_FF,'r.-',Erlang,p_k_x_approx1_FF,'go-',Erlang,p_k_x_approx2_FF,'b>-',Erlang,p_k_x_Uniform,'m+-',Erlang,Kaufmann,'kx--',Erlang,Binomial,'c*--');
% legend('Exact','App.EES','App.SOC','App.Uni', 'Kaufmann', 'Binomial');
% xlabel('Number of Occupied Slices (x)');
% ylabel({'Avg. Probability of Acceptance in FF'});


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%% 10-hops %%%%%%%%%%%%%%%%%%%
% 10-links , C=100,  d=[3,4,6]
Erlang_net1 =[10 15 20 25 30];

%RF_sim=[3.843075E-4,0.006834295,0.030019412,0.06839896,0.11216542];
FF_sim=[3.4697898E-6,5.584314E-4,0.008254755,0.034394275,0.075458966];
%RF_SC_sim=[6.265578E-5,0.0017815725,0.012286129,0.039383937,0.078440614];
FF_SC_sim=[2.2451154E-6,3.1166754E-4,0.004920197,0.02299405,0.055615734];

%RF_app1= [3.925561e-04,8.735398e-03,3.798140e-02,7.902938e-02,1.208727e-01]; % 
%RF_SC_app1= [1.166724e-04,3.718857e-03,2.297501e-02,5.908367e-02,1.009712e-01]; % 

RF_app2= [3.766911e-05,1.390188e-03,9.753566e-03,2.922458e-02,5.774360e-02]; % 
RF_SC_app2= [7.526870e-06,3.355751e-04,3.387935e-03,1.579764e-02,4.305152e-02]; % 

Kaufmann= [1.733339e-11,1.604287e-11,1.518445e-11,1.112666e-11,9.531339e-12]; % 

Binomial= [3.118301e-01,3.494181e-01,3.722531e-01,3.828133e-01,3.910106e-01]; % 
Binomial_SC= [0,0,0,0,0]; %

% figure;
% subplot(2,1,1);
% plot(Erlang_net1,RF_sim,'rd-',Erlang_net1,RF_app1,'r.--',Erlang_net1,FF_sim,'go-',Erlang_net1,RF_app2,'gx--',Erlang_net1,Binomial,'k+-.');
% legend('RF (Sim.)','RF (App.EES)','FF (Sim.)','FF (App.SOC)','Binomial');
% xlabel('Offered Load (Erlangs)');
% ylabel({'Blocking Probability'});
% 
% subplot(2,1,2);
% plot(Erlang_net1,RF_SC_sim,'rd-',Erlang_net1,RF_SC_app1,'r.--',Erlang_net1,FF_SC_sim,'go-',Erlang_net1,RF_SC_app2,'gx--');
% legend('RF-SC (Sim.)','RF-SC (App.EES)','FF-SC (Sim.)','FF-SC (App.SOC)');
% xlabel('Offered Load (Erlangs)');
% ylabel({'Blocking Probability'});

% 10-links , C=200,  d=[4,6,10]
Erlang_net1 =[15 20 25 30 35];

%RF_sim=[7.813282E-4,0.006587134,0.022674136,0.048275393,0.078640215];
FF_sim=[1.4144081E-6,1.5216453E-4,0.00225926,0.011797577,0.032141473];
%RF_SC_sim=[9.719853E-5,0.0013480537,0.0073537217,0.022791898,0.0478731];
FF_SC_sim=[1.1113312E-6,7.8102894E-5,0.0012354131,0.007101703,0.021274166];

%RF_app1= [4.080709e-05,7.481383e-04,6.299928e-03,2.347400e-02,5.085963e-02]; % 
%RF_SC_app1= [1.184101e-05,3.641646e-04,4.000790e-03,1.771342e-02,4.262382e-02]; % 

RF_app2= [4.159357e-06,1.745175e-04,2.065095e-03,9.719491e-03,2.517213e-02]; % 
RF_SC_app2= [9.347342e-07,4.629655e-05,6.558756e-04,3.993228e-03,1.384136e-02]; % 

Kaufmann= [9.362881e-13,1.475412e-12,6.092267e-11,9.143945e-12,1.333333e-11]; % 

Binomial= [3.460377e-01,3.699541e-01,3.860427e-01,3.985551e-01,4.090027e-01]; % 
Binomial_SC= [0,0,0,0,0]; %


% figure;
% subplot(2,1,1);
% plot(Erlang_net1,RF_sim,'rd-',Erlang_net1,RF_app1,'r.--',Erlang_net1,FF_sim,'go-',Erlang_net1,RF_app2,'gx--',Erlang_net1,Binomial,'k+-.');
% legend('RF (Sim.)','RF (App.EES)','FF (Sim.)','FF (App.SOC)','Binomial');
% xlabel('Offered Load (Erlangs)');
% ylabel({'Blocking Probability'});
% 
% subplot(2,1,2);
% plot(Erlang_net1,RF_SC_sim,'rd-',Erlang_net1,RF_SC_app1,'r.--',Erlang_net1,FF_SC_sim,'go-',Erlang_net1,RF_SC_app2,'gx--');
% legend('RF-SC (Sim.)','RF-SC (App.EES)','FF-SC (Sim.)','FF-SC (App.SOC)');
% xlabel('Offered Load (Erlangs)');
% ylabel({'Blocking Probability'});


% NSFNET C=10, d=[3,4], [0.6,1.2,2.4,4.8,9.6]

% NSFNET C=100, d=[3,4,6], 
Erlang_C1=[100,150,200,250,300];

%RF_K1_C1= [2.848710e-03,2.518208e-02,6.982053e-02,1.222520e-01,1.735341e-01]; % 
FF_K1_C1=[3.644515e-04,5.287520e-03,2.451398e-02,6.120302e-02]; 
%RF_SC_K1_C1= [1.754323e-03,1.892993e-02,5.896429e-02,1.101900e-01,1.623192e-01]; % 
FF_SC_K1_C1=[1.760669e-04,3.790462e-03,2.170974e-02,5.825504e-02]; 

%RF_K1_C1_sim=[0.004803947,0.03568681,0.0892691,0.14770032,0.20195676];
FF_K1_C1_sim=[5.676051E-4,0.016136032,0.06263671,0.1214223,0.17798366];
%RF_SC_K1_C1_sim=[0.0013834392,0.015342281,0.051087145,0.10076911,0.15344928];
FF_SC_K1_C1_sim=[3.3012123E-4,0.009037223,0.03907891,0.08476388,0.1350797];

%RF_K2_C1= [2.495296e-05,3.527671e-03,3.399003e-02,8.833535e-02,1.434627e-01]; 
FF_K2_C1=[2.681418e-06,4.346164e-04,5.957307e-03,2.902191e-02,7.487410e-02];
%RF_SC_K2_C1= [5.672304e-06,1.239966e-03,2.008169e-02,7.075423e-02,1.289659e-01]; 
FF_SC_K2_C1=[3.595149e-07,8.148093e-05,1.906383e-03,1.686731e-02,6.339633e-02];

%RF_K2_C1_sim=[2.2275565E-4,0.011592538,0.055857968,0.115568064,0.17344935];
FF_K2_C1_sim=[1.1108566E-6,0.001787277,0.03192455,0.09144483,0.15227206];
%RF_SC_K2_C1_sim=[3.8761605E-6,9.3863293E-4,0.01488135,0.059746515,0.11894607];
FF_SC_K2_C1_sim=[2.0399737E-7,2.6092888E-4,0.007973187,0.0427947,0.09824607];

% NSFNET C=200, d=[4,6,10], 
Erlang_C2=[100,150,200,250,300];

%RF_K1_C2= [1.871498e-05,1.248699e-03,1.078930e-02,3.447134e-02,6.888202e-02]; % 
FF_K1_C2=[7.105373e-06,6.625675e-04,6.425789e-03,2.212113e-02,4.757457e-02]; 
%RF_K2_C2= [6.811646e-10,1.558928e-06,2.321629e-04,4.878317e-03,2.890421e-02]; 
FF_K2_C2=[3.667268e-11,3.791477e-07,6.780021e-05,1.324096e-03,8.833708e-03];

%RF_K1_C2_sim=[5.249845E-4,0.00924918,0.03580075,0.07433984,0.11614067];
FF_K1_C2_sim=[1.377551e-05,5.208763e-04,4.236452e-03,3.363014e-02,8.602078e-02];
%RF_K2_C2_sim=[3.0292795E-6,0.0010167339,0.013791505,0.046866324,0.08898136];
FF_K2_C2_sim=[0.0,1.2117118E-6,7.6907314E-4,0.014334793,0.049477387];

%RF_SC_K1_C2= [1.137458e-05,9.657711e-04,9.189849e-03,3.090719e-02,6.374798e-02]; 
FF_SC_K1_C2=[3.497390e-06,3.798565e-04,4.178775e-03,1.628278e-02,3.899131e-02]; 
%RF_SC_K2_C2= [1.374793e-10,6.429542e-07,1.266679e-04,3.177599e-03,2.314578e-02]; 
FF_SC_K2_C2=[4.858817e-12,7.004492e-08,1.522794e-05,3.917280e-04,3.867296e-03];

%RF_SC_K1_C2_sim=[1.055224E-4,0.0027401438,0.0149499215,0.03971139,0.073136635];
FF_SC_K1_C2_sim=[2.243971E-6,4.778107E-4,0.006210765,0.02308931,0.050069794];
%RF_SC_K2_C2_sim=[1.0097599E-7,2.0801172E-5,0.0010431946,0.010166135,0.037659064];
FF_SC_K2_C2_sim=[0.0,4.0390395E-7,1.05723906E-4,0.0027848007,0.017186353];


figure;
subplot(2,2,1);
plot(Erlang_C1,RF_K1_C1,'r.-',Erlang_C1,RF_SC_K1_C1,'b*-',Erlang_C1,RF_K2_C1,'g.-',Erlang_C1,RF_SC_K2_C1,'k.-',...
     Erlang_C1,RF_K1_C1_sim,'rd--',Erlang_C1,RF_SC_K1_C1_sim,'bd--',Erlang_C1,RF_K2_C1_sim,'gd--',Erlang_C1,RF_SC_K2_C1_sim,'kd--');
legend('RF,\kappa_o=1','RF-SC,\kappa_o=1','RF,\kappa_o=2','RF-SC,\kappa_o=2','Sim. RF,\kappa_o=1','Sim. RF-SC,\kappa_o=1','Sim. RF,\kappa_o=2','Sim. RF-SC,\kappa_o=2');
xlabel('Offered Load (Erlang)');
ylabel({'Blocking Probability'});

subplot(2,2,2);
plot(Erlang_C1,FF_K1_C1,'r.-',Erlang_C1,FF_SC_K1_C1,'b.-',Erlang_C1,FF_K2_C1,'g.-',Erlang_C1,FF_SC_K2_C1,'k.-',...
     Erlang_C1,FF_K1_C1_sim,'rd--',Erlang_C1,FF_SC_K1_C1_sim,'bd--',Erlang_C1,FF_K2_C1_sim,'gd--',Erlang_C1,FF_SC_K2_C1_sim,'kd--');
legend('FF,\kappa_o=1','FF-SC,\kappa_o=1','FF,\kappa_o=2','FF-SC,\kappa_o=2','Sim. FF,\kappa_o=1','Sim. FF-SC,\kappa_o=1','Sim. FF,\kappa_o=2','Sim. FF-SC,\kappa_o=2');
xlabel('Offered Load (Erlang)');
ylabel({'Blocking Probability'});

subplot(2,2,3);
plot(Erlang_C2,RF_K1_C2,'r.-',Erlang_C2,RF_SC_K1_C2,'b.-',Erlang_C2,RF_K2_C2,'g.-',Erlang_C2,RF_SC_K2_C2,'k.-',...
     Erlang_C2,RF_K1_C2_sim,'rd--',Erlang_C2,RF_SC_K1_C2_sim,'bd--',Erlang_C2,RF_K2_C2_sim,'gd--',Erlang_C2,RF_SC_K2_C2_sim,'kd--');
legend('RF,\kappa_o=1','RF-SC,\kappa_o=1','RF,\kappa_o=2','RF-SC,\kappa_o=2','Sim. RF,\kappa_o=1','Sim. RF-SC,\kappa_o=1','Sim. RF,\kappa_o=2','Sim. RF-SC,\kappa_o=2');
xlabel('Offered Load (Erlang)');
ylabel({'Blocking Probability'});

subplot(2,2,4);
plot(Erlang_C2,FF_K1_C2,'r.-',Erlang_C2,FF_SC_K1_C2,'b.-',Erlang_C2,FF_K2_C2,'g.-',Erlang_C2,FF_SC_K2_C2,'k.-',...
     Erlang_C2,FF_K1_C2_sim,'rd--',Erlang_C2,FF_SC_K1_C2_sim,'bd--',Erlang_C2,FF_K2_C2_sim,'gd--',Erlang_C2,FF_SC_K2_C2_sim,'kd--');
legend('FF,\kappa_o=1','FF-SC,\kappa_o=1','FF,\kappa_o=2','FF-SC,\kappa_o=2','Sim. FF,\kappa_o=1','Sim. FF-SC,\kappa_o=1','Sim. FF,\kappa_o=2','Sim. FF-SC,\kappa_o=2');
xlabel('Offered Load (Erlang)');
ylabel({'Blocking Probability'});
