function matchedStr = matchAndStruct(str, threshold)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
run('/home/rameshkonatala/Documents/MATLAB/vlfeat-0.9.21/toolbox/vl_setup')
i = 1;
while i<=19
    index1 = i;
    index2 = i+1;
    if(index2==20)
        index2=1;
    end
    featureVectorsImage1 = str(index1).D;
    featureVectorsImage2 = str(index2).D;
    
    [matches, scores]   = vl_ubcmatch(featureVectorsImage1, featureVectorsImage2,threshold) ;
    matchedStr(i).a = matches;
    
    i=i+1
end
save('matchedStruct.mat', 'matchedStr')
end
