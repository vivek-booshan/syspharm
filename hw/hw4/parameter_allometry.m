function out = parameter_allometry(weight, parameters)
    arguments (Input)
        weight (:, 1) double
        parameters (1, 2) double
    end
    arguments (Output)
        out (:, 1) double
        % V (:, 1) double % volume (L)
        % cl (:, 1) double % clearance (L/hr)
        % ka (:, 1) double % absorption (L/hr)
    end
    
    coeff = parameters(1);
    exponent = parameters(2);

    out = coeff .* (weight ./ 45) .^ exponent;

end