# ******************************************************************************
# Download Landsat time series using site coordinates
# 
# Author: Xiaojie Gao
# Date: 2024-06-27
# ******************************************************************************
library(data.table)
# The following file will provide functions to communicate w/ AppEEARS
source("src/AppEEARS_api.R")



# ! Change this to your data ---------------------------------------------------
# Format a data frame to store site coordinates
lat <- c(36.206228, 37.289327) # Latitude of the point sites
lon <- c(-112.127134, -112.973760) # Longitude of the point sites
id <- c("0", "1") # ID for the point sites
category <- c("Grand Canyon", "Zion") # Category for point sites
pts_df <- data.frame(
   id = id,
   longitude = lon,
   latitude = lat,
   category = category
)
# ------------------------------------------------------------------------------


# Define layers to download
layers <- data.frame(
    product = c(
        rep("L05.002", 3), 
        rep("L07.002", 3),
        rep("L08.002", 3),
        rep("L09.002", 3),
        rep("HLSS30.020", 3),
        rep("HLSL30.020", 3)
    ),
    layer = c(
        "SR_B3", "SR_B4", "QA_PIXEL", 
        "SR_B3", "SR_B4", "QA_PIXEL",
        "SR_B4", "SR_B5", "QA_PIXEL",
        "SR_B4", "SR_B5", "QA_PIXEL",
        "B04", "B8A", "Fmask",
        "B04", "B05", "Fmask"
    )
)

# User credential is stored in a separate file and not tracked by git
# ! Change to your username and password
token <- Login(usr = "", pwd = "")


# Submit the task to AppEEARS
# ! Change the `task_name`
SubmitTask(
    token = token,
    task_name = "my_task",
    task_type = "point",
    start_date = "01-01-1984",
    end_date = "12-31-2023",
    layers = layers,
    point_df = pts_df
)
# Run the above function and make sure it does not report an error

# Check status of your jobs. You can also open the AppEEARS website and see the
# status of the jobs there
job_stats <- CheckTaskStatus(token, 10, brief = TRUE)


# Once the job is done, run the following to download the data

# Define a folder where you want to store the downloaded data
outdir <- "data/raw/landsat"
dir.create(outdir, showWarnings = FALSE, recursive = TRUE)

# Copy the `job_id` and define it here:
job_id <- ""

DownloadTask(token, task_id = job_id, out_dir = outdir)



