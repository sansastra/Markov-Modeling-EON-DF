function [blockingPerClass] = CalculateApproxBPInEONs(stateProbabilities,Pr_exact_m,bandwidthPerClass,freeSlotsPerState,path)

         classes= length(bandwidthPerClass);
         
         blockingPerClass=zeros(1,classes);    
         for c=1:classes
             for state=1:sum(freeSlotsPerState>=bandwidthPerClass(c))
                 blockingPerClass(c)=blockingPerClass(c)+stateProbabilities{path(1)}(state)*(Pr_exact_m(state,c));
             end
             blockingPerClass(c)=1-blockingPerClass(c);
             blockingPerClass(blockingPerClass<0)=0; % subtraction makes life difficult
         end
             
%              case 3     
%                  for c=1:classes 
%                      for state1=1:sum(freeSlotsPerState>=bandwidthPerClass(c))
%                          tempBlocking2=0;
%                          upper_ind=zeros(1,length(path));
%                          for p=1:length(path)
%                              upper_ind(p)=find(freeSlotsPerState<=(freeSlotsPerState(1)-avgOccupiedSlots{path(p)}),1);
%                          end
%                          for state2=upper_ind(2)-1:upper_ind(2)
%                              for state3=upper_ind(3)-1:upper_ind(3)
%                                  tempBlocking2 = tempBlocking2 +stateProbabilities{path(3)}(state3)...
%                                                                 *stateProbabilities{path(2)}(state2)*(Pr_exact_m(state3,state2,state1,c));
%                              end
%                           end
%                           blockingPerClass(c)= blockingPerClass(c)+ stateProbabilities{path(1)}(state1)*tempBlocking2;
%                          %end
%                      end
%                      blockingPerClass(c)=1-blockingPerClass(c)-Pr_Xr_Xj_error_route(1,c)*(1-sum(stateProbabilities{path(1)}(state1+1:numberOfStates)));
%                      blockingPerClass(blockingPerClass<0)=0; % subtraction makes life difficult
%                  end
        
%                  for c=1 : classes 
%                     blockingPerClass(c)= 1-BPperLinkperClass(path(1),c);
%                     for p=2:length(path)
%                         blockingPerClass(c)=blockingPerClass(c)*(1-BPperLinkperClass(path(p),c));
%                     end
%                     blockingPerClass(c)=1-blockingPerClass(c);
%                     blockingPerClass(blockingPerClass<0)=0; % subtraction makes life difficult
%                  end
%             case 3     
%                  for c=1:classes
%                      len1=sum(freeSlotsPerState>=bandwidthPerClass(c));
%                      for state1=1:len1
%                          %if (freeSlotsPerState(state1)>=bandwidthPerClass(c))
%                              tempBlocking2=0;
%                              for state2=1:len1
%                                  %if ((freeSlotsPerState(state2)>=bandwidthPerClass(c)))
%                                      for state3=1:len1
%                                          %if ((freeSlotsPerState(state3)>=bandwidthPerClass(c)))
%                                             tempBlocking2 = tempBlocking2 +stateProbabilities{path(3)}(state3)...
%                                                                *stateProbabilities{path(2)}(state2)*(Pr_exact_m(state3,state2,state1,c));
%                                          %end
%                                      end
%                                  %end
%                              end
%                              blockingPerClass(c)= blockingPerClass(c)+ stateProbabilities{path(1)}(state1)*tempBlocking2;
%                          %end
%                      end
%                      blockingPerClass(c)=1-blockingPerClass(c);
%                      blockingPerClass(blockingPerClass<0)=0; % subtraction makes life difficult
%                  end               
%              case 4     
%                  for c=1:classes
%                      for state1=1:numberOfStates
%                          if (freeSlotsPerState(state1)>=bandwidthPerClass(c))
%                              tempBlocking2=0;
%                              for state2=1:numberOfStates
%                                  if ((freeSlotsPerState(state2)>=bandwidthPerClass(c)))
%                                      for state3=1:numberOfStates
%                                          if ((freeSlotsPerState(state3)>=bandwidthPerClass(c)))
%                                             for state4=1:numberOfStates
%                                                 if ((freeSlotsPerState(state4)>=bandwidthPerClass(c))) 
%                                                     tempBlocking2 = tempBlocking2 +stateProbabilities{path(4)}(state4)*stateProbabilities{path(3)}(state3)...
%                                                                *stateProbabilities{path(2)}(state2)*(Pr_exact_m(state4,state3,state2,state1,c));
%                                                 end
%                                             end
%                                          end
%                                      end
%                                  end
%                              end
%                              blockingPerClass(c)= blockingPerClass(c)+ stateProbabilities{path(1)}(state1)*tempBlocking2;
%                          end
%                      end
%                      blockingPerClass(c)=1-blockingPerClass(c);
%                      blockingPerClass(blockingPerClass<0)=0; % subtraction makes life difficult
%                  end    
%              case 5     
%                  for c=1:classes
%                      for state1=1:numberOfStates
%                          if (freeSlotsPerState(state1)>=bandwidthPerClass(c))
%                              tempBlocking2=0;
%                              for state2=1:numberOfStates
%                                  if ((freeSlotsPerState(state2)>=bandwidthPerClass(c)))
%                                      for state3=1:numberOfStates
%                                          if ((freeSlotsPerState(state3)>=bandwidthPerClass(c)))
%                                             for state4=1:numberOfStates
%                                                 if ((freeSlotsPerState(state4)>=bandwidthPerClass(c))) 
%                                                     for state5=1:numberOfStates
%                                                         if ((freeSlotsPerState(state5)>=bandwidthPerClass(c))) 
%                                                             tempBlocking2 = tempBlocking2 +stateProbabilities{path(5)}(state5)*stateProbabilities{path(4)}(state4)...
%                                                                *stateProbabilities{path(3)}(state3)*stateProbabilities{path(2)}(state2)*(Pr_exact_m5(state5,c)*Pr_exact_m(state4,state3,state2,state1,c));
%                                                         end
%                                                     end
%                                                 end
%                                             end
%                                          end
%                                      end
%                                  end
%                              end
%                              blockingPerClass(c)= blockingPerClass(c)+ stateProbabilities{path(1)}(state1)*tempBlocking2;
%                          end
%                      end
%                      blockingPerClass(c)=1-blockingPerClass(c);
%                      blockingPerClass(blockingPerClass<0)=0; % subtraction makes life difficult
%                  end        
             
       
end
