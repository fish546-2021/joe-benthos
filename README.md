# joe-benthos

## Summary
Initial attempt to reproduce and expand on analysis of Hood Canal and San Juan Islands eDNA data. Raw data and original bioinformatic pipeline available on [Ramon Gallego's github](https://github.com/ramongallego/Harmful.Algae.eDNA) The related Ocean Acidification project and pipeline is available [here](https://github.com/ramongallego/eDNA.and.Ocean.Acidification.Gallego.et.al.2020).

## Initial Methods and Results
[Initial Results](https://docs.google.com/presentation/d/1q-Bd3QJwW9msHNLYgbhqpKB1MxS_UekDfvtgkPvtSzE/edit#slide=id.p)   
[Methods and Results](https://github.com/fish546-2021/joe-benthos/blob/main/documentation/methods-results.md)   

## Workflow 
 - Retrieve Data from Gannet 
 - Run MultiQC
 - Demultiplex Samples with [custom script](https://github.com/ramongallego/demultiplexer_for_DADA2/blob/master/code_day.md)
 - Denoise and Filter Sequences with dada2
 - Assign taxa with Insect 1.2
 
To reproduce this workflow see [Methods and Results](https://github.com/fish546-2021/joe-benthos/blob/main/documentation/methods-results.md) 

## Directory Structure 
- `/analysis/` Code for taxa assignment data shaping, data exploration and visualization.   
    - `/all.the.useful.tables/` Output tables from taxa assignment and data shaping. 
- `/blast-db/` Uniprot database from blast attempts
- `/code/` Code for retrieving data, and example code for other bioinformatics tools. 
- `/data/` Raw data. 
- `/documentation/` Initial results and methods. 
- `/practice/` Practice code and assignments from Fish546. 
- `/refs/` Useful and interesting references for this project and future projects. 
