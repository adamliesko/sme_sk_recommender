select sme_id, url  from vi_train
group by sme_id, url
INTO OUTFILE '/Users/Adam/smecko.csv'
FIELDS ENCLOSED BY '"' TERMINATED BY ';' ESCAPED BY '"' 
LINES TERMINATED BY '\r\n';


