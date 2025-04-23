/*

>> Steps to Load the data into MySQL <<

1. Make sure your dataset is in .csv format (you can export it from Excel if needed). Here’s how to import:

2. Create a new schema (e.g., hr_analytics).

3. Use the Table Data Import Wizard:

4. Go to your schema > Right-click > "Table Data Import Wizard".

5. Choose your CSV file.

6. Follow the prompts to set column types (date, text, etc.).

7. Confirm that the table is created and preview some rows as we've done following:

*/

SELECT *
FROM main_data
LIMIT 10;