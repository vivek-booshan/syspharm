classdef Model

    properties
        params
        ics
    end

    methods
        function obj = Model(p, y0)
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

        function [t, solution, balance] = repeated_bolus(obj, tmax, freq, step)
            t = zeros(freq / step + 1, tmax/freq);
            solution = zeros(freq / step + 1, length(obj.ics), tmax/freq);
            balance = zeros(freq / step + 1, tmax/freq);
            
            for i = 1:tmax/freq
                [t(:, i), solution(:, :, i), balance(:, i)] = obj.get_solution((i-1)*freq:step:i*freq);
                % balance(:, i) = balance(:, i) + (i-1)*264;
                obj.ics = solution(end, :, i);
            end
        end
    end
    
    methods (Access = private)
        function dydt = heparinODE(obj, t, y, p, ra)
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