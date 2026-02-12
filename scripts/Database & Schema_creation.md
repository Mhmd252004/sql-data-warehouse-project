## Database Setup (Manual / GUI Method)

This project uses a PostgreSQL database. Follow these steps to set up the database structure using **pgAdmin 4**:

### 1. Create the Database
1. Open **pgAdmin 4** and connect to your server (usually strictly `PostgreSQL 16` or similar).
2. Right-click on **Databases**.
3. Select **Create > Database...**
4. In the **General** tab:
   - **Database:** Enter the name (e.g., `job_scraping_db`).
5. Click **Save**.

### 2. Create the Schema
1. In the browser tree on the left, expand your newly created database.
2. Right-click on **Schemas**.
3. Select **Create > Schema...**
4. In the **General** tab:
   - **Name:** Enter the schema name (e.g., `staging` or `raw_data`).
5. Click **Save**.

### 3. Create Tables (Optional)
1. Expand **Schemas > [Your Schema Name]**.
2. Right-click on **Tables**.
3. Select **Create > Table...**
4. In the **General** tab, name your table.
5. Switch to the **Columns** tab to add your specific columns and data types.
6. Click **Save**.