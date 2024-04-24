classdef Model

    properties
        params struct
        ics (1, :) {mustBeNumeric}
    end

    methods
        function obj = Model(p, y0)
            arguments
                p struct %parameters of model
                y0 (1, 7) {mustBeNumeric, mustBeReal} %initial conditions
            end
            obj.params = p;
            obj.ics = y0;
        end

        function [t, solution, balance] = get_solution(obj, time, rate_adjust)
            arguments
                obj Model
                time (1, :) {mustBeNumeric} %time range
                rate_adjust logical = 1 % boolean for rate adjusted ode
            end
            options = odeset( ...
                'MaxStep', 5e-2, ...
                'AbsTol', 1e-5, ...
                'RelTol', 1e-5, ...
                'InitialStep', 1e-2 ...
            );
            % Change system based on rate adjustment
            [t, solution] = ode45(...
                @obj.heparinODE, ...
                time, ...
                obj.ics, ...
                options, ...
                obj.params, ...
                rate_adjust...
            );
            volumes = [
                obj.params.vbp, ...
                obj.params.vbp, ...
                obj.params.vt1, ...
                obj.params.vt2, ...
                obj.params.vb, ...
                1
            ];
            balance = obj.ics(1) * obj.params.vbp - solution(:, 1:6)*volumes';
        end

        function [time, solution, balance] = repeated_bolus(obj, D0, tmax, freq, step, rate_adjust)
            arguments
                obj Model
                D0 double % Bolus in nmol
                tmax double % length of sim (hrs)
                freq double % frequency of dose (hrs)
                step double % resolution
                rate_adjust logical = 1 % boolean for rate adjusted ode
            end
            time = [];
            solution = [];
            balance = [];
            y0 = obj.ics;
            p = obj.params;
            volumes = [p.vbp, p.vbp, p.vt1, p.vt2, p.vb, 1];
            for i = 1:tmax/freq
                options = odeset( ...
                    'MaxStep', 5e-2, ...
                    'AbsTol', 1e-5, ...
                    'RelTol', 1e-5, ...
                    'InitialStep', 1e-2 ...
                );
                [t, y] = ode45( ...
                    @obj.heparinODE, ...
                    (i-1)*freq:step:i*freq, ...
                    y0, ...
                    options, ...
                    obj.params, ...
                    rate_adjust ...
                );
                b = i*D0*p.vbp - y(:, 1:6)*volumes';
                time = [time; t];
                solution = [solution; y];
                balance = [balance; b];
                
                y0 = y(end, :);
                y0(1) = y0(1) + D0;
            end
        end
    end
    
    methods (Access = private)
        function dydt = heparinODE(obj, time, y, parameters, rate_adjust)
            arguments
                obj Model
                time (1, :) {mustBeNumeric}
                y (1, 7) {mustBeNumeric} 
                parameters struct
                rate_adjust logical
            end
            dydt = heparinODE(time, y, parameters, rate_adjust);

        end
    end
end