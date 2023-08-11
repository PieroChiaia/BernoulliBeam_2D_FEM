%% MATLAB CODE TO PLOT THE DEFORMED AND UNDERFORMED STRUCTURE %%

clear all
close all
clc

% Adapt the scale factor to visualize better the deformed structure
Scale = 1e2;


% Elements, node and displacement components results
Configuration = load('RESULTS.dat','-ascii');
StiffnessMatrix = load('K_MAT_BC.dat','-ascii');

% Check if stiffness matrix is symmetrix for correctness of problem definition
if(issymmetric(StiffnessMatrix))
    disp('Checking stiffness matrix: IS SYMMETRIC')
end


% Adaptive plot axis
minX_Undeformed = min(Configuration(:,3)) ;
maxX_Undeformed = max(Configuration(:,3)) ;
minY_Undeformed = min(Configuration(:,4)) ;
maxY_Undeformed = max(Configuration(:,4)) ;

minX_Deformed = min(Configuration(:,3)+Configuration(:,5));
maxX_Deformed = max(Configuration(:,3)+Configuration(:,5));
minY_Deformed = min(Configuration(:,4)+Configuration(:,6));
maxY_Deformed = max(Configuration(:,4)+Configuration(:,6));

AxisLimitX = (maxX_Deformed-minX_Deformed)/5;
AxisLimitY = (maxY_Deformed-minY_Deformed)/5;

minX = min(minX_Deformed,minX_Undeformed) - AxisLimitX;
maxX = max(maxX_Deformed,maxX_Undeformed) + AxisLimitX;
minY = min(minY_Deformed,minY_Undeformed) - AxisLimitY;
maxY = max(maxY_Deformed,maxY_Undeformed) + AxisLimitY;




set(gcf,'color','w');


% Loop on elements

for i=1:2:length(Configuration(:,1))
    Node1_Pos0 = Configuration(i,3:4);
    Node1_Pos1 = Configuration(i,3:4) + Scale*Configuration(i,5:6);

    Node2_Pos0 = Configuration(i+1,3:4);
    Node2_Pos1 = Configuration(i+1,3:4) + Scale*Configuration(i+1,5:6);

    % Plot dell'elemento indeformato     
    plot([ Node1_Pos0(1) Node2_Pos0(1) ], [ Node1_Pos0(2) Node2_Pos0(2) ],'ko','LineWidth',1)
    line([ Node1_Pos0(1) Node2_Pos0(1) ], [ Node1_Pos0(2) Node2_Pos0(2) ],'Color','black','LineStyle','--')
    
    hold on

    % Plot dell'elemento deformato
    plot([ Node1_Pos1(1) Node2_Pos1(1) ], [ Node1_Pos1(2) Node2_Pos1(2) ],'ko','LineWidth',2)
    line([ Node1_Pos1(1) Node2_Pos1(1) ], [ Node1_Pos1(2) Node2_Pos1(2) ],'Color','black','LineStyle','-','LineWidth',2)
    daspect([1 1 1])
    axis([minX maxX minY maxY])
    

    hold on
    

end

hold off

%% Graphical representation of the stiffness matrix
for i=1:length(StiffnessMatrix(:,1))
    for j=1:length(StiffnessMatrix(:,1))
        if( abs(StiffnessMatrix(i,j)) ~= 0)
            StiffnessMatrix(i,j) = 1;
        end
    end
end

figure(3)
X = linspace(1,length(StiffnessMatrix(:,1)),length(StiffnessMatrix(:,1)));
Y = linspace(length(StiffnessMatrix(:,1)),1,length(StiffnessMatrix(:,1)));
pcolor(X,Y,StiffnessMatrix)


Nc = 256;
myColorMap = [linspace(1,0,Nc).' linspace(1,0,Nc).' linspace(1,0,Nc).'];
%myColorMap = [linspace(1,0,Nc).' linspace(1,0,Nc).' ones(Nc,1)];
colormap(myColorMap)


