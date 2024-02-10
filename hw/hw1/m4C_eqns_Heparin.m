function dydt = m4C_eqns_Heparin(t, y, p)
    
    % y1 = D_BP
    % y2 = DP
    % y3 = D_T1
    % y4 = D_T2
    % y5 = D_b
    % y6 = D_c

    dydt = zeros(6, 1);

    dydt(1) = ( ...
        - p.kon * p.vbp * y(1) + p.koff * p.vbp * y(2) ...
        - p.kt1 * p.vbp * y(1) + p.kt1r * p.vt1 * y(3) ...
        - p.kt2 * p.vbp * y(1) + p.kt2r * p.vt2 * y(4) ...
        - p.kb * p.vbp * y(1) + p.kbr * p.vb * y(5) ...
        - p.kc * p.vbp * y(6) ...
    ) / p.vbp;
    dydt(2) = (p.kon * p.vbp * y(1) - p.koff * p.vbp * y(2)) / p.vbp;
    dydt(3) = (p.kt1 * p.vbp * y(1) - p.kt1r * p.vt1  * y(3)) / p.vt1;
    dydt(4) = (p.kt2 * p.vbp * y(1) - p.kt2r * p.vt2  * y(4)) / p.vt2;
    dydt(5) = (p.kb  * p.vbp * y(1) - p.kbr  * p.vb   * y(5)) / p.vb;
    dydt(6) =  p.kc  * p.vbp * y(1);