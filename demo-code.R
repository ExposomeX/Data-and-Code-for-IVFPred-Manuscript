# install "IVFPred" packages----------------
# install.packages('devtools')
devtools::install_github('https://github.com/ExposomeX/IVFPred.git')
# library package
library(IVFPred)
# Step 0. Start
res <- InitIVF()
# Step 1. LoadData
res1 = LoadIVF(PID = res$PID,
               DataPath = 'demo-data/Clinical_Pregnancy_demo_data.xlsx', 
               VocaPath = 'demo-data/Clinical_Pregnancy_demo_voca.xlsx')
## Step 1 Tidy data ----------------------
# Missing data imputation for IVF-ET data
res2 = TransImputIVF(PID=res$PID, 
                     OutPath = "output",
                     Vars="all.x")
# Delete variables with low variance for IVF-ET data
res2 = DelLowVarIVF(PID=res$PID,
                    OutPath = "output")
# Delete variables with missing values for IVF-ET data
res2 = DelMissIVF(PID=res$PID,
                  OutPath = "output")
# Transform data type for IVF-ET data
res2 = TransTypeIVF(PID = res$PID, 
                    OutPath = "output",
                    Vars = "Y,X12,X34,X59,X69,X80,X83,X93,X98",
                    To = "factor")
# Classify variables into various groups for IVF-ET data
res2 = TransClassIVF(PID = res$PID, 
                     Vars = "X91", 
                     OutPath = "output",
                     LevelTo = 4)
# Scale variables for IVF-ET data
res2 = TransScaleIVF(PID = res$PID, 
                     OutPath = "output",
                     Vars = "X50", 
                     Method = "normal")
# Transform variable distribution for IVF-ET data
res2 = TransDistrIVF(PID = res$PID, 
                     OutPath = "output",
                     Vars = "X62",
                     Method = "log10")

## Step 2 Building ML models--------------------------------------------------------------
# Building models
res3 = IVFPred(PID = res$PID, 
               OutPath = "output",
               AutTuneM = "random_search", 
               AutTuneN = 5,
               RsmpMethod = "cv", 
               Folds = 5,
               Learners = "logistic,rf,xgboost")
# Visualize IVF-ET model results
res3 = VizIVFPred(PID = res$PID, 
                  OutPath = "output",
                  Brightness = "light", 
                  Palette = "lancet")
## Step 3 Statistical explanation-----------------------------------------------
# Model validation between group
res4 = IVFValid(PID = res$PID, 
                OutPath = "output",
                SingleGroup = FALSE)
# Visualize validation results
res4 = VizIVFValid(PID = res$PID, 
                   OutPath = "output",
                   Brightness = "dark", 
                   Palette = "lancet")
## Exit 
FuncExit(PID = res$PID)
