classdef Patients < handle
    % Patients (class)
    %       Usage
    %           obj = Patients(num_patients = 1000, T2DM = 1)
    %
    %       Properties
    %           num_patients (double)
    %           T2DM (logical)
    %           meanBMI (double)
    %           stdBMI (double)
    %           meanFG (double)
    %           stdFG (double)
    %           cutoffBMI (double)
    %           cutoffFG (double)
    %           meanSimulatedBMI (double)
    %           stdSimulatedBMI (double)
    %           BMI (nx1 double)
    %           FG (nx1 double)
    %
    %       Methods (see help for each function)
    %           generateBMI
    %           generateFG
    %
    %       Methods (Static) (see help for each function)
    %           pkParameters 
    %           pdParameters 
    %           tirzepatidePK 
    %           tirzepatidePD 
    %           simulatePK
    %           simulatePD
    properties
        num_patients double
        T2DM logical
        meanBMI double = 27.1
        stdBMI double = 4.33
        meanFG double = 5.20
        stdFG double = 0.583
        cutoffBMI double = 12
        cutoffFG double = 3
        meanSimulatedBMI double
        stdSimulatedBMI double
        BMI (:, 1) double
        FG (:, 1) double
    end

    methods
        function obj = Patients(num_patients, T2DM)
            arguments
                num_patients double %= 1000
                T2DM logical %= 0
            end
            obj.num_patients = num_patients;
            obj.T2DM = T2DM;
            if obj.T2DM
                obj.meanBMI = 29.7;
                obj.stdBMI = 4.98;
                obj.meanFG = 9.62;
                obj.stdFG = 2.24;
            end
        end

        function generateBMI(obj)
            rng(0, 'simdTwister');
            xtemp = obj.stdBMI .* randn(obj.num_patients, 1) + obj.meanBMI;
            a = length(xtemp( xtemp <= obj.cutoffBMI)); 
            i = 0;
            cycle = 1;
            while a > 0
                xtemp(xtemp <= obj.cutoffBMI) = obj.stdBMI .* randn(a, 1) + obj.meanBMI;
                a = length(xtemp(xtemp <= obj.cutoffBMI));
                cycle = cycle + 1;
                i = i + 1;
            end
            obj.meanSimulatedBMI = mean(xtemp);
            obj.stdSimulatedBMI = std(xtemp);
            obj.BMI = xtemp;
        end

        function generateFG(obj)
            p = 0.564;
            BMIdist_zval = (obj.BMI - obj.meanSimulatedBMI) / obj.stdSimulatedBMI;
            FGdist_zval = p.*BMIdist_zval + sqrt(1 - p.^2).*randn(size(BMIdist_zval));
            obj.FG = FGdist_zval*obj.stdFG + obj.meanFG;
        end
    end

    methods (Static)
        function p = pkParameters(Vc, Vp, ka, CL, Q, F)
            % function that takes in pk parameter inputs and generates a struct 
            % of all values
            %
            % Inputs
            % Vc   single           : Central Volume Distribution (L)
            % Vp   single           : Peripheral Volume Distribution (L)
            % ka   single           : absorbance rate (1/hr)
            % CL   single           : Clearance (L/hr)
            % Q    single           : Intercompartmental Clearance (L/hr)
            % F    single = 0.8     : Bioavailability

            arguments
                Vc single % Central Volume Distribution (L)
                Vp single % Peripheral Volume Distribution (L)
                ka single % absorbance rate (1/hr)
                CL single % Clearance (L/hr)
                Q single % Intercompartmental Clearance (L/hr)
                F single = 0.8 % Bioavailability
            end
            p = struct( ...
                'Vc', Vc, 'Vp', Vp, 'ka', ka, 'CL', CL, 'Q', Q, 'F', F, ...
                'kCL', CL / Vc, 'k12', Q/Vc, 'k21', Q/Vp ...
            );
        end
        function p = pdParameters(Vc, Vp, ka, CL, Q, F, kDIS, kOFF, kOUT, E0H, E0G, EC50, PLAC, Hlim, FPG)
            % function that takes in pd parameter inputs and generates a struct 
            % of all values
            %
            % Inputs
            % Vc   single           : Central Volume Distribution (L)
            % Vp   single           : Peripheral Volume Distribution (L)
            % ka   single           : absorbance rate (1/hr)
            % CL   single           : Clearance (L/hr)
            % Q    single           : Intercompartmental Clearance (L/hr)
            % F    single = 0.8     : Bioavailability
            % kDIS single = 0.0215  : FG disease progression rate (mM/wk)
            % kOFF single = 0.00306 : Offset rate (1/hr)
            % kOUT single = 0.00156 : Turnover rate const for HbA1c (1/hr)
            % E0H  single = 8.25    : Baseline HbA1c (%)
            % E0G  single = 9.23    : Baseline FG (mmol/L)
            % EC50 single = 144     : [Tirzepatide] with 50% max effect (ng/mL)
            % PLAC single = 0.0846  : Placebo fractional reduction of FG
            % Hlim single = 5.02    : Limit for HbA1c-Emax (%)
            % FPG  single = 0.799   : Expo for effect of FG on HbA1c (gamma)
            % 
            % Outputs
            % p (struct) : struct of all inputs
            arguments
                Vc single % Central Volume Distribution (L)
                Vp single % Peripheral Volume Distribution (L)
                ka single % absorbance rate (1/hr)
                CL single % Clearance (L/hr)
                Q single % Intercompartmental Clearance (L/hr)
                F single = 0.8 % Bioavailability
                kDIS single = 0.0215 % FG disease progression rate (mM/wk)
                kOFF single = 0.00306 % Offset rate (1/hr)
                kOUT single = 0.00156 % Turnover rate const for HbA1c (1/hr)
                E0H single = 8.25 % Baseline HbA1c (%)
                E0G single = 9.23 % Baseline FG (mmol/L)
                EC50 single = 144 % [Tirzepatide] with 50% max effect (ng/mL)
                PLAC single = 0.0846 % Placebo fractional reduction of FG
                Hlim single = 5.02 % Limit for HbA1c-Emax (%)
                FPG single = 0.799 % Expo for effect of FG on HbA1c (gamma)
            end
            p = struct( ...
                'Vc', Vc, 'Vp', Vp, 'ka', ka, 'CL', CL, 'Q', Q, 'F', F, ...
                'kCL', CL/Vc, 'k12', Q/Vc, 'k21', Q/Vp, ...
                'kDIS', kDIS, 'kOFF', kOFF, 'kOUT', kOUT, 'E0H', E0H, ...
                'E0G', E0G, 'EC50', EC50, 'PLAC', PLAC, 'Hlim', Hlim, 'FPG', FPG ...
            );
        end

        function [time, solution] = simulatePK(p, y0, dose, options)
            % Solves the stiff tirzepatide PK problem. Steps are calculated
            % with respect to 168 hour ranges specified by resolution.
            % (see Patients.tirzepatidePK documentation for more)
            % 
            % Inputs
            %   p       (struct): PK parameter fields
            %   y0   (4x1 float): initial conditions
            %                     (central, peripheral, absorbed, total)
            %   dose (nx1 float): vector of weekly dose amount
            %
            % Inputs (Optional)
            %   resolution (float) = 1 : (1/resolution) step size
            %   solver (@func) = @ode23s : ode solver
            %   options = [] : replace with odeset options if desired.
            % 
            % Outputs
            %   time     (nx1 float) : time points
            %   solution (nx4 float) : solutions

            arguments
                p struct
                y0 (1, 4)
                dose (1, :)
                options.resolution (1, 1) double = 1
                options.solver = @ode23s
                options.options = []
            end

            dose_count = length(dose);
            sim_len = options.resolution*168 + 1;
            time = zeros(dose_count*sim_len, 1); 
            solution = zeros(dose_count*sim_len, 4);
            for i = 1:dose_count
                y0(3) = y0(3) + dose(i);
                [t, y] = options.solver(@Patients.tirzepatidePK, ...
                        168*(i-1):(1/options.resolution):168*i, y0, ...
                        options.options, p);
                y0 = y(end, :);
                range = sim_len*(i-1)+1:sim_len*i;
                time(range) = t;
                solution(range, :) = y;
            end
        end

        function [time, solution] = simulatePD(p, y0, dose, options)
            % Solves the stiff PD problem. Steps are calculated with 
            % respect to 168 hour ranges specified by resolution
            % (See Patients.tirzepatidePD documentation for more)
            % Inputs
            %   p       (struct): PD parameter fields
            %   y0   (7x1 float): initial conditions
            %                     (central, peripheral, absorbed, total,
            %                      FG disease progression, OFFSET, ONSET) 
            %   dose (nx1 float): vector of weekly dose amount
            %
            % Inputs (Optional)
            %   resolution (float) = 1 : (1/resolution) step size
            %   solver (@func) = @ode23s : ode solver.
            %   options = [] : replace with odeset options if desired.
            % 
            % Outputs
            %   time     (nx1 float) : time points
            %   solution (nx7 float) : solutions

            arguments
                p struct
                y0 (1, 7)
                dose (1, :)
                options.resolution (1, 1) double = 30
                options.solver = @ode23s
                options.options = []
            end

            dose_count = length(dose);
            sim_len = options.resolution*168 + 1;
            time = zeros(dose_count*sim_len, 1); % dose_count simulations of length sim_len
            solution = zeros(dose_count*sim_len, 7);
            for i = 1:16
                y0(3) = y0(3) + dose(i);
                [t, y] = options.solver(@Patients.tirzepatidePD, ...
                        168*(i-1):(1/options.resolution):168*i, y0, ...
                        options.options, p);
                y0 = y(end, :);
                range = sim_len*(i-1)+1:sim_len*i;
                time(range) = t;
                solution(range, :) = y;
            end
        end
    % end
    % 
    % methods (Access = private, Static)
        function dydt = tirzepatidePK(t, y, p)
            % ODE specified by pg 65 of 
            % https://www.accessdata.fda.gov/drugsatfda_docs/nda/2022/215866Orig1s000ClinPharmR.pdf
            %
            % Inputs 
            %   t (float) : dummy input to log timestep
            %   y (4x1 float)
            %   p (struct) : pk Parameter struct (see Patients.pkParameters
            %                                     for details)
            %
            % Outputs
            %   dydt (4x1 float) : 
            %       [central, peripheral, absorbance, cumulative]

            dydt = zeros(4, 1);
            dydt(1) = p.F * p.ka * y(3) - p.kCL * y(1) - p.k12 * y(1) + p.k21 * y(2);
            dydt(2) = p.k12 * y(1) - p.k21 * y(2);
            dydt(3) = -p.ka * y(3) * p.Vc;
            dydt(4) = (1 - p.F) * p.ka * y(3) + p.kCL * y(1) * p.Vc;
        end

        function dydt = tirzepatidePD(t, y, p)
            % ODE specified by pg 65 of 
            % https://www.accessdata.fda.gov/drugsatfda_docs/nda/2022/215866Orig1s000ClinPharmR.pdf
            %
            % Inputs 
            %   t (float) : dummy input to log timestep
            %   y (7x1 float)
            %   p (struct) : pk Parameter struct (see Patients.pkParameters
            %                                     for details)
            %
            % Outputs
            %   dydt (7x1 float) :
            %           [ central, peripheral, absorbance, cumulative,
            %             disease progression, offset, HbA1c]

            dydt = zeros(7, 1);
            dydt(1) = p.F*p.ka*y(3) - p.kCL*y(1) - p.k12*y(1) + p.k21*y(2); 
            dydt(2) = p.k12*y(1) - p.k21*y(2);
            dydt(3) = -p.ka*y(3)*p.Vc; 
            dydt(4) = (1-p.F)*p.ka*y(3) + p.kCL*y(1)*p.Vc;
            dydt(5) = p.kDIS;
            dydt(6) = p.kOFF*((1-p.PLAC-(p.Hlim/p.E0H)^(1/p.FPG))*y(1)/(y(1)+p.EC50)-y(6));
            dydt(7) = (p.kOUT*p.E0H*(y(5)-y(5)*y(6))^p.FPG/(p.E0G^p.FPG))-p.kOUT*y(7);
        end
    end
end
