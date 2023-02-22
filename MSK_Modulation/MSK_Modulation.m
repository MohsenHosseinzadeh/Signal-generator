function [signal, final_phase] = MSK_Modulation(bits, differential,~,~, upsampling_factor, init_phase)
    if(differential)
        bits = Differential_Encoder(bits,0);
    end    
    %
    symbols_temp_1 = repelem(2*bits(1:2:end) - 1, 2*upsampling_factor);
    symbols_temp_1(1:upsampling_factor) = [];
    symbols_temp_2 = repelem(2*bits(2:2:end  ) - 1, 2*upsampling_factor);
    symbols_temp_2 = [symbols_temp_2;zeros(1,upsampling_factor)'];
    if(isrow(symbols_temp_1))
        symbols_temp_1 = symbols_temp_1.';
    end
    if(isrow(symbols_temp_2))
        symbols_temp_2 = symbols_temp_2.';
    end
        
    arg = (pi*(0:length(symbols_temp_1)-1)/(2*upsampling_factor)).';
    signal = (symbols_temp_1.*cos(arg+pi) + 1i*symbols_temp_2.*sin(arg)).*exp(1i.*init_phase);
    %
    init_phase = pi*(length(symbols_temp_1)-upsampling_factor)/(2*upsampling_factor);
    final_phase = mod(init_phase, 2*pi);    
%     phase_val = [0 pi/2 pi 3*pi/2 2*pi]';
%     [~, indx] = min(abs(phase_val - phase_temp));       
%     final_phase = mod(phase_val(indx),2*pi);    
end