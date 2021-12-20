$abbreviation = "IMP"
Start-Process "http://impent02:8080/IMP-BC180-PROD/?Company=Implevit AG TEST&page=50000&mode=View&filter='Customer Abbreviation' IS $($abbreviation)"
