load('cameraParams.mat');
img_front = imread('front.jpg');
figure();
imshow(img_front);
J1 = undistortFisheyeImage(img_front,cameraParams.Intrinsics);
figure
imshow(J1)
J2 = undistortFisheyeImage(img_front,cameraParams.Intrinsics,'ScaleFactor',0.35);
figure
imshow(J2)