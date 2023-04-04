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
        field(50010; "IMP Check Journal Overlap"; Boolean)
        {
            Caption = 'Check Job Journal Overlap';
            DataClassification = CustomerContent;
            
        }
        field(50020; "IMP Mark Journal Overlap"; Boolean)
        {
            Caption = 'Mark Job Journal Overlap';
            DataClassification = CustomerContent;
            
        }
        field(50030; "IMP Job Consulting Invoice PDF"; Text[250])
        {
            Caption = 'Job Consulting Invoice PDF';
            DataClassification = CustomerContent;
            
        }
        
    }
}