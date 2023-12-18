# install "IVFPred" packages----------------
# install.packages('devtools')
devtools::install_github('https://github.com/ExposomeX/IVFPred.git')
# library package
library(IVFPred)
# Step 0. Start
res <- InitIVF()
# Step 1. LoadData
res1 = LoadIVF(PID = res$PID,
               DataPath = 'demo-data/eg_data_IVFPred1.xlsx', 
               VocaPath = 'demo-data/eg_voca_IVFPred1.xlsx')
## Step 1 Tidy data ----------------------
res2 = TransImputIVF(PID=res$PID, Vars="all.x")
res2 = DelLowVarIVF(PID=res$PID)
res2 = DelMissIVF(PID=res$PID)
res2 = TransTypeIVF(PID = res$PID, Vars = "Y,X85,X86,X87,X88,X89,X90,X91,X92,X93,X94,X95,X96,X97,X98,X100",
                    To = "factor")
res2 = TransClassIVF(PID = res$PID, Vars = "X47", LevelTo = 4)
res2 = TransScaleIVF(PID = res$PID, Vars = "X55", Method = "normal")
res2 = TransDistrIVF(PID = res$PID, Vars = "X61", Method = "log10")

## Step 2 Building ML models--------------------------------------------------------------
res3 = IVFPred(PID = res$PID, AutTuneM = "random_search", AutTuneN = 5,
               RsmpMethod = "cv", Folds = 5,
               Learners = "logistic,rf,xgboost")
res3 = VizIVFPred(PID = res$PID, Brightness = "light", Palette = "lancet")
## Step 3 Statistical explanation-----------------------------------------------
res4 = IVFValid(PID = res$PID, SingleGroup = FALSE)
res4 = VizIVFValid(PID = res$PID, Brightness = "dark", Palette = "lancet")

FuncExit(PID = res$PID)