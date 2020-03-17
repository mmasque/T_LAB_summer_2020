function [decimal] = convert_binary_to_decimal(bin_mat_3d_as_dec)
    %%%Converts a binary input array to a decimal%%%
    arr_dim = size(bin_mat_3d_as_dec);
    decimal = zeros(arr_dim);
    for i = 1:arr_dim(1)
        for j = 1:arr_dim(2)
            decimal(i,j) = bin2dec(num2str(bin_mat_3d_as_dec(i,j)));
        end
    end
end