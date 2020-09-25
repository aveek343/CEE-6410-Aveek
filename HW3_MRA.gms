$ontext
CEE 6410 - Water Resources Systems Analysis
2.4. Problems: Problem number 4 from Bishop Et Al Text (https://digitalcommons.usu.edu/ecstatic_all/76/)

THE PROBLEM:

The problem states a system where an excess amount of water will be transferred for agricultural use from an industrial region during June, July,
and August. Two crops, Hay (H) and Grain (G), are proposed for agricultural production.   Data are as fol-lows:

Constraint Equations:
        June water constraint equation, 2H + G <= 14000 (ACF) ……… (1)
        July water constraint equation, H + 2G <= 18000 (ACF) ……… (2)
        August water constraint equation, H + 0 x G <= 6000 (ACF) ……… (3)
        Land constraint equation, H + G <= 10000 (Acre) ……… (4)

Objective Function:

        Z= 100H + 120 G (5)

The objective is to maximize z

THE SOLUTION:
Uses General Algebraic Modeling System to Solve this Linear Program
Mahmud Aveek
mahmud.aveek@usu.edu
September 22, 2020
$offtext

* 1. Defining the sets
SETS crps for the production /Hay, Grain/
     constr montly changes and resources /June_Water, July_Water, August_Water, Land/;

* 2. Defining the input data
PARAMETERS
    c(crps) Objective function coefficient ($ per acre)
            /Hay 100,
            Grain 120/
    b(constr) Right hand constraint value (per resource)
            /June_Water 14000,
            July_Water 18000,
            August_Water 6000,
            Land 10000 /;

TABLE A(crps, constr) Left hand side of the constraint equations

            June_Water   July_Water   August_Water   Land
Hay            2              1          1           1
Grain          1              2          0           1;

* 3 Define the variables
VARIABLES X(crps) crops planted (acre)
        VRETURN total return ($);

* Non-negetivity constraint
POSITIVE VARIABLES X

* 4 Combining the variables and data in equations

EQUATIONS
    PROFIT Total return ($) using the objective function
    RES_CONSTRAIN(constr);

PROFIT..            VRETURN=E=SUM(crps,c(crps)*X(crps));
RES_CONSTRAIN(constr)..     SUM(crps,A(crps, constr)*X(crps)) =L= b(constr);

* 5 Defining the model from the solution
MODEL PLANTING /PROFIT, RES_CONSTRAIN/;

*MODEL PLANTING /ALL/;

* Solving the Model
SOLVE PLANTING USING LP MAXIMIZING VRETURN;

