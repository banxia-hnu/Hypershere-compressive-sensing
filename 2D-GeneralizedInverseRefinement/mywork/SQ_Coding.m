function [y_q, rate] = SQ_Coding(y, quantizer_bitdepth, num_rows, num_cols)


if iscell(y) % quantization for cell form of data (MS-BCS-SPL)
    y_max = max(y{1}(:));     y_min = min(y{1}(:));

    % q: stepsize
    q = (y_max - y_min)/2^quantizer_bitdepth;         
    
    yq = cell(1, length(y));     y_q = cell(1, length(y));
    
    % baseband coding
    yq{1} = round(y{1}/q);
    % y_rate is to measure entropy
    y_rate = yq{1}(:);
    y_q{1} =  yq{1}*q;
    
    % subband coding
    for i = 1:length(y)-1
        for subband = 1:3
            yq{i+1}{subband} = round(y{i+1}{subband}/q);
            y_rate = [y_rate; yq{i+1}{subband}(:)];
            y_q{i+1}{subband} = yq{i+1}{subband}*q;
        end
    end
    total_pixels = num_rows*num_cols;
    rate = Measurement_Entropy(y_rate(:),total_pixels);
    
else % quantization for vector form or matrix form of data
    y_max = max(y(:)); y_min = min(y(:));
    % q: stepsize
    q = (y_max - y_min)/2^quantizer_bitdepth;

    % simple scalar quantization
    yq = round(y/q);

    total_pixels = num_rows*num_cols;     
    rate = Measurement_Entropy(yq(:),total_pixels);
    y_q = yq*q;
    
end
