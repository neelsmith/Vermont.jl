# Vermont.jl

Code and data for a project looking at census records for parts of Addison County, Vermont, along the coast of Lake Champlain, in the second half of the nineteenth century.



## Census tables

The `data` directory has delimited-text files with transcribed census records for a selection of Vermont census districts from 1850 through 1880. 


### Coverage


Key: 
- ✓  initial data entry complete
- ✅ all data load correctly into `CensusRecord` objects



| Year | Addison | Bridport | Ferrisburg | Panton | Vergennes |
| --- | --- | --- | --- | --- | --- |
| 1850 |✅|✅|✅|✅| ✅|
| 1860 |✓| ✓ ||✓||
| 1870 |✅| ✅ | ✅ |✅||
| 1880 |✅|✅|✅|✅|✅|




### Validating content

Each column includes two values separated by a slash. The first column is the figure manuially recorded on a census page. The second column is the result of querying the digital `CensusRecord`s. Where the two figures match, we can be confident that the digital objects capture the transcribed data with some reliability.

| District | Year | White males | White females | Colored males | Colored females | Total males | Total females | Aggregate |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| **Addison** | **1850** |  ||  |  | |  |  |
| **Bridport** | **1850** |  ||  |  | |  |  |
| **Ferrisburg** | **1850** |  ||  |  | |  |  |
| **Panton** | **1850** | 287 / `287` | 267 / `267` | 3 / `3` | 2 / `2` | 290 / `290` | 269 / `269` | 559 / `559`| 
| **Vergennes** | **1850** |  ||  |  | |  |  |