function plot_solution(sol,index,sol_nr)
global D0 motor normal_chi normal_beta 

if sol_nr ==0;
    else
try
    i = index(sol_nr);
catch
    disp('Note: Skipping plot of specific solution! The selected solution (value of solution_number in section (5) Study a specific Solution) does not exist! Review Figure 1 and enter an existing solution_number! ');
    return
end

    % Plot amplitude, phase, real, and imaginary parts
    
    ds  = 0.01; dt = 0.1;
    s   = 0:ds:1;
    t   = 0:dt:1;
    
    % general figure settings
    scrsz = get(0,'ScreenSize');
    figure('Position',[1 scrsz(4)/2 scrsz(3)/4 scrsz(4)/2.5]);
    set(gcf,'color','w');
    hold on
    
    % Plot amplitude
    subplot(3,2,1),plot(s,abs(sol(i).psi),'k','LineWidth',1.5);
    xlabel('Arc-length, s/L'); ylabel('|\psi |');
    axis([0 1 0 1.1])
    
    % Plot phase
    subplot(3,2,3),plot(s,unwrap(angle(sol(i).psi))-max(unwrap(angle(sol(i).psi))),'k','LineWidth',1.1);
    xlabel('Arc-length, s/L'); ylabel('arg (\psi )');
    
    ymin =  min(unwrap(angle(sol(i).psi))-max(unwrap(angle(sol(i).psi))));
    axis([0 1 ymin*1.1 -ymin*.1])
    
    % Plot Real and Imaginary part of psi
    subplot(3,2,5),plot(s,real(sol(i).psi),'b',s,imag(sol(i).psi),'r','LineWidth',1.1);
    xlabel('Arc-length, s/L');
    ylabel('{\color{blue}Re(\psi )} and {\color{red}Im(\psi )}');
    axis([0 1 -1.1 1.1])

    
    % Plot angle time-series
     subplot(3,2,2)    
        ccc = jet(size(t,2));    
        y = real(sol(i).psi'*exp(2*pi*1i*t));
for j=1:size(t,2)
    hold on   
    plot(s,y(:,j), 'color',ccc(j,:),'LineWidth',1.1);
end   
    xlabel('Arc-length, s/L');
    ylabel('\psi (s,t)');
    axis([0 1 -1.1 1.1])
    
    % Plot positional representation
    subplot(3,2,[4 6])
        ccc = jet(size(t,2));
        x = ds*cumtrapz(cos(D0*(s'*ones(1,length(t)))+real(sol(i).psi'*exp(2*pi*1i*t))));
        y = ds*cumtrapz(sin(D0*(s'*ones(1,length(t)))+real(sol(i).psi'*exp(2*pi*1i*t))));
for k=1:size(t,2)
    hold on
    plot(x(:,k),y(:,k),'color',ccc(k,:),'LineWidth',1.1);
    axis equal
end
    %c = colorbar('southoutside');
    c=colorbar('southoutside','Ticks',0:1/2:1,...
         'TickLabels',{'0','\pi','2\pi'});
    colormap(ccc) 
    axpos = get(c,'Position'); axpos(4)=axpos(4)/3.3; axpos(2)=axpos(2)/1;
    set(c,'Position',axpos);
    axis off
    ylabel(c, 'Beat Cycle')
    %set(c,'XTick',1:64/size(t,2):64);
    %set(c,'XTickLabel',{0:1:10});
   
    
    % Generate title
    
    switch motor
        case 'sliding'
        titlestring = [' Solution ' num2str(sol_nr)...
            '   \chi'' = ' num2str(sol(i).res(1)/normal_chi,'%.2f ') ' (pN / \mum^2) '...
            '   \chi'''' = ' num2str(sol(i).res(2)/normal_chi,'%.2f ') ' (pN / \mum^2) '...
            '   \epsilon = ' num2str(sol(i).err)];
                
        case 'dyn-curvature'
        titlestring = [' Solution ' num2str(sol_nr)...
            '   \chi'' = ' num2str(sol(i).res(1)/normal_chi,'%.2f ') ' (pN / \mum^2) '...
            '   \beta'''' = ' num2str(sol(i).res(2)/normal_beta,'%.2f ') ' (pN) '...
            '   \epsilon = ' num2str(sol(i).err)];
                
        case 'curvature'   
        titlestring = [' Solution ' num2str(sol_nr)...
            '   \beta'' = ' num2str(sol(i).res(1)/normal_beta,'%.2f ') ' (pN) '...
            '   \beta'''' = ' num2str(sol(i).res(2)/normal_beta,'%.2f ') ' (pN) '...
            '   \epsilon = ' num2str(sol(i).err)];
    end
    
    set(gcf,'NextPlot','add');
    axes; 
    set(gca,'Visible','off'); 
    h = title(titlestring,...
        'FontWeight','b',...
        'FontSize',12,...
        'FontName','Helvetica');
    set(h,'Visible','on');
    
end