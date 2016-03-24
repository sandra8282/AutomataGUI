clear;
clf();

% 1: Empty cell (white)
% 2: Colicin-producing cell, i.e. strain C, or strain 2 (red)
% 3: Colicin-resistant cell, i.e. strain R, or strain 3 (green)
% 4: Colicin-susceptible cell, i.e. strain S, or strain 4 (blue)
% 5: Wall (black)

TimeStep=.09;                      % dt: Time step width
Width=200;                       % Width of lattice
BirthRate=[12,13.6,16];         % BirthRate: due to array indexing issue,
                             % BirthRate(i) denotes birth probability of strain (i+1)
DeathRate = 1;               % DeathRate: assumed constant for all strains
SeedRadius = 1;             % SeedRadius: denotes radius seeds are dispersed to
ColStrength = 4;             % ColStrength: Proportionality constant for impact of colicin-
                             % producing strain on colicin-susceptible strain
NumTimeStep=1000;                   % Step: Number of time steps to perform

ProbEmpty = 0.2;
ProbProd = 0.1;
ProbRes = 0.3;
ProbSus = 0.4;
Bound = true;
Cracks = false;
deadYet = false;

%L=InitSpiralGrid(Width,1,100,40);
L=InitGrid(ProbEmpty,ProbProd,ProbRes,ProbSus,Bound,Cracks,Width); 
Time = [TimeStep:TimeStep:TimeStep * NumTimeStep];

PopCount = zeros(NumTimeStep, 5);
Inhomogeneity = zeros(NumTimeStep, 1);

if Bound == true
mymap = [1  1   1
    1 0 0
    0 1 0
    0 0 1
    0 0 0];
else 
  mymap = [1  1   1
    1 0 0
    0 1 0
    0 0 1];  
end

colormap(mymap)

for i = 1:NumTimeStep
     DisplayGrid(L);
    if mod(i,100)==0
        imagesc(L);
        %saveas(gcf,num2str(i),'png');
    end
    %i
    L = NewState(L, TimeStep, DeathRate, BirthRate, SeedRadius, ColStrength);
    [PopCount(i, :), Inhomogeneity(i)] = LatticeData(L);    
    if (deadYet == false)
        for j = 2:4
            if PopCount(i,j) == 0
                deadYet = true;
                deadTime = i * TimeStep;
            end
        end
    end
end

figure(2);
plot(Time, PopCount');
legend('Empty','Colicin','Resistant','Susceptible')

%figure(3);
%plot(Time, Inhomogeneity');
