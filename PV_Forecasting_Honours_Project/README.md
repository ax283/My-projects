# PV-Forecasting-Honours-Project

## Overview

The aims of this project are:
1. To experiment with existing PV forecasting methods
2. To test an algorithm with transfer learning on multiple datasets

This repository contains the code, datasets and saved models for my honours project. 
The "Datasets" folder contains the datasets used for the experiment. 

## About the datasets

* The "Solar Power Plant Data.csv" dataset was obtained from Kaggle: https://www.kaggle.com/datasets/pythonafroz/solar-powe-generation-data/data
* The "all_data.csv" dataset was provided by a research fellow in the same research group
* The "1 gazbray.csv" dataset was obtained from a public GitHub repository: https://github.com/gomesramos/PV-Output-Datasets

## About the code

The "code" folder contains the code and saved models which are in separate folders. The LSTM folder contains the base BI-LSTM model. This model was trained on the "Solar Power Plant Data.csv" dataset. 
The LSTM_w_TL_1 folder contains the first BI-LSTM model with transfer learning applied. This model was trained on the "all_data.csv" dataset.
The LSTM_w_TL_2 folder contains the second and last BI-LSTM model with transfer learning applied. This model was trained on the "1 gazbray.csv" dataset.

## Setup
**Important:** If you don't already have **Anaconda** installed on your system, make sure to do that before proceeding. This is crucial for managing dependencies without conflicts, particularly when working with the Keras library.
To get started, follow these steps: 

1. Clone the repository: `git clone https://github.com/ax-72/PV-Forecasting-Honours-Project.git`
2. Navigate to your project directory
3. Install the dependencies: `conda install --file requirements.txt`

## Running the code
To run the code, follow these steps:

1. Change all the file paths to point to where the files are stored on your computer.
2. Execute the code for the base model. You have the option to either run all code cells or execute up to the training section, depending on your preference and requirements.
3. Repeat the above steps for running the code for the transfer learning models. 

