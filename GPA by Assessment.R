library(dplyr)
library(shiny)
library(reshape2)
library(readxl)
library(ggplot2)
#setting working directory
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


#interactive plots
######### Assessment inequality by race/Gender
test <- sort(unique(pj_melt$variable))
flag <- unique(pj_melt$Flag)

ui = fluidPage(
  titlePanel("GPA by Standardized Assessment Score"),
  
  sidebarLayout(
    sidebarPanel(
      selectInput(inputId = "assessment",
                  h3("Assessment"),
                  choices = test,
                  selected = 1),
      selectInput(inputId = "flag",
                  h3("Flag"),
                  choices =  flag,
                  selected = 1)
    ),
    mainPanel(
      plotOutput(outputId = "scorePlot")
    )
  )
)

server = function(input, output) {
  output$scorePlot = renderPlot({
    
    ggplot(pj_melt[pj_melt$variable == input$assessment & pj_melt$Flag == input$flag,]) +
      geom_point(aes(x = value,
                     y = GPA,
                     shape = Sex,
                     color = Ethnicity))+
      theme_bw() +
      labs(x = "Standardized Assessment Score", 
           y = "GPA",
           color = "Ethnicity",
           shape = "Gender") +
      xlim(c(400, 450)) +
      ylim(c(0, 4)) +
      geom_smooth(method = "lm", aes(x=value, y=GPA))
  })
}

shinyApp(ui = ui, server = server)
