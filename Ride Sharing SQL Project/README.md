# 🚕 Ride Sharing Dynamic Pricing Engine — SQL Project

This project represents a complete end-to-end **SQL analytics and pricing simulation case study** built on a Ride Sharing dataset. The objective is to analyze **ride demand patterns, revenue trends, driver performance, and customer experience**, while implementing a **dynamic surge pricing logic** similar to real-world ride-hailing platforms.

---

## 📌 Project Overview

Modern ride-sharing platforms rely on understanding:

- Which **locations generate the highest demand**
- What **time of day has peak ride activity**
- Which **drivers generate the most revenue**
- How **traffic conditions and peak hours affect pricing**
- How to simulate **surge pricing based on demand levels**

This project uses MySQL to analyze ride data and simulate business-driven pricing logic.

---

## 🧠 What I Did in This Project — Step-by-Step Process

| Phase | Activities |
|-------|------------|
| 📂 **Phase 1 — Database Setup** | Created structured MySQL table and imported dataset |
| 🧱 **Phase 2 — Data Cleaning** | Standardized column names and converted datetime fields |
| 🔍 **Phase 3 — Demand Analysis** | Analyzed ride distribution by hour, location & day |
| 💰 **Phase 4 — Revenue Analysis** | Calculated total revenue, revenue by location & hour |
| 🚗 **Phase 5 — Driver Performance** | Ranked drivers by earnings using window functions |
| 📈 **Phase 6 — Surge Simulation** | Implemented CASE-based dynamic pricing multiplier |
| 📊 **Phase 7 — Advanced SQL** | Used RANK(), LAG(), and moving averages for insights |

---

## 🗂 Dataset Features

The dataset includes:

- Ride ID  
- Request Time  
- Pickup & Dropoff Location  
- Latitude & Longitude Coordinates  
- Ride Distance (miles)  
- Fare Amount ($)  
- Payment Method  
- Driver ID  
- Vehicle Type  
- Traffic Condition  
- Peak Hours  
- Day of Week  
- Public Holiday Indicator  
- User Rating  

This structure allows deep analysis of operational and pricing performance.

---

## 🎯 Key Business Questions Solved

✔ What is the **total revenue and ride volume**?  
✔ Which **pickup locations have the highest demand**?  
✔ What are the **peak ride hours**?  
✔ Which **drivers generate maximum earnings**?  
✔ How does **traffic condition affect user ratings**?  
✔ What is the **average fare per mile**?  
✔ How can we simulate **surge pricing based on demand thresholds**?  
✔ What is the **hourly ride growth trend** using LAG()?  

All SQL queries are included in:  
📌 `Ride_sharing_SQL_Project.sql`

---

## 🔍 Surge Pricing Logic Implemented

Dynamic multiplier simulation:

| Demand Level (Rides per Hour) | Surge Multiplier |
|--------------------------------|------------------|
| > 50                          | 2.0x             |
| > 30                          | 1.5x             |
| Otherwise                     | 1.0x             |

This simulates real-world ride-hailing surge behavior.

---

## 🔎 Advanced SQL Concepts Used

- Aggregations with GROUP BY  
- CASE Statements  
- STR_TO_DATE() for datetime conversion  
- Window Functions:
  - RANK()
  - LAG()
  - Moving Average
- Subqueries for hourly demand analysis  

---

## 📊 Insights & Key Findings

📌 Peak ride demand occurs during defined peak hours and high-traffic periods.  
📌 Certain pickup locations consistently generate higher revenue.  
📌 A small percentage of drivers contribute significantly to total earnings.  
📌 Fare per mile increases during peak demand conditions.  
📌 User ratings tend to drop slightly during heavy traffic conditions.  

---

## 📁 Project Structure

```
Ride Sharing SQL Project
│
├── Ride_sharing_SQL_Project.sql
├── rides.csv
├── Ride Sharing Dataset.xlsx
├── ride sharing project png.png
└── README.md
```

---

## 🛠 Tools & Technologies Used

| Component | Technology |
|----------|------------|
| Database | MySQL |
| Language | SQL (DDL + DML + Window Functions) |
| Tool | MySQL Workbench |
| Version Control | Git & GitHub |

---

## 📈 Possible Extensions

Future enhancements for this project:

- 🔹 Implement stored procedures for automated surge calculation  
- 🔹 Create database views for reporting dashboards  
- 🔹 Build a Power BI dashboard on top of SQL output  
- 🔹 Perform time-series revenue forecasting  
- 🔹 Optimize queries using indexing strategies  

---

## 👤 Author

**Anurag Patil**

- 🔗 GitHub: https://github.com/Anurag-Patil-Git  
- 🔗 LinkedIn: https://www.linkedin.com/in/anurag-patil-1009  

---

💬 *If you have feedback or suggestions, feel free to connect or raise an issue!*
