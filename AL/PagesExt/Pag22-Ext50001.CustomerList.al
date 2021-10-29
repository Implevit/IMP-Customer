pageextension 50001 "IMP Pag22-Ext50001" extends "Customer List"
{
    layout
    {
        addafter("No.")
        {
            field("IMP Abbreviation"; Rec."IMP Abbreviation")
            {
                ApplicationArea = All;
            }
            field("IMP Apps"; Rec."IMP Apps")
            {
                ApplicationArea = All;
            }
            field("IMP Connections"; Rec."IMP Connections")
            {
                ApplicationArea = All;
            }
        }
        addafter(City)
        {
            field("IMP Tenant Id"; Rec."IMP Tenant Id")
            {
                ApplicationArea = All;
            }
        }
    }
}