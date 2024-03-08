function error = allometry_error(real_wt, real_measure, guess_parameters)
    arguments (Input)
        real_wt (:, 1) double
        real_measure (:, 1) double
        guess_parameters (1, 2) double
    end
    arguments (Output)
        error (:, 1) double
    end

    out = parameter_allometry(real_wt, guess_parameters);
    
    error = real_measure - out;
end