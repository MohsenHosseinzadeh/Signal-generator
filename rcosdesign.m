function h = rcosdesign(beta, span, sps, shape)

% Check if sps*span is even
if mod(sps*span, 2) == 1
    error('span*sps should be even');
end

% Design the raised cosine filter
delay = span*sps/2;
t = (-delay:delay)/sps;

if strncmp(shape, 'normal', 1)
    % Design a normal raised cosine filter
    
    % Find non-zero denominator indices
    denom = (1-(2*beta*t).^2);
    idx1 = find(abs(denom) > sqrt(eps));
    
    % Calculate filter response for non-zero denominator indices
    h(idx1) = sinc(t(idx1)).*(cos(pi*beta*t(idx1))./denom(idx1))/sps;
    
    % fill in the zeros denominator indices
    idx2 = 1:length(t);
    idx2(idx1) = [];
    
    h(idx2) = beta * sin(pi/(2*beta)) / (2*sps);
    
else
    % Design a square root raised cosine filter
    
    % Find mid-point
    idx1 = find(t == 0);
    if ~isempty(idx1),
        h(idx1) = -1 ./ (pi.*sps) .* (pi.*(beta-1) - 4.*beta );
    end
    
    % Find non-zero denominator indices
    idx2 = find(abs(abs(4.*beta.*t) - 1.0) < sqrt(eps));
    if ~isempty(idx2),
        h(idx2) = 1 ./ (2.*pi.*sps) ...
            * (    pi.*(beta+1)  .* sin(pi.*(beta+1)./(4.*beta)) ...
            - 4.*beta     .* sin(pi.*(beta-1)./(4.*beta)) ...
            + pi.*(beta-1)  .* cos(pi.*(beta-1)./(4.*beta)) ...
            );
    end
    
    % fill in the zeros denominator indices
    ind = 1:length(t);
    ind([idx1 idx2]) = [];
    nind = t(ind);
    
    h(ind) = -4.*beta./sps .* ( cos((1+beta).*pi.*nind) + ...
        sin((1-beta).*pi.*nind) ./ (4.*beta.*nind) ) ...
        ./ (pi .* ((4.*beta.*nind).^2 - 1));
    
end

% Normalize filter energy
h = h / sqrt(sum(h.^2));
