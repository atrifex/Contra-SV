[x, map, trans] = imread('Right.png');
fileID = fopen('total_mem.txt','w');

A = zeros(33, 24);

B = [
        0	248	240	80	255	0	252	188	164	216	252	252	240	52	109	193	134	101	22  255;
        0	56	208	48	224	88	252	188	0	40	116	188	188	53	108	187	216	176	95  255;
        0	0	  176	0	  168	248	252	188	0	0	96	176	60	2	1	1	1	255	217 255;
  ];


tempDistR = 256;
tempDistG = 256;
tempDistB = 256;

currentDist = 450.^2;
nextDist = 450.^2;

for i = 1:24
    for j = 1:33
        if(trans)
             A(j,i) = 19;
        else
            for p = 1:19
                tempDistR = (B(1, p) - x(j,i,1)).^2;
                tempDistG = (B(2, p) - x(j,i,2)).^2;
                tempDistB = (B(3, p) - x(j,i,3)).^2;
                nextDist = tempDistR + tempDistG + tempDistB;

                if(nextDist < currentDist)
                    A(j,i) = p-1;
                    currentDist = nextDist;
                end
            end
        end
    end
end

fwrite(fileID,A);

[x, map, trans] = imread('Left.png');

A = zeros(33, 24);

currentDist = 450.^2;
nextDist = 450.^2;

for i = 1:24
    for j = 1:33
        if(trans)
             A(j,i) = 19;
        else
            for p = 1:19
                tempDistR = (B(1, p) - x(j,i,1)).^2;
                tempDistG = (B(2, p) - x(j,i,2)).^2;
                tempDistB = (B(3, p) - x(j,i,3)).^2;
                nextDist = tempDistR + tempDistG + tempDistB;

                if(nextDist < currentDist)
                    A(j,i) = p-1;
                    currentDist = nextDist;
                end
            end
        end
    end
end
fwrite(fileID,A);

[x, map, trans] = imread('Left_Up.png');

A = zeros(45, 14);

for i = 1:14
    for j = 1:45
        currentDist = 900.^2;
        nextDist = 450.^2;
        for p = 1:19
                tempDistR = (B(1, p) - x(j,i,1)).^2;
                tempDistG = (B(2, p) - x(j,i,2)).^2;
                tempDistB = (B(3, p) - x(j,i,3)).^2;
                nextDist = tempDistR + tempDistG + tempDistB;

                if(nextDist <= currentDist)
                    A(j,i) = p-1;
                    currentDist = nextDist;
                end

        end
    end
end

fwrite(fileID,A);


fclose(fileID);
%%
[x, map, trans] = imread('ken.png');
fileID = fopen('trans1.hex','w');

A = zeros(480, 272);

for i = 1:480
    for j = 1:272
        if(trans(j,i) == 0)
            A(i,j) = bitset(A(i,j), 1, 1);
        else
            A(i,j) = bitset(A(i,j), 1, 0);
        end
    end
end

fwrite(fileID,A,'ubit1');
fclose(fileID);
