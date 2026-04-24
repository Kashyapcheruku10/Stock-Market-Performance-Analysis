SELECT 
    ticker,
    COUNT(*) AS total_trading_days,
    MIN(trade_date) AS start_date,
    MAX(trade_date) AS end_date
FROM stock_prices
GROUP BY ticker
ORDER BY ticker;



WITH first_price AS (
SELECT ticker, close_price AS start_price
FROM stock_prices
WHERE trade_date = (SELECT MIN(trade_date) FROM stock_prices)
),
last_price AS (
SELECT ticker, close_price AS end_price
FROM stock_prices
WHERE trade_date = (SELECT MAX(trade_date) FROM stock_prices)
)
SELECT 
f.ticker,
f.start_price,
l.end_price,
ROUND(l.end_price - f.start_price, 2) AS price_change,
ROUND(((l.end_price - f.start_price) / f.start_price) * 100, 2) AS pct_return
FROM first_price f
JOIN last_price l ON f.ticker = l.ticker
ORDER BY pct_return DESC;



SELECT 
ticker,
YEAR(trade_date) AS year,
MONTH(trade_date) AS month,
DATENAME(MONTH, MIN(trade_date)) AS month_name,
ROUND(AVG(close_price), 2) AS avg_close_price,
ROUND(MAX(close_price), 2) AS monthly_high,
ROUND(MIN(close_price), 2) AS monthly_low
FROM stock_prices
GROUP BY ticker, YEAR(trade_date), MONTH(trade_date)
ORDER BY ticker, year, month;



SELECT 
ticker,
ROUND(AVG(high_price - low_price), 2) AS avg_daily_swing,
ROUND(MAX(high_price - low_price), 2) AS max_single_day_swing
FROM stock_prices
GROUP BY ticker
ORDER BY avg_daily_swing DESC;



SELECT TOP 10
ticker,
trade_date,
volume,
close_price
FROM stock_prices
ORDER BY volume DESC;



SELECT 
    ticker,
    trade_date,
    close_price,
    ROUND(AVG(close_price) OVER (
        PARTITION BY ticker 
        ORDER BY trade_date 
        ROWS BETWEEN 29 PRECEDING AND CURRENT ROW
    ), 2) AS moving_avg_30d
FROM stock_prices
ORDER BY ticker, trade_date;


SELECT
    ticker,
    trade_date,
    close_price,
    LAG(close_price) OVER (PARTITION BY ticker ORDER BY trade_date) AS prev_close,
    ROUND(
        ((close_price - LAG(close_price) OVER (PARTITION BY ticker ORDER BY trade_date))
        / LAG(close_price) OVER (PARTITION BY ticker ORDER BY trade_date)) * 100
    , 4) AS daily_return_pct
FROM stock_prices
ORDER BY ticker, trade_date;



WITH daily_returns AS (
    SELECT
        ticker,
        trade_date,
        close_price,
        LAG(close_price) OVER (PARTITION BY ticker ORDER BY trade_date) AS prev_close
    FROM stock_prices
),
returns_calc AS (
    SELECT
        ticker,
        trade_date,
        close_price,
        CASE 
            WHEN prev_close IS NULL THEN 0
            ELSE ROUND(((close_price - prev_close) / prev_close) * 100, 4)
        END AS daily_return_pct
    FROM daily_returns
)
SELECT
    ticker,
    trade_date,
    close_price,
    daily_return_pct,
    ROUND(
        EXP(SUM(LOG(1 + daily_return_pct / 100)) 
        OVER (PARTITION BY ticker ORDER BY trade_date))
        * 100
    , 2) AS cumulative_return
FROM returns_calc
ORDER BY ticker, trade_date;



-- Which month was best and worst for each stock?
WITH monthly_perf AS (
    SELECT
        ticker,
        YEAR(trade_date) AS yr,
        MONTH(trade_date) AS mn,
        DATENAME(MONTH, MIN(trade_date)) AS month_name,
        ROUND(MIN(close_price), 2) AS month_open,
        ROUND(MAX(close_price), 2) AS month_close,
        ROUND(
            ((MAX(close_price) - MIN(close_price)) / MIN(close_price)) * 100
        , 2) AS monthly_return_pct
    FROM stock_prices
    GROUP BY ticker, YEAR(trade_date), MONTH(trade_date)
)
SELECT *,
    RANK() OVER (PARTITION BY ticker ORDER BY monthly_return_pct DESC) AS best_rank,
    RANK() OVER (PARTITION BY ticker ORDER BY monthly_return_pct ASC) AS worst_rank
FROM monthly_perf
ORDER BY ticker, yr, mn;


SELECT
ticker,
ROUND(MAX(close_price), 2) AS week52_high,
ROUND(MIN(close_price), 2) AS week52_low,
ROUND(AVG(close_price), 2) AS avg_price,
ROUND(MAX(close_price) - MIN(close_price), 2) AS price_range,
ROUND(
((MAX(close_price) - MIN(close_price)) / MIN(close_price)) * 100
, 2) AS range_pct
FROM stock_prices
WHERE trade_date >= DATEADD(YEAR, -1, (SELECT MAX(trade_date) FROM stock_prices))
GROUP BY ticker
ORDER BY range_pct DESC;




WITH prices AS (
    SELECT
        trade_date,
        MAX(CASE WHEN ticker = 'AAPL' THEN close_price END) AS AAPL,
        MAX(CASE WHEN ticker = 'MSFT' THEN close_price END) AS MSFT,
        MAX(CASE WHEN ticker = 'TSLA' THEN close_price END) AS TSLA,
        MAX(CASE WHEN ticker = 'GOOGL' THEN close_price END) AS GOOGL,
        MAX(CASE WHEN ticker = 'AMZN' THEN close_price END) AS AMZN
    FROM stock_prices
    GROUP BY trade_date
)
SELECT
    ROUND(
        (AVG(AAPL * MSFT) - AVG(AAPL) * AVG(MSFT)) /
        (STDEV(AAPL) * STDEV(MSFT))
    , 4) AS corr_AAPL_MSFT,
    ROUND(
        (AVG(AAPL * TSLA) - AVG(AAPL) * AVG(TSLA)) /
        (STDEV(AAPL) * STDEV(TSLA))
    , 4) AS corr_AAPL_TSLA,
    ROUND(
        (AVG(MSFT * GOOGL) - AVG(MSFT) * AVG(GOOGL)) /
        (STDEV(MSFT) * STDEV(GOOGL))
    , 4) AS corr_MSFT_GOOGL
FROM prices;
