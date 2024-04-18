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
                num_patients double = 1000
                T2DM logical = 0
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
    
end
