close all;
clear all;
clc;
warning off;
% _____Load Dataset
FileNames = dir(fullfile('DB1_B', '*.tif'));
 
for k = 1:length(FileNames) 
    filename =['DB1_B\', FileNames(k).name];
    Img = imread(filename); 
%     figure;imshow(Img);
    [m, n]=size(Img);
    % _______Preprocessing
    Img_double = im2double(Img);
    Img_hist = histeq(Img_double);
    col=[];
    for i=1:32:m-32
        raw=[];
        for j=1:32:n-32
            Block = fft2( Img_hist(i:i+31,j:j+31));
            Block = Block.*(abs(Block).^0.45);
            Block = ifft2(Block);
            raw=[raw,Block];
        end
        col=[col;raw];
    end
    Img_ifft=col;
    Img_ifft=Img_ifft/max(max(Img_ifft));
%     figure;imshow(Img_ifft);    
    [m, n]=size(Img_ifft);
    col=[];
    for i=1:16:m-16
        raw=[];
        for j=1:16:n-17
            Block = imbinarize( Img_ifft(i:i+15,j:j+15));
            raw=[raw,Block];
        end
        col=[col;raw];
    end
    Img_binary=col;
    %_______Minutiae
%     figure;imshow(Img_binary);
    Img_skel=bwskel([Img_binary]==0);
    Img_thinh=bwmorph(Img_skel,'hbreak');
    Img_thins=bwmorph(Img_thinh,'spur');
%     figure;imshow(Img_thins);
    
    [m,n]=size(Img_thins);
    start_points=zeros(m,n);
    end_points=zeros(m,n);
    for i=2:m-1
        for j=2:n-1
            if Img_thins(i,j)==1
                if sum(sum(Img_thins(i-1:i+1,j-1:j+1)))-1==3
                    if Img_thins(i-1,j)==1 && Img_thins(i,j+1)==1
                    else
                    start_points(i,j)=1;
                    end
                end
                if sum(sum(Img_thins(i-1:i+1,j-1:j+1)))-1==1
                    end_points(i,j)=1;
                end
            end
        end
    end
%     [xs,ys]=find(start_points==1);
%     [xe,ye]=find(end_points==1);
%     figure;imshow(Img_thins);
%     hold on
%     plot(ys,xs,'*r');
%     plot(ye,xe,'*g');
    remove_false_minutiae;
%     [xs,ys]=find(start_points==1);
%     [xe,ye]=find(end_points==1);
%     figure;imshow(Img_thins);
%     hold on
%     plot(ys,xs,'*r');
%     plot(ye,xe,'*g');
feat_ext;
feat(:,k)=minu';

end


for i=1:length(FileNames) 
    feat(11,i)=ceil(i/8);
end
%________Classification
% DECISION TREE
[tree_mdl,tree_accu]=trainClassifier_tree(feat);
disp(['Tree Accuracy: ',num2str(tree_accu)]);
% LINEAR DISCRIMINANT ANALYSIS
[lda_mdl,lda_accu]=trainClassifier_lda(feat);
disp(['LDA Accuracy: ',num2str(lda_accu)]);
% MEDIUM GAUSSIAN SUPPORT VECTOR MACHINES
[MGSVM_mdl,MGSVM_accu]=trainClassifier_mgsvm(feat);
disp(['MGSVM Accuracy: ',num2str(MGSVM_accu)]);
% K-NEAREST NEIGHBOR
[KNN_mdl,KNN_accu]=trainClassifier_knn(feat);
disp(['KNN Accuracy: ',num2str(KNN_accu)]);
% BAGGED TREE ENSEMBLE
[Ense_mdl,Ense_accu]=trainClassifier_ensemble(feat);
disp(['Bagged Tree Ensemble Accuracy: ',num2str(Ense_accu)]);



