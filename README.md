# Nashville Housing Data Cleaning & Business Insights

## Introduction

This project demonstrates **end-to-end real estate data cleaning and business analysis** for the Nashville housing market.  
Using SQL (T-SQL), I transformed raw and messy housing data into a **clean, consistent dataset**, then analyzed it to uncover **market trends, property values, investment opportunities, and seasonal cycles**.

The results show **which property types bring the best ROI, how housing prices evolve over time, and how timing affects investment decisions**.

---

## Table of Contents

1. [Project Overview](#project-overview)
2. [Data Cleaning Steps](#data-cleaning-steps)
3. [Business Insights](#business-insights)
   - [Housing Sales Trends Over Time](#1-housing-sales-trends-over-time)
   - [Land Use Differences](#2-land-use-differences)
   - [Tax District Comparisons](#3-tax-district-comparisons)
   - [Property Age and Value](#4-property-age-and-value)
   - [Room Count and Price](#5-room-count-and-price)
   - [Investment Opportunities](#6-investment-opportunities)
   - [Seasonal Patterns](#7-seasonal-patterns)
4. [Key Insights Summary](#key-insights-summary)
5. [Tools & Skills](#tools--skills)
6. [Next Steps](#next-steps)
7. [Call to Action](#call-to-action)

---

## Project Overview

The dataset contained inconsistencies (missing addresses, mixed formats, duplicates).  
Through SQL transformations, I ensured the dataset was **clean, reliable, and ready for business analysis**.

---

## Data Cleaning Steps

1. **Standardized Dates** → Removed time component from `SaleDate`.
2. **Populated Missing Property Addresses** → Used `ParcelID` self-joins.
3. **Split Columns** → Broke down `PropertyAddress` & `OwnerAddress` into `Address`, `City`, `State`.
4. **Standardized Fields** → Converted `SoldAsVacant` from `Y/N` → `Yes/No`.
5. **Removed Duplicates** → Using `ROW_NUMBER()` CTE.
6. **Dropped Redundant Columns** → Kept only clean, usable fields.

✅ Final dataset is **clean, consistent, and business-ready**.

---

## Business Insights

### 1. Housing Sales Trends Over Time

- **Query Example**  
  ![SQL Query for Sales Trends](https://drive.google.com/uc?export=view&id=1AEtECnydV_T6NKUtNS7MSikWSs7dZz0F)
- **Query Result**  
  ![Sales Trends Table](https://drive.google.com/uc?export=view&id=1LoyTJ05ohExOfqyvHQgDK-2T-Tzkw0kQ)

**Insight:** Housing sales in Nashville grew **sharply between 2013–2016**, in both **volume and revenue**.  
**Takeaway:** The market expanded rapidly, but outlier transactions inflated averages → investors should watch for anomalies.

---

### 2. Land Use Differences

- **Query Example**  
  ![SQL Query for Land Use](https://drive.google.com/uc?export=view&id=1Wb8DA88ADepescjRDMld7j0HRnEJYjjF)
- **Query Result**  
  ![Land Use Values Table](https://drive.google.com/uc?export=view&id=1kkhGchC_WehPR6dT7ibmKHwyC1woIdyp)

**Insight:**

- **Highest Value:** Vacant Commercial Land & Condos
- **Lowest Value:** Mobile Homes & Zero Lot Line properties

**Takeaway:** Land parcels show **high growth potential** but are riskier, while residential homes remain **stable and liquid investments**.

---

### 3. Tax District Comparisons

- **Query Example**  
  ![SQL Query for Tax Districts](https://drive.google.com/uc?export=view&id=19M2dlaStwXM-61OMUOOqzPnmNwCUO_nS)
- **Query Result**  
  ![SQL Query for Tax Districts](https://drive.google.com/uc?export=view&id=12EiSAfydf_IE1PyYe6sIHDZAQJwTf7_m)

**Insight:**

- Luxury suburbs (Belle Meade, Forest Hills, Oak Hill) = **highest property values**
- Central districts (Berry Hill, Urban Core) = **highest price per acre**

**Takeaway:** Investors can choose between **large suburban homes** or **compact high-value urban lots**.

---

### 4. Property Age and Value

- **Query Example**  
  ![SQL Query for Property Age](https://drive.google.com/uc?export=view&id=1AHTkBmTeUF_1PqJIEWkSd2CCAdnZYLt9)
- **Query Result**  
  ![Property Age and Value Table](https://drive.google.com/uc?export=view&id=1MGNwtEJaF8NZ9qKcgOqtmStgm1ZiNjcl)

**Insight:**

- Homes **11–20 years old** = highest average prices (**~$471K**)
- New homes (0–10 years) often sold **below appraisal value**

**Takeaway:** Best opportunities lie in **10–20 year-old homes** → affordable yet profitable.

---

### 5. Room Count and Price

- **Query Example**  
  ![SQL Query for Room Count and Price](https://drive.google.com/uc?export=view&id=1TeLAKr2O7yOnRKnNu38akODVUWS3HXg0)
- **Query Result**  
  ![Room Count and Price Table](https://drive.google.com/uc?export=view&id=1tzj0U81a8jYn0Gpk1hK8-R08TBwIaHi2)

**Insight:**

- Bathrooms drive value **more than bedrooms**
- Smaller homes = higher **price per room** (great for rentals)

**Takeaway:**

- **Rentals:** Small homes → high ROI
- **Sales:** Bathrooms → stronger price driver

---

### 6. Investment Opportunities

- **Query Example**  
  ![SQL Query for Investment Opportunities](https://drive.google.com/uc?export=view&id=14HdskdU0tby70D-uKciv5ouLNO5RpSnS)
- **Query Result**  
  ![Investment Opportunities Table](https://drive.google.com/uc?export=view&id=1B6RoQCfJN-lCT1AwPQY1xpL0demBAq2a)

**Insight:**

- Vacant Land & Mobile Homes = **40–70% undervalued**
- Single-family homes often sold **~25% below assessed value**

**Takeaway:** Many undervalued deals exist → require careful **legal/zoning checks**.

---

### 7. Seasonal Patterns

- **Query Example**  
  ![SQL Query for Seasonal Trends](https://drive.google.com/uc?export=view&id=11gUbtUmwxEPqM-z0Sz7BUUQWDJHJ3s_B)
- **Query Result**  
  ![Seasonal Trends Table](https://drive.google.com/uc?export=view&id=1Q28komITBwDX69Vibcp9GZiKVxX_OYGe)

**Insight:**

- **Summer/Fall:** High transaction volume, lower prices → **Best for buyers**
- **Spring/Winter:** Low volume, higher prices → **Best for sellers**

**Takeaway:** **Timing matters**. Investors should align buy/sell strategies with seasonal cycles.

---

## Key Insights Summary

- Housing sales **boomed 2013–2016** → expanding market.
- **Land parcels** = high potential but higher risk.
- **Luxury suburbs** vs. **central urban lots** → different investment profiles.
- Homes **11–20 years old** = most profitable segment (~$471K).
- **Bathrooms > Bedrooms** in driving price.
- Many properties sold **below assessed value** → undervalued investment opportunities.
- **Seasonality** affects pricing → Summer for buyers, Winter for sellers.

---

## Tools & Skills

- **SQL (T-SQL):** Data cleaning, joins, CTEs, string manipulation
- **Business Analysis:** Market segmentation, trend identification, investment evaluation
- **Data Storytelling:** Translating technical queries into actionable business insights

---

## Next Steps

- Build a **dashboard (Power BI / Tableau)** for visualizing insights
- Develop **predictive models (Python/ML)** for property value forecasting

---

## Call to Action

📂 Check out the SQL scripts in the `/queries` folder.  
🚀 Future work: Interactive dashboard coming soon.
