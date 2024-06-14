library(dplyr)
library(shiny)
library(reshape2)
library(readxl)
library(ggplot2)
#Set your working directory
setwd("C:/Users/brake/OneDrive/Documents/Masters/824 Data Visuals/Semester Project")

############# Data Processing
pj <- as.data.frame(read_xlsx("Final824.xlsx", col_names = T))

#missing values mean imputation
mrow <- pj[!complete.cases(pj),][1]
for(i in 1:length(mrow[[1]])) { 
  ifelse(is.na(pj[mrow[[1]][i],c(4:7)]),
         pj[mrow[[1]][i],c(4:7)] <- round(rowMeans(pj[mrow[[1]][i],c(4:7)], na.rm = T),0),"") 
}

#removing remainder of missing values 
rem <- pj[is.nan(pj$English),][,1]
pj_clean <- pj[-rem,]
pj_melt <- melt(pj_clean, measure.vars = c("English", "Math", "Science", "Reading"))

#removing errors
pj_melt <- pj_melt[-which(pj_melt$value<400),]
pj_clean <- pj_clean[-c(which(pj_clean$Math<400), which(pj_clean$English<400),
                        which(pj_clean$Science<400),which(pj_clean$Reading<400)),]

#creating/labeling factors
pj_melt$Flag <- factor(pj_melt$Flag)
levels(pj_melt$Flag) <- c("No Exceptionality","Exceptionality")
pj_melt$Ethnicity <- factor(pj_melt$Ethnicity)
levels(pj_melt$Ethnicity) <- c("Asian", "Black", "Hispanic","White")
pj_melt$Sex <- factor(pj_melt$Sex)
levels(pj_melt$Sex) <- c("Female","Male")
pj_melt$School <- factor(pj_melt$School)

pj_clean$Flag <- factor(pj_clean$Flag)
levels(pj_clean$Flag) <- c("No Exceptionality","Exceptionality")
pj_clean$Ethnicity <- factor(pj_clean$Ethnicity)
levels(pj_clean$Ethnicity) <- c("Asian", "Black", "Hispanic","White")
pj_clean$Sex <- factor(pj_clean$Sex)
levels(pj_clean$Sex) <- c("Female","Male")
pj_clean$School <- factor(pj_clean$School)
pj_clean$Avg <- rowMeans(pj_clean[c(4:7)])
## All Ethnicities 
pj_orig <- pj_clean

## Two Groups of Ethnicities
levels(pj_clean$Ethnicity) <- c("Asian", "Black", "Hispanic","White", "Other")
pj_clean$Ethnicity[pj_clean$Ethnicity == "Asian" | pj_clean$Ethnicity == "Black" | pj_clean$Ethnicity == "Hispanic"] <- "Other"

pj_clean$Ethnicity <- factor(pj_clean$Ethnicity)
levels(pj_clean$Ethnicity) <- c("White","Other")


### Static Visuals
pj_orig %>%
  ggplot(aes(Avg, GPA))+
  geom_point(aes(color=Ethnicity, shape=Sex))

pj_orig %>%
  ggplot(aes(Avg, GPA))+
  geom_point(aes(color=Sex))

pj_melt %>%
  ggplot(aes(value, GPA))+
  geom_point(aes(color = Ethnicity))+
  facet_wrap(.~variable)

pj_clean %>%
  ggplot(aes(Avg, GPA))+
  geom_point(aes(color=Sex))+
  facet_wrap(.~School)

pj_orig %>%
  ggplot(aes(Avg, GPA))+
  geom_point(aes(shape=Sex, color=Ethnicity))+
  facet_wrap(.~School)

pj_clean %>%
  ggplot(aes(Avg, GPA))+
  geom_point(aes(shape=Sex, color=Ethnicity))+
  facet_wrap(.~School)

pj_orig %>%
  ggplot(aes(Avg, GPA))+
  geom_point(aes(color=Flag))+
  facet_wrap(.~School)

pj_orig %>%
  ggplot(aes(Avg, GPA))+
  geom_point(aes(color=Ethnicity, shape= Flag))+
  facet_wrap(.~School)

#correlation
pj_melt %>%
  ggplot(aes(value, GPA))+
  geom_point(aes(color=Ethnicity, shape= Flag))+
  geom_smooth(aes(value, GPA), method="lm")+
  facet_wrap(.~variable)

pj_orig %>%
  ggplot(aes(Avg, GPA))+
  geom_point(aes(color=Ethnicity))+
  geom_smooth(aes(Avg, GPA), method="lm")+
  facet_wrap(.~Flag)

pj_orig %>%
  ggplot(aes(Avg, GPA))+
  geom_point(aes(color=Ethnicity))+
  geom_smooth(aes(Avg, GPA), method="lm")+
  facet_wrap(.~Sex)

pj_orig %>%
  ggplot(aes(Avg, GPA))+
  geom_point(aes(color=Ethnicity, shape= Flag))+
  geom_smooth(aes(Avg, GPA), method="lm")+
  facet_wrap(.~School)

#interactive plots
######### Assessment inequality by race/Gender
# test <- sort(unique(pj_melt$variable))
# flag <- unique(pj_melt$Flag)
# 
# ui = fluidPage(
#   titlePanel("GPA by Standardized Assessment Score"),
#   
#   sidebarLayout(
#     sidebarPanel(
#       selectInput(inputId = "assessment",
#                   h3("Assessment"),
#                   choices = test,
#                   selected = 1),
#       selectInput(inputId = "flag",
#                   h3("Flag"),
#                   choices =  flag,
#                   selected = 1)
#     ),
#     mainPanel(
#       plotOutput(outputId = "scorePlot")
#     )
#   )
# )
# 
# server = function(input, output) {
#   output$scorePlot = renderPlot({
#     
#     ggplot(pj_melt[pj_melt$variable == input$assessment & pj_melt$Flag == input$flag,]) +
#       geom_point(aes(x = value,
#                      y = GPA,
#                      shape = Sex,
#                      color = Ethnicity))+
#       theme_bw() +
#       labs(x = "Standardized Assessment Score", 
#            y = "GPA",
#            color = "Ethnicity",
#            shape = "Gender") +
#       xlim(c(400, 450)) +
#       ylim(c(0, 4)) +
#       geom_smooth(method = "lm", aes(x=value, y=GPA))
#   })
# }
# 
# shinyApp(ui = ui, server = server)

###### GPA and Average Assessment by School
school <- sort(unique(pj_orig$School))
sex <- unique(pj_orig$Sex)

ui = fluidPage(
  titlePanel("GPA by Standardized Assessment Average"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput(inputId = "school",
                  h3("Primary School"),
                  choices = school,
                  selected = 1),
      selectInput(inputId = "gender",
                  h3("Gender"),
                  choices =  sex,
                  selected = 1)
    ),
    mainPanel(
      plotOutput(outputId = "avgPlot")
    )
  )
)

server = function(input, output) {
  output$avgPlot = renderPlot({
    
    ggplot(pj_orig[pj_orig$School == input$school & pj_orig$Sex == input$gender,]) +
      geom_point(aes(x = Avg,
                     y = GPA,
                     shape = Flag,
                     color = Ethnicity))+
      theme_bw() +
      labs(x = "Average Standardized Assessment Score", 
           y = "GPA",
           color = "Ethnicity") +
      xlim(c(400, 450)) +
      ylim(c(0, 4)) +
      geom_smooth(method = "lm", aes(x=Avg, y=GPA))
  })
}

shinyApp(ui = ui, server = server)
