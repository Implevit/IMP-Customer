pageextension 50007 "IMP Pag33-Ext50007" extends "Customer Lookup"
{
    layout
    {
        addafter("No.")
        {
            field("IMP Abbreviation"; Rec."IMP Abbreviation")
            {
                ApplicationArea = All;
            }
        }
    }
}