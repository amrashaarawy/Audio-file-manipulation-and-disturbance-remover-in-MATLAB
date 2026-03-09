%% 
load audioNew.mat;
listening_time = 26;

Fs1 = Fs / 25;      % downsampled rate
T  = 1 / Fs;        % original sampling step
T1 = 1 / Fs1;       

N = length(x_new);              
t = (0:N-1) * T;                
f = (-N/2 : N/2 - 1) * (Fs / N); 

%% original audio x_new
player = audioplayer(x_new, Fs);
play(player);
pause(listening_time);
stop(player);

X_new = fft(x_new);
X_new_shifted = fftshift(T * X_new);

%% downsample without filtering - aliasing present
xsampled = downsample(x_new, 25);
N_ds = length(xsampled);
f_ds = (-N_ds/2 : N_ds/2 - 1) * (Fs1 / N_ds);

player = audioplayer(xsampled, Fs1);
play(player);
pause(listening_time);
stop(player);

Xsampled = fft(xsampled);
Xsampled_shifted = fftshift(T1 * Xsampled);

%% filter signal x_new 
fstop = (Fs / 50)*0.8;
h = LPF_design(fstop, Fs);
x_filt = filter(h, x_new);

X_filt = fft(x_filt);
X_filt_shifted = fftshift(T * X_filt);

%% downsample x_filt
xsampled_new = downsample(x_filt, 25);
Xsampled_new = fft(xsampled_new);
Xsampled_new_shifted = fftshift(T1 * Xsampled_new);

player = audioplayer(xsampled_new, Fs1);
play(player);
pause(listening_time);
stop(player);

%% plot1: x_new vs x_filt 
figure;
plot(f, abs(X_new_shifted), 'b'); hold on;
plot(f, abs(X_filt_shifted), 'r');
xlabel('Frequency (Hz)');
ylabel('|X(f)|');
legend('Original', 'Filtered');
title('Comparison: FFT of Xnew (original) vs Xfilt (filtered) Signals');
grid on;

%% plot2: xsampled vs xsampled_new 
figure;
plot(f_ds, abs(Xsampled_shifted), 'r'); hold on;
plot(f_ds, abs(Xsampled_new_shifted), 'b');
xlabel('Frequency (Hz)');
ylabel('|X(f)|');
legend('Xsampled (no filter)', 'Xsamplednew (filtered)');
title('FFT of Xsampled(w/o filter) vs Xsamplednew');
grid on;

%% filter function
function LPF = LPF_design(f_stop, Fs)
    f_pass = f_stop - 100;
    deltap = 0.01;
    deltas = 0.001;
    Ap = 20 * log10(1 + deltap) - 20 * log10(1 - deltap);
    Ast = -20 * log10(deltas);
    SPEC = 'Fp,Fst,Ap,Ast';
    LP_spec = fdesign.lowpass(SPEC, f_pass, f_stop, Ap, Ast, Fs);
    LPF = design(LP_spec, 'equiripple');
    fvtool(LPF);
end
