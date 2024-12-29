# Walmart_Sales_DataAnalysis

![walmart_project](https://github.com/user-attachments/assets/ff3c31d9-65bf-4aab-9479-261b74da60ad)


This project offers a comprehensive solution to analyze Walmart sales data using Python and SQL. It is designed to address key business questions and extract actionable insights through structured data analysis, cleaning, and querying techniques. The project is an excellent opportunity for data analysts to enhance their expertise in Python and SQL, including working with real-world data pipelines and advanced queries.

## Project Steps

### 1. Set Up the Environment
   - **Tools Used**: Visual Studio Code (VS Code), Python, MySQL
   - **Goal**: Create a structured workspace within VS Code and organize project folders for smooth development and data handling.

### 2. Set Up Kaggle API
   - **API Setup**: Obtain your Kaggle API token from [Kaggle](https://www.kaggle.com/) by navigating to your profile settings and downloading the JSON file.
   - **Configure Kaggle**: 
      - Place the downloaded `kaggle.json` file in your local `.kaggle` folder.
      - Use the command `kaggle datasets download -d <dataset-path>` to pull datasets directly into your project.

### 3. Download Walmart Sales Data
   - **Data Source**: Use the Kaggle API to download the Walmart sales datasets from Kaggle.
   - **Dataset Link**: [Walmart Sales Dataset](https://www.kaggle.com/najir0123/walmart-10k-sales-datasets)
   - **Storage**: Save the data in the `data/` folder for easy reference and access.

### 4. Install Required Libraries and Load Data
   - **Libraries**: Install necessary Python libraries using:
     ```bash
     pip install pandas numpy sqlalchemy mysql-connector-python
     ```
   - **Loading Data**: Read the data into a Pandas DataFrame for initial analysis and transformations.

### 5. Explore the Data
   - **Goal**: Conduct an initial data exploration to understand data distribution, check column names, types, and identify potential issues.
   - **Analysis**: Use functions like `.info()`, `.describe()`, and `.head()` to get a quick overview of the data structure and statistics.

### 6. Data Cleaning
   - **Remove Duplicates**: Identify and remove duplicate entries to avoid skewed results.
   - **Handle Missing Values**: Drop rows or columns with missing values if they are insignificant; fill values where essential.
   - **Fix Data Types**: Ensure all columns have consistent data types (e.g., dates as `datetime`, prices as `float`).
   - **Currency Formatting**: Use `.replace()` to handle and format currency values for analysis.
   - **Validation**: Check for any remaining inconsistencies and verify the cleaned data.

### 7. Feature Engineering
   - **Create New Columns**: Calculate the `Total Amount` for each transaction by multiplying `unit_price` by `quantity` and adding this as a new column.
   - **Enhance Dataset**: Adding this calculated field will streamline further SQL analysis and aggregation tasks.

### 8. Load Data into MySQL and PostgreSQL
   - **Set Up Connections**: Connect to MySQL using `sqlalchemy` and load the cleaned data into each database.
   - **Table Creation**: Set up tables in MySQL using Python SQLAlchemy to automate table creation and data insertion. `df.to_sql(name='walmart_sales', con= engine_mysql, if_exists='append', index=False)`
   - **Verification**: Run initial SQL queries to confirm that the data has been loaded accurately.

### 9. SQL Analysis: Complex Queries and Business Problem Solving
   - **Business Problem-Solving**: Write and execute complex SQL queries to answer critical business questions, such as:
     - Revenue trends across branches and categories.
     - Identifying total profit for each category, ranked from highest to lowest?
```
SELECT 
    category,
    ROUND(SUM(total), 2) AS total_revenue,
    ROUND(SUM(unit_price * quantity * profit_margin),
            2) AS total_profit
FROM
    walmart_sales
GROUP BY category
ORDER BY total_profit DESC;
```
 **From this we come to know that: **Fashion accessories** are the most profitable**
 
 - Indentifying the most frequently used payment method in each branch
```
select
  *
from
(select
	branch,
    payment_method,
    count(*) as total_transactions,
   rank() over(partition by branch order by count(*) desc) as ranking
from
	walmart_sales
    group by branch, payment_method) as tab
    where ranking = 1;
```
  - Identify the 5 branches with the highest revenue decrease ratio from last year to current year (e.g., 2022 to 2023)

```
with revenue_2022
as 
(SELECT 
    branch, SUM(total) AS total_revenue
FROM
    walmart_sales
WHERE
    YEAR(STR_TO_DATE(date, '%d/%m/%y')) = 2022
GROUP BY branch),

revenue_2023
as 
(SELECT 
    branch, SUM(total) AS total_revenue
FROM
    walmart_sales
WHERE
    YEAR(STR_TO_DATE(date, '%d/%m/%y')) = 2023
GROUP BY branch)

SELECT 
    r2022.branch,
    r2022.total_revenue AS last_yr_revenue,
    r2023.total_revenue AS current_yr_revenue,
    ROUND(((r2022.total_revenue - r2023.total_revenue) / r2022.total_revenue) * 100,
            2) AS revenue_decreased_ratio
FROM
    revenue_2022 AS r2022
        JOIN
    revenue_2023 AS r2023 ON r2022.branch = r2023.branch
WHERE
    r2022.total_revenue > r2023.total_revenue
ORDER BY revenue_decreased_ratio DESC
LIMIT 5;
```
** || From here we could see WALM045, WALM047, WALM098, WALM033 and WALM081 are the brances with highest revenue drop than the previous year||**
 
  - **Documentation**: Keep clear notes of each query's objective, approach, and results.

---

## Requirements

- **Python 3.8+**
- **SQL Databases**: MySQL, PostgreSQL
- **Python Libraries**:
  - `pandas`, `numpy`, `sqlalchemy`, `mysql-connector-python`
- **Kaggle API Key** (for data downloading)


## Project Structure

```plaintext
|-- data/                     # Raw data and transformed data
|-- sql_queries/              # SQL scripts for analysis and queries
|-- notebooks/                # Jupyter notebooks for Python analysis
|-- README.md                 # Project documentation
|-- requirements.txt          # List of required Python libraries
|-- main.py                   # Main script for loading, cleaning, and processing data
```
---


## Future Enhancements

Possible extensions to this project:
- Integration with a dashboard tool (e.g., Power BI or Tableau) for interactive visualization.
- Additional data sources to enhance analysis depth.
- Automation of the data pipeline for real-time data ingestion and analysis.

---

## License

This project is licensed under the MIT License. 

---

## Acknowledgments

- **Data Source**: Kaggle’s Walmart Sales Dataset
- **Inspiration**: Walmart’s business case studies on sales and supply chain optimization.
