folder = 'C:\Users\Ketan\Desktop\Deep Learning\Project1_Ketan';
genpath(folder);
projections=[0 1 2 3 4 5 6 7 8 9 10 11 60 61 62 63 64 65 66 67 68 69 70 71];
accuracy=zeros(4, 4);

for ll=[5, 10, 15, 20]
traindata=datasample(projections, ll, 'Replace', false);
testdata=setdiff(projections',traindata','rows')';
object_numbers=[3 4 5 6 9 10 12 13 14 19];

no=numel(testdata);
ntotal=numel(object_numbers)*no;
object=[0 1 2 3 4 5 6 7 8 9 10 11 60 61 62 63 64 65 66 67 68 69 70 71];
test_image=[3 8 9 70];
step=0;
feature=[];
feature_training=[];
Length_Pair=NaN;
for Feature_number=[2,4,8,16]
        index_i=1;

for i=object_numbers
    
for k = traindata
         filename1 = ['coil-20-proc\obj' num2str(i) '__' num2str(k), '.png'];

         I1 = imread(filename1);
         points1= detectSURFFeatures(I1);
         strongest1= points1.selectStrongest(Feature_number);
         [features1 , valid_points1] = extractFeatures(I1, strongest1);
         feature=[ feature; features1];
end

    index_j=1;
for l=object_numbers
for j=testdata
    filename2 = ['coil-20-proc\obj' num2str(l) '__' num2str(j), '.png'];

    I2 = (imread(filename2));
    points2= detectSURFFeatures(I2);
    strongest2= points2.selectStrongest(Feature_number);
    [features2 , valid_points1] = extractFeatures(I2, strongest2);
    [Pairs, ~] = matchFeatures(feature, features2, 'Unique', true);
    Length_Pair(step+index_i, index_j)=length(Pairs(:, 2));
    index_j=index_j+1;
    step+index_i;
end
end

index_i=index_i+1;
feature=[];
end
step=step+10;
end
%% seperating four matrix

LP1=zeros(numel(object_numbers), ntotal);
LP2=zeros(numel(object_numbers), ntotal);
LP3=zeros(numel(object_numbers), ntotal);
LP4=zeros(numel(object_numbers), ntotal);

LP1=Length_Pair(1:10, :);
LP2=Length_Pair(11:20, :);
LP3=Length_Pair(21:30, :);
LP4=Length_Pair(31:40, :);
%% checking max match

match_maximum=NaN(ntotal, 4);
for i=1:ntotal
    [Maximum_1, I1]=max(LP1(:, i));
    [Maximum_2, I2]=max(LP2(:, i));
    [Maximum_3, I3]=max(LP3(:, i));
    [Maximum_4, I4]=max(LP4(:, i));

    if Maximum_1==0
        match_maximum(i, 1)=0;
    else
        match_maximum(i, 1)=I1;
    end
    if Maximum_2==0
        match_maximum(i, 2)=0;
    else
        match_maximum(i, 2)=I2;
    end
    if Maximum_3==0
        match_maximum(i, 3)=0;
    else
        match_maximum(i, 3)=I3;
    end
    if Maximum_4==0
        match_maximum(i, 4)=0;
    else
        match_maximum(i, 4)=I4;
    end
end

%% original Matrix
original_matrix=zeros(ntotal, 5);
step=0;
for i=1:numel(object_numbers)
        original_matrix(1+step:no+step, 1)=step/no+1;

        step=step+no;
end

%% Comparison
original_matrix(:, 2)=xor(original_matrix(:, 1), match_maximum(:,1));
original_matrix(:, 3)=xor(original_matrix(:, 1), match_maximum(:,2));
original_matrix(:, 4)=xor(original_matrix(:, 1), match_maximum(:,3));
original_matrix(:, 5)=xor(original_matrix(:, 1), match_maximum(:,4));

%% Accuracy

accuracy(ll/5, 1)=(1-(sum(original_matrix(:, 2))/ntotal)).*100;
accuracy(ll/5, 2)=(1-(sum(original_matrix(:, 3))/ntotal)).*100;
accuracy(ll/5, 3)=(1-(sum(original_matrix(:, 4))/ntotal)).*100;
accuracy(ll/5, 4)=(1-(sum(original_matrix(:, 5))/ntotal)).*100;

end
accuracy(ll/5+1, 1:4)=[2 4 8 16];
accuracy(1:4,ll/5+1 )=[5 10 15 20];

%% Plotting
figure;
plot(accuracy(1:4, 5), accuracy(1:4, 1), 'rs-');
hold on
plot(accuracy(1:4, 5), accuracy(1:4, 2), 'g^-');
hold on
plot(accuracy(1:4, 5), accuracy(1:4, 3), 'b*-');
hold on
plot(accuracy(1:4, 5), accuracy(1:4, 4), 'ko-');
title('Accuracy for different Training Image with Different Feature Size')
legend('Feature # 2', 'Feature # 4', 'Feature # 8', 'Feature # 16');
xlim([5 20] ); ylim([65 105]);
xlabel('Number of Training Images');
ylabel('Accuracy Percentage(%)');
