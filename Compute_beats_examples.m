%% Compute flagellar beats v1.0 PS and VFG 2017-01-03 (please review readme.txt)

% This is an example file on how to calculate flagellar beats. 
% This is done in three steps: 
%(1) choose parameters, 
%(2) explore phase space, 
%(3) calculate solutions.

clear; close all;                                       % Empty the matlab workspace

%% (0) Choose a specific example 
Example = 3;        % Choose Example Sperm (SC) = 1,  Chlamydomonas (DCC) = 2, Chlamydomonas (CC) = 3;

%% (1) CHOOSE PARAMETERS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Default parameters are defined in "parameters.m". 
% Here, we can specify all parameters described in Table 3

%%(1) Choose parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Example 1: Sperm Parameters (Riedel Kruse et al,.)
            if Example == 1    
            input = struct(...
                                        'Length',58,...                 % (um)                            
                                        'Frequency',21,...              % (Hz)
                                        'Spacing',0.185,...             % (um)
                                        'BendingRigidity',1700,...      % (pN um^2)
                                        'BasalStiffness',95000,...      % (pN / um)
                                        'BasalFriction',36154,...       % (pN / um)
                                        'Motor','sliding',...
                                        'Boundaries','clamped-free');
                parameters(input);
            end

            
% Example 2: Chlamydomonas Parameters (Sartori et al,.)
            if Example == 2    
            input = struct(...
                                         'Length',9.2,...               % (um)
                                         'Frequency',28,...             % (Hz)
                                         'Spacing',0.06,...             % (um)
                                         'BendingRigidity',400,...      % (pN um^2)    
                                         'BasalStiffness',2100,...      % (pN / um)
                                         'BasalFriction',2300,...       % (pN / um)
                                         'Motor','dyn-curvature',...
                                         'Boundaries','free-free');

                parameters(input);
            end
            
% Example 3: Chlamydomonas Parameters (Sartori et al,.)
            if Example == 3    
            input = struct(...
                                         'Length',12,...                % (um)
                                         'Frequency',30,...             % (Hz)
                                         'Spacing',0.06,...             % (um)
                                         'BendingRigidity',400,...      % (pN um^2)    
                                         'BasalStiffness',0,...         % (pN / um)
                                         'BasalFriction',0,...          % (pN / um)
                                         'SlidingStiffness',15000,...   % (pN / um^2)
                                         'Motor','curvature',...
                                         'Boundaries','free-free');

                parameters(input);
            end

% Load parameters.m For defaults: use "parameters" with no arguments 


%%(2) EXPLORE PHASE-SPACE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global normal_beta normal_chi
% Note: The response coefficeients have dimensions
        % chi (pN / um^2),  beta (pN)

if Example == 1    % Sperm Parameters (Riedel-Kruse et al,.)           
        % For sliding control, we explore the [chi1,chi2] space
        chi1    = -5030:30:0;       % (pN / um^2)    
        chi2    = -2000:50:650;     % (pN / um^2)  
    space = solspace(chi1.*normal_chi,chi2.*normal_chi,0); % input normalized values in solspace
  
end


if Example == 2    % Chlamydomonas Parameters (Sartori et al,.)   
        % For dynamic curvature control we explore the [chi1,beta2] space
        chi1    = -0:300:32900;     % (pN / um^2)
        beta2   = -8123:30:-833;    % (pN ) 
    space = solspace(chi1.*normal_chi,beta2.*normal_beta,0); % input normalized values in solspace
    
end


if Example == 3    % Chlamydomonas Parameters (Sartori et al,.)
      % For curvature control, we explore the [beta1,beta2] space           
      beta1     = -8433:100:8433;    % (pN )
      beta2     = -10000:60:10000;   % (pN )  
   space = solspace(beta1.*normal_beta,beta2.*normal_beta,0); % input normalized values in solspace
  
end
clearvars -except space input

%% (3) CALCULATE SOLUTIONS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Taking the seeds from the phase space we can calculate the modes
solutions = beatmodes(space.seeds);
% We can use "beatmodes.m" with any guessed seed(i.e. for sliding control it would be  mysolution = beatmodes([-chi1_bar;-chi2_bar]) );

%%(4) Study the phasesspace and display solutions 
    % Plot the phasespace (seeds are red dots, solutions are white circles and numbered by proximity to origin)
    % the order (proximity to origin) is given in index
    % You can cange the err_tol parameter to exclude or include more
    % solutions from display
err_tol =  10^-1;  %
space.index = plot_phasespace(space,solutions,err_tol);

%% (5) Study a specific Solution (Select a solution from the phase plot that you want to display)
solution_number = 2;    % Soluton number in phasespace plot
plot_solution(solutions,space.index,solution_number);          % this plots a stored solution 


