function y = AWGN_Channel(s,SNR,IgnoreNoSignalTimes,UnitPower)

%% Add noise
if IgnoreNoSignalTimes
    Ps = mean(abs(s(s~=0)).^2); % Signal power
else
    Ps = mean(abs(s).^2); % Signal power
end
Pn = Ps/(10.^(SNR/10)); % Noise power

if isreal(s)
    y = s+sqrt(Pn)*randn(size(s)); % Add noise
else
    y = complex(s+sqrt(Pn/2)*(randn(size(s))+1i*randn(size(s)))); % Add noise
end

%% Normailze Signals
if UnitPower
    Py = mean(abs(y).^2);
    y = y/sqrt(Py); % Normalize output signal
    s = s/sqrt(Ps); % Normalize output signal
end