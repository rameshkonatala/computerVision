im1 = (imread('synth1.pgm'));
im2 = (imread('synth2.pgm'));
[x,y,u,v] = optical_flow(im1,im2)