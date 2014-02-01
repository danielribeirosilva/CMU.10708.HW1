% +-----------------------------------
% | PGM - HW1 
% | Question 4 - Image Denoising V2 (dynamic update of Z)
% | Daniel Ribeiro Silva (drsilva)
% +-----------------------------------

load('hw1_images.mat');
%imshow(origImg), figure, imshow(noisyImg);

%RBM constants
h = -1;
beta = 8;
v = 6;

%1,6,4 -> 0.003975

lowestError = 1;

for h=-5:5
    for beta=0:10
        for v=0:10

            %Node Layers
            gridSize = size(noisyImg);
            gridX = noisyImg;
            gridZ = noisyImg;
            totalChanges = 1;

            %while doesn't converge
            while totalChanges > 0
                totalChanges = 0;
                %for each node Z
                for i = 1:gridSize(1)
                    for j = 1:gridSize(2)
                        currentX = gridX(i,j);
                        currentZ = gridZ(i,j);

                        currentEnergyContribution = h*currentZ - v*currentZ*currentX;

                        %contribution from left neighbor
                        if(j>1)
                            leftZ = gridZ(i,j-1);
                            currentEnergyContribution = currentEnergyContribution - beta*leftZ*currentZ;
                        end
                        %contribution from right neighbor
                        if(j<gridSize(2))
                            rightZ = gridZ(i,j+1);
                            currentEnergyContribution = currentEnergyContribution - beta*rightZ*currentZ;
                        end
                        %contribution from top neighbor
                        if(i>1)
                            topZ = gridZ(i-1,j);
                            currentEnergyContribution = currentEnergyContribution - beta*topZ*currentZ;
                        end
                        %contribution from bottom neighbor
                        if(i<gridSize(1))
                            bottomZ = gridZ(i+1,j);
                            currentEnergyContribution = currentEnergyContribution - beta*bottomZ*currentZ;
                        end

                        if currentEnergyContribution > 0
                            gridZ(i,j) = - currentZ;
                            totalChanges = totalChanges + 1;
                        end

                    end 
                end

                %fprintf('total changes: %f\n',totalChanges);

            end

            denoisedImg = gridZ;
            %figure, imshow(noisyImg), title('Noisy Imgage');
            %figure, imshow(denoisedImg), title('Denoised Imgage');
            %figure, imshow(abs(origImg-denoisedImg)), title('Difference from Origin');

            %compute stats
            initialNoiseFrac = sum(sum(origImg~=noisyImg)) / (size(origImg,1)*size(origImg,2));
            finalNoiseFrac = sum(sum(origImg~=denoisedImg)) / (size(origImg,1)*size(origImg,2));
            fprintf('\n h: %f, beta: %f, v=%f', h,beta,v);
            %fprintf('\ninitial noise rate: %f\n', initialNoiseFrac);
            fprintf('\nfinal noise rate: %f',finalNoiseFrac);

            if lowestError>finalNoiseFrac
                best.h=h;
                best.beta = beta;
                best.v = v;
                lowestError = finalNoiseFrac;
            end
            
            %denoisedImg(200:220,300:320)
            %noisyImg(200:220,300:320)
        end
    end
end


