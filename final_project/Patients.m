classdef Patients < handle
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
        
        function [time, solution] = simulatePK(p, y0, dose)
            dose_count = length(dose);
            resolution = 1;
            sim_len = resolution*168 + 1;
            time = zeros(dose_count*sim_len, 1); % 16 simulations of 10081 time steps
            solution = zeros(dose_count*sim_len, 4);
            for i = 1:dose_count
                y0(3) = y0(3) + dose(i);
                [t, y] = ode23s(@Patients.tirzepatidePK, 168*(i-1):(1/resolution):168*i, y0, [], p);
                y0 = y(end, :);
                range = sim_len*(i-1)+1:sim_len*i;
                time(range) = t;
                solution(range, :) = y;
            end
        end

        function [time, solution] = simulatePD(p, y0, dose)
            options = odeset('MaxStep', 5e-2, 'AbsTol', 1e-5, 'RelTol', 1e-5, 'InitialStep', 1e-2);
            time = zeros(16*10081, 1); % 16 simulations of 10081 time steps
            solution = zeros(16*10081, 7);
            for i = 1:16
                y0(3) = y0(3) + dose(i);
                [t, y] = ode45(@Patients.tirzepatidePD, 168*(i-1):(1/60):168*i, y0, options, p);
                y0 = y(end, :);
                range = 10081*(i-1)+1:10081*i;
                time(range) = t;
                solution(range, :) = y;
            end
        end
    end

    methods (Access = private, Static)
        function dydt = tirzepatidePK(t, y, p)
            dydt = zeros(4, 1);
            dydt(1) = p.F * p.ka * y(3) - p.kCL * y(1) - p.k12 * y(1) + p.k21 * y(2);
            dydt(2) = p.k12 * y(1) - p.k21 * y(2);
            dydt(3) = -p.ka * y(3) * p.Vc;
            dydt(4) = (1 - p.F) * p.ka * y(3) + p.kCL * y(1) * p.Vc;
        end

        function dydt = tirzepatidePD(t, y, p)
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
