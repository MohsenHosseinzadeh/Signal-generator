function coded_bits = Differential_Encoder(bits, init_bit)
    len = length(bits);
    coded_bits(1,1) = bitxor(bits(1,1),init_bit);
    for q = 2:len
        coded_bits(q,1) = bitxor(coded_bits(q-1,1),bits(q,1));
    end
end