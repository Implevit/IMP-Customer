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
        field(50010; "Journal Template Name"; Code[10])
        {
            Caption = 'Journal Template Name';
            DataClassification = CustomerContent;
            TableRelation = "Job Journal Template";
        }
        field(50020; "Journal Batch Name"; Code[10])
        {
            Caption = 'Journal Batch Name';
            DataClassification = CustomerContent;
            TableRelation = "Job Journal Batch".Name where("Journal Template Name" = field("Journal Template Name"));
        }
    }
}