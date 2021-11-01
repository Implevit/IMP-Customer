$url = "http://impent01:8080/IMP-BC180-PROD/"
$company = "CRONUS (Schweiz) AG"
$page = 50008
$appname = "imp-customer"
$filter = "'App Name' IS $($appname) AND 'Object No.' IS '0'"
Start-Process "$($url)?Company=$($company)&page=$($page)&mode=View&filter=$($filter)"