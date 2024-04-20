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
        function p = parameters(Vc, Vp, ka, CL, Q)
            p = struct('Vc', Vc, 'Vp', Vp, 'ka', ka, 'CL', CL, 'Q', Q);
        end
        
        function [time, solution] = simulateRegime(p, y0, dose)
            p.kCL = p.CL / p.Vc;
            p.k12 = p.Q / p.Vc;
            p.k21 = p.Q / p.Vp;
            p.F = 0.8;

            options = odeset('MaxStep', 5e-2, 'AbsTol', 1e-5, 'RelTol', 1e-5, 'InitialStep', 1e-2);
            time = zeros(16*10081, 1); % 16 simulations of 10081 time steps
            solution = zeros(16*10081, 4);
            for i = 1:16
                y0(3) = y0(3) + dose(i);
                [t, y] = ode45(@Patients.tirzepatideODE, 168*(i-1):(1/60):168*i, y0, options, p);
                y0 = y(end, :);
                range = 10081*(i-1)+1:10081*i;
                time(range) = t;
                solution(range, :) = y;
            end
        end    
    end

    methods (Access = private, Static)
        function dydt = tirzepatideODE(t, y, p)
            dydt = zeros(4, 1);
            dydt(1) = p.F * p.ka * y(3) - p.kCL * y(1) - p.k12 * y(1) + p.k21 * y(2);
            dydt(2) = p.k12 * y(1) - p.k21 * y(2);
            dydt(3) = -p.ka * y(3) * p.Vc;
            dydt(4) = (1 - p.F) * p.ka * y(3) + p.kCL * y(1) * p.Vc;
        end
    end
end
