function[picture] = DisplayGrid(grid) 


imagesc(grid) % Draw an array showing the current state of the array

%                              % Include a bar indicating which color corresponds to which 
%                              %   cell type
%   colorbar('Ticks',[1,2,3,4],...
%        'TickLabels',{'Empty','Parasitic Plant','Forbe','Grass'})                   
   drawnow                    % Draw the array now, rather then waiting until the program 
%                              %   is complete