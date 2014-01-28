% +-----------------------------------
% | PGM - HW1 
% | Question 4 - Image Denoising
% | Daniel Ribeiro Silva (drsilva)
% +-----------------------------------

load('hw1_images.mat');
%imshow(origImg), figure, imshow(noisyImg);

%RBM constants
h = -1;
beta = 15;
v = 20;

%-2,15,20 -> 0.023943

%Node Layers
gridSize = size(noisyImg);
gridX = noisyImg;
oldGridZ = noisyImg;
newGridZ = noisyImg;
diff = 1000000000;
lastdiff=0;

%while doesn't converge
while diff > 1
    
    %for each node Z
    oldGridZ = newGridZ;
    %newGridZ = zeros(gridSize);
    for i = 1:gridSize(1)
        for j = 1:gridSize(2)
            currentX = gridX(i,j);
            currentZ = oldGridZ(i,j);
            alternativeZ = -currentZ;

            currentEnergyContribution = h*currentZ - v*currentZ*currentX;
            alternativeEnergyContribution = h*alternativeZ - v*alternativeZ*currentX;
            
            %contribution from left neighbor
            if(j>1)
                leftZ = oldGridZ(i,j-1);
                currentEnergyContribution = currentEnergyContribution - beta*leftZ*currentZ;
                alternativeEnergyContribution = alternativeEnergyContribution - beta*leftZ*alternativeZ;
            end
            %contribution from right neighbor
            if(j<gridSize(2))
                rightZ = oldGridZ(i,j+1);
                currentEnergyContribution = currentEnergyContribution - beta*rightZ*currentZ;
                alternativeEnergyContribution = alternativeEnergyContribution - beta*rightZ*alternativeZ;
            end
            %contribution from top neighbor
            if(1>1)
                topZ = oldGridZ(i-1,j);
                currentEnergyContribution = currentEnergyContribution - beta*topZ*currentZ;
                alternativeEnergyContribution = alternativeEnergyContribution - beta*topZ*alternativeZ;
            end
            %contribution from bottom neighbor
            if(i<gridSize(1))
                bottomZ = oldGridZ(i+1,j);
                currentEnergyContribution = currentEnergyContribution - beta*bottomZ*currentZ;
                alternativeEnergyContribution = alternativeEnergyContribution - beta*bottomZ*alternativeZ;
            end
            
            if alternativeEnergyContribution < currentEnergyContribution
                newGridZ(i,j) = alternativeZ;
            else
                newGridZ(i,j) = currentZ;
            end
        
        end 
    end
    
    diff = sum(sum(oldGridZ~=newGridZ));
    disp(diff);
    
    if(lastdiff==diff)
        break;
    end
    
    lastdiff=diff;
    
end

denoisedImg = newGridZ;
figure, imshow(noisyImg), title('Noisy Imgage');
figure, imshow(denoisedImg), title('Denoised Imgage');
figure, imshow(abs(origImg-denoisedImg)), title('Difference from Origin');

%compute stats
initialNoiseFrac = sum(sum(origImg~=noisyImg)) / (size(origImg,1)*size(origImg,2));
finalNoiseFrac = sum(sum(origImg~=denoisedImg)) / (size(origImg,1)*size(origImg,2));
fprintf('\ninitial noise rate: %f\n', initialNoiseFrac);
fprintf('final noise rate: %f\n',finalNoiseFrac);

%denoisedImg(200:220,300:320)
%noisyImg(200:220,300:320)


