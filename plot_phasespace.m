function [indexseeds] = plot_phasespace(space,solutions,tol)

global normal_chi normal_beta motor 
global Sp bc  L omega chi1_b chi2_b kappa a_0 chi1_s chi2_s; % Load parameters for plot annotation
%% PLOT The phasespace with solutions
% Generate heat map

scrsz = get(0,'ScreenSize');
figure('Position',[1 1 scrsz(3)/2.8 scrsz(4)/2.8]);
set(gcf,'color','w');
hold on

%,'units','normalized','outerposition',[0 0 0.5 0.5]...
%figure
%daspect([1.5 2 1]);


%subplot(1,2,1)
colormap(winter);
%imagesc([xrange(1),xrange(end)],[yrange(1),yrange(end)],z);

switch motor
    case 'sliding'
    contourf(space.xyz{1}./normal_chi,space.xyz{2}./normal_chi,space.xyz{3}');
           
% Add red dots and numbers for seeds and Add red circles for potential solutions
     for j=1:size(space.seeds,2)
         plot(space.seeds(1,j)./normal_chi,space.seeds(2,j)./normal_chi,'r.','MarkerSize',10)
     end

     for j=1:size(solutions,2)

         xmin(j) = solutions(j).res(1)./normal_chi;
         ymin(j) = solutions(j).res(2)./normal_chi;
     end
 
% Sort solutions 
    [~,indexseeds]=sort(xmin.^2+ymin.^2); 
  
% Consider the error tolerance
    index_new=[];
        for i =1:length(indexseeds)
            if  solutions(indexseeds(i)).err<tol % filter for solutions with  error < tol
                if    i==1
                else
                    if sqrt( ((solutions(indexseeds(i-1)).res(1) - solutions(indexseeds(i)).res(1)))^2  +...% filter for solutions that differ from each other 
                            ((solutions(indexseeds(i-1)).res(2) - solutions(indexseeds(i)).res(2)))^2 ) ...
                            > abs(solutions(indexseeds(i)).res(1)+solutions(indexseeds(i)).res(2))/2*10^-2;
                        index_new = [index_new,indexseeds(i)];
                    end
                end
            end;
        end
     indexseeds =  index_new;        
    
 % plot solutions with numbers    
for k1=1:length(indexseeds)
          hold on
          text(solutions(indexseeds(k1)).res(1)./normal_chi,solutions(indexseeds(k1)).res(2)./normal_chi,num2str(k1),'Color',[1 1 1],'FontSize',15)
          plot(solutions(indexseeds(k1)).res(1)./normal_chi,solutions(indexseeds(k1)).res(2)./normal_chi,'wo','MarkerSize',25)
end 
  
% Plot labels
  stringx = 'Sliding response     \chi'' (pN / \mum^2)';
  stringy = 'Sliding response     \chi''''  (pN / \mum^2)';

%%Anotate the plot
    xlabel(stringx,'FontSize',12,'FontName','Helvetica');
    ylabel(stringy,'FontSize',12,'FontName','Helvetica');
    h = colorbar;
    ylabel(h, 'log_{10}(det(M))');
    hold on
     title( {['Motor model: '   motor '       Boundary conditions: ' bc ] ; '' ;...
    [' L = ' num2str(L) ' (\mum)' '    f = ' num2str(omega) ' (Hz) ' '    a = '  num2str(a_0) ' (\mum)' '    \kappa = ' num2str(kappa) ' (pN um^2) ' ...
    '    \chi_b = ' num2str(chi1_b,'%1.0f') ' +i ' num2str(chi2_b,'%1.0f') ' (pN / \mum)' '    S_p= ' num2str(Sp,'%1.0f') ]},...
    'FontWeight','bold','FontSize',12,'FontName','Times New Roman');
        

  
  
        
    case 'dyn-curvature'
    contourf(space.xyz{1}./normal_chi,space.xyz{2}./normal_beta,space.xyz{3}');
        
% Add red dots  for seeds and Add white circles for potential solutions
     for j=1:size(space.seeds,2)
         plot(space.seeds(1,j)./normal_chi,space.seeds(2,j)./normal_beta,'r.')
     end

     for j=1:size(solutions,2)

         xmin(j) = solutions(j).res(1)./normal_chi;
         ymin(j) = solutions(j).res(2)./normal_beta;
     end
 
% Sort solutions 
    [~,indexseeds]=sort(xmin.^2+ymin.^2); 
 
% Consider the error tolerance
    index_new=[];
        for i =1:length(indexseeds)
            if  solutions(indexseeds(i)).err<tol % filter for solutions with  error < tol
                if    i==1
                else
                    if sqrt( ((solutions(indexseeds(i-1)).res(1) - solutions(indexseeds(i)).res(1)))^2  +...% filter for solutions that differ from each other 
                            ((solutions(indexseeds(i-1)).res(2) - solutions(indexseeds(i)).res(2)))^2 ) ...
                            > abs(solutions(indexseeds(i)).res(1)+solutions(indexseeds(i)).res(2))/2*10^-2;
                        index_new = [index_new,indexseeds(i)];
                    end
                end
            end;
        end
     indexseeds =  index_new;   

    
% plot solutions with numbers
 
 for k1=1:length(indexseeds)
              hold on
              text(solutions(indexseeds(k1)).res(1)./normal_chi,solutions(indexseeds(k1)).res(2)./normal_beta,num2str(k1),'Color',[1 1 1],'FontSize',15)
              plot(solutions(indexseeds(k1)).res(1)./normal_chi,solutions(indexseeds(k1)).res(2)./normal_beta,'wo','MarkerSize',25)
 end
 
 % Plot labels
   stringx = 'Sliding response     \chi'' (pN / \mum^2)';
   stringy = 'Curvature response     \beta'''' (pN)';       

%%Anotate the plot
    xlabel(stringx,'FontSize',12,'FontName','Helvetica');
    ylabel(stringy,'FontSize',12,'FontName','Helvetica');
    h = colorbar;
    ylabel(h, 'log_{10}(det(M))');
    hold on
     title( {['Motor model: '   motor '       Boundary conditions: ' bc ] ; '' ;...
    [' L = ' num2str(L) ' (\mum)' '    f = ' num2str(omega) ' (Hz) ' '    a = '  num2str(a_0) ' (\mum)' '    \kappa = ' num2str(kappa) ' (pN um^2) ' ...
    '    \chi_b = ' num2str(chi1_b,'%1.0f') ' +i ' num2str(chi2_b,'%1.0f') ' (pN / \mum)' '    S_p= ' num2str(Sp,'%1.0f') ]},...
    'FontWeight','bold','FontSize',12,'FontName','Times New Roman');
   
   
   
   
    case 'curvature'
    contourf(space.xyz{1}./normal_beta,space.xyz{2}./normal_beta,space.xyz{3}');
        
 % Add red dots and numbers for seeds and Add red circles for potential solutions
     for j=1:size(space.seeds,2)
         plot(space.seeds(1,j)./normal_beta,space.seeds(2,j)./normal_beta,'r.')
     end
 
     for j=1:size(solutions,2)
         
         xmin(j) = solutions(j).res(1)./normal_beta;
         ymin(j) = solutions(j).res(2)./normal_beta;
     end
     
 % Sort solutions 
    [~,indexseeds]=sort(xmin.^2+ymin.^2); 

   
% Consider the error tolerance
    index_new=[];
        for i =1:length(indexseeds)
            if  solutions(indexseeds(i)).err<tol % filter for solutions with  error < tol
                if    i==1
                else
                    if sqrt( ((solutions(indexseeds(i-1)).res(1) - solutions(indexseeds(i)).res(1)))^2  +...% filter for solutions that differ from each other 
                            ((solutions(indexseeds(i-1)).res(2) - solutions(indexseeds(i)).res(2)))^2 ) ...
                            > abs(solutions(indexseeds(i)).res(1)+solutions(indexseeds(i)).res(2))/2*10^-2;
                        index_new = [index_new,indexseeds(i)];
                    end
                end
            end;
        end
     indexseeds =  index_new;        
    
% plot solutions with numbers    
    
     for k1=1:length(indexseeds)
            hold on
            text(solutions(indexseeds(k1)).res(1)./normal_beta,solutions(indexseeds(k1)).res(2)./normal_beta,num2str(k1),'Color',[1 1 1],'FontSize',15)
            plot(solutions(indexseeds(k1)).res(1)./normal_beta,solutions(indexseeds(k1)).res(2)./normal_beta,'wo','MarkerSize',25)
     end               
     % Plot labels
     stringx = 'Curvature response     \beta''  (pN / \mum^2)';
     stringy = 'Curvature response    \beta''''  (pN / \mum^2)';
        


    %%Anotate the plot
    xlabel(stringx,'FontSize',12,'FontName','Helvetica');
    ylabel(stringy,'FontSize',12,'FontName','Helvetica');
    h = colorbar;
    ylabel(h, 'log_{10}(det(M))');
    hold on

   
    title( {['Motor model: '   motor '       Boundary conditions: ' bc ] ; '' ;...
    [' L = ' num2str(L) ' (\mum)' '    f = ' num2str(omega) ' (Hz) ' '    a = '  num2str(a_0) ' (\mum)' '    \kappa = ' num2str(kappa) ' (pN um^2) ' ...
    '    \chi_b = ' num2str(chi1_b,'%1.0f') ' +i ' num2str(chi2_b,'%1.0f') ' (pN / \mum)' ...
    '    \chi = ' num2str(chi1_s,'%1.0f') ' +i ' num2str(chi2_s,'%1.0f') ' (pN / \mum^2)'  ...
    '    S_p= ' num2str(Sp,'%1.0f') ]},...
    'FontWeight','bold','FontSize',12,'FontName','Times New Roman');

 end
hold off


