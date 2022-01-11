$appName = "imp-customer"
Start-Process "http://impent02:8080/IMP-BC180-PROD/?Company=Implevit AG&page=50008&mode=View&filter='App Name' IS $($appName) AND 'Object No.' IS '0'"