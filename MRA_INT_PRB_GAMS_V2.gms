$ontext
CEE 6410 - Water Resources Systems Analysis
7.1. Problems: Problem number 1 from Bishop Et Al Text Chapter 7 (https://digitalcommons.usu.edu/ecstatic_all/76/)

THE PROBLEM:


Constraint Equations:


Objective Function:



The objective is to maximize z

THE SOLUTION:
Uses General Algebraic Modeling System to Solve this Linear Program
Mahmud Aveek
mahmud.aveek@usu.edu
September 22, 2020
$offtext

* Creating the sets, the problem has three dimensions, so we will declare three sets
SETS l the location of different geographic features /reservoir "Reservoir Location", pump "Pump Location", farm "Farm Location", river "The stream"/

     t the seasons /season1, season2/

     s size of the reservoir /noRes, smallRes, bigRes/;

* Assigning the parameter values (coefficients) those change over dimension

PARAMETERS
INFLOW(t) the amount of inflow in each season [ac-ft] /season1 600, season2 200/
DEMAND(t) the irrigation demand in each season [ac-ft per ac] /season1 1, season2 3/
INT_RES_COST(s) the initial or capital cost of different reservoirs [$] /noRes 0, smallRes 6000, bigRes 10000/
RES_CAPACIYT(s) the capacity of different reservoirs [ac-ft] /noRes 0, smallRes 300, bigRes 700/;

* Assigning the parameter values (coefficients) those do not change over dimension
SCALARS
BASEFLOW the amount of groundwater flowing to the river each season (365 days divided by 2 and multiplied by 2acft per day) [ac-ft per season]/365/
PUMP_INT_COST the initial or capital cost for pump construction [$] /8000/
PUMP_OPT_COST the operational cost of pump ($20 dollars per acre) [$ per ac-ft] /20/
PUMP_CAP the capacity of pump (365 days divided by 2 and multiplied by 2.2 acft per day) [ac-ft per season] /401.5/
IRR_REVENUE the irrigation revenue [$ per acre per year] /300/;


* Defining the variables
VARIABLES
NETBENEFIT the profit will be stored here [$]
AREA area of the irrigated land [acre]
X(l,t) the inflow at different location for different seasnons [ac-ft]
IR(l,s) the decision variable which is contains binary values and is a function of location (only resevoir) and size  (0 or 1)
IP (l) the decision variable whether to go for constructing pumps (0 or 1);

* non negetivity
POSITIVE VARIABLES X;

* defining binary variables
BINARY VARIABLES IR, IP;

* Defining the equations
EQUATIONS
revenue the profit generated from the irrigation minus the operational and capital cost and this is the objective function we need to maximize [$]
resNum the number of reservoir cannot be greater than one at any season
massBalRes_int(t) the mass balance at the reservoir location at initial time step [ac-ft]
massBalRes(t) the mass balance at the reservoir in other time steps [ac-ft]
resStoCap(t) the reservoir storage must be less than reservoir capacity [ac-ft]
pumpCap(t) the pump capacity must be less than or equal to 401.5 acre-ft per season [ac-ft]
massBalPump(t) the mass balance at the pump location [ac-ft]
irrArea(t) the area which will be irrigated [acre];


revenue..                        NETBENEFIT=E= IRR_REVENUE*AREA - SUM(s,INT_RES_COST(s)*IR("reservoir",s)) - PUMP_INT_COST*IP("pump") - SUM(t,PUMP_OPT_COST*X("pump",t));
resNum..                         1=E=SUM(s,IR("reservoir",s));
massBalRes_int(t)..              X("reservoir","season1") =E= INFLOW("season1")-X("river","season1")-X("farm","season1");
massBalRes(t)$(ord(t) ge 2)..    X("reservoir",t) =E= INFLOW(t)+X("reservoir",t-1)-X("river",t)-X("farm",t);
resStoCap(t)..                   X("reservoir",t) =L=  SUM(s,RES_CAPACIYT(s)*IR("reservoir",s));
pumpCap(t)..                     X("pump",t) =L=  PUMP_CAP*IP("pump");
massBalPump(t)..                 X("pump",t) =L= X("river",t)+BASEFLOW;
irrArea(t)..                     AREA =L= (X("farm",t)+X("pump",t))/DEMAND(t);

* now we assign a model

Model INTEGER_GAMS /all/;
INTEGER_GAMS.optfile=1;

* solving the model and maximizeing the NETBENEFIT using the MIP which is mixed integer programing
SOLVE INTEGER_GAMS USING MIP Maximize NETBENEFIT;

* Dumping all input data and results to a GAMS gdx file
Execute_Unload "MRA_INT_PRB_GAMS_V2.gdx";
* Dumping the gdx file to an Excel workbook
Execute "gdx2xls MRA_INT_PRB_GAMS_V2.gdx"





