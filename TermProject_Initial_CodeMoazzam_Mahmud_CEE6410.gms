$ontext
Re-operate Lake Powell and Lake Mead for Ecosystem and Water Supply Benefits (3 year model)
###################################
Created By: Moazzam and Mahmudur Rahman Aveek
Email: moazzamalirind@gmail.com

Created : 10/28/2020
Last updated: 11/19/2020

*****Description: (You can write this or I can write sometime, a breif abstract telling what this model is about and what it produce as output)
This model considers water year calender for its calculations.

######################################
$offtext

****Model code:

Set
             yr                 water years /y1*y3/
             M                  Months in a year /M1*M12/
             modpar             Saving model parameter for each of the solutions for each of the scenario/ ModStat "Model Statistics", SolStat "Solve Statistics"/
;


*Define a second name for the sets
*Alias ()

*======================================
Parameters
*======================================
*Initial storages
Init_Powell                           Initial reservoir storage in Lake Powell i.e. storage on 30th september (acre-ft)/14664000/
Init_Mead                             Initial reservoir storage in Lake Mead i.e. storage on 30th september (acre-ft)/10182000/
*Here  we consider 2018,2019,2020 water years as an example. The values given here were measured at the start of october 2017.

*Inflows to the system
Inflow_Powell(yr,M)                      Monthly average inflows to lake Powell during three years (acre-ft)
Inflow_Paria(yr,M)                       Monthly average inflows from Paria river during three years (acre-ft)
Inflow_LitColorado(yr,M)                 Monthly average inflows from Little Colorado river during three years (acre-ft)
Inflow_KanabCreek(yr,M)                  Monthly average inflows from KanabCreek during three years (acre-ft)
Inflow_Havasu(yr,M)                      Monthly average inflows from Havasu during three years (acre-ft)
Inflow_Diamond(yr,M)                     Monthly average inflows from Diamond during three years (acre-ft)

* Structural and operational constraints
****************
*Lake Powell
***************
Maxstorage_Powell                     Maximum Reservoir capacity of Lake Powell (acre-ft)/27865918/
*Volume total capacity at maximum storage level of 3710 FT
Minstorage_Powell                     Minimum reservoir storage to generate hydropower(acre-ft)/000000/
*Volume total capacity at 00000 FT level (dead level)
*Elevation to storage curve information can be found at; https://www.usbr.gov/lc/region/programs/strategies/FEIS/AppA.pdf

Min_RelPowell                         Minimum Powell release during any time period (cfs)/8000/
*****I think we can't say that flow can be zero.. If that's zero then ecosystem will die nothing will be there. I think 8000 minimum is decent but we can change when we need.
Max_RelPowell                         Maximum Powell release during any time period (cfs)/00000/
*Information can be found at: https://ltempeis.anl.gov/documents/docs/LTEMP_ROD.pdf. Look for alternative D

evap_Powell(M)                        Monthly Evaporation rate for Lake Powell. (Monthly evaporation volume per monthly reservior storage)
*we need rate i.e. (observed monthly/storage during that month).


**************
*Lake Mead
**************
Maxstorage_Mead                       Maximum Reservoir capacity of Lake Mead (acre-ft)/27767000/
* total capacity at maximum storage level
Minstorage_Mead                       Minimum reservoir storage to generate hydropower(acre-ft)/00000/
* total capacity at (Level at deadpool)
****Elevation to storage curve information can be found at; (Provide source here)

Min_RelMead                           Minimum Mead release during any time period (cfs)/8000/
Max_RelMead                           Maximum Mead release during any time period (cfs)/0000/
****Deadpool level for Mead

evap_Mead(M)                          Monthly Evaporation rate for Lake Mead. (Monthly evaporation volume per monthly reservior storage)
*we need rate i.e. (observed monthly/storage during that month).

**************************************************

*Storing Results
Rstore_Month(yr,M)                     Storing monthly release values (cfs)
Sstore_Powell(yr,M)                    Store Storage values of Powell for on a monthly scale (ac-ft)
Sstore_Mead(yr,M)                      Store Storage values of Mead for on a monthly scale (ac-ft)
Rel_volPowell(yr)                      Annual release volume from Powell (ac-ft)
Rel_volPowell(yr)                      Annual release volume from Mead (ac-ft)

Powell_yr1                             Storage volume in Powell at the end of the first water year (ac-ft)
Powell_yr2                             Storage volume in Powell at the end of the Second water year (ac-ft)

Mead_yr1                               Storage volume in Mead at the end of the first water year (ac-ft)
Mead_yr2                               Storage volume in Mead at the end of the Second water year (ac-ft)
;

*===================================================
* Read data from Excel
*===================================================
$CALL GDXXRW.EXE input=Input_2017-20WY.xlsx output=initial_Results.gdx   par=Inflow_Powell rng=Inflow_powell!A1 Rdim=1  par=Inflow_Paria rng=Inflow_paria!A1 Rdim=1  par=Inflow_LitColorado rng=Inflow_littleColorado!A1 Rdim=1 par=Inflow_unknown rng=Inflow_unknown!A1 Rdim=1 par=evap_Powell rng=evap_powell!A1 Rdim=1 par=evap_Mead rng=evap_mead!A1 Rdim=1

*Write the input Data into a GDX file
$GDXIN initial_Results.gdx

* loading parameters and input data from the GDX file into the model
$LOAD Inflow_Powell
$LOAD Inflow_Paria
$LOAD Inflow_LitColorado
$LOAD Inflow_KanabCreek
$LOAD Inflow_Havasu
$LOAD Inflow_Diamond
$LOAD evap_Mead
$LOAD evap_Powell

*Close the GDX file
$GDXIN

Display Inflow_Powell,Inflow_Paria,Inflow_LitColorado,Inflow_KanabCreek,Inflow_Havasu,Inflow_Diamond,evap_Powell,evap_Mead;
*===============================================

*========================================
Scalar
*========================================
Convert                      conversion factor from cfs to ac-ft per day (0.0014*60*24)/1.983/

*Elev_Powell_Low              Desirable ELevation ( coverted into corresponding reservior storage) of Lake powell to produce favorable downstream release temperature lower end  (ac-ft) /4096000/
*Elev_Powell_High             Desirable ELevation (coverted into corresponding reservior storage) of Lake powell to produce favorable downstream release temperature upper end  (ac-ft) /6270000/
*Elevation_Mead               Desirable Elevation of Lake Mead for to maintain the Peace ferry rapid (ac-ft)upper end /15120000/
;

Variables

*Mass balance at various locations of the study area
Storage_Powell(yr,M)              Storage in Lake Powell at each time step (ac-ft)

Storage_Mead(yr,M)                Storage in Lake Mead at each time step (ac-ft)

*Releases
Rel_Powell(yr,M)                 Release from lake powell (cfs)
Rel_Mead(yr,M)                   Release from Lake Mead (cfs)

*Volumes
Vol_Powell(yr)              Total volume of water released from lake powell during water year (ac-ft)
Vol_Mead(yr)                Total volume of water released from lake Mead during  water year (ac-ft)

;



**************************************************************************************************************************
Equation
EQ1_Powell_1styr(yr,M)     Mass balance at Lake powell during year 1 (ac-ft)
EQ2_Powell_2ndyr(yr,M)     Mass balance at Lake powell during year 2 (ac-ft)
EQ3_Powell_3rdyr(yr,M)     Mass balance at Lake powell during year 3 (ac-ft)
EQ4_Mead_1styr(yr,M)       Mass balance at Lake Mead during year 1 (ac-ft)
EQ5_Mead_2ndyr(yr,M)       Mass balance at Lake Mead during year 2 (ac-ft)
EQ6_Mead_3rdyr(yr,M)       Mass balance at Lake Mead during year 3 (ac-ft)
EQ7_maxstor_Powell(yr,M)   Powell storage max (ac-ft)
EQ8_maxstor_Mead(yr,M)     Mead storage max (ac-ft)
EQ9_minstor_Powell(yr,M)   The minimum storage equivalent to reservoir deadpool level (ac-ft)
EQ10_minstor_Mead(yr,M)    The minimum storage equivalent to reservoir deadpool level (ac-ft)
EQ11_MaxR_Powell(yr,M)     Max Release for Powell(cfs)
EQ12_MaxR_Mead(yr,M)       Max Release for Mead(cfs)
EQ13_MinR_Powell(yr,M)     Minimum Release for Powell(cfs)
EQ14_MinR_Mead(yr,M)       Minimum Release for Mead(cfs)
EQ15_TotVolPowell(yr)      Total volume of water released from Lake powell during water year (ac-ft)
EQ16_TotVolMead(yr)        Total volume of water released from Lake Mead during water year (ac-ft)


EQ13_obj_temp              Objective counting number of summer months we will be releasing water from desirable storage level window
EQ14_obj_Mead              Objective to maximize the number of months when storage at mead is less than peace ferry storage level
EQ15_Totobj                Overall objective of the model consisting of all the objectives



;
*****************************************************************************************************************************


EQ1_Powell_1styr(yr,M)$(ord (yr) eq 1)..          Storage_Powell(yr,M) =e= Init_Powell$(ord(M)eq 1)+ Storage_Powell(yr,M-1)$(ord(M)gt 1)+ Inflow_Powell(yr,M)- Rel_Powell(yr,"M1")*Convert*31 - Rel_Powell(yr,"M2")*Convert*30 - Rel_Powell(yr,"M3")*Convert*31 - Rel_Powell(yr,"M4")*Convert*31 - Rel_Powell(yr,"M5")*Convert*28 - Rel_Powell(yr,"M6")*Convert*31 - Rel_Powell(yr,"M7")*Convert*30 - Rel_Powell(yr,"M8")*Convert*31 - Rel_Powell(yr,"M9")*Convert*30 - Rel_Powell(yr,"M10")*Convert*31 - Rel_Powell(yr,"M11")*Convert*31 - Rel_Powell(yr,"M12")*Convert*30 - evap_Powell(M)*Storage_Powell(yr,M);
*                                                                                                                                                                October                            November                          December                           January                            Feburary                            March                      April                         May                                  June                                July                               August                     September
*                                                                                                                                                                                          Number in the equation is number of days in the specific months
EQ2_Powell_2ndyr(yr,M)$(ord (yr) eq 2)..          Storage_Powell(yr,M) =e= Powell_yr1$(ord(M)eq 1)+ Storage_Powell(yr,M-1)$(ord(M)gt 1)+ Inflow_Powell(yr,M)- Rel_Powell(yr,"M1")*Convert*31 - Rel_Powell(yr,"M2")*Convert*30 - Rel_Powell(yr,"M3")*Convert*31 - Rel_Powell(yr,"M4")*Convert*31 - Rel_Powell(yr,"M5")*Convert*28 - Rel_Powell(yr,"M6")*Convert*31 - Rel_Powell(yr,"M7")*Convert*30 - Rel_Powell(yr,"M8")*Convert*31 - Rel_Powell(yr,"M9")*Convert*30 - Rel_Powell(yr,"M10")*Convert*31 - Rel_Powell(yr,"M11")*Convert*31 - Rel_Powell(yr,"M12")*Convert*30 - evap_Powell(M)*Storage_Powell(yr,M);

EQ3_Powell_3rdyr(yr,M)$(ord (yr) eq 3)..          Storage_Powell(yr,M) =e=  Powell_yr2$(ord(M)eq 1)+ Storage_Powell(yr,M-1)$(ord(M)gt 1)+ Inflow_Powell(yr,M)- Rel_Powell(yr,"M1")*Convert*31 - Rel_Powell(yr,"M2")*Convert*30 - Rel_Powell(yr,"M3")*Convert*31 - Rel_Powell(yr,"M4")*Convert*31 - Rel_Powell(yr,"M5")*Convert*28 - Rel_Powell(yr,"M6")*Convert*31 - Rel_Powell(yr,"M7")*Convert*30 - Rel_Powell(yr,"M8")*Convert*31 - Rel_Powell(yr,"M9")*Convert*30 - Rel_Powell(yr,"M10")*Convert*31 - Rel_Powell(yr,"M11")*Convert*31 - Rel_Powell(yr,"M12")*Convert*30 - evap_Powell(M)*Storage_Powell(yr,M);

EQ4_Mead_1styr(yr,M)$(ord (yr) eq 1)..            Storage_Mead(yr,M) =e= Init_Mead$(ord(M)eq 1) + Storage_Powell(yr,M-1)$(ord(M)gt 1)+ Rel_Powell(yr,"M1")*Convert*31 + Rel_Powell(yr,"M2")*Convert*30 + Rel_Powell(yr,"M3")*Convert*31 + Rel_Powell(yr,"M4")*Convert*31 + Rel_Powell(yr,"M5")*Convert*28 + Rel_Powell(yr,"M6")*Convert*31 + Rel_Powell(yr,"M7")*Convert*30 + Rel_Powell(yr,"M8")*Convert*31 + Rel_Powell(yr,"M9")*Convert*30 + Rel_Powell(yr,"M10")*Convert*31 + Rel_Powell(yr,"M11")*Convert*31 + Rel_Powell(yr,"M12")*Convert*30+ Inflow_Paria(yr,M)+ Inflow_KanabCreek(yr,M)+ Inflow_Havasu(yr,M)+Inflow_Diamond(yr,M)+ Inflow_LitColorado(yr,M)-Rel_Mead(yr,"M1")*Convert*31 - Rel_Mead(yr,"M2")*Convert*30 - Rel_Mead(yr,"M3")*Convert*31 - Rel_Mead(yr,"M4")*Convert*31 - Rel_Mead(yr,"M5")*Convert*28 - Rel_Mead(yr,"M6")*Convert*31 - Rel_Mead(yr,"M7")*Convert*30 - Rel_Mead(yr,"M8")*Convert*31 - Rel_Mead(yr,"M9")*Convert*30 - Rel_Mead(yr,"M10")*Convert*31 - Rel_Mead(yr,"M11")*Convert*31 - Rel_Mead(yr,"M12")*Convert*30 - evap_Mead(M)*Storage_Mead(yr,M);

EQ5_Mead_2ndyr(yr,M)$(ord (yr) eq 2)..            Storage_Mead(yr,M) =e= Mead_yr1$(ord(M)eq 1) + Storage_Mead(yr,M-1)$(ord(M)gt 1)+ Rel_Powell(yr,"M1")*Convert*31 + Rel_Powell(yr,"M2")*Convert*30 + Rel_Powell(yr,"M3")*Convert*31 + Rel_Powell(yr,"M4")*Convert*31 + Rel_Powell(yr,"M5")*Convert*28 + Rel_Powell(yr,"M6")*Convert*31 + Rel_Powell(yr,"M7")*Convert*30 + Rel_Powell(yr,"M8")*Convert*31 + Rel_Powell(yr,"M9")*Convert*30 + Rel_Powell(yr,"M10")*Convert*31 + Rel_Powell(yr,"M11")*Convert*31 + Rel_Powell(yr,"M12")*Convert*30+ Inflow_Paria(yr,M)+ Inflow_KanabCreek(yr,M)+ Inflow_Havasu(yr,M)+Inflow_Diamond(yr,M)+ Inflow_LitColorado(yr,M)-Rel_Mead(yr,"M1")*Convert*31 - Rel_Mead(yr,"M2")*Convert*30 - Rel_Mead(yr,"M3")*Convert*31 - Rel_Mead(yr,"M4")*Convert*31 - Rel_Mead(yr,"M5")*Convert*28 - Rel_Mead(yr,"M6")*Convert*31 - Rel_Mead(yr,"M7")*Convert*30 - Rel_Mead(yr,"M8")*Convert*31 - Rel_Mead(yr,"M9")*Convert*30 - Rel_Mead(yr,"M10")*Convert*31 - Rel_Mead(yr,"M11")*Convert*31 - Rel_Mead(yr,"M12")*Convert*30 - evap_Mead(M)*Storage_Mead(yr,M);

EQ6_Mead_3rdyr(yr,M)$(ord (yr) eq 3)..            Storage_Mead(yr,M) =e= Mead_yr2$(ord(M)eq 1) + Storage_Mead(yr,M-1)$(ord(M)gt 1)+ Rel_Powell(yr,"M1")*Convert*31 + Rel_Powell(yr,"M2")*Convert*30 + Rel_Powell(yr,"M3")*Convert*31 + Rel_Powell(yr,"M4")*Convert*31 + Rel_Powell(yr,"M5")*Convert*28 + Rel_Powell(yr,"M6")*Convert*31 + Rel_Powell(yr,"M7")*Convert*30 + Rel_Powell(yr,"M8")*Convert*31 + Rel_Powell(yr,"M9")*Convert*30 + Rel_Powell(yr,"M10")*Convert*31 + Rel_Powell(yr,"M11")*Convert*31 + Rel_Powell(yr,"M12")*Convert*30+ Inflow_Paria(yr,M)+ Inflow_KanabCreek(yr,M)+ Inflow_Havasu(yr,M)+Inflow_Diamond(yr,M)+ Inflow_LitColorado(yr,M)-Rel_Mead(yr,"M1")*Convert*31 - Rel_Mead(yr,"M2")*Convert*30 - Rel_Mead(yr,"M3")*Convert*31 - Rel_Mead(yr,"M4")*Convert*31 - Rel_Mead(yr,"M5")*Convert*28 - Rel_Mead(yr,"M6")*Convert*31 - Rel_Mead(yr,"M7")*Convert*30 - Rel_Mead(yr,"M8")*Convert*31 - Rel_Mead(yr,"M9")*Convert*30 - Rel_Mead(yr,"M10")*Convert*31 - Rel_Mead(yr,"M11")*Convert*31 - Rel_Mead(yr,"M12")*Convert*30 - evap_Mead(M)*Storage_Mead(yr,M);

EQ7_maxstor_Powell(yr,M)..            Storage_Powell(yr,M)=l= Maxstorage_Powell;
EQ8_maxstor_Mead(yr,M)..              Storage_Mead(yr,M)=l= Maxstorage_Mead;
EQ9_minstor_Powell(yr,M)..            Storage_Powell(yr,M)=g= Minstorage_Powell;
EQ10_minstor_Mead(yr,M)..             Storage_Mead(yr,M)=g= Minstorage_Mead;
EQ11_MaxR_Powell(yr,M)..              Rel_Powell(yr,M)=L= Max_RelPowell;
EQ12_MaxR_Mead(yr,M)..                Rel_Mead(yr,M)=L= Max_RelMead;
EQ13_MinR_Powell(yr,M)..              Rel_Powell(yr,M)=g= Min_RelPowell;
EQ14_MinR_Mead(yr,M)..                Rel_Mead(yr,M)=g= Min_RelMead;
EQ15_TotVolPowell(yr)..               Vol_Powell(yr)=e= Rel_Powell(yr,"M1")*Convert*31 + Rel_Powell(yr,"M2")*Convert*30 + Rel_Powell(yr,"M3")*Convert*31 + Rel_Powell(yr,"M4")*Convert*31 + Rel_Powell(yr,"M5")*Convert*28 + Rel_Powell(yr,"M6")*Convert*31 + Rel_Powell(yr,"M7")*Convert*30 + Rel_Powell(yr,"M8")*Convert*31 + Rel_Powell(yr,"M9")*Convert*30 + Rel_Powell(yr,"M10")*Convert*31 + Rel_Powell(yr,"M11")*Convert*31 + Rel_Powell(yr,"M12")*Convert*30;
EQ16_TotVolMead(yr)..                 Vol_Mead(yr) =e= Rel_Mead(yr,"M1")*Convert*31 + Rel_Mead(yr,"M2")*Convert*30 + Rel_Mead(yr,"M3")*Convert*31 + Rel_Mead(yr,"M4")*Convert*31 + Rel_Mead(yr,"M5")*Convert*28 + Rel_Mead(yr,"M6")*Convert*31 + Rel_Mead(yr,"M7")*Convert*30 + Rel_Mead(yr,"M8")*Convert*31 + Rel_Mead(yr,"M9")*Convert*30 + Rel_Mead(yr,"M10")*Convert*31 + Rel_Mead(yr,"M11")*Convert*31 + Rel_Mead(yr,"M12")*Convert*30;







*********************************************************************************************

Powell_yr1= Storage_Powell("y1","M12");
Powell_yr2= Storage_Powell("y2","M12");

Mead_yr1= Storage_Mead("y1","M12");
Mead_yr2= Storage_Mead("y2","M12");