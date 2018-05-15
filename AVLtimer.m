%% for timing AVL with differing vortice counts %%

%%% inputs %%%
planeName = 'plane'; % Name for the output files (string)
g = 9.81; % Gravitational acceleration
d = 1.225; % Air density
mass = 0.3; % Total mass of the plane
vCruise = 13.5; % Velocity at cruise

wingSpan = 0.31; % Span of the wings
wingArea = 0.03705; % Planform area of the wings
wingTaper = 1; % Wing taper ratio
wingAirfoil = 'mh114.dat'; % Airfoil used on the wings (string)
theta1 = 0;
theta2 = 0;
L1 = 0.2;
L2 = 0.6;
backLoft = 0.0508; % Height that the second wing is lofted to

wings = 1;
runs = 3;
maxNspan = 20;
maxNchord = 20;
minNspan = 8;
minNchord = 8;
x = maxNchord-minNchord;
y = maxNspan-minNspan;
setupTime = zeros([x y runs]);
runTime = zeros([x y runs]);
measureTime = zeros([x y runs]);
data = zeros([x y runs 7]); % alpha cL cD stripCL Cma Cnb Clp


%%% script (single wing) %%%
for Nchord=minNspan:maxNchord
    for Nspan=minNspan:maxNspan
        for n=1:runs
            if Nchord*Nspan*2 > 6000
                fprintf('Too high\n');
                break
            end
            tic;
            wing1 = Main_Wing(wingSpan,wingArea,wingTaper,0,wingAirfoil,0,theta1,[],[0 0 0],'wing1');
            Case = inputs(g,d,mass,0,L1,0,0,vCruise,0,false);
            
            plane = Aircraft(wing1,[],[],Case,[],[L1*0.25,0,0],mass,[1,1,1],planeName,Nchord,Nspan);
            plane.build_file;
            plane.build_mass;
            setupTime(Nchord,Nspan,n) = toc;
            
            tic;
            plane.run_avl;
            runTime(Nchord,Nspan,n) = toc;
            
            tic;
            % Reading the header data from the sb file
            Header = parseRunCaseHeader(strcat('.\AVL_DATA\',planeName,'_DATA.sb'));
            alpha = Header.alpha;
            cL = Header.CLtot;
            cD = Header.CDtot;
            
            % Reading the strip force data for each wing
            SF = parseSF(strcat('.\AVL_DATA\',planeName,'_DATA.fs'));
            sIndex = getSurfaceByName(SF,'wing1');
            StripForces = SF(sIndex).strip{1};
            cL1 = StripForces.cl; % Root strip coefficient of lift for front wing
            measureTime(Nchord,Nspan,n) = toc;
            
            ST = parseST(strcat('.\AVL_DATA\',planeName,'_DATA.st'));
            data(Nchord,Nspan,n,:) = [alpha,cL,cD,cL1,ST.Cma,ST.Cnb,ST.Clp];
        end
    end
end