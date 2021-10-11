tableextension 50004 "IMP Tab237-Ext50004" extends "Job Journal Batch"
{
    fields
    {
        field(50000; "IMP Line Nos."; Code[20])
        {
            Caption = 'Line Nos.';
            DataClassification = CustomerContent;
            TableRelation = "No. Series";
        }
    }
}