function[Count, Hom] = LatticeData(L)

Width = size(L, 1);

Count = zeros(5, 1);

for i = 1:Width
    for j = 1:Width
        Count(L(i,j)) = Count(L(i,j)) + 1;
    end
end

NoWallCount = zeros(5,1);

for i = 3:Width-2
    for j = 3:Width - 2
        NoWallCount(L(i,j)) = NoWallCount(L(i,j)) + 1;
    end
end

NeighborColorAmounts = zeros(5,5);

for i = 3:Width - 2
    for j = 3:Width - 2
          NeighborColorAmounts(L(i,j), L(i,j + 1)) = NeighborColorAmounts(L(i,j), L(i,j + 1)) + 1;
          NeighborColorAmounts(L(i,j), L(i,j - 1)) = NeighborColorAmounts(L(i,j), L(i,j - 1)) + 1;
          NeighborColorAmounts(L(i,j), L(i + 1,j)) = NeighborColorAmounts(L(i,j), L(i + 1,j)) + 1;
          NeighborColorAmounts(L(i,j), L(i - 1,j)) = NeighborColorAmounts(L(i,j), L(i - 1,j)) + 1;
    end
end

Proportion = zeros(5,5);

for i = 1:5
    for j = 1:5
        Proportion(i,j) = NeighborColorAmounts(i,j) / (4 * NoWallCount(i));
    end
end

DifferenceSquared = zeros(5,5);

for i = 1:5
    for j = 1:5
        DifferenceSquared(i,j) = (Proportion(i,j) - (Count(i) / (Width^2)))^2;
    end
end

Hom = 0;

for i = 2:4
    for j = 2:4
        Hom = Hom + DifferenceSquared(i,j) / 9;
    end
end
