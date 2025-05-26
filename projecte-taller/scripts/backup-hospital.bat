echo off 

:: Extraer la hora, el día, el mes y el año
set HORA=%TIME:~0,2%
set DIA=%DATE:~0,2%
set MES=%DATE:~3,2%
set ANIO=%DATE:~6,4%

:: Asegurarse de que la hora tenga dos dígitos (agregar un cero si es necesario)
if %HORA% LSS 10 set HORA=0%HORA:~1,1%

:: Crear el nombre del fichero
set FILENAME=backup_hospital_%HORA%%DIA%%MES%%ANIO%.sql

"C:\Program Files\MySQL\MySQL Server 8.4\bin\mysqldump.exe" -uroot -pEducem00. -hlocalhost -P3306 hospital-projecte > C:\Users\Edu_t\Desktop\DIGITALITZACIO\scripts\%FILENAME%