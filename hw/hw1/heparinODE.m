function dydt = heparinODE(~, y, p, rate_adjusted)
    arguments
        ~
        y (1, 7) {mustBeNumeric, mustBeReal}
        p struct
        rate_adjusted logical = 1
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

    dydt = zeros(6, 1);
    if rate_adjusted
        p.kt1 = p.kt1 * (p.vt1 / p.vbp);
        p.kt2 = p.kt2 * (p.vt2 / p.vbp);
    end
    dydt(1) = ( ...
        - p.kon * p.vbp * y(1) + p.koff * p.vbp * y(2) ...
        - p.kt1 * p.vbp * y(1) + p.kt1r * p.vt1 * y(3) ...
        - p.kt2 * p.vbp * y(1) + p.kt2r * p.vt2 * y(4) ...
        - p.kb  * p.vbp * y(1) + p.kbr  * p.vb  * y(5) ...
        - p.kc  * p.vbp * y(1) ...
    ) / p.vbp;
    dydt(2) = (p.kon * p.vbp * y(1) - p.koff * p.vbp  * y(2)) / p.vbp;
    dydt(3) = (p.kt1 * p.vbp * y(1) - p.kt1r * p.vt1  * y(3)) / p.vt1;
    dydt(4) = (p.kt2 * p.vbp * y(1) - p.kt2r * p.vt2  * y(4)) / p.vt2;
    dydt(5) = (p.kb  * p.vbp * y(1) - p.kbr  * p.vb   * y(5)) / p.vb;
    dydt(6) =  p.kc  * p.vbp * y(1); %in amount
    dydt(7) = -p.kon * p.vbp * y(7) + p.koff * p.vbp * y(2); %in amount