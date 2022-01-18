pageextension 50004 "IMP Pag463-Ext50004" extends "Jobs Setup"
{
    layout
    {
        addlast(General)
        {
            field("IMP Job Travel Work Type Code"; Rec."IMP Job Travel Work Type Code")
            {
                ApplicationArea = All;
            }
        }
    }
}