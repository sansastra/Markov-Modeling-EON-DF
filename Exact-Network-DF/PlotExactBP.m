%%%%% INFOCOM 2019 %%%%%%%%%%%%%%%%%%%%%
% 2-HOP, link capacity=10 slices, d_k=3,4
Erlang_net1 =[0.05,0.1,0.15,0.2,0.25];

RF_RB_net1= [3.112256e-04,1.201617e-03,2.610063e-03,4.480223e-03,6.760403e-03];
RF_FB_net1= [1.574639e-03,3.486734e-03,5.688941e-03,8.138610e-03,1.079747e-02];
RF_net1= [1.885864e-03,4.688352e-03,8.299004e-03,1.261883e-02,1.755787e-02]; % overall
% DF %%%%%%%%
RF_DF_RB_net1= [3.382238e-04,1.317408e-03,2.886200e-03,4.995624e-03,7.599238e-03];
RF_DF_FB_net1= [0,0,0,0,0];
RF_DF_net1= [3.382238e-04,1.317408e-03,2.886200e-03,4.995624e-03,7.599238e-03]; %[1.856080e-03,4.579607e-03,8.076257e-03,1.225907e-02,1.704819e-02]; % 

% simulation 
RF_RB_net1_sim= [3.1545915E-4,0.0012225424,0.0026311483,0.004480063,0.006745953];
RF_FB_net1_sim= [0.0015829626,0.003476423,0.005714323,0.00817868,0.010807882];
RF_net1_sim= [0.0018984218,0.004698965,0.008345471,0.012658743,0.017553834]; % overall
% DF %%%%%%%%
RF_DF_RB_net1_sim= [3.4182283E-4,0.0013364818,0.002901957,0.004973195,0.007559691];
RF_DF_FB_net1_sim= [5.0505844E-7,2.0202233E-6,4.4444923E-6,9.394064E-6,1.6969878E-5];
RF_DF_net1_sim= [3.423279E-4,0.001338502,0.0029064014,0.004982589,0.007576661];

%%%%%%%%%%%%%%%%%%%%%%% FF %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
FF_RB_net1= [3.363334e-04,1.303074e-03,2.840045e-03,4.891201e-03,7.404552e-03];
FF_FB_net1= [1.055054e-04,4.050017e-04,8.746537e-04,1.492788e-03,2.239736e-03];
FF_net1=[4.418388e-04,1.708076e-03,3.714699e-03,6.383989e-03,9.644288e-03]; % 
% DF %%%%%%%%
FF_DF_RB_net1= [3.381829e-04,1.317306e-03,2.885982e-03,4.995249e-03,7.598653e-03];
FF_DF_FB_net1= [0,0,0,0,0];
FF_DF_net1=[3.381829e-04,1.317306e-03,2.885982e-03,4.995249e-03,7.598653e-03];

% simulation
% simulation 
FF_RB_net1_sim= [3.404087E-4,0.0013239566,0.002863472,0.004883902,0.007388378];
FF_FB_net1_sim= [1.0606331E-4,3.988988E-4,8.707283E-4,0.001495389,0.002247628];
FF_net1_sim= [4.4647203E-4,0.0017228555,0.0037342003,0.006379291,0.009636006]; % overall
% DF %%%%%%%%
FF_DF_RB_net1_sim= [3.4222688E-4,0.001338401,0.0029079164,0.0049865283,0.0075827218];
FF_DF_FB_net1_sim= [0.0,5.050638E-7,1.5151913E-6,3.1313953E-6,5.656714E-6];
FF_DF_net1_sim= [3.4222688E-4,0.0013389061,0.0029094317,0.00498966,0.0075883786];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 3 -node ring,link capacity=7 slices, d_k= 3,4, DF_rate=1000
Erlang_net2 =[0.001,0.008,0.05,0.1,0.15];

RF_RB_net2= [1.666883e-04,1.330630e-03,8.227823e-03,1.625408e-02,2.409175e-02];
RF_FB_net2= [2.165260e-04,1.723296e-03,1.045075e-02,2.018097e-02,2.925212e-02];
RF_net2= [3.832144e-04,3.053926e-03,1.867857e-02,3.643506e-02,5.334387e-02];
% DF
RF_DF_RB_net2= [1.667748e-04,1.335482e-03,8.409712e-03,1.694832e-02,2.558335e-02];
RF_DF_FB_net2= [6.370970e-09,4.402426e-07,1.651096e-05,6.286567e-05,1.346950e-04];
RF_DF_net2= [1.667748e-04,1.335482e-03,8.409712e-03,1.694832e-02,2.558335e-02];

% simulation 
RF_RB_net2_sim= [1.6642336E-4,0.0013067476,0.008231337,0.01624958,0.024134703];
RF_FB_net2_sim= [2.1919665E-4,0.0017369015,0.0104412185,0.020138923,0.02918581];
RF_net2_sim= [3.8562E-4,0.003043649,0.018672556,0.0363885,0.053320512];
% DF
RF_DF_RB_net2_sim= [1.6642336E-4,0.0013115957,0.008387291,0.016870875,0.025482044];
RF_DF_FB_net2_sim= [0.0,3.0305537E-7,1.6062537E-5,6.324014E-5,1.352689E-4];
RF_DF_net2_sim= [1.6642336E-4,0.0013118988,0.008403353,0.016934115,0.025617313];


%%%%%%%%%%%%%%%%%%%%%%% FF %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
FF_RB_net2= [1.667352e-04,1.334999e-03,8.391101e-03,1.687063e-02,2.540269e-02];
FF_FB_net2= [4.969524e-08,2.649222e-06,9.893178e-05,3.761532e-04,8.051721e-04];
FF_net2=[1.667842e-04,1.337649e-03,8.490031e-03,1.724678e-02,2.620786e-02];
%%%%%%%%% DF %%%%%%%%%%%%%%%%%%%
FF_DF_RB_net2= [1.667506e-04,1.335022e-03,8.393016e-03,1.688482e-02,2.544733e-02];
FF_DF_FB_net2= [6.629445e-09,4.404437e-07,1.651777e-05,6.288894e-05,1.347412e-04];
FF_DF_net2=[1.667849e-04,1.337648e-03,8.490033e-03,1.724678e-02,2.620786e-02]; % overall

%%%%%% Simulation %%%%%%
FF_RB_net2_sim= [1.6468872E-4,0.0013317983,0.008404296,0.01686659,0.025413295];
FF_FB_net2_sim= [6.012E-8,2.7254423E-6,9.817606E-5,3.7667225E-4,8.0414605E-4];
FF_net2_sim=[1.6474884E-4,0.0013345238,0.008502472,0.017243262,0.026217442];
%%%%%%%%% DF %%%%%%%%%%%%%%%%%%%
FF_DF_RB_net2_sim= [1.6468872E-4,0.0013318183,0.008406321,0.016880538,0.025457283];
FF_DF_FB_net2_sim= [0.0,4.809624E-7,1.5851734E-5,6.138288E-5,1.3452933E-4];
FF_DF_net2_sim=[1.6468872E-4,0.0013322993,0.008422172,0.016941922,0.025591813];

% figure;
% %subplot(1,3,1)
% plot(Erlang_net1,RF_FB_net1,'r-',Erlang_net1,RF_RB_net1,'g--',Erlang_net1,RF_DF_RB_net1,'k-.',...
%      Erlang_net1,RF_FB_net1_sim,'rd',Erlang_net1,RF_RB_net1_sim,'go',Erlang_net1,RF_DF_RB_net1_sim,'kx');
% legend('FBP-RF (Exact)','RBP-RF (Exact)','RBP-RF-DF (Exact)','FBP-RF (Sim.)','RBP-RF (Sim.)','RBP-RF-DF (Sim.)');
% xlabel('Offered Load (Erlang)');
% ylabel({'Blocking parts in RF (RBP and FBP)'});
% figure;
% %subplot(1,3,2)
% plot(Erlang_net1,FF_FB_net1,'r-',Erlang_net1,FF_RB_net1,'g--',Erlang_net1,FF_DF_RB_net1,'k-.',...
%      Erlang_net1,FF_FB_net1_sim,'rd',Erlang_net1,FF_RB_net1_sim,'go',Erlang_net1,FF_DF_RB_net1_sim,'kx');
% legend('FBP-FF (Exact)','RBP-FF (Exact)','RBP-FF-DF (Exact)','FBP-FF (Sim.)','RBP-FF (Sim.)','RBP-FF-DF (Sim.)');
% xlabel('Offered Load (Erlang)');
% ylabel({'Blocking parts in FF (RBP and FBP)'});
% figure;
% %subplot(1,3,3)
% plot(Erlang_net1,RF_net1,'r-',Erlang_net1,RF_DF_net1,'g--',Erlang_net1,FF_net1,'b-',Erlang_net1,FF_DF_net1,'k--',...
%      Erlang_net1,RF_net1_sim,'rd',Erlang_net1,RF_DF_net1_sim,'go',Erlang_net1,FF_net1_sim,'bs',Erlang_net1,FF_DF_net1_sim,'kx');
% legend('RF (Exact)','RF-DF (Exact)','FF (Exact)','FF-DF (Exact)','RF (Sim.)','RF-DF (Sim.)','FF (Sim.)','FF-DF (Sim.)');
% xlabel('Offered Load (Erlang)');
% ylabel({'Blocking Probability'});
% 
% 
% 
% figure;
% %subplot(1,3,1)
% plot(Erlang_net2,RF_FB_net2,'r-',Erlang_net2,RF_RB_net2,'g--',Erlang_net2,RF_DF_FB_net2,'b-',Erlang_net2,RF_DF_RB_net2,'k-.',...
%      Erlang_net2,RF_FB_net2_sim,'rd',Erlang_net2,RF_RB_net2_sim,'go',Erlang_net2,RF_DF_FB_net2_sim,'bs',Erlang_net2,RF_DF_RB_net2_sim,'kx');
% legend('FBP-RF (Exact)','RBP-RF (Exact)','FBP-RF-DF (Exact)','RBP-RF-DF (Exact)','FBP-RF (Sim.)','RBP-RF (Sim.)','FBP-RF-DF (Sim.)','RBP-RF-DF (Sim.)');
% xlabel('Offered Load (Erlang)');
% ylabel({'Blocking parts in RF (RBP and FBP)'});
% figure;
% %subplot(1,3,2)
% plot(Erlang_net2,FF_FB_net2,'r-',Erlang_net2,FF_RB_net2,'g--',Erlang_net2,FF_DF_FB_net2,'b-',Erlang_net2,FF_DF_RB_net2,'k-.',...
%      Erlang_net2,FF_FB_net2_sim,'rd',Erlang_net2,FF_RB_net2_sim,'go',Erlang_net2,FF_DF_FB_net2_sim,'bs',Erlang_net2,FF_DF_RB_net2_sim,'kx');
% legend('FBP-FF (Exact)','RBP-FF (Exact)','FBP-FF-DF (Exact)','RBP-FF-DF (Exact)','FBP-FF (Sim.)','RBP-FF (Sim.)','FBP-FF-DF (Sim.)','RBP-FF-DF (Sim.)');
% xlabel('Offered Load (Erlang)');
% ylabel({'Blocking parts in FF (RBP and FBP)'});
% figure;
% %subplot(1,3,3)
% plot(Erlang_net2,RF_net2,'r-',Erlang_net2,RF_DF_net2,'g--',Erlang_net2,FF_net2,'b-',Erlang_net2,FF_DF_net2,'k-.',...
%      Erlang_net2,RF_net2_sim,'rd',Erlang_net2,RF_DF_net2_sim,'go',Erlang_net2,FF_net2_sim,'bs',Erlang_net2,FF_DF_net2_sim,'kx');
% legend('RF (Exact)','RF-DF (Exact)','FF (Exact)','FF-DF (Exact)','RF (Sim.)','RF-DF (Sim.)','FF (Sim.)','FF-DF (Sim.)');
% xlabel('Offered Load (Erlang)');
% ylabel({'Overall Blocking Probability'});

%%% single link C=20 %%% 1/mu={0.001, 0.1}
%%%% Exact %%%%%%%%%%%%
Erlang=[0.1,0.6,1.2,2.4,3.6];
RBP_RF=[1.992825e-08,9.093274e-05,1.672210e-03,1.848517e-02,5.382655e-02];
FBP_RF=[8.156935e-06,2.192241e-03,1.607182e-02,7.854893e-02,1.489961e-01];
BP_RF=[8.176863e-06,2.283173e-03,1.774403e-02,9.703410e-02,2.028226e-01];

RBP_FF=[5.211275e-08,2.248203e-04,3.827807e-03,3.693462e-02,9.696854e-02];
FBP_FF=[5.579189e-08,2.005623e-04,3.302986e-03,2.871640e-02,6.644400e-02];
BP_FF=[1.079046e-07,4.253825e-04,7.130793e-03,6.565102e-02,1.634125e-01];
%%%%%% Defrag%%%%%%%
BP_RF_mu1=[4.903607e-08,2.457508e-04,4.535210e-03,4.914654e-02,1.361436e-01];
BP_RF_mu2=[5.098308e-08,2.562001e-04,4.707048e-03,5.059686e-02,1.392602e-01];

BP_FF_mu1=[5.287541e-08,2.456334e-04,4.533486e-03,4.913524e-02,1.361237e-01];
BP_FF_mu2=[5.280996e-08,2.470048e-04,4.576305e-03,4.975268e-02,1.377968e-01];


%%%% approximations %%%%%%%%%%%%%%%
RBP_RF_Apprx=[1.845210e-08,8.749728e-05,1.556771e-03,1.639577e-02,4.658226e-02];
FBP_RF_Apprx=[7.758796e-06,2.119584e-03,1.597375e-02,8.151878e-02,1.588736e-01];
BP_RF_Approx=[7.777248e-06,2.207082e-03,1.753052e-02,9.791455e-02,2.054559e-01];

RBP_FF_Apprx=[2.407276e-08,1.150673e-04,2.068545e-03,2.210585e-02,6.304457e-02];
FBP_FF_Apprx=[7.015316e-06,1.737293e-03,1.276502e-02,6.479958e-02,1.257626e-01];
BP_FF_Approx=[7.039389e-06,1.852360e-03,1.483356e-02,8.690543e-02,1.888071e-01];
%%% DF %%%%%%%
BP_RF_Apprx_mu1=[6.044992e-08,2.907954e-04,5.184144e-03,5.016689e-02,1.247546e-01];
BP_RF_Apprx_mu2=[6.794195e-08,3.303522e-04,5.931133e-03,5.736240e-02,1.410909e-01];

BP_FF_Apprx_mu1=[7.601908e-08,3.680564e-04,6.587747e-03,6.375675e-02,1.571315e-01];
BP_FF_Apprx_mu2=[8.192683e-08,4.000628e-04,7.198401e-03,6.954923e-02,1.697632e-01];


figure;
plot(Erlang,RBP_RF,'r-',Erlang,FBP_RF,'m--',Erlang,RBP_FF,'g-',Erlang,FBP_FF,'c--',Erlang,BP_RF_mu1,'b-',Erlang,BP_FF_mu1,'k-',...
    Erlang,RBP_RF_Apprx,'rd',Erlang,FBP_RF_Apprx,'md',Erlang,RBP_FF_Apprx,'gd',Erlang,FBP_FF_Apprx,'cd',Erlang,BP_RF_Apprx_mu1,'bd',Erlang,BP_FF_Apprx_mu1,'kd');
legend('Exact-RBP-RF','Exact-FBP-RF','Exact-RBP-FF','Exact-FBP-FF','Exact-RBP-RF-DF','Exact-RBP-FF-DF','App.');
xlabel('Arrival rate per class per route (\lambda_k^o)');
ylabel({'Blocking Probability'});


QLen_RF_mu1= [3.941065e+00,3.817613e+00,3.766431e+00,3.720338e+00,3.695111e+00];
WaitTime_RF_mu1=[3.941065e+01,6.362688e+00,3.138693e+00,1.550141e+00,1.026420e+00];

QLen_RF_mu2= [3.961590e+00,3.894936e+00,3.865783e+00,3.834980e+00,3.811587e+00];
WaitTime_RF_mu2=[3.961590e+01,6.491560e+00,3.221486e+00,1.597908e+00,1.058774e+00];

QLen_FF_mu1= [4.625386e+00,3.930164e+00,3.884205e+00,3.823093e+00,3.785585e+00];
WaitTime_FF_mu1=[4.625386e+01,6.550274e+00,3.236837e+00,1.592955e+00,1.051551e+00];

QLen_FF_mu2= [4.469160e+00,3.956685e+00,3.926148e+00,3.879549e+00,3.846489e+00];
WaitTime_FF_mu2=[4.469160e+01,6.594475e+00,3.271790e+00,1.616479e+00,1.068469e+00];

% approx
QLen_RF_Apprx_mu1= [3.879188e+00,3.780763e+00,3.696396e+00,3.588226e+00,3.522627e+00];
WaitTime_RF_Apprx_mu1=[3.879188e+01,6.301271e+00,3.080330e+00,1.495094e+00,9.785076e-01];

QLen_RF_Apprx_mu2= [3.910919e+00,3.935437e+00,3.965023e+00,4.019383e+00,4.062901e+00];
WaitTime_RF_Apprx_mu2=[3.910919e+01,6.559061e+00,3.304186e+00,1.674743e+00,1.128584e+00];

QLen_FF_Apprx_mu1= [3.969992e+00,3.852111e+00,3.756179e+00,3.637141e+00,3.564348e+00];
WaitTime_FF_Apprx_mu1=[3.969992e+01,6.420186e+00,3.130149e+00,1.515475e+00,9.900966e-01];

QLen_FF_Apprx_mu2= [3.999750e+00,4.003361e+00,4.012338e+00,4.029165e+00,4.035973e+00];
WaitTime_FF_Apprx_mu2=[3.999750e+01,6.672268e+00,3.343615e+00,1.678819e+00,1.121104e+00];

%%%%%%%%% NSF Result %%%%%%%%%%%%
% C=100, d=[3, 4, 6], t_DF=0
Erlang=[ 150, 200, 250];
RBP_RF_App1=[8.0e-9,1.0e-7,5.4e-7];
FBP_RF_App1=[2.5e-2,7.0e-2,1.2e-1];
RBP_RF_DF_App1=[4.0e-4,1.3e-3,3.1e-3];
FBP_RF_DF_App1=[1.2e-2,4.8e-2,9.4e-2];

RBP_RF_Sim=[5.0e-7,9.1e-7,3.0e-6];
FBP_RF_Sim=[3.6e-2,8.9e-2,1.5e-1];
RBP_RF_DF_Sim=[8.5e-4,5.3e-3,1.3e-2];
FBP_RF_DF_Sim=[3.7e-3,2.1e-2,5.4e-2];

RBP_FF_App2=[2.5e-4,2.5e-3,1.1e-2];
FBP_FF_App2=[1.6e-2,5.0e-2,9.5e-2];
RBP_FF_DF_App2=[1.9e-3,1.3e-2,3.9e-2];
FBP_FF_DF_App2=[2.8e-3,1.2e-2,2.3e-2];

RBP_FF_Sim=[2.7e-5,6.1e-5,8.8e-5];
FBP_FF_Sim=[1.6e-2,6.3e-2,1.2e-1];
RBP_FF_DF_Sim=[1.0e-3,6.2e-3,1.5e-2];
FBP_FF_DF_Sim=[3.4e-3,1.9e-2,5.2e-2];


BP_RF_App1= RBP_RF_App1 + FBP_RF_App1;
%BP_FF_Sim= RBP_FF_Sim + FBP_FF_Sim;
BP_RF_DF_App1= RBP_RF_DF_App1 + FBP_RF_DF_App1;
%BP_FF_DF_Sim= RBP_FF_DF_Sim + FBP_FF_DF_Sim;

BP_RF_Sim= RBP_RF_Sim + FBP_RF_Sim;
BP_FF_Sim= RBP_FF_Sim + FBP_FF_Sim;
BP_RF_DF_Sim= RBP_RF_DF_Sim + FBP_RF_DF_Sim;
BP_FF_DF_Sim= RBP_FF_DF_Sim + FBP_FF_DF_Sim;

figure;
%plot(Erlang,RBP_RF_Sim,'r-',Erlang,FBP_RF_Sim,'m--',Erlang,RBP_FF_Sim,'g-',Erlang,FBP_FF_Sim,'c--',...
%    Erlang,RBP_RF_App1,'rd',Erlang,FBP_RF_App1,'md');
plot(Erlang,BP_RF_Sim,'r-',Erlang,BP_FF_Sim,'k-',Erlang,BP_RF_DF_Sim,'g-',Erlang,BP_FF_DF_Sim,'b-',...
    Erlang,BP_RF_App1,'m--',Erlang,BP_RF_DF_App1,'c--');
legend('RF (Sim.)','FF (Sim.)','RF-DF (Sim.)','FF-DF (Sim.)','App.(w/o DF)','App. (with DF))');
xlabel('Offered Load (Erlangs)');
ylabel({'Overall Blocking Probability'});




% C=200, d=[4, 6, 10], t_DF=0
% offered load=[150, 200, 250]
RBP_RF_App1=[1.7e-13,1.3e-12,1.1e-11];
FBP_RF_App1=[1.2e-3,1.1e-2,3.4e-2];
RBP_RF_DF_App1=[2.3e-7,2.0e-6,1.0e-5];
FBP_RF_DF_App1=[8.5e-4,8.7e-3,3.0e-2];

RBP_RF_Sim=[0.0,0.0,0.0];
FBP_RF_Sim=[9.2e-3,3.6e-2,7.4e-2];
RBP_RF_DF_Sim=[1.1e-5,2.9e-4,1.8e-3];
FBP_RF_DF_Sim=[1.8e-4,2.8e-3,1.3e-2];

RBP_FF_App2=[2.4e-6,7.8e-5,6.7e-4];
FBP_FF_App2=[8.5e-4,8.4e-3,2.9e-2];
RBP_FF_DF_App2=[2.2e-5,6.4e-4,4.7e-3];
FBP_FF_DF_App2=[2.6e-4,3.1e-3,1.1e-2];

RBP_FF_Sim=[1.7e-6,7.9e-6,1.9e-5];
FBP_FF_Sim=[7.9e-4,1.1e-2,3.8e-2];
RBP_FF_DF_Sim=[4.0e-5,7.6e-4,3.9e-3];
FBP_FF_DF_Sim=[8.7e-5,1.8e-3,9.4e-3];

BP_RF_App1= RBP_RF_App1 + FBP_RF_App1;
%BP_FF_Sim= RBP_FF_Sim + FBP_FF_Sim;
BP_RF_DF_App1= RBP_RF_DF_App1 + FBP_RF_DF_App1;
%BP_FF_DF_Sim= RBP_FF_DF_Sim + FBP_FF_DF_Sim;

BP_RF_Sim= RBP_RF_Sim + FBP_RF_Sim;
BP_FF_Sim= RBP_FF_Sim + FBP_FF_Sim;
BP_RF_DF_Sim= RBP_RF_DF_Sim + FBP_RF_DF_Sim;
BP_FF_DF_Sim= RBP_FF_DF_Sim + FBP_FF_DF_Sim;

figure;
%plot(Erlang,RBP_RF_Sim,'r-',Erlang,FBP_RF_Sim,'m--',Erlang,RBP_FF_Sim,'g-',Erlang,FBP_FF_Sim,'c--',...
%    Erlang,RBP_RF_App1,'rd',Erlang,FBP_RF_App1,'md');
plot(Erlang,BP_RF_Sim,'r-',Erlang,BP_FF_Sim,'k-',Erlang,BP_RF_DF_Sim,'g-',Erlang,BP_FF_DF_Sim,'b-',...
    Erlang,BP_RF_App1,'m--',Erlang,BP_RF_DF_App1,'c--');
legend('RF (Sim.)','FF (Sim.)','RF-DF (Sim.)','FF-DF (Sim.)','App.(w/o DF)','App. (with DF))');
xlabel('Offered Load (Erlangs)');
ylabel({'Overall Blocking Probability'});
