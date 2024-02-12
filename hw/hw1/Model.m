classdef Model

    properties
        params struct
        ics (1, :) {mustBeNumeric}
    end

    methods
        function obj = Model(p, y0)
            arguments
                p struct
                y0 (1, 7) {mustBeNumeric, mustBeReal}
            end
            obj.params = p;
            obj.ics = y0;
        end

        function [t, solution, balance] = get_solution(obj, time, rate_adjust)
            arguments
                obj Model
                time (1, :) {mustBeNumeric}
                rate_adjust logical = 1
            end
            options = odeset( ...
                'MaxStep', 5e-2, ...
                'AbsTol', 1e-5, ...
                'RelTol', 1e-5, ...
                'InitialStep', 1e-2 ...
            );
            % Change system based on volume correction
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
            % do not include column 7 which is protein conc.
            % drug_mass = zeros(size(solution, 1), 6);
            % for i = 1:(size(solution, 2) - 1)
            %     drug_mass(:, i) = solution(:, i) * volumes(i);
            % end
            balance = obj.ics(1) * obj.params.vbp - solution(:, 1:6)*volumes'; %sum(drug_mass, 2);
        end

        function [time, solution, balance] = repeated_bolus(obj, D0, tmax, freq, step, rate_adjust)
            arguments
                obj Model
                D0 double 
                tmax (1, :) {mustBeNumeric, mustBeReal}
                freq double
                step double
                rate_adjust logical = 1
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
                [t, y] = ode45(@obj.heparinODE, (i-1)*freq:step:i*freq, y0, options, obj.params, rate_adjust);
                b = obj.ics(1)*obj.params.vbp - y(:, 1:6)*volumes';
                time = [time; t];
                solution = [solution; y];
                balance = [balance; b];
                
                y0 = y(end, :);
                y0(1) = y0(1) + D0;
            end
        end
    end
    
    methods (Access = private)
        function dydt = heparinODE(obj, t, y, p, ra)
            arguments
                obj Model
                t (1, :) {mustBeNumeric}
                y (1, 7) {mustBeNumeric}
                p struct
                ra logical
            end
            % y1 = D_BP : blood plasma drug
            % y2 = DP : drug-protein complex
            % y3 = D_T1 : drug in tumor 1
            % y4 = D_T2 : drug in tumor 2
            % y5 = D_b : drug in body
            % y6 = D_c : drug cleared
            % y7 = P : protein
        
            % kon : rate constant of plasma protein binding
            % koff : rate constant of plasma protein unbinding
            % kt1 & kt1r : rate constant of tumor 1 and reverse direction
            % kt2 & kt2r : rate constant of tumor 2 and reverse direction
            % kb & kbr : rate constant of body and reverse
            % kc : rate constant of clearance
            dydt = heparinODE(t, y, p, ra);

        end
    end
end