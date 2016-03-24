function[NewGrid] = NewState(Lattice, TimeStep, DeathRate, BirthRate, DispersalRadius, ColStrength)

Width = size(Lattice, 1); 

stepX = [0, 1, 0, -1];
stepY = [-1, 0, 1, 0];

r = rand(Width^2, 1); % Probability rolls to determine if something happens
rX = rand(Width^2, 1); % Rolls to pick coordinates of cells
rY = rand(Width^2, 1);
rRadius = rand(Width^2, 1); % Rolls to pick target of seed dispersal
rTheta = rand(Width^2, 1);

for j=1:Width^2                % There are Width^2 chances for something to happen in each dt step

    [x,y]=deal(floor(Width*rX(j))+1,floor(Width*rY(j))+1); % Pick a random place where something might happen
    
    if (Lattice(x, y) ~= 1) && (Lattice(x, y) ~= 5) % If the cell is occupied, proceed:
    
        trueDeathRate = DeathRate; % The true death rate will be the actual death rate of cells at this point, modified by neighbors
        
        if Lattice(x, y) == 4
            for i = 1:4 % Check neighbors to modify the trueDeathRate
                adjX = x + stepX(i);
                adjY = y + stepY(i);
                if (adjX > 0) && (adjX <= Width) && (adjY > 0) && (adjY <= Width) && (Lattice(adjX, adjY) == 2)
                    trueDeathRate = trueDeathRate + (ColStrength / 4);
                end
            end
        end
    
        if r(j) < trueDeathRate * TimeStep
            Lattice(x, y) = 1;
        elseif r(j) < (trueDeathRate + BirthRate(Lattice(x, y) - 1)) * TimeStep
            % Pick target site:
            targX = round(x + (rRadius(j) * DispersalRadius * cos(rTheta(j) * 2 * pi)));
            targY = round(y + (rRadius(j) * DispersalRadius * sin(rTheta(j) * 2 * pi)));
            
            if (targX > 0) && (targY > 0) && (targX <= Width) && (targY <= Width) && Lattice(targX, targY) == 1
                Lattice(targX, targY) = Lattice(x, y);
            end
        end
    end
end 

NewGrid = Lattice;
