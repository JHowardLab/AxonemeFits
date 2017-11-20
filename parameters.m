% Function that loads all the parameters. To explore variability of one of
% the parameters just remove it from here and change the program to convert
% it in input of "solspace" and "beatmodes".

function parameters(varargin)
%Declare global variables and parser
global Sp D0 chib kp k xi xitrn xirot
global bc motor
global normal_chi normal_beta L omega kappa a_0 chi1_b chi2_b chi1_s chi2_s
p = inputParser;

%INPUT PARAMETERS
% Default parameters
defLength            = 58;        % in um
defFrequency         = 21;        % in 1/s
defBasalStiffness    = 95000;     % in pN/um
defBasalFriction     = 36154;     % in pN/um
defHeadFrictionRot   = 0.;        % in pN*s*um
defHeadFrictionTrans = 0.;        % in pN*s/um
defSlidingStiffness  = 0.;        % in pN/um^2
defSlidingFriction   = 0.;        % in pN*s/um^2
defPivotStiffness    = 0.;        % in pN
defAsymmetry         = 0.0;       % in rad/um
defSpacing           = 0.185;     % in um
defBendingRigidity   = 1700;      % in pN*um^2
defNormalFriction    = 0.0034;    % in pN*s/um^2
defMotor             = 'sliding';
defBoundaries        = 'clamped-free';


% Available boundary conditions and motor models
availBoundaries = {'free-free','clamped-free','swim-free','pivot-free'};
availMotors     = {'sliding','curvature','dyn-curvature'};

%Parse inputs
addOptional(p,'Length',defLength,@isnumeric);
addOptional(p,'Frequency',defFrequency,@isnumeric);
addOptional(p,'BasalStiffness',defBasalStiffness,@isnumeric);
addOptional(p,'BasalFriction',defBasalFriction,@isnumeric);
addOptional(p,'HeadFrictionRot',defHeadFrictionRot,@isnumeric);
addOptional(p,'HeadFrictionTrans',defHeadFrictionTrans,@isnumeric);
addOptional(p,'SlidingStiffness',defSlidingStiffness,@isnumeric);
addOptional(p,'SlidingFriction',defSlidingFriction,@isnumeric);
addOptional(p,'PivotStiffness',defPivotStiffness,@isnumeric);
addOptional(p,'Asymmetry',defAsymmetry,@isnumeric);
addOptional(p,'Spacing',defSpacing,@isnumeric);
addOptional(p,'BendingRigidity',defBendingRigidity,@isnumeric);
addOptional(p,'NormalFriction',defNormalFriction,@isnumeric);
addOptional(p,'Motor',defMotor,@(x) any(validatestring(x,availMotors)));
addOptional(p,'Boundaries',defBoundaries,...
              @(x) any(validatestring(x,availBoundaries)));
parse(p,varargin{:});

%% GLOBAL PARAMETERS
% Calculate dimensionless and other global variables
bc    = p.Results.Boundaries;
motor = p.Results.Motor;
Sp    = 2*pi*p.Results.Frequency*p.Results.NormalFriction...
        *p.Results.Length^4/p.Results.BendingRigidity;
D0    = p.Results.Asymmetry*p.Results.Length;
chib  = (p.Results.BasalStiffness...
        +1i*p.Results.BasalFriction)...
        *(p.Results.Length*p.Results.Spacing^2/p.Results.BendingRigidity);
k     = p.Results.SlidingStiffness...
        *(p.Results.Length^2*p.Results.Spacing^2/p.Results.BendingRigidity);
xi    = p.Results.SlidingFriction...
        *(p.Results.Length^2*p.Results.Spacing^2/p.Results.BendingRigidity);
kp    = p.Results.PivotStiffness...
        *(p.Results.Length*p.Results.Spacing^2/p.Results.BendingRigidity);
xitrn = 1i*2*pi*p.Results.Frequency*p.Results.HeadFrictionRot...
        *p.Results.Length^3/p.Results.BendingRigidity;
xirot = 1i*2*pi*p.Results.Frequency*p.Results.HeadFrictionTrans...
        *p.Results.Length/p.Results.BendingRigidity;

% Parameters
    L       = p.Results.Length;
    kappa   = p.Results.BendingRigidity;
    a_0     = p.Results.Spacing;
    omega   = p.Results.Frequency;
    chi1_b  = p.Results.BasalStiffness;
    chi2_b  = p.Results.BasalFriction;
    chi1_s  = p.Results.SlidingStiffness;
    chi2_s  = p.Results.SlidingFriction; 
% Normalization Parameters   
    normal_chi    =  ((a_0^2 *L^2)/kappa);
    normal_beta   =  ((a_0*L)/kappa);
    
    
      
    
