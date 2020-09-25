$ontext
CEE 6410
Assignment 4:
Problem formulation:
      Reservoir Operation
      The problem consist of a system where water is coming from a reservoir to a hydro-power generator turbine,
      then to a stream and the water can be further diverted for irrigating lands, but there is a point called point "A"
      where at least 1 unit of water must be kept at all time stamp. The reservoir gets its water from a upstream water sources as
      inflows and has a maximum capacity of 9 units of water and any additional amount of infow can be spilled.At a
      given time period,the initial storage of the reservoir is 5 units.
      The hydropower generator turbine has a maximum capacity of 4 units per month.
      The problem provides the $/unit volume that can be generated each month from hydro power and the irrigation.
      Considering all the information, there are total 7 constraint equations;
      1. Mass balance at the reservoir at the initial month;
               X(reservoir, month_1) = X(Inflow, month_1) + Initial storage (5 unit) - X(Spill, month_1) - X(Hydropower, month_1)
      2. Mass balance at the reservoir for any other time step;
               X(reservoir, month_n) = X(reservoir, month_n-1)+X(Inflow)- X(Spill) - X(Hydropower)    [wher n is number of monthes from 2]
      3. Reservoir capacity at any time step <= 9
      4. Hydropower generation at any time step <= 4
      5. Flow requirement @ A at any time step <= 1
      6. Mass balance just before irrigation diversion
               X(Spill,month_n) + X(Hydropower,month_n) <= X(Irrigation,month_n)+ X(Spill,month_n) [month_n = 1,2,..,6]
      7. All variables must be positive.

      if the coefficient of Hydropower benefit and irrigation benefit is hb and ib respectiely, then
               Objective function is: Z = summation {hb*X(@month_n)+ ib*X(@month_n)}

Prepared by: Mahmudur Rahman Aveek
Aid: A02305118
email: mahmud.aveek@usu.edu
date: 23 September 2020
$offtext

*Define Sets
SETS l all the points on the schemetic diagram /Res "Reservoir", Hyd "Hydropower", Irr "Irrigation", Spi "Spill", AAA "A"/
     t all timesteps in months /month1*month6/;

*Define input data


PARAMETERS
    inflow(t) reservoir inflow (unit volume)
        /month1 2, month2 2, month3 3, month4 4, month5 3, month6 2/
    hb(t) reservoir benefit from hydro power($ per unit of water)
        /month1 1.6, month2 1.7, month3 1.8, month4 1.9, month5 2.0, month6 2.0/
    ib(t) reservoir benefit from irrigation ($ per unit of water)
       /month1 1.0, month2 1.2, month3 1.9, month4 2.0, month5 2.2, month6 2.2/;

SCALARS
    MaxStorage  Maximum Reservoir Storage (unit volume) /9/
    InStorage   Initial Storage of Reservoir (unit volume) /5/
    FlowReqA    Flow Requirment at point A (unit volume) /0/
    TurbCapacity Monthly maximum capacity (unit volume)/4/;

VARIABLES
    X(l,t)   The amount of water unit at t timestep (unit volume)
    TOTALBEN Total Benefit ($);

POSITIVE VARIABLES X

EQUATIONS

 PROFIT Total collective profit generated from six months opertation
 RES_Storage_Con(l,t) Reservoir has a capacity
 Sustain_Con(l,t) Final Reservoir Storage must be greater than or equal to initial one
 OutFlow_at_A_Con(l,t) Outflow at point A be 1 or greater
 Turbine_Con(l,t) The turbine's montly maximum is 4
 MassBalance_at_B_Con(t) The mass balance at an imaginary point B just before the irrigation diversion
 MassBalance_at_Res_Con(t) The mass balance at the reservoir
 MassBalance_at_Res_ini_Con(t) The initial mass balance at the reservoir;

PROFIT..                          TOTALBEN=E=SUM(t,hb(t)*X("Hyd",t)+ib(t)*X("Irr",t));
RES_Storage_Con(l,t)..            X("Res",t)=L= MaxStorage;
Sustain_Con(l,t)..                X("Res","month6") =G= InStorage;
OutFlow_at_A_Con(l,t)..           X("AAA",t)=G=FlowReqA;
Turbine_Con(l,t)..                X("Hyd",t)=L= TurbCapacity;
MassBalance_at_B_Con(t)..       X("Spi",t)+X("Hyd",t)=E=X("Irr",t)+X("AAA",t);
MassBalance_at_Res_ini_Con(t)..   X("Res","month1")=E=InStorage+ inflow("month1")-X("Spi","month1")-X("Hyd","month1");
MassBalance_at_Res_Con(t)$(ord(t) ge 2)..     X("Res",t)=E= X("Res",t-1)+inflow(t)-X("Spi",t)-X("Hyd",t);

* Defining the model
*MODEL ADJUSTINGBTN /PROFIT,RES_Storage_Con,Sustain_Con,OutFlow_at_A_Con,Turbine_Con,MassBalance_at_B_Con,MassBalance_at_Res_ini_Con,MassBalance_at_Res_Con/;
 MODEL ADJUSTINGBTN/ALL/
* Solving model
SOLVE ADJUSTINGBTN USING LP MAXIMIZING TOTALBEN;
