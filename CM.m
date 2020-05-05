clear; clc;
load('cameraParams.mat');
img_front = imread('front.JPG');
img_back = imread('back.jpg');
img_left = imread('left.jpg');
img_right = imread('right.jpg');
%img_car = imread('car.bmp');
img_car = zeros(500,500,3);

J_Front = undistortFisheyeImage(img_front, cameraParams.Intrinsics,'ScaleFactor',0.38); % Front,Back = 0.3
J_Back =  undistortFisheyeImage(img_back, cameraParams.Intrinsics,'ScaleFactor',0.38); % Front,Back = 0.3
J_Left = undistortFisheyeImage(img_left, cameraParams.Intrinsics,'ScaleFactor',0.38);% Left = 0.45 / right = 0.53
J_Right = undistortFisheyeImage(img_right, cameraParams.Intrinsics,'ScaleFactor',0.21); % 0.21

%figure(4); imshow(J_Front)
%figure(2); imshow(J_Right)

A_F = [268 255; 377 257; 417 284; 230 280];
B_F = [160 160; 340 160; 340 220; 160 220]; % Front

A_B = [260 245; 387 245; 430 297; 222 296];
B_B = [160 180; 340 180; 340 240; 160 240]; % Back

% A_L = [136 214; 514 189; 635 289; 43 311];
% B_L = [30 70; 450 70; 450 160; 30 160 ]; % Left

% A_L = [107 214; 517 191; 635 289; 4 311];
% B_L = [30 70; 450 70; 450 160; 30 160 ]; % Left 더 정확

A_L = [103 220; 481 198; 581 281; 3 299];
B_L = [0 50; 480 50; 480 160; 0 160 ]; % 480일 때 뒤쪽 한칸이 포함되어버림 정확한 사진은 510으로 16칸 딱 나옴 

% A_L = [103 220; 481 198; 581 281; 3 299];
% B_L = [0 0; 510 0; 510 160; 0 160 ];% 16개 프린트 첫장 처럼

% A_R = [79 215; 521 191; 635 290; 6 310];
% B_R = [62.5 468.75; 62.5 0; 156.25 0;156.25 468.75]; %박남석

% A_R = [105 176; 542 237; 587 282; 1 253]; % 16
% B_R = [0 70; 480 70; 480 130; 0 130]; % 16개 %Right 3칸
%B = [0 70; 480 70; 480 160; 0 160]; % 16개 %Right 2칸 위 아래 축소
 
A_R = [181 206; 401 239; 429 268; 6 279]; % 16
B_R = [0 50; 480 50; 480 160; 0 160]; % 16개 %Right 3칸 정확하게 맞춘것정확하게 맞춘것


Tf_F = fitgeotrans(A_F, B_F, 'projective');
Tf_B = fitgeotrans(A_B, B_B, 'projective');
Tf_L = fitgeotrans(A_L, B_L, 'projective');
Tf_R = fitgeotrans(A_R, B_R, 'projective');

%I_ref = imref2d([250 500]); %전후
%I_ref = imref2d([160 510]); % right
% I_ref = imref2d([500 160]); % 박남석

I_ref_FB = imref2d([250 500]);
I_ref_LR = imref2d([160 480]); % 510

I_F = imwarp(J_Front, Tf_F, 'OutputView', I_ref_FB);
I_B = imwarp(J_Back, Tf_B, 'OutputView', I_ref_FB);
I_L = imwarp(J_Left, Tf_L, 'OutputView', I_ref_LR);
I_R = imwarp(J_Right, Tf_R, 'OutputView', I_ref_LR);

I_L = rot90(I_L);
I_R = rot90(I_R,-1);
I_B = rot90(I_B,-2);

 figure(1); imshow(I_F);
% figure(2); imshow(I_B);
% figure(3); imshow(I_L);
% figure(4); imshow(I_R);


% C = imresize(img_car,[500,180]);
% SI = [If; Il,C,Ir;Ib];
% SIr = imresize(SI,0.7);
% imshow(SIr);

I_C = imresize(img_car, [480 180]);
View360 = [I_F;I_L I_C I_R;I_B];
View360_resz = imresize(View360, 0.7);
figure(1); imshow(View360_resz);