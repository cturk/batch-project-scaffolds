@echo off
echo Starting Machine Learning Project Setup...

REM Create project directory structure
echo Creating project directory structure...
mkdir ml-project
cd ml-project
mkdir src
mkdir notebooks
mkdir models
mkdir data
mkdir scripts
mkdir tests
mkdir reports
mkdir docker

REM Create virtual environment
echo Creating Python virtual environment...
python -m venv venv
call venv\Scripts\activate

REM Install core data science and ML dependencies
echo Installing data science dependencies...
call pip install numpy pandas scikit-learn scipy matplotlib seaborn
call pip install jupyter
call pip install mlflow
call pip install streamlit
call pip install fastapi uvicorn

REM Install additional machine learning libraries
echo Installing additional ML libraries...
call pip install tensorflow torch transformers
call pip install xgboost lightgbm catboost
call pip install plotly bokeh altair

REM Install experiment tracking and versioning
echo Installing experiment tracking tools...
call pip install mlflow[extras]
call pip install optuna
call pip install kedro

REM Install testing and development tools
echo Installing testing and development tools...
call pip install pytest pytest-cov
call pip install black flake8 mypy
call pip install cookiecutter

REM Create requirements file
echo Creating requirements.txt...
call pip freeze > requirements.txt

REM Create Jupyter configuration
echo Creating Jupyter configuration...
echo {
echo   "NotebookApp": {
echo     "nbserver_extensions": {
echo       "mlflow": true
echo     },
echo     "open_browser": false
echo   }
echo } > jupyter_notebook_config.json

REM Create MLflow tracking configuration
echo Creating MLflow configuration...
echo # MLflow configuration
echo MLFLOW_TRACKING_URI=./mlruns
echo MLFLOW_EXPERIMENT_NAME=default_experiment > mlflow.env

REM Create example Jupyter notebook
echo Creating example Jupyter notebook...
mkdir notebooks
echo {
 "cells": [
  {
   "cell_type": "markdown",
   "metadata": {},
   "source": [
    "# Machine Learning Project Notebook"
   ]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "metadata": {},
   "source": [
    "import mlflow\n",
    "import pandas as pd\n",
    "import numpy as np\n",
    "from sklearn.model_selection import train_test_split\n",
    "from sklearn.preprocessing import StandardScaler\n",
    "from sklearn.linear_model import LogisticRegression\n",
    "from sklearn.metrics import accuracy_score, classification_report"
   ]
  }
 ],
 "metadata": {
  "kernelspec": {
   "display_name": "Python 3",
   "language": "python",
   "name": "python3"
  }
 },
 "nbformat": 4,
 "nbformat_minor": 2
} > notebooks/ml_project_template.ipynb

REM Create FastAPI model deployment script
echo Creating model deployment script...
echo import mlflow
echo import mlflow.sklearn
echo from fastapi import FastAPI
echo from pydantic import BaseModel
echo import uvicorn
echo.
echo # Load saved model
echo model = mlflow.sklearn.load_model("./models/best_model")
echo.
echo class PredictionInput(BaseModel):
echo     features: list[float]
echo.
echo app = FastAPI()
echo.
echo @app.post("/predict")
echo def predict(input: PredictionInput):
echo     prediction = model.predict([input.features])
echo     return {"prediction": prediction.tolist()}
echo.
echo if __name__ == "__main__":
echo     uvicorn.run(app, host="0.0.0.0", port=8000) > src/model_api.py

REM Create Streamlit visualization app
echo Creating Streamlit visualization app...
echo import streamlit as st
echo import mlflow
echo import pandas as pd
echo import plotly.express as px
echo.
echo def main():
echo     st.title("ML Model Dashboard")
echo.
echo     # Load MLflow run metrics
echo     metrics = mlflow.search_runs()
echo.
echo     # Visualize metrics
echo     st.header("Model Performance Metrics")
echo     st.dataframe(metrics)
echo.
echo     # Interactive plotting
echo     metric_cols = metrics.select_dtypes(include=['float64', 'int64']).columns
echo     x_metric = st.selectbox("X-axis Metric", metric_cols)
echo     y_metric = st.selectbox("Y-axis Metric", metric_cols)
echo.
echo     fig = px.scatter(metrics, x=x_metric, y=y_metric, 
echo                      title=f"{x_metric} vs {y_metric}")
echo     st.plotly_chart(fig)
echo.
echo if __name__ == "__main__":
echo     st.set_page_config(layout="wide")
echo     main() > src/dashboard.py

REM Create Dockerfile for containerization
echo Creating Dockerfile...
echo FROM python:3.9-slim
echo.
echo WORKDIR /app
echo.
echo # Copy requirements and install dependencies
echo COPY requirements.txt .
echo RUN pip install --no-cache-dir -r requirements.txt
echo.
echo # Copy project files
echo COPY . .
echo.
echo # Expose ports for services
echo EXPOSE 8000 8501
echo.
echo # Default command (can be overridden)
echo CMD ["uvicorn", "src.model_api:app", "--host", "0.0.0.0", "--port", "8000"] > Dockerfile

REM Create docker-compose file
echo Creating docker-compose.yml...
echo version: '3.8'
echo services:
echo   ml-api:
echo     build: .
echo     ports:
echo       - "8000:8000"
echo     environment:
echo       - MLFLOW_TRACKING_URI=./mlruns
echo.
echo   ml-dashboard:
echo     build: .
echo     ports:
echo       - "8501:8501"
echo     command: streamlit run src/dashboard.py
echo     depends_on:
echo       - ml-api > docker-compose.yml

REM Create README
echo Creating README.md...
echo # Machine Learning Project > README.md
echo. >> README.md
echo ## Project Setup >> README.md
echo. >> README.md
echo \`\`\`bash >> README.md
echo # Create virtual environment >> README.md
echo python -m venv venv >> README.md
echo source venv/bin/activate  # On Unix >> README.md
echo venv\Scripts\activate  # On Windows >> README.md
echo. >> README.md
echo # Install dependencies >> README.md
echo pip install -r requirements.txt >> README.md
echo \`\`\` >> README.md
echo. >> README.md
echo ## Workflows >> README.md
echo. >> README.md
echo "- **Jupyter Notebook**: Exploratory data analysis" >> README.md
echo "- **MLflow**: Experiment tracking" >> README.md
echo "- **FastAPI**: Model deployment" >> README.md
echo "- **Streamlit**: Model visualization" >> README.md
echo "- **Docker**: Containerization" >> README.md

REM Initialize git
echo Initializing git repository...
git init
echo venv/ > .gitignore
echo __pycache__/ >> .gitignore
echo *.pyc >> .gitignore
echo .ipynb_checkpoints/ >> .gitignore
echo mlruns/ >> .gitignore
echo *.log >> .gitignore
echo .env >> .gitignore

echo Machine Learning Project Setup Complete!
echo Next steps:
echo 1. Activate virtual environment
echo 2. Install dependencies
echo 3. Explore Jupyter notebooks
echo 4. Track experiments with MLflow
echo 5. Deploy model via FastAPI or Streamlit
pause