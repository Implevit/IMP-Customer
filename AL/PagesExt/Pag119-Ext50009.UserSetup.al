pageextension 50009 "IMP Pag119-Ext50009" extends "User Setup"
{
    layout
    {
        addafter("Allow Posting To")
        {
            field("IMP Job Resource No."; Rec."IMP Job Resource No.")
            {
                ApplicationArea = All;
            }
            field("IMP Journal Template Name"; Rec."Journal Template Name")
            {
                ApplicationArea = All;
            }
            field("IMP Journal Batch Name"; Rec."Journal Batch Name")
            {
                ApplicationArea = All;
            }
        }
    }


}