function[Lattice] = InitGrid(ProbEmpty,ProbProd,ProbRes,ProbSus,Bound,Cracks,Width) 

Lattice=zeros(Width,Width);

v=rand(Width,Width); 

for i=1:Width
  for j=1:(Width)
      if v(i,j)<ProbEmpty; Lattice(i,j)=1; %Lattice: Array of bacteria states (1,2,3, or 4)
      elseif v(i,j)<ProbProd+ProbEmpty; Lattice(i,j)=2; 
      elseif v(i,j)<ProbRes+ProbProd+ProbEmpty; Lattice(i,j)=3; 
      else Lattice(i,j)=4;
      end   
  end 
end   

if Bound==true
   for i=1:Width 
    Lattice(i,Width)=5; 
    Lattice(Width,i)=5; 
    Lattice(1,i)=5; 
    Lattice(i,1)=5;
   end    
end 

