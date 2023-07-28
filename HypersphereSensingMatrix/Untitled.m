clc;
clear;
close all;

tic;
t=0;
SM = SensingMatrix(256, 512, 11, 13);
times = toc;
times/512