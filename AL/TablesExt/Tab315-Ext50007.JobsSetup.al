tableextension 50007 "IMP Tab315-Ext50007" extends "Jobs Setup"
{
    fields
    {
        field(50000; "IMP Job Travel Work Type Code"; Code[10])
        {
            Caption = 'Job Travel Work Type Code';
            DataClassification = CustomerContent;
            TableRelation = "Work Type";
        }
    }
}