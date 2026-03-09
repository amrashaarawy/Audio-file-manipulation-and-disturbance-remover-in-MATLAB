%%
load audio1.mat;
listening_time = 26;
player = audioplayer(x, Fs);
play(player);
pause(listening_time);
stop(player);

%% original signal x
T = 1/Fs; %sampling step
t = 0: T: listening_time;
X = fft(x);
N = length(x);
f = Fs * (0:N-1) / N;

figure;
plot(f, abs(X));
xlabel('Frequency (Hz)');
ylabel('|X(f)|');
title('Magnitude of Fourier Transform of signal x');
grid on;

%% flter function
 function NF = NF_design( f0 , Fs )
    N = 6; % filter order
    Q = 30; % quality factor of the filter
    % Tolerances in passband ( deltap ) and stopband ( deltas )
    deltap = 0.01;
    deltas = 0.001;

    % Tolerances expressed in dB: [A]_dB = 20* log10 (A)
    Ap = 20*log10(1 + deltap) - 20*log10(1 - deltap); % (approx)
    Ast = -20*log10(deltas);

   % Filter specification
    SPEC = 'N,F0,Q,Ap,Ast';
    NF_spec = fdesign.notch ( SPEC , N , f0 , Q , Ap , Ast , Fs );
    NF = design( NF_spec );
    fvtool (NF);
end


%% filters design
f1 = 200;
f2 = 10000;

h1 = NF_design(f1, Fs);
h2 = NF_design(f2, Fs);

x_filt = filter(h1, x);
x_filt1 = filter(h2, x_filt);

%% final signal
listening_time = 26;
player = audioplayer(x_filt1, Fs);
play(player);
pause(listening_time);
stop(player);

%% plot x vs x_filt
X_filt = fft(x_filt1);
f = Fs * (0:N-1) / N;

figure;
plot(f, abs(X), 'b'); hold on;
plot(f, abs(X_filt), 'r');
xlabel('Frequency (Hz)');
ylabel('Magnitude |X(f)|');
legend('Original', 'Filtered');
title('Comparison: Original vs Filtered Fourier Transform');
grid on;

