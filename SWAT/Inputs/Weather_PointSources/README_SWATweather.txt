Station_Name	StationIDnumberedbySWAT	SubbasinsRepresented
FRC1_PCP	1	None
FIS1_PCP	2	None
LUD1_PCP	3	6,11
MHT2_PCP	4	13
RNT1_PCP	5	None
MHT3_PCP	6	12
MSF1_PCP	7	None
MHT1_PCP	8	15
WHT1_PCP	9	None
MON3_PCP	10	17,18
MON2_PCP	11	14,16,19
CSC1_PCP	12	25
MON1_PCP	13	23,26
CLT1_PCP	14	None
DET2_PCP	15	27,38
DET1_PCP	16	31,32
MTZ1_PCP	17	33,40,44
BUF1_PCP	18	34,36
EDN1_PCP	19	None
SU01_PCP	20	1
SU03_PCP	21	2,3,4
SU05_PCP	22	5,7,8,10
SU09_PCP	23	9
SU35_PCP	24	29,35,37,39,42
SU43_PCP	25	41,43,45
SU20_PCP	26	20,21,22
SU24_PCP	27	24,28,30


This information can be verified by going to individual subbasin. For example, to know which station represents subbasin 3, need to go to 000030000.sub and look for the value along
IRGAGE: precip gage data used in subbasin. The lat and lon of each individual sites are provided in the shape file.

Although SWAT automatically assigns the stations to each Subbasin, we had to manually edit/check whether the spatial variability in precipitation is
adequately represented in the Model.
For more details, refer to Niroula et al (2023), JAWRA.

The precipitation data (daily) from 2000/01/01 to 2018/12/31 is provied in pcp1.pcp. The information on the data format can be found in the I/O documentation, page 139. 
The station assignment is the same for temperature data (maximum and minimum temperature). Can be verified by looking at the respective subbasin file.
Other weather variables such as relative humidity, wind speed and solar radiation is obtained by using model's default weather generator.

The precipitation and temperature data were obtained from NOAA and PRISM data (Niroula et al 2023).
