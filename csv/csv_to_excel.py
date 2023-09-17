import pandas as pd
csvFile = pd.read_csv('Death_Black_Speed_Europe_to_Excel.csv', sep=';')
excelFile = pd.ExcelWriter('Liste_Death_Black_Speed_Europe.xlsx')
csvFile.to_excel(excelFile, index=False, header=True)
excelFile._save()
