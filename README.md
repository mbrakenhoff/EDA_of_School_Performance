# EDA of School Perfomance

This project aims to visualize and analyze the performance of students in a high school, with a focus on identifying potential disparities based on ethnicity, gender, and primary school attended. The analysis also explores the relationship between GPA and standardized test scores to identify students in need of additional support.

## Table of Contents
- [Introduction](#introduction)
- [Aims](#aims)
- [Data Sources](#data-sources)
- [Preliminary Analysis](#preliminary-analysis)
- [Visual Analysis](#visual-analysis)
- [Conclusions](#conclusions)
- [Getting Started](#getting-started)
- [Files](#files)


## Introduction

This project focuses on:
- Ensuring equal educational opportunities for all students.
- Identifying primary schools that may hinder student performance.
- Using standardized test scores to identify students who may need further support early in their high school careers.

## Aims

1. Visualize data to uncover any inconsistencies or patterns indicating inequality.
2. Explore the impact of primary schools on GPA and standardized test performance.
3. Examine the correlation between GPA and standardized test scores to identify students needing additional support.

## Data Sources

Data was collected from a high school over three years (2015-2018) and includes:
- **GPA** at the end of the Geometry class.
- **Primary school** attended.
- **Flag** for special services.
- **Gender** and **Race** of students.
- **ACT Aspire Scores** in English, Math, Reading, and Science.

## Preliminary Analysis

- Addressed missing values with mean imputation.
- Identified and removed data entry errors.
- Checked for outliers and handled sparse data in categorical variables.

## Visual Analysis

Explored data through various visualizations to highlight issues with performance disparities based on ethnicity, gender, and primary school attended.

## Conclusions

Identified significant performance disparities among black and Hispanic students, particularly those transferring into the district. Noted the influence of primary school on GPA and standardized test scores.

## Getting Started

### Prerequisites

- R and RStudio installed
- Required R libraries: `readxl`, `dplyr`, `reshape2`, `ggplot2`, `knitr`, `DT`

### Installation

1. Clone the repository:
    ```sh
    git clone https://github.com/mbrakenhoff/EDA_of_School_Performance.git
    ```
2. Open the project in RStudio.
3. Install the required libraries if not already installed:
    ```r
    install.packages(c("readxl", "dplyr", "reshape2", "ggplot2", "knitr", "DT"))
    ```
4. Run the `Workstation.R` script to load and preprocess the data.

### Usage

Run the R Markdown document (`school_performance.Rmd`) to generate the analysis report or view the html files in a browser.

## Files

- `school_performance.Rmd`: R Markdown file containing the analysis.
- `school_performance.html`: HTML file showing the completed knitting of the R Markdown document.
- `flexboard_presentation.html`: HTML file showing a flexboard used for presentation.

## Shiny Apps

- https://mbrakenhoff.shinyapps.io/Assessment_Shiny/ : Shiny Interactive Visual for GPA by Assessment type. 
- https://mbrakenhoff.shinyapps.io/School_Shiny/ : Shiny Interactive Visual comparing GPA by School.

