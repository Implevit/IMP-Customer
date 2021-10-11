tableextension 50000 "IMP Tab79-Ext50000" extends "Company Information"
{
    fields
    {
        field(50000; "IMP Connection Nos."; Code[20])
        {
            Caption = 'Server Instance Nos.';
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }
    }
}