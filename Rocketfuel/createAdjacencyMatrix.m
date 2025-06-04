function adjMatrix = createAdjacencyMatrix(filename)
% Construct the adjacency matrix from the Rocketfuel topology file.

    fileID = fopen(filename, 'r');
    if fileID == -1
        error('文件无法打开，请检查文件名和路径。');
    end
    
    nodeNameToIndex = containers.Map();
    adjMatrix = [];
    
    while ~feof(fileID)
        line = fgetl(fileID);
        line = regexprep(line, '\s*\d+$', '');
        tokens = strsplit(line, '->');
        
        if length(tokens) ~= 2
            continue;
        end
        
        nodeName1 = tokens{1};
        nodeName2 = tokens{2};
        
        if ~nodeNameToIndex.isKey(nodeName1)
            nodeNameToIndex(nodeName1) = length(nodeNameToIndex) + 1;
        end
        if ~nodeNameToIndex.isKey(nodeName2)
            nodeNameToIndex(nodeName2) = length(nodeNameToIndex) + 1;
        end
        
        index1 = nodeNameToIndex(nodeName1);
        index2 = nodeNameToIndex(nodeName2);
        
        % Ensure that the size of the adjacency matrix is sufficient to contain these two nodes.
        if isempty(adjMatrix)
            adjMatrix = zeros(1, 1);
        end
        maxIndex = max(index1, index2);
        if maxIndex > size(adjMatrix, 1)
            % Expand the adjacency matrix to accommodate larger node indices.
            adjMatrix = [adjMatrix, zeros(size(adjMatrix, 1),maxIndex - size(adjMatrix, 2))];
            adjMatrix = [adjMatrix; zeros(maxIndex - size(adjMatrix, 1), size(adjMatrix, 2))];
        end
        
        adjMatrix(index1, index2) = 1;
        adjMatrix(index2, index1) = 1; 
    end
    
    fclose(fileID);
end

