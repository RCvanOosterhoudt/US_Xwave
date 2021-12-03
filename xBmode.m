%% Processing step 1: Visualize RF with imagesc
%Take 1st and 32nd transmission 
RF1 = RF(:,:,1);
RF32 = RF(:,:,32);
%View 1st and 32nd transmission
figure()
imagesc(RF1)
xlim ([0 65])
ylim ([0 100])
xticks([3, 13, 23, 33, 43, 53, 63])
xticklabels({'-30','-20','-10','0','10','20','30'})
xlabel('lateral distance [mm]')
ylabel('depth [mm]')
title('Echoes corresponding to the 1st transmission')

figure()
imagesc(RF32)
xlim ([0 65])
ylim ([0 100])
xticks([3, 13, 23, 33, 43, 53, 63])
xticklabels({'-30','-20','-10','0','10','20','30'})
xlabel('lateral distance [mm]')
ylabel('depth [mm]')
title('Echoes corresponding to the 32nd transmission')

%% Processing step 2: Calculate minimum and maximum depth of the xBmode image.
%maximum depth of field (in m)
Zmax = nAp*p/2*cot(xAngle*pi/180);
%minimum depth of field (in m)
Zmin = nAp*p/2*tan(xAngle*pi/180);

%% Processing step 3: Create a vector with the positions in depth of the sample points.
%Depth of samples in virtual axis z
c = 1:1536;
z = c*(c_us/Fs)/2; %wavelength c_us/Fs
z = z';
%Finding z_echo for all sampled times tau_xn and xn
xn = 0:64;
xn = xn';
x1 = 0;
xb = 0.5*max(xn);
[Xn,Z] = meshgrid(xn,z);

delta = 1/c_us*(sqrt((Xn-xb).^2*p^2+Z.^2)-Z); %delta = tau_xn-tau_xb
tau_xn = c/Fs; %klopt dit? vgm wel
tau_xn = tau_xn';
z_echo = (c_us*(tau_xn-delta)-(xb-x1)*p*sin(xAngle*pi/180))/(cos(xAngle*pi/180)+1);

%% Processing step 4: Write a function that can reconstruct one image line by applying delay-and-sum method
%Creating a single vector for depth
z_echox = z_echo;
for d = 2:65 
 z_echo_cat = cat(1,z_echox(:,1), z_echo(:,d));
 z_echox = z_echo_cat; 
end
%Creating a single vector for intensity for RF1
RF1x = RF1;
for d = 2:65
 RF1_cat = cat(1,RF1x(:,1),RF1(:,d));
 RF1x = RF1_cat;
end
%Creating 1 line image
[z_echo_cat_sorted, I] = sort(z_echo_cat);
RF1_cat_sorted = RF1_cat(I);
figure()
plot(z_echo_cat_sorted, RF1_cat_sorted)

