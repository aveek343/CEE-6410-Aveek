#####################
# This script is written to create the box-whiskers plot and the parallel coordinate plots for assignment-7 of CEE 6410
# Created by: Mahmudur Rahman Aveek

# Reaquired library
  library(plotly)
  library(dplyr)
  library(reshape2)
  library(ggplot2)

# Read the original CSV file which is my case "HW7_alts_Original.csv"
  setwd("D:\\Courses\\Fall 2020\\CEE6410\\Assignment\\Assignment-7\\NSGA2-Matlab\\NSGA2-Matlab")
  Assignment7_data_Original <- as.data.frame(read.csv("HW7_alts_Original.csv"))

  
   Assignment7_data_Original$irr_hydro_unmet_range <- ifelse(Assignment7_data_Original$UnmetIrrDemand<=10.8,1,
                                                             ifelse(Assignment7_data_Original$UnmetIrrDemand>10.8 & Assignment7_data_Original$UnmetIrrDemand<=10.9,2,
                                                                    ifelse(Assignment7_data_Original$UnmetIrrDemand>10.9 & Assignment7_data_Original$UnmetIrrDemand<=11,3,
                                                                           ifelse(Assignment7_data_Original$UnmetIrrDemand>11 & Assignment7_data_Original$UnmetIrrDemand<=12,4,
                                                                                  ifelse(Assignment7_data_Original$UnmetIrrDemand>12 & Assignment7_data_Original$UnmetIrrDemand<=13,5,6)))))
  
   
   
  
   IrrDemandVsHydroDemandDeficit <- ggplot()+geom_point(data=Assignment7_data_Original, mapping =aes(x=UnmetIrrDemand,y=UnmetHydroDemand))+
     ggtitle("Unmet Irrigation Demand vs Unmet Hydropower Demand")+ 
     xlab("Unmet Irrigation Demand (m3/day)")+ylab("Unmet Hydropower Demand (m3/day)")
   
   IrrDemandVsHydroDemandDeficit   
   
   
   IrrDemandVsRecreationDemandDeficit <- ggplot()+geom_point(data=Assignment7_data_Original, mapping =aes(x=UnmetIrrDemand,y=UnmetRecreationDemand))+
     ggtitle("Unmet Irrigation Demand vs Unmet Recreation Demand")+ 
     xlab("Unmet Irrigation Demand (m3/day)")+ylab("Unmet Recreation Demand (m3)")
   
   IrrDemandVsRecreationDemandDeficit 
   
   IrrDemandVsFloodIntensity <- ggplot()+geom_point(data=Assignment7_data_Original, mapping =aes(x=UnmetIrrDemand,y=FloodIntensity))+
     ggtitle("Unmet Irrigation Demand vs Flood Intensity")+ 
     xlab("Unmet Irrigation Demand (m3/day)")+ylab("Flood Intensity (m)")
   
   IrrDemandVsFloodIntensity 
   
   
   FloodDensityvsUnmetRecreation <- ggplot()+geom_point(data=Assignment7_data_Original, mapping =aes(x=UnmetRecreationDemand,y=FloodIntensity))+
     ggtitle("Flood Intensity vs Unmet Recreation Demand")+ 
     xlab("Unmet Recreation Demand (m3)")+ylab("Flood Intensity (m)")
   
   FloodDensityvsUnmetRecreation
   
   
   
   
    DifferentPlot1 <- ggplot()+geom_point(data=Assignment7_data_Original, mapping =aes(x=UnmetRecreationDemand,y=FloodIntensity,
                                                                                      col=as.factor(irr_hydro_unmet_range),group = irr_hydro_unmet_range))+
     scale_color_manual("Unmet Irrigation or\nHydropower Demand\n(m^3/day)",values=c('#AB0CFA','#330CFA','#5AC7CC','#10C4CA','#10A8CA','#1086CA'), labels=c("<10.8", "10.8-10.9", "10.9-11.0",
                                                                                                                                  "11-12","12-13",">13"))+
       ggtitle(paste0("Flood Intensity vs Unmet Recreation demand\nthe colored points are showing unmet irrigation/hydropower demand"))+ 
       ylab("Flood Intensity (m)")+xlab("Unmet Recreation Demand(m^3)")
     
   DifferentPlot1   
     
final_decision <-Assignment7_data_Original[Assignment7_data_Original$Dominance>30,]
  
DifferentPlot_final <- ggplot()+geom_point(data=Assignment7_data_Original[Assignment7_data_Original$Dominance>30,], mapping =aes(x=UnmetRecreationDemand,y=FloodIntensity,
                                                                                   col=as.factor(irr_hydro_unmet_range),group = irr_hydro_unmet_range))+
  scale_color_manual("Unmet Irrigation or\nHydropower Demand\n(m^3/day)",values=c('#10C4CA'), labels=c("11-12"))+
  ggtitle(paste0("Flood Intensity vs Unmet Recreation demand\nthe colored points are showing unmet irrigation/hydropower demand"))+ 
  ylab("Flood Intensity (m)")+xlab("Unmet Recreation Demand(m^3)")

DifferentPlot_final 


 
   # Plotting data parallel coordinate plot in plotly
  Assignment7ParCordFile <- Assignment7_data_Original[Assignment7_data_Original$Dominance>30,] %>%
    plot_ly(type = 'parcoords',
            line = list(color = ~ "Assignment7_data_Original$UnmetIrrDemand",
                        colorscale = 'Blues',
                        showscale = TRUE,
                        reversescale = TRUE,
                        cmin = min(Assignment7_data_Original$UnmetIrrDemand),
                        cmax = max(Assignment7_data_Original$UnmetIrrDemand)),
            dimensions = list(
              list(range = c(~min(FloodIntensity),~max(FloodIntensity)),
                   label = 'Flood Intensity', values = ~FloodIntensity),
              list(range = c(~min(UnmetIrrDemand),~max(UnmetIrrDemand)),
                   label = 'Unmet Irrigation Demand (m3/d)', values = ~UnmetIrrDemand),
              list(range = c(~min(UnmetHydroDemand),~max(UnmetHydroDemand)),
                   label = 'Unmet Hydropower Demand (m3/d)', values = ~UnmetHydroDemand),
              list(range = c(~min(UnmetRecreationDemand),~max(UnmetRecreationDemand)),
                   label = 'Recreation Storage Deficit (m3)', values = ~UnmetRecreationDemand),
              list(range = c(~min(x1),~max(x1)),
                   label = 'Shortage Slope (x1; radians)', values = ~x1),
              list(range = c(~min(x2),~max(x2)),
                   label = 'Spill Trigger (x2; m3)', values = ~x2),
              list(range = c(~min(x3),~max(x3)),
                   label = 'Spill Slope (x3; radians)', values = ~x3),
              list(range = c(~min(Dominance),~max(Dominance)),
                   label = 'Dominance', values = ~Dominance)
              
            )
    )
  
  Assignment7ParCordFile
  
  
  ###########################################################################################################################################
  # Create a basic box plot with ggplot
  Assignment7_data_Original2 <- as.data.frame(read.csv("HW7_alts_Original.csv"))
  Assignment7_data_Original2$Difference <- "Original"
  
  Assignment7_data_100Pop <- as.data.frame(read.csv("HW7_pop100_gen20_it10.csv"))
  Assignment7_data_300Pop<-as.data.frame(read.csv("HW7_pop300gen20it10.csv"))
  ####################################
  Assignment7_data_300Pop$irr_hydro_unmet_range <- ifelse(Assignment7_data_300Pop$UnmetIrrDemand<=10.8,1,
                                                            ifelse(Assignment7_data_300Pop$UnmetIrrDemand>10.8 & Assignment7_data_300Pop$UnmetIrrDemand<=10.9,2,
                                                                   ifelse(Assignment7_data_300Pop$UnmetIrrDemand>10.9 & Assignment7_data_300Pop$UnmetIrrDemand<=11,3,
                                                                          ifelse(Assignment7_data_300Pop$UnmetIrrDemand>11 & Assignment7_data_300Pop$UnmetIrrDemand<=12,4,
                                                                                 ifelse(Assignment7_data_300Pop$UnmetIrrDemand>12 & Assignment7_data_300Pop$UnmetIrrDemand<=13,5,6)))))
  
  
  
  DifferentPlot2 <- ggplot()+geom_point(data=Assignment7_data_300Pop[Assignment7_data_300Pop$Dominance>40,], mapping =aes(x=UnmetRecreationDemand,y=FloodIntensity,
                                                                                     col=as.factor(irr_hydro_unmet_range),group = irr_hydro_unmet_range))+
    scale_color_manual("Unmet Irrigation or\nHydropower Demand\n(m^3/day)",values=c('#10C4CA'), labels=c("11-12"))+
    ggtitle(paste0("Flood Intensity vs Unmet Recreation demand\nthe colored points are showing unmet irrigation/hydropower demand"))+ 
    ylab("Flood Intensity (m)")+xlab("Unmet Recreation Demand(m^3)")
  
  DifferentPlot2 
  
  Assignment7_data_10Gen <- as.data.frame(read.csv("HW7_pop200_gen10_it10.csv"))
  Assignment7_data_30Gen <-as.data.frame(read.csv("HW7_pop200gen30it10.csv"))
  
  ####################################
  Assignment7_data_30Gen$irr_hydro_unmet_range <- ifelse(Assignment7_data_30Gen$UnmetIrrDemand<=10.8,1,
                                                          ifelse(Assignment7_data_30Gen$UnmetIrrDemand>10.8 & Assignment7_data_30Gen$UnmetIrrDemand<=10.9,2,
                                                                 ifelse(Assignment7_data_30Gen$UnmetIrrDemand>10.9 & Assignment7_data_30Gen$UnmetIrrDemand<=11,3,
                                                                        ifelse(Assignment7_data_30Gen$UnmetIrrDemand>11 & Assignment7_data_30Gen$UnmetIrrDemand<=12,4,
                                                                               ifelse(Assignment7_data_30Gen$UnmetIrrDemand>12 & Assignment7_data_30Gen$UnmetIrrDemand<=13,5,6)))))
  
  
  
  DifferentPlot3 <- ggplot()+geom_point(data=Assignment7_data_30Gen[Assignment7_data_30Gen$Dominance>30,], mapping =aes(x=UnmetRecreationDemand,y=FloodIntensity,
                                                                                                                          col=as.factor(irr_hydro_unmet_range),group = irr_hydro_unmet_range))+
    scale_color_manual("Unmet Irrigation or\nHydropower Demand\n(m^3/day)",values=c('#330CFA','#10C4CA'), labels=c("10.8-10.9","11-12"))+
    ggtitle(paste0("Flood Intensity vs Unmet Recreation demand\nthe colored points are showing unmet irrigation/hydropower demand"))+ 
    ylab("Flood Intensity (m)")+xlab("Unmet Recreation Demand(m^3)")
  
  DifferentPlot3 
  
  Assignment7_data_5It  <- as.data.frame(read.csv("HW7_pop200gen20it5.csv"))
  Assignment7_data_30It <-as.data.frame(read.csv("HW7_pop200gen20It30.csv"))
  ####################################
  Assignment7_data_30It$irr_hydro_unmet_range <- ifelse(Assignment7_data_30It$UnmetIrrDemand<=10.8,1,
                                                         ifelse(Assignment7_data_30It$UnmetIrrDemand>10.8 & Assignment7_data_30It$UnmetIrrDemand<=10.9,2,
                                                                ifelse(Assignment7_data_30It$UnmetIrrDemand>10.9 & Assignment7_data_30It$UnmetIrrDemand<=11,3,
                                                                       ifelse(Assignment7_data_30It$UnmetIrrDemand>11 & Assignment7_data_30It$UnmetIrrDemand<=12,4,
                                                                              ifelse(Assignment7_data_30It$UnmetIrrDemand>12 & Assignment7_data_30It$UnmetIrrDemand<=13,5,6)))))
  
  
  
  DifferentPlot4 <- ggplot()+geom_point(data=Assignment7_data_30It[Assignment7_data_30It$Dominance>30,], mapping =aes(x=UnmetRecreationDemand,y=FloodIntensity,
                                                                                                                        col=as.factor(irr_hydro_unmet_range),group = irr_hydro_unmet_range))+
    scale_color_manual("Unmet Irrigation or\nHydropower Demand\n(m^3/day)",values=c('#330CFA','#5AC7CC','#10C4CA'), labels=c("10.8-10.9","10.9-11.0","11-12"))+
    ggtitle(paste0("Flood Intensity vs Unmet Recreation demand\nthe colored points are showing unmet irrigation/hydropower demand"))+ 
    ylab("Flood Intensity (m)")+xlab("Unmet Recreation Demand(m^3)")
  
  DifferentPlot4 
  
  
  Assignment7_different_Data <- rbind(Assignment7_data_Original2,Assignment7_data_100Pop,Assignment7_data_300Pop,
                                      Assignment7_data_10Gen,Assignment7_data_30Gen,
                                      Assignment7_data_5It,Assignment7_data_30It)
  
  Assignment7_different_Data_melt <- melt(Assignment7_different_Data,var.id="Difference")
  
  
  #####################
  # Flood Intensity
  Assignment7_different_Data_FloodIntensity = subset(Assignment7_different_Data_melt, variable=="FloodIntensity")
  # The box-whiskers's plot
  Assignment7_data_100Pop_box_FloodIntensity<-ggplot(Assignment7_different_Data_FloodIntensity, aes(x=factor(Difference), y=value)) +
    geom_boxplot()+ggtitle("Difference when parameters are changed for Flood Intensity")+
    xlab("Changed Parameters in the Matlab Code\nfrom original Generation Value of 20,\niteration value of 10,\nPopulation value of 200")
  Assignment7_data_100Pop_box_FloodIntensity
  
  
  ########################
  # Unmet Irrigation Demand
  Assignment7_different_Data_UnmetIrrDemand = subset(Assignment7_different_Data_melt, variable=="UnmetIrrDemand")
  # The box-whiskers's plot
   Assignment7_data_100Pop_box_UnmetIrrDemand<-ggplot(Assignment7_different_Data_UnmetIrrDemand, aes(x=factor(Difference), y=value)) +
    geom_boxplot()+ggtitle("Difference when parameters are changed for Unmet Irrigation Demand")+
  xlab("Changed Parameters in the Matlab Code\nfrom original Generation Value of 20,\niteration value of 10,\nPopulation value of 200")
   Assignment7_data_100Pop_box_UnmetIrrDemand
  
  
  ##################
  # Hydro Demand 
    Assignment7_different_Data_UnmetHydroDemand = subset(Assignment7_different_Data_melt, variable=="UnmetHydroDemand")
   # The box-whiskers's plot
   Assignment7_data_100Pop_box_UnmetHydroDemand<-ggplot(Assignment7_different_Data_UnmetHydroDemand, aes(x=factor(Difference), y=value)) +
     geom_boxplot()+ggtitle("Difference when parameters are changed for Unmet Hydro Demand")+
     xlab("Changed Parameters in the Matlab Code\nfrom original Generation Value of 20,\niteration value of 10,\nPopulation value of 200")
   Assignment7_data_100Pop_box_UnmetHydroDemand
  
  #####################
  # Recreation Demand
   Assignment7_different_Data_UnmetRecreationDemand = subset(Assignment7_different_Data_melt, variable=="UnmetRecreationDemand")
   # The box-whiskers's plot
   Assignment7_data_100Pop_box_UnmetRecreationDemand<-ggplot(Assignment7_different_Data_UnmetRecreationDemand, aes(x=factor(Difference), y=value)) +
     geom_boxplot()+ggtitle("Difference when parameters are changed for Unmet Recreation Demand")+
     xlab("Changed Parameters in the Matlab Code\nfrom original Generation Value of 20,\niteration value of 10,\nPopulation value of 200")
   Assignment7_data_100Pop_box_UnmetRecreationDemand
  
  ######################  
  #x1
    Assignment7_different_Data_x1 = subset(Assignment7_different_Data_melt, variable=="x1")
   # The box-whiskers's plot
   Assignment7_data_100Pop_box_x1<-ggplot(Assignment7_different_Data_x1, aes(x=factor(Difference), y=value)) +
     geom_boxplot()+ggtitle("Difference when parameters are changed for x1")+
     xlab("Changed Parameters in the Matlab Code\nfrom original Generation Value of 20,\niteration value of 10,\nPopulation value of 200")
   Assignment7_data_100Pop_box_x1
  
  ######################
   #x2
  Assignment7_different_Data_x2 = subset(Assignment7_different_Data_melt, variable=="x2")
   # The box-whiskers's plot
   Assignment7_data_100Pop_box_x2<-ggplot(Assignment7_different_Data_x2, aes(x=factor(Difference), y=value)) +
     geom_boxplot()+ggtitle("Difference when parameters are changed for x2")+
     xlab("Changed Parameters in the Matlab Code\nfrom original Generation Value of 20,\niteration value of 10,\nPopulation value of 200")
   Assignment7_data_100Pop_box_x2
   
  #######################
   #x3
  Assignment7_different_Data_x3 = subset(Assignment7_different_Data_melt, variable=="x3")
   # The box-whiskers's plot
   Assignment7_data_100Pop_box_x3<-ggplot(Assignment7_different_Data_x3, aes(x=factor(Difference), y=value)) +
     geom_boxplot()+ggtitle("Difference when parameters are changed for x3")+
     xlab("Changed Parameters in the Matlab Code\nfrom original Generation Value of 20,\niteration value of 10,\nPopulation value of 200")
   Assignment7_data_100Pop_box_x3
  ######################
  
  
  
  
  
  
  
  
  
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # 
  # SummaryStatistic_different <-Assignment7_different_Data%>%
  #   group_by(Difference)%>%
  #   summarize(
  #     FloodIntensity_Min = min(FloodIntensity),
  #     FloodIntensity_1stQuantile=quantile(FloodIntensity,probs=.25),
  #     FloodIntensity_Mean = mean(FloodIntensity),
  #     FloodIntensity_Median = median(FloodIntensity),
  #     FloodIntensity_3rdQuantile=quantile(FloodIntensity,probs=.75),
  #     FloodIntensity_Max = max(FloodIntensity),
  #     
  #     UnmetIrrDemand_Min = min(UnmetIrrDemand),
  #     UnmetIrrDemand_1stQuantile=quantile(UnmetIrrDemand,probs=.25),
  #     UnmetIrrDemand_Mean = mean(UnmetIrrDemand),
  #     UnmetIrrDemand_Median = median(UnmetIrrDemand),
  #     UnmetIrrDemand_3rdQuantile=quantile(UnmetIrrDemand,probs=.75),
  #     UnmetIrrDemand_Max = max(UnmetIrrDemand),
  #     
  #     UnmetHydroDemand_Min = min(UnmetHydroDemand),
  #     UnmetHydroDemand_1stQuantile=quantile(UnmetHydroDemand,probs=.25),
  #     UnmetHydroDemand_Mean = mean(UnmetHydroDemand),
  #     UnmetHydroDemand_Median = median(UnmetHydroDemand),
  #     UnmetHydroDemand_3rdQuantile=quantile(UnmetHydroDemand,probs=.75),
  #     UnmetHydroDemand_Max = max(UnmetHydroDemand),
  #     
  #     UnmetRecreationDemand_Min = min(UnmetRecreationDemand),
  #     UnmetRecreationDemand_1stQuantile=quantile(UnmetRecreationDemand,probs=.25),
  #     UnmetRecreationDemand_Mean = mean(UnmetRecreationDemand),
  #     UnmetRecreationDemand_Median = median(UnmetRecreationDemand),
  #     UnmetRecreationDemand_3rdQuantile=quantile(UnmetRecreationDemand,probs=.75),
  #     UnmetRecreationDemand_Max = max(UnmetRecreationDemand),
  #     
  #     x1_Min = min(x1),
  #     x1_1stQuantile=quantile(x1,probs=.25),
  #     x1_Mean = mean(x1),
  #     x1_Median = median(x1),
  #     x1_3rdQuantile=quantile(x1,probs=.75),
  #     x1_Max = max(x1),
  #     
  #     x2_Min = min(x2),
  #     x2_1stQuantile=quantile(x2,probs=.25),
  #     x2_Mean = mean(x2),
  #     x2_Median = median(x2),
  #     x2_3rdQuantile=quantile(x2,probs=.75),
  #     x2_Max = max(x2),
  #     
  #     x3_Min = min(x3),
  #     x3_1stQuantile=quantile(x3,probs=.25),
  #     x3_Mean = mean(x3),
  #     x3_Median = median(x3),
  #     x3_3rdQuantile=quantile(x3,probs=.75),
  #     x3_Max = max(x3)
  #   )
  # 
  # 






   Assignment7_data_100Pop 
   Assignment7_data_300Pop
   
   Assignment7_data_10Gen 
   Assignment7_data_30Gen 
   
   Assignment7_data_5It 
   Assignment7_data_30It 







#X<-Assignment7_data_100Pop
# X<-Assignment7_data_300Pop
#X<-Assignment7_data_10Gen
# X<-Assignment7_data_30Gen
#X<-Assignment7_data_5It






# Plotting data parallel coordinate plot in plotly for 30 iteration alternative
   X<-Assignment7_data_30It
   Assignment7ParCordFile_30It <- X[X$Dominance>30,] %>%
  plot_ly(type = 'parcoords',
          line = list(color = ~ "X$UnmetIrrDemand",
                      colorscale = 'Blues',
                      showscale = TRUE,
                      reversescale = TRUE,
                      cmin = min(X$UnmetIrrDemand),
                      cmax = max(X$UnmetIrrDemand)),
          dimensions = list(
            list(range = c(~min(FloodIntensity),~max(FloodIntensity)),
                 label = 'Flood Intensity', values = ~FloodIntensity),
            list(range = c(~min(UnmetIrrDemand),~max(UnmetIrrDemand)),
                 label = 'Unmet Irrigation Demand (m3/d)', values = ~UnmetIrrDemand),
            list(range = c(~min(UnmetHydroDemand),~max(UnmetHydroDemand)),
                 label = 'Unmet Hydropower Demand (m3/d)', values = ~UnmetHydroDemand),
            list(range = c(~min(UnmetRecreationDemand),~max(UnmetRecreationDemand)),
                 label = 'Recreation Storage Deficit (m3)', values = ~UnmetRecreationDemand),
            list(range = c(~min(x1),~max(x1)),
                 label = 'Shortage Slope (x1; radians)', values = ~x1),
            list(range = c(~min(x2),~max(x2)),
                 label = 'Spill Trigger (x2; m3)', values = ~x2),
            list(range = c(~min(x3),~max(x3)),
                 label = 'Spill Slope (x3; radians)', values = ~x3),
            list(range = c(~min(Dominance),~max(Dominance)),
                 label = 'Dominance', values = ~Dominance)
            

          )
  )

Assignment7ParCordFile_30It
###########################################################
##### 300 population
 X<-Assignment7_data_300Pop
Assignment7ParCordFile_300Pop <- X[X$Dominance>30,] %>%
  plot_ly(type = 'parcoords',
          line = list(color = ~ "X$UnmetIrrDemand",
                      colorscale = 'Blues',
                      showscale = TRUE,
                      reversescale = TRUE,
                      cmin = min(X$UnmetIrrDemand),
                      cmax = max(X$UnmetIrrDemand)),
          dimensions = list(
            list(range = c(~min(FloodIntensity),~max(FloodIntensity)),
                 label = 'Flood Intensity', values = ~FloodIntensity),
            list(range = c(~min(UnmetIrrDemand),~max(UnmetIrrDemand)),
                 label = 'Unmet Irrigation Demand (m3/d)', values = ~UnmetIrrDemand),
            list(range = c(~min(UnmetHydroDemand),~max(UnmetHydroDemand)),
                 label = 'Unmet Hydropower Demand (m3/d)', values = ~UnmetHydroDemand),
            list(range = c(~min(UnmetRecreationDemand),~max(UnmetRecreationDemand)),
                 label = 'Recreation Storage Deficit (m3)', values = ~UnmetRecreationDemand),
            list(range = c(~min(x1),~max(x1)),
                 label = 'Shortage Slope (x1; radians)', values = ~x1),
            list(range = c(~min(x2),~max(x2)),
                 label = 'Spill Trigger (x2; m3)', values = ~x2),
            list(range = c(~min(x3),~max(x3)),
                 label = 'Spill Slope (x3; radians)', values = ~x3),
            list(range = c(~min(Dominance),~max(Dominance)),
                 label = 'Dominance', values = ~Dominance)
            
            
          )
  )

Assignment7ParCordFile_300Pop


###############################################################
X<-Assignment7_data_30Gen
# Plotting data parallel coordinate plot in plotly for 30 iteration alternative
Assignment7ParCordFile_30Gen <- X[X$Dominance>30,] %>%
  plot_ly(type = 'parcoords',
          line = list(color = ~ "X$UnmetIrrDemand",
                      colorscale = 'Blues',
                      showscale = TRUE,
                      reversescale = TRUE,
                      cmin = min(X$UnmetIrrDemand),
                      cmax = max(X$UnmetIrrDemand)),
          dimensions = list(
            list(range = c(~min(FloodIntensity),~max(FloodIntensity)),
                 label = 'Flood Intensity', values = ~FloodIntensity),
            list(range = c(~min(UnmetIrrDemand),~max(UnmetIrrDemand)),
                 label = 'Unmet Irrigation Demand (m3/d)', values = ~UnmetIrrDemand),
            list(range = c(~min(UnmetHydroDemand),~max(UnmetHydroDemand)),
                 label = 'Unmet Hydropower Demand (m3/d)', values = ~UnmetHydroDemand),
            list(range = c(~min(UnmetRecreationDemand),~max(UnmetRecreationDemand)),
                 label = 'Recreation Storage Deficit (m3)', values = ~UnmetRecreationDemand),
            list(range = c(~min(x1),~max(x1)),
                 label = 'Shortage Slope (x1; radians)', values = ~x1),
            list(range = c(~min(x2),~max(x2)),
                 label = 'Spill Trigger (x2; m3)', values = ~x2),
            list(range = c(~min(x3),~max(x3)),
                 label = 'Spill Slope (x3; radians)', values = ~x3),
            list(range = c(~min(Dominance),~max(Dominance)),
                 label = 'Dominance', values = ~Dominance)
            
            
          )
  )

Assignment7ParCordFile_30Gen  

