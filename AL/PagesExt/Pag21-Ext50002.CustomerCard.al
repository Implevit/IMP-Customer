pageextension 50002 "IMP Pag21-Ext50002" extends "Customer Card"
{
    layout
    {
        addafter(General)
        {
            group(GrpIMPGeneral)
            {
                Caption = 'Implevit';

                field("IMP Abbreviation"; Rec."IMP Abbreviation")
                {
                    ApplicationArea = All;
                }
                field("IMP Tenant Id"; Rec."IMP Tenant Id")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}