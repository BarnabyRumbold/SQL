## Creating and querying a CosmosDB database ##

git clone https://github.com/MicrosoftLearning/DP-900T00A-Azure-Data-Fundamentals dp-900
cd dp-900/nosql
bash setup.sh

SELECT p.productname, p.color, p.listprice, p.description, p.images.thumbnail
FROM products p
WHERE p.productcategory.subcategory = "Mountain Bikes"

SELECT p.productname, p.color, p.listprice, p.description, p.images.thumbnail
FROM products p
WHERE p.productcategory.subcategory = "Road Bikes"

SELECT COUNT(p.productname)
FROM products p
WHERE p.productcategory.subcategory = "Touring Bikes"

SELECT VALUE COUNT(p.productname)
FROM products p
WHERE p.productcategory.subcategory = "Touring Bikes"

SELECT VALUE SUM(p.quantityinstock)
FROM products p
WHERE p.productcategory.subcategory = "Touring Bikes"

SELECT*
FROM products p
WHERE p.productcategory.subcategory = "Touring Bikes"
