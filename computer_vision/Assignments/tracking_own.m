fileID = fopen('model house/measurement_matrix.txt','r');
fileID = fopen('model house/measurement_matrix.txt','r');
formatSpec = '%f';
A = fscanf(fileID,formatSpec);
A_new = zeros(size(A));
A = reshape(A,[215,202]);
A_new = reshape(A_new,[215,202]);
im1 = (imread('/home/rameshkonatala/Documents/masters/computer_vision/Assignments/model house/frame00000001.jpg'));

files = dir('model house/*.jpg');
count = 1;
A_new(:,1:2) = A(:,1:2);
newCoordinates = A(:,1:2);

while count<size(files,1)-1
    im1 = (imread((strcat('model house/',files(count).name))));
    im2 = (imread((strcat('model house/',files(count+1).name))));
    newCoordinates = tracking(im1,im2,newCoordinates);
    A_new(:,count:count+1) = newCoordinates;
    count = count +1;
end

distances = A-A_new;
distances = distances.^2;
eu_distances = zeros(size(distances,1),size(distances,2)/2);
i=1;
while i < size(files,1)*2
   eu_distances(:,ceil(i/2)) = sqrt(distances(:,i)+distances(:,i+1));
   i=i+2;
end
eu_distances = sum(eu_distances,1);
plot(eu_distances)