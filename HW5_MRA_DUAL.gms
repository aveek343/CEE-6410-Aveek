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

* Defining the sets
SETS crps for the production /Hay, Grain/
     constr montly changes and resources /June_Water, July_Water, August_Water, Land/;

* Defining the input data
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

* Define the variables
VARIABLES X(crps) crops planted (acre)
        VRETURN total return ($)
         Y(constr) value of resources for different months (unit ACF for monthly water and acre for land)
          REDCOST total reduced cost for resources;

* Non-negetivity constraint
POSITIVE VARIABLES X ,Y;

* Combining the variables and data in equations

EQUATIONS
    PROFIT_PRIMAL Total return ($) using the objective function
    RES_CONSTRAIN_PRIMAL(constr)
    REDCOST_DUAL Reduced cost ($) for the constraints
    RES_CONSTRAIN_DUAL(crps);


* Primal equation
PROFIT_PRIMAL..            VRETURN=E=SUM(crps,c(crps)*X(crps));
RES_CONSTRAIN_PRIMAL(constr)..     SUM(crps,A(crps, constr)*X(crps)) =L= b(constr);

* Dual equation
 REDCOST_DUAL..                  REDCOST=E=SUM(constr, b(constr)*Y(constr));
 RES_CONSTRAIN_DUAL(crps)..      SUM(constr,A(crps, constr)*Y(constr)) =G= c(crps);


* Defining the primal model from the solution
MODEL PLANTING_PRIMAL /PROFIT_PRIMAL, RES_CONSTRAIN_PRIMAL/;
*Set the options file to print out range of basis information
PLANTING_PRIMAL.optfile = 1;

* Defining the Dual model from the solution
MODEL PLANTING_DUAL /REDCOST_DUAL,RES_CONSTRAIN_DUAL/;


* 6. SOLVE the MODELS
* Primal
SOLVE PLANTING_PRIMAL USING LP MAXIMIZING VRETURN;

* Dual
SOLVE PLANTING_DUAL USING LP MINIMIZING REDCOST;
*Order does not matter!


Execute_Unload "HW5_MRA_DUAL.gdx";

Execute "gdx2xls HW5_MRA_DUAL.gdx"
* To open the GDX file in the GAMS IDE, select File => Open.
* In the Open window, set Filetype to .gdx and select the file.

