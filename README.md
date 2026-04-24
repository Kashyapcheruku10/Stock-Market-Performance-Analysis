

# Stock Market Performance Analysis
### SQL + Python  End-to-End Data Analysis Project

## Overview

An end-to-end data analysis project analyzing **5 major US tech stocks** (AAPL, TSLA, MSFT, GOOGL, AMZN) over a **2-year period (2022–2024)** using real-time data fetched from Yahoo Finance, stored and queried in SQL Server, and visualized using Python.

## Problem Statement

> Which stocks offered the best return, the least risk, and the most efficient risk-adjusted performance, and what trading signals emerged over these 2 years?

## Tools & Technologies

    Tools              Purpose 
 Python (yfinance):  Fetch real stock data from Yahoo Finance 
 Pandas         :   Data Cleaning and Transformation 
 SQL Server (SSMS):  Store and query structured stock data
 Matplotlib & Seaborn: Static visualizations
 Plotly  : Interactive charts
 Jupyter Notebook: Analysis environment
 

## Key Analysis

- **Overall return comparison** — which stock grew the most over 2 years
- **Monthly price trend analysis** — seasonality and crash patterns
- **Volatility measurement** — average daily price swing per stock
- **30-day & 200-day moving averages** — using SQL window functions
- **Golden Cross / Death Cross detection** — moving average crossover strategy
- **Risk vs Return analysis** — standard deviation vs avg daily return
- **Pearson correlation matrix** — how stocks move relative to each other
- **52-week high & low** — real financial metric used by analysts daily
- **Volume spike analysis** — detecting news-driven trading days

## Key Findings

 #  Insight 

| 1 | MSFT was the best performer with +22.46% cumulative return over 2 years 

| 2 | TSLA was 3.3x more volatile than GOOGL ($11.51 vs $2.93 avg daily swing) yet delivered only +1.05% return

| 3 | AAPL offered the best risk-adjusted return — lowest risk score (1.85) with +18.37% return

| 4 | A Golden Cross signal was detected in AAPL on March 23, 2023 — a classic bullish indicator

| 5 | AAPL and MSFT had the highest correlation (0.72), driven by shared macro factors

| 6 | TSLA dominated top volume days — 306.59M shares traded on Jan 27, 2023

| 7 | AMZN showed the sharpest recovery — rising from $82.87 low to $154.40 (+86.32% range)


## How to Run

```
# 1. Clone the repository
git clone https://github.com/Kashyapcheruku10/Stock-Market-Performance-Analysis.git

# 2. Install dependencies
pip install yfinance pandas sqlalchemy pyodbc matplotlib seaborn plotly

# 3. Set up SQL Server
# Run sql/analysis_queries.sql in SSMS first

# 4. Run the notebook
jupyter notebook notebooks/stock_analysis.ipynb
```

## Connect With Me

**LinkedIn:** [www.linkedin.com/in/kashyap-cheruku-071012342]  
**GitHub:** [(https://github.com/Kashyapcheruku10)]

*Built with real market data | Yahoo Finance API | 2022–2024*
