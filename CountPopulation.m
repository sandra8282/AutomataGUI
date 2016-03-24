function[Count] = CountPopulation(L)

Width = size(L, 1);

Count = zeros(5, 1);

for i = 1:Width
    for j = 1:Width
        Count(L(i,j)) = Count(L(i,j)) + 1;
    end
end
