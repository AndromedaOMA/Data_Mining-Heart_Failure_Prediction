if (!require("tourr")) install.packages("tourr")
if (!require("tidyverse")) install.packages("tidyverse")

library(tourr)
library(tidyverse)

heart_data <- read.csv("data/heart.csv")

# Selectăm doar coloanele numerice sau convertim cele categorice
# Projection Pursuit necesită date numerice.
heart_numeric <- heart_data %>%
  mutate(
    Sex = as.numeric(as.factor(Sex)),
    ChestPainType = as.numeric(as.factor(ChestPainType)),
    RestingECG = as.numeric(as.factor(RestingECG)),
    ExerciseAngina = as.numeric(as.factor(ExerciseAngina)),
    ST_Slope = as.numeric(as.factor(ST_Slope))
  )

# Extragem eticheta pentru colorare (HeartDisease)
target <- heart_numeric$HeartDisease
# Eliminăm coloana țintă din datele pentru proiecție
data_to_project <- heart_numeric %>% select(-HeartDisease)

# Scalarea datelor (esențial pentru Projection Pursuit)
data_scaled <- rescale(data_to_project)

# Realizarea Proiecției Pursuit (Grand Tour)
# Se caută automat cele mai "interesante" vederi 2D ale datelor
# Vom colora punctele în funcție de prezența bolii (0 = sănătos, 1 = bolnav)

cat("Se deschide fereastra interactivă pentru Tour...")

animate_xy(data_scaled, 
           guided_tour(holes()),
           col = target + 1)

# Variantă cu indexul de densitate (pentru a găsi clustere)
animate_xy(data_scaled, guided_tour(cmass()), col = target + 1)