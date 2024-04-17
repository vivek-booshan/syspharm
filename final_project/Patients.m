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
        meanSimulatedFG double
        stdSimulatedFG double
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
        
        function [xdist] = generateBMI(obj)
            % x = 10:0.5:60;
            % y = obj.normalPDF(x, obj.meanBMI, obj.stdBMI);
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
            xdist = xtemp;
        end

        function [xdist] = generateFG(obj)
            rng(1, 'simdTwister');
            xtemp = obj.stdFG .* randn(obj.num_patients, 1) + obj.meanFG;
            a = length(xtemp(xtemp <= obj.cutoffFG));
            i = 0; cycle = 1;
            while a > 0
                xtemp(xtemp <= obj.cutoffFG) = obj.stdFG .* randn(a, 1) + obj.meanFG;
                a = length(xtemp(xtemp <= obj.cutoffFG));
                cycle = cycle + 1;
                i = i + 1;
            end
            obj.meanSimulatedFG = mean(xtemp);
            obj.stdSimulatedFG = std(xtemp);
            xdist = xtemp;
        end
    end

     methods (Access = private)
        function y = normalPDF(obj, x, mu, std)
            y = 1/(std * sqrt(2*pi))*exp(-((x(:) - mu).^2)/(2*std^2));
        end
    end
end
