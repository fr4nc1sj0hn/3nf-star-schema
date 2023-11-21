# 3nf-star-schema

Step 1: Upload the each csv file under <i>data</i> on separate sql tables.

Step 2: Execute <i>CreateDimensionalModel.sql</i> to create and populate the tables.

Take note that dimension attributes can be sourced from a different table. For example, Employee Status is from a different table but is included in DimEmployee. You have to group together related attributes into a single dimension table. An example in retail is Product and Product Type.

<h2>PBI Files</h2>

You can look at the relationship tab in the PBI file to see the data model and how the tables are related to one another. Compare the two PBI files.

<img width="670" alt="image" src="https://github.com/fr4nc1sj0hn/3nf-star-schema/assets/21030302/5433ee01-83a7-4fd6-8c24-409619f9f64e">

versus:

<img width="696" alt="image" src="https://github.com/fr4nc1sj0hn/3nf-star-schema/assets/21030302/819204e8-11b1-4fee-97df-bbe3ac6b9633">


You can see that the star schema (granted we only have two dimensions) is simpler but redundant (Employee Status gets repeated per row). This will yield to a faster query execution for Direct Query mode but will consume more storage in the database. 


<i>StarSchema.pbix</i> contains a sample report that uses the dimensional model. 

<img width="689" alt="image" src="https://github.com/fr4nc1sj0hn/3nf-star-schema/assets/21030302/7ce3bcb8-1190-4138-9de3-09bef275890e">

