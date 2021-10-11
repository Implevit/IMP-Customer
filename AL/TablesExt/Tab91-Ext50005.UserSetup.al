tableextension 50005 "IMP Tab91-Ext50005" extends "User Setup"
{
    fields
    {
        field(50000; "IMP Job Resource No."; Code[20])
        {
            Caption = 'Job Resource No.';
            DataClassification = CustomerContent;
            TableRelation = Resource."No.";
        }
    }
}