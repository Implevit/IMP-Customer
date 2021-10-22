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
        field(50010; "IMP Gitlab Url"; Text[100])
        {
            Caption = 'Gitlab Url';
            DataClassification = CustomerContent;
        }
    }
}