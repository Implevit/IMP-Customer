tableextension 50008 "Tab36-Ext50008IMPSalesHeader" extends "Sales Header"
{
    fields
    {
        field(50000; "IMP Job Accounting Description"; Text[80])
        {
            Caption = 'Job Accounting Description';
            DataClassification = CustomerContent;
        }
        field(50001; "IMP Accounting Description"; Text[80])
        {
            Caption = 'Accounting Description';
            DataClassification = CustomerContent;
        }
    }
    
    var
        myInt: Integer;
}