---
title: "Getting and cleaning data"
author: "Evgeny Karpushkin"
---

```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```

## Script description

The script in "run_analysis.R" file consists of several steps.

* First, the data are downloaded to a working directory and unzipped. Moreover, "tidyverse" package is loaded (it creates the functions required to perform the analysis).

* Second, necessary data files are imported into R dataframes. The data on the subject ID and its activities are merged with the variables recorded from the accelerometers. In view of further data analysis, only the variables with the mean values and standard deviation are left in the merged dataset. Correspondence of the variables to mean or standard deviation statistic was found from the presence of "mean()" or "std()" in the variable name, respectively. These operations were performed separately for the training and testing datasets, and finally two obtained dataframes were merged into the single "all_df" dataset. Overall, this part of the script performs steps 1 and 2 of the task.

* Then, steps 3 and 4 of the task were performed by replacing the numeric variable for activity type with a factor variable containing recognizable strings as labels. To make the variables names simpler, useledd "()" were removed from the columns name. Otherwise, the column names were found well recognizable (see the codebook for more detail).

* Finally, step 5 was performed by grouping the obtained dataframe with respect to the subject ID and activity type, and then average values for each variable were obtained within each group. The obtained dataset was converted in the long tidy format to separate each original variable (containing information about the recorded signal and its statistics) into two cleaner variables.  

## Dataset description

The dataset obtained as described above contains 11880 observations: 6 activity types for 30 subjects under investigation gives 80 "subject-activity" pairs, for each of which 66 pairs of measured variable and statistics applied (mean or standard deviation) occurs. 

Hence, each observation in the created dataset contains 5 variables: "subject" identifying the person tested, "activity" identifying the person's activity type, "signal" showing the signal measured in the experiment (see details in the codebook), "statistics" showing the processing (mean or standard deviation) applied to the measured signal to obtain the original dataset, and "value" containing the average of the respective signal parameter in the original dataset for each combination of subject and activity.



