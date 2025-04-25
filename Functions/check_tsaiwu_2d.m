function [failure, tsai_wu_criteria] = check_tsaiwu_2d(sigma, F)
% Inputs
%   sigma - 3xn matrix where the ith column is [sigma_1; sigma_2; tau_6]
%           for the ith lamina to be checked
%   F     - [F_1t; F_1c; F_2t; F_2c; F_6]
%
% Outputs
%   failure             - nx1 vector containing boolean values. true if
%                         critera >= 1, false otherwise.
%   tsai_wu_criteria    - tsai-wu numerical value, used to compute failure
%                         boolean

    % Check inputs
    sz = size(sigma);
    if sz(1) ~= 3
        error("Incorrect number of rows in input sigma matrix")
    end

    F = F(:);
    if length(F) ~= 5
        error("Incorrect number of failure strengths input")
    end

    % compute number of laminas
    n = sz(2);

    % compute coefficients
    f_1 = (1/F(1)) - (1/F(2));
    f_11 = 1/(F(1) * F(2));
    f_2 = (1/F(3)) - (1/F(4));
    f_22 = 1/(F(3) * F(4));
    f_12 = -0.5 * sqrt(f_11 * f_22);
    f_66 = 1/(F(5)^2);

    % Preallocate
    tsai_wu_criteria = NaN(n,1);

    % Loop through laminas and compute the criteria value
    for i = 1:n
        tsai_wu_criteria(i) = f_1 * sigma(1,i) + f_2 * sigma(2,i) + f_11 * sigma(1,i)^2 + f_22 * sigma(2,i)^2 + 2 * f_12 * sigma(1,i) * sigma(2,i) + f_66 * sigma(3,i)^2;
    end

    % compare values for failure
    failure = tsai_wu_criteria >= 1;

end
