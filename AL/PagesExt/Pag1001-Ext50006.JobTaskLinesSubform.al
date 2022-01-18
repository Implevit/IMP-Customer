pageextension 50006 "IMP Pag1001-Ext50006" extends "Job Task Lines Subform"
{
    layout
    {
        addlast(Control1)
        {
            field("IMP Closed"; Rec."IMP Closed")
            {
                ApplicationArea = All;
            }
            field("IMP All inclusive"; Rec."IMP All inclusive")
            {
                ApplicationArea = All;
            }
            field("IMP Schedule (Total hours)"; Rec."IMP Schedule (Total hours)")
            {
                ApplicationArea = All;
            }
            field("IMP Usage (Total hours)"; Rec."IMP Usage (Total hours)")
            {
                ApplicationArea = All;
            }
            field("IMP Total Inv. In Journal"; Rec."IMP Total Inv. In Journal")
            {
                ApplicationArea = All;
            }
            field("IMP Total Not Inv. In Journal"; Rec."IMP Total Not Inv. In Journal")
            {
                ApplicationArea = All;
            }
            field(IMPTotalUsageInJournal; IMPTotalUsageInJournal)
            {
                Caption = 'Total Usage in journal';
                ApplicationArea = All;
                Editable = false;
            }
            field("IMP Achieved Percent"; Rec."IMP Achieved Percent")
            {
                ApplicationArea = All;
            }
            field("IMP Total In Accounting"; Rec."IMP Total In Accounting")
            {
                ApplicationArea = All;
            }
            field("IMP Total Inv. In Accounting"; Rec."IMP Total Inv. In Accounting")
            {
                ApplicationArea = All;
            }
            field("IMP Total not. Inv. In Acc."; Rec."IMP Total not. Inv. In Acc.")
            {
                ApplicationArea = All;
            }
            field("IMP Sched. (Sales Amount LCY)"; Rec."IMP Sched. (Sales Amount LCY)")
            {
                ApplicationArea = All;
            }
            field("IMP Schedule (Sales Amount)"; Rec."IMP Schedule (Sales Amount)")
            {
                ApplicationArea = All;
            }

        }
    }

    #region Triggers

    trigger OnAfterGetRecord()
    begin
        Rec.CalcFields("IMP Usage (Total hours)", "IMP Total Inv. In Journal");
        IMPTotalUsageInJournal := Rec."IMP Usage (Total hours)" + Rec."IMP Total Inv. In Journal";
    end;

    #endregion Triggers

    var
        IMPTotalUsageInJournal: Decimal;
}