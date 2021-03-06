% Function that calculates space of solutions via det(M). The inputs xrange
% and yrange are the ranges of the two components of the response
% coefficient to be analyzed. The output is a list with the xy coordinates
% of the minima. The function also saves a figure with the det-landscape
% and stores the xyz as well as seeds on a .dat file.

function space = solspace(xrange,yrange,plots)
% We load the parameters
global motor chib bc Sp kp xihead k xi 

%% CALCULATE DETERMINANT SURFACE
% Depending on the motor model we generate xyz-data and calculate minima  
switch motor
    case 'sliding'
        % Determinant of bvp for sliding control 
        determinant = @(res) det(bcmat([res(1),res(2),0,0]));
        
        % We compute the determinant on the given range
        detdat = zeros(length(xrange),length(yrange));
        h = waitbar(0,'Phase Space entries are calulated...');
        for i=1:length(xrange)
            for j=1:length(yrange)
                detdat(i,j)=abs(determinant([xrange(i),yrange(j)]));
            end
            waitbar(i / length(xrange))
        end
        close(h);
        
        % Data is stored in log-scale as xyz
        [x,y]   = meshgrid(xrange,yrange);
        stringx = 'Sliding response  \chi_{bar}''';
        stringy = 'Sliding response  \chi_{bar}''''';
        z       = log10(detdat);
        
        % And calculate the minima
        [~,~,~,imin] = extrema2(z');
        
    case 'dyn-curvature'
        % Determinant of bvp for sliding control 
        determinant = @(res) det(bcmat([res(1),0,0,res(2)]));
        
        % We compute the determinant on the given range
        detdat = zeros(length(xrange),length(yrange));
        h = waitbar(0,'Phase Space entries are calulated...');
        for i=1:length(xrange)
            for j=1:length(yrange)
                detdat(i,j)=abs(determinant([xrange(i),yrange(j)]));
            end
        waitbar(i / length(xrange))    
        end
        close(h);
        
        % Data is stored in log-scale as xyz
        [x,y]   = meshgrid(xrange,yrange);
        stringx = 'Sliding response \chi_{bar}''';
        stringy = 'Curvature response \beta_{bar}''''';
        z       = log10(detdat);
        
        % And calculate the minima
        [~,~,~,imin] = extrema2(z'); 
        
    case 'curvature'
        % Determinant of bvp for sliding control 
        determinant = @(res) det(bcmat([k,xi,res(1),res(2)]));
        
        % We compute the determinant on the given range
        detdat = zeros(length(xrange),length(yrange));
        h = waitbar(0,'Phase Space entries are calulated...');
        for i=1:length(xrange)
            for j=1:length(yrange)
                detdat(i,j)=abs(determinant([xrange(i),yrange(j)]));
            end
        waitbar(i / length(xrange))    
        end
        close(h);
        
        % Data is stored in log-scale as xyz
        [x,y]   = meshgrid(xrange,yrange);
        stringx = 'Curvature response \beta_{bar}''';
        stringy = 'Curvature response \beta_{bar}''''';
        z       = log10(detdat);
        
        % And calculate the minima
        [~,~,~,imin] = extrema2(z');              
end

%% OBTAIN SEEDS
% We find the points that are xy null
xmin=x(imin);
ymin=y(imin);
nonull=((xmin~=0)+(ymin~=0))~=0;

% And select the rest
xmin = xmin(nonull);
ymin = ymin(nonull);
space.seeds = [xmin';ymin'];
space.xyz   = {x,y,z};

if plots == 1
%% PLOT HEATMAP
% Generate heat map
figure;
colormap(winter);
%imagesc([xrange(1),xrange(end)],[yrange(1),yrange(end)],z);
contourf(x,y,z');
daspect([1 1 1]);
xlabel(stringx,'FontSize',12,'FontName','Helvetica');
ylabel(stringy,'FontSize',12,'FontName','Helvetica');
h = colorbar;
ylabel(h, 'log_{10}(det(M))');
hold on

% Add dots and numbers for modes
plot(xmin,ymin,'r.')
[~,indexseeds]=sort(xmin.^2+ymin.^2);
text(xmin(indexseeds)-0*abs(xrange(end)-xrange(1)),...
     ymin(indexseeds)-0*abs(xrange(end)-xrange(1)),...
     textscan(num2str(1:length(indexseeds)),'%s'),'Color',[1 1 1]);

% Anotate the plot
inset={['Motor model: ' motor],['Boundary conditions: ' bc],...
       ['S_p=' num2str(Sp) ';   \chi_b=' num2str(chib)],...
       ['k_p=' num2str(kp) ';   \xi_h=' num2str(xihead)], ...
       ['k_i=' num2str(k)  ';   \xi_i=' num2str(xi)]};

annotation('textbox',...
    [.15 .7 .33 .17],...
    'String',inset,...
    'FontSize',12,...
    'FontName','Helvetica',...
    'EdgeColor',[1 1 1],...
    'FitBoxToText','off',...
    'Color',[1 1 1],...
    'FitHeightToText','on');
hold off
title('Note: Seeds are numbered')
end

%%%%%% Additional functions

function [xymax,smax,xymin,smin] = extrema2(xy,varargin)
%EXTREMA2   Gets the extrema points from a surface.
%   [XMAX,IMAX,XMIN,IMIN] = EXTREMA2(X) returns the maxima and minima 
%   elements of the matriz X ignoring NaN's, where
%    XMAX - maxima points in descending order (the bigger first and so on)
%    IMAX - linear indexes of the XMAX
%    XMIN - minima points in descending order
%    IMIN - linear indexes of the XMIN.
%   The program uses EXTREMA.
% 
%   The extrema points are searched only through the column, the row and
%   the diagonals crossing each matrix element, so it is not a perfect
%   mathematical program and for this reason it has an optional argument.
%   The user should be aware of these limitations.
%
%   [XMAX,IMAX,XMIN,IMIN] = EXTREMA2(X,1) does the same but without
%   searching through the diagonals (less strict and perhaps the user gets
%   more output points).
%
%   DEFINITION (from http://en.wikipedia.org/wiki/Maxima_and_minima):
%   In mathematics, maxima and minima, also known as extrema, are points in
%   the domain of a function at which the function takes a largest value
%   (maximum) or smallest value (minimum), either within a given
%   neighbourhood (local extrema) or on the function domain in its entirety
%   (global extrema). 
%
%   Note: To change the linear index to (i,j) use IND2SUB. 
%
%   Example:
%      [x,y] = meshgrid(-2:.2:2,3:-.2:-2);
%      z = x.*exp(-x.^2-y.^2); z(10,7)= NaN; z(16:19,13:17) = NaN;
%      surf(x,y,z), shading interp
%      [zmax,imax,zmin,imin] = extrema2(z);
%      hold on  
%       plot3(x(imax),y(imax),zmax,'bo',x(imin),y(imin),zmin,'ro')
%       for i = 1:length(zmax)
%        text(x(imax(i)),y(imax(i)),zmax(i),['  ' num2str(zmax(i))])
%       end
%       for i = 1:length(zmin)
%        text(x(imin(i)),y(imin(i)),zmin(i),['  ' num2str(zmin(i))])
%       end
%      hold off 
%
%   See also EXTREMA, MAX, MIN

%   Written by
%   Lic. on Physics Carlos Adri�n Vargas Aguilera
%   Physical Oceanography MS candidate
%   UNIVERSIDAD DE GUADALAJARA 
%   Mexico, 2005
%
%   nubeobscura@hotmail.com

% From       : http://www.mathworks.com/matlabcentral/fileexchange
% File ID    : 12275
% Submited at: 2006-09-14
% 2006-11-11 : English translation from spanish. 
% 2006-11-17 : Accept NaN's.
% 2006-11-22 : Fixed bug in INDX (by JaeKyu Suhr)
% 2007-04-09 : Change name to MAXIMA2, and definition added.

M = size(xy);
if length(M) ~= 2
 error('Entry must be a matrix.')
end
N = M(2);
M = M(1);

% Search peaks through columns:
[smaxcol,smincol] = extremos(xy);

% Search peaks through rows, on columns with extrema points:
im = unique([smaxcol(:,1);smincol(:,1)]); % Rows with column extrema
[smaxfil,sminfil] = extremos(xy(im,:).');

% Convertion from 2 to 1 index:
smaxcol = sub2ind([M,N],smaxcol(:,1),smaxcol(:,2));
smincol = sub2ind([M,N],smincol(:,1),smincol(:,2));
smaxfil = sub2ind([M,N],im(smaxfil(:,2)),smaxfil(:,1));
sminfil = sub2ind([M,N],im(sminfil(:,2)),sminfil(:,1));

% Peaks in rows and in columns:
smax = intersect(smaxcol,smaxfil);
smin = intersect(smincol,sminfil);

% Search peaks through diagonals?
if nargin==1
 % Check peaks on down-up diagonal:
 [iext,jext] = ind2sub([M,N],unique([smax;smin]));
 [sextmax,sextmin] = extremos_diag(iext,jext,xy,1);

 % Check peaks on up-down diagonal:
 smax = intersect(smax,[M; (N*M-M); sextmax]);
 smin = intersect(smin,[M; (N*M-M); sextmin]);

 % Peaks on up-down diagonals:
 [iext,jext] = ind2sub([M,N],unique([smax;smin]));
 [sextmax,sextmin] = extremos_diag(iext,jext,xy,-1);

 % Peaks on columns, rows and diagonals:
 smax = intersect(smax,[1; N*M; sextmax]);
 smin = intersect(smin,[1; N*M; sextmin]);
end

% Extrema points:
xymax = xy(smax);
xymin = xy(smin);

% Descending order:
[~,inmax] = sort(-xymax); clear temp
xymax = xymax(inmax);
smax = smax(inmax);
[xymin,inmin] = sort(xymin);
smin = smin(inmin);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [smax,smin] = extremos(matriz)
% Peaks through columns or rows.

smax = [];
smin = [];

for n = 1:length(matriz(1,:))
 [~,imaxfil,~,iminfil] = extrema(matriz(:,n)); 
 if ~isempty(imaxfil)     % Maxima indexes
  imaxcol = repmat(n,length(imaxfil),1);
  smax = [smax; imaxfil imaxcol];
 end
 if ~isempty(iminfil)     % Minima indexes
  imincol = repmat(n,length(iminfil),1);
  smin = [smin; iminfil imincol];
 end
end


function [sextmax,sextmin] = extremos_diag(iext,jext,xy,A)
% Peaks through diagonals (down-up A=-1)

[M,N] = size(xy);
if A==-1
 iext = M-iext+1;
end
[iini,jini] = cruce(iext,jext,1,1);
[iini,jini] = ind2sub([M,N],unique(sub2ind([M,N],iini,jini)));
[ifin,jfin] = cruce(iini,jini,M,N);
sextmax = [];
sextmin = [];
for n = 1:length(iini)
 ises = iini(n):ifin(n);
 jses = jini(n):jfin(n);
 if A==-1
  ises = M-ises+1;
 end
 s = sub2ind([M,N],ises,jses);
 [~,imax,~,imin] = extrema(xy(s)); 
 sextmax = [sextmax; s(imax)'];
 sextmin = [sextmin; s(imin)'];
end


function [i,j] = cruce(i0,j0,I,J)
% Indexes where the diagonal of the element io,jo crosses the left/superior
% (I=1,J=1) or right/inferior (I=M,J=N) side of an MxN matrix. 

arriba = 2*(I*J==1)-1;

si = (arriba*(j0-J) > arriba*(i0-I));
i = (I - (J+i0-j0)).*si + J+i0-j0;
j = (I+j0-i0-(J)).*si + J;


% Carlos Adri�n Vargas Aguilera. nubeobscura@hotmail.com

function [xmax,imax,xmin,imin] = extrema(x)
%EXTREMA   Gets the global extrema points from a time series.
%   [XMAX,IMAX,XMIN,IMIN] = EXTREMA(X) returns the global minima and maxima 
%   points of the vector X ignoring NaN's, where
%    XMAX - maxima points in descending order
%    IMAX - indexes of the XMAX
%    XMIN - minima points in descending order
%    IMIN - indexes of the XMIN
%
%   DEFINITION (from http://en.wikipedia.org/wiki/Maxima_and_minima):
%   In mathematics, maxima and minima, also known as extrema, are points in
%   the domain of a function at which the function takes a largest value
%   (maximum) or smallest value (minimum), either within a given
%   neighbourhood (local extrema) or on the function domain in its entirety
%   (global extrema).
%
%   Example:
%      x = 2*pi*linspace(-1,1);
%      y = cos(x) - 0.5 + 0.5*rand(size(x)); y(40:45) = 1.85; y(50:53)=NaN;
%      [ymax,imax,ymin,imin] = extrema(y);
%      plot(x,y,x(imax),ymax,'g.',x(imin),ymin,'r.')
%
%   See also EXTREMA2, MAX, MIN

%   Written by
%   Lic. on Physics Carlos Adri�n Vargas Aguilera
%   Physical Oceanography MS candidate
%   UNIVERSIDAD DE GUADALAJARA 
%   Mexico, 2004
%
%   nubeobscura@hotmail.com

% From       : http://www.mathworks.com/matlabcentral/fileexchange
% File ID    : 12275
% Submited at: 2006-09-14
% 2006-11-11 : English translation from spanish. 
% 2006-11-17 : Accept NaN's.
% 2007-04-09 : Change name to MAXIMA, and definition added.


xmax = [];
imax = [];
xmin = [];
imin = [];

% Vector input?
Nt = numel(x);
if Nt ~= length(x)
 error('Entry must be a vector.')
end

% NaN's:
inan = find(isnan(x));
indx = 1:Nt;
if ~isempty(inan)
 indx(inan) = [];
 x(inan) = [];
 Nt = length(x);
end

% Difference between subsequent elements:
dx = diff(x);

% Is an horizontal line?
if ~any(dx)
 return
end

% Flat peaks? Put the middle element:
a = find(dx~=0);              % Indexes where x changes
lm = find(diff(a)~=1) + 1;    % Indexes where a do not changes
d = a(lm) - a(lm-1);          % Number of elements in the flat peak
a(lm) = a(lm) - floor(d/2);   % Save middle elements
a(end+1) = Nt;

% Peaks?
xa  = x(a);             % Serie without flat peaks
b = (diff(xa) > 0);     % 1  =>  positive slopes (minima begin)  
                        % 0  =>  negative slopes (maxima begin)
xb  = diff(b);          % -1 =>  maxima indexes (but one) 
                        % +1 =>  minima indexes (but one)
imax = find(xb == -1) + 1; % maxima indexes
imin = find(xb == +1) + 1; % minima indexes
imax = a(imax);
imin = a(imin);

nmaxi = length(imax);
nmini = length(imin);                

% Maximum or minumim on a flat peak at the ends?
if (nmaxi==0) && (nmini==0)
 if x(1) > x(Nt)
  xmax = x(1);
  imax = indx(1);
  xmin = x(Nt);
  imin = indx(Nt);
 elseif x(1) < x(Nt)
  xmax = x(Nt);
  imax = indx(Nt);
  xmin = x(1);
  imin = indx(1);
 end
 return
end

% Maximum or minumim at the ends?
if (nmaxi==0) 
 imax(1:2) = [1 Nt];
elseif (nmini==0)
 imin(1:2) = [1 Nt];
else
 if imax(1) < imin(1)
  imin(2:nmini+1) = imin;
  imin(1) = 1;
 else
  imax(2:nmaxi+1) = imax;
  imax(1) = 1;
 end
 if imax(end) > imin(end)
  imin(end+1) = Nt;
 else
  imax(end+1) = Nt;
 end
end
xmax = x(imax);
xmin = x(imin);

% NaN's:
if ~isempty(inan)
 imax = indx(imax);
 imin = indx(imin);
end

% Same size as x:
imax = reshape(imax,size(xmax));
imin = reshape(imin,size(xmin));

% Descending order:
[temp,inmax] = sort(-xmax); clear temp
xmax = xmax(inmax);
imax = imax(inmax);
[xmin,inmin] = sort(xmin);
imin = imin(inmin);


% Carlos Adri�n Vargas Aguilera. nubeobscura@hotmail.com

