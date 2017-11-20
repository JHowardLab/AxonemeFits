% Function that calculates the beating modes given a list of seeds.

function sol = beatmodes(seeds)
%Load parameters
global Sp motor k xi D0;

%% STRUCTURE
% Number of seeds and plot titles
nseeds = size(seeds,2);
titles = cell(1,nseeds);

% Outputs
sol(nseeds).res = [0,0];
sol(nseeds).k   = [0,0,0,0];
sol(nseeds).A   = [0,0,0,0,0];
sol(nseeds).err =  0;

warning off
%% CALCULATE SOLUTIONS
switch motor
    case 'sliding'
        % Reverse condition number for sliding control
        revcond = @(res) rcond(bcmat([res(1),res(2),0,0]));
        
        % Set options for the solver
        options = optimset('Display','off','TolFun',1e-15,'TolX',1e-15);
        
        % Loop over all seeds
        h = waitbar(0,'Solutions are calulated...');
        for i=1:nseeds
            % Solve the singular system using singular value decomposition
            x0         = [seeds(1,i),seeds(2,i)];
            sol(i).res = fmincon(revcond,x0,[[1,0];[0,1]],[0 0],[],[],...
                               [],[],[],options);
            M          = bcmat([sol(i).res(1),sol(i).res(2),0,0]);
            [~,~,V]    = svd(M,'econ');
            
            % Assign amplitudes, modes, and errors
            sol(i).A = V(:,size(M,2));
            sol(i).k = roots([1,0,-(sol(i).res(1)+1i*sol(i).res(2)),0,...
                1i*Sp]);
            sol(i).err =  sqrt(sum((abs(M*sol(i).A)).^2)) / sqrt(sum((abs(sol(i).A)).^2))  ;%sum(abs(M*sol(i).A));
            
            
            %sqrt(sum((abs(M*sol(i).A)).^2)) % old error
            
            % Create plot title
            titles{i}=['Mode \chi='...
                        num2str(sol(i).res(1)+1i*sol(i).res(2))...
                       '  with error   '  num2str(sol(i).err)];
            waitbar(i / nseeds)
        end
        
    case 'dyn-curvature'
        % Reverse condition number for dynamic curvature control
        revcond = @(res) rcond(bcmat([res(1),0,0,res(2)]));
        
        % Set options for the solver
        options = optimset('Display','off','TolFun',1e-15,'TolX',1e-15);

        % Loop over all seeds
        h = waitbar(0,'Solutions are calulated...');
        for i=1:nseeds
            % Solve the singular system using singular value decomposition
            x0       = [seeds(1,i),seeds(2,i)];
            sol(i).res=fmincon(revcond,x0,[-1,0],0,[],[],[],[],[],options);
            M        = bcmat([sol(i).res(1),0,0,sol(i).res(2)]);
            [~,~,V]  = svd(M,'econ');
            
            % Assign amplitudes, modes, and errors
            sol(i).A = V(:,size(M,2));
            sol(i).k =roots([1,-1i*sol(i).res(2),-sol(i).res(1),0,1i*Sp]);
            sol(i).err =  sqrt(sum((abs(M*sol(i).A)).^2)) / sqrt(sum((abs(sol(i).A)).^2))  ;%sum(abs(M*sol(i).A));
            
            % Create plot title
            titles{i}=['Mode \chi''=' num2str(sol(i).res(1))...
                       '     and \beta''''=' num2str(1i*sol(i).res(2))...
                       '  with error   '  num2str(sol(i).err)];
            waitbar(i / nseeds)
        end
        
    case 'curvature'
        % Reverse condition number for dynamic curvature control
        revcond = @(res) rcond(bcmat([k,xi,res(1),res(2)]));
        
        % Set options for the solver
        options = optimset('Display','off','TolFun',1e-15,'TolX',1e-15);
        
        % Loop over all seeds
        h = waitbar(0,'Solutions are calulated...');
        for i=1:nseeds
            % Solve the singular system using singular value decomposition
            x0       = [seeds(1,i),seeds(2,i)];
            sol(i).res=fmincon(revcond,x0,[-1,0],10^7,[],[],[],[],[],options);
            M        = bcmat([k,xi,sol(i).res(1),sol(i).res(2)]);
            [~,~,V]  = svd(M,'econ');
            
            % Assign amplitudes, modes, and errors
            sol(i).A = V(:,size(M,2));
            sol(i).k =roots([1,-(sol(i).res(1)+1i*sol(i).res(2)),...
                      -(k+xi),0,1i*Sp]);
            sol(i).err =  sqrt(sum((abs(M*sol(i).A)).^2)) / sqrt(sum((abs(sol(i).A)).^2))  ;%sum(abs(M*sol(i).A));
            
            % Create plot title
            titles{i}=['Mode \beta='...
                        num2str(sol(i).res(1)+1i*sol(i).res(2))...
                       '  with error   '  num2str(sol(i).err)];
            waitbar(i / nseeds)
        end
      
end
 close(h); 

% Calculate the angle and sample it in arc-length "s" and time "t"
for i=1:nseeds
    psi=[];
    
    ds  =0.01; dt = 0.1;
    s   = 0:ds:1;
    t   = 0:dt:1;
    
    psi = (sol(i).A(1)*exp(sol(i).k(1)*s)+sol(i).A(2)*exp(sol(i).k(2)*s)...
        +  sol(i).A(3)*exp(sol(i).k(3)*s)+sol(i).A(4)*exp(sol(i).k(4)*s));
    sol(i).psi = psi/(max([0.01 abs(psi) ]));
    sol(i).seed =i; % Put the seed number in 
end

end