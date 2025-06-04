function [ R, g] = routingMatrixGenFromAdja_2( adjacency, Nvant)
%   adjacency: adjacency matrix of a graph; Nvant: number of vantage points(default 29); R:routing matrix g:graph
%   the routing matrix is created by shortest-path and graph g is created by delete the nodes/edges not covered by R
v = size(adjacency, 1);

g=graph(adjacency);
plot(g)
v=numnodes(g);

% find the Nvant nodes with least degree 
allvDegree = zeros(v, 2);
allvDegree(:, 1) = 1:v;
for i=1:v
    allvDegree(i, 2) = degree(g,i);
end
allvDegreeSorted = sortrows(allvDegree, 2);
disp(allvDegree)
vantages = allvDegreeSorted(1:Nvant, 1);

% construct routing matrix R
allEdge = edgeofG(g); 
R = zeros(numnodes(g)*numnodes(g), numedges(g)); k=0;
for i=1:length(vantages)-1
    for j=i+1:length(vantages)
    path = shortestpath(g, vantages(i), vantages(j));
    if ~isempty(path)
        k = k+1;
        edges = edgeofP(path);
        line = zeros(1, numedges(g));
        [lia, locb1] = ismember(edges, allEdge, 'rows');
        [lia, locb2] = ismember(edges(:,[2,1]), allEdge, 'rows');
        line(locb1+locb2) = 1;
        R(k,:) = line;
    end
    end
end
R = R(1:k,:);

% remove all the links not belong to path 
R(:, sum(R, 1)==0)=[];
% remove all "identical" links
% RR = R';
% RRR = unique(RR,'rows');
% R = RRR';
end

function edge = edgeofP(path)
edge = zeros(length(path)-1, 2);
for i=1:length(path)-1
    edge(i,:) = [path(i) path(i+1)];
end
end

function vertex = vWithdgree(g, d)
k = 0; vertexs = zeros(1, nv(g));
for i=1:nv(g)
    if degree(g,i)==d
        k = k+1;
        vertexs(k) = i;
    end
end
vertex = vertexs(1:k);
end

function allEdges = edgeofG(g)
A = adjacency(g);
k = 0; edges = zeros(numnodes(g)*numnodes(g), 2);
for i=1:numnodes(g)-1
    for j=i+1:numnodes(g)
        if A(i,j)
            k = k+1;
            edges(k,:) = [i j];
        end
    end
end
allEdges = edges(1:k,:);
end