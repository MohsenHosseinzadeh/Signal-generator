clear; clc; close all;
% % % =============================================================== % % %
% % % USER PARAMETERS
% % % =============================================================== % % %
number_of_bits = 2*200000; % set number_of_bits equals to multiple of 2
upsampling_factor = 7;
init_phase = 0; % set init_phase equals to multiple of pi/2
% % % =============================================================== % % %
% % % INITIALIZATION
% % % =============================================================== % % %
bits = randi([0 1],number_of_bits,1);
% % % =============================================================== % % %
% % % MY FILE
% % % =============================================================== % % %
symbols = [];
bitstate = 0;
for i = 1:9
    [O, init_phase] = MSK_Modulation(bits((i-1)*4000+1:i*4000+1),0,0,0,upsampling_factor,init_phase);
    symbols = [symbols; O(1:end-upsampling_factor)];
    final_phase = init_phase
end
% % % =============================================================== % % %
% % % MATLAB
% % % =============================================================== % % %
init_phase = 0;
[matlab_symbols, matlab_final_phase] = mskmod(bits,upsampling_factor,'nondiff',init_phase);
% % % =============================================================== % % %
% % % COMPARE
% % % =============================================================== % % %
N = min(numel(matlab_symbols),numel(symbols));
disp(sum(abs(matlab_symbols(1:N) - symbols(1:N))));
% disp(sum(abs(matlab_final_phase - final_phase)));
figure;
plot(abs(matlab_symbols(1:N) - symbols(1:N)),'-sb','LineWidth',2,'MarkerSize',4);
set(gca,'FontSize',18);
grid on;
title('$\textrm{Difference Between the Written Function and MATLAB Function}$','Interpreter','latex');