pageextension 50004 "IMP Pag463-Ext50004" extends "Jobs Setup"
{
    layout
    {
        addlast(General)
        {

            group("IMP-Customer")
            {
                Caption = 'IMP-Customer';

                field("IMP Job Travel Work Type Code"; Rec."IMP Job Travel Work Type Code")
                {
                    ApplicationArea = All;
                }
            }

        }
    }
}