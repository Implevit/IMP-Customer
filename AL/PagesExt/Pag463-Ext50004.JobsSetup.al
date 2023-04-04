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
                 field("Check Journal Overlap"; Rec."IMP Check Journal Overlap")
                {
                    ApplicationArea = All;
                    Caption = 'Check Journal Overlap';

                }
                field("Mark Journal Overlap"; Rec."IMP Mark Journal Overlap")
                {
                    ApplicationArea = All;
                    Caption = 'Mark Journal Overlap';

                }
                 field("IMP Job Consulting Invoice PDF"; Rec."IMP Job Consulting Invoice PDF")
                {
                    ApplicationArea = All;
                    Caption = 'Job Consulting Invoice PDF';

                }
                

            }

        }
    }
}