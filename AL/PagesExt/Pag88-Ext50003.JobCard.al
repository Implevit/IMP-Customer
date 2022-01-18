pageextension 50003 "IMP Pag88-Ext50003" extends "Job Card"
{
    layout
    {
        addbefore("Bill-to Contact")
        {
            field("IMP Bill-Receiver Contact No."; Rec."IMP Bill-Receiver Contact No.")
            {
                ApplicationArea = All;
            }
        }
        addafter("Project Manager")
        {
            field("IMP Project Manager IMPL"; Rec."IMP Project Manager IMPL")
            {
                ApplicationArea = All;
            }
            field("IMP Project Manager Standby"; Rec."IMP Project Manager Standby")
            {
                ApplicationArea = All;
            }
            field("IMP New Cust Short Mark"; Rec."IMP New Cust Short Mark")
            {
                ApplicationArea = All;
            }
        }
        addbefore(Status)
        {
            field("IMP Internal Job"; Rec."IMP Internal Job")
            {
                ApplicationArea = All;
            }
            field("IMP Flat charge"; Rec."IMP Flat charge")
            {
                ApplicationArea = All;
            }
            field("IMP Job Task No. Expenses"; Rec."IMP Job Task No. Expenses")
            {
                ApplicationArea = All;
            }
            field("IMP Distance km"; Rec."IMP Distance km")
            {
                ApplicationArea = All;
            }
            field("IMP Travel Time (100er units)"; Rec."IMP Travel Time (100er units)")
            {
                ApplicationArea = All;
            }
            field("IMP No Settlement Statement"; Rec."IMP No Settlement Statement")
            {
                ApplicationArea = All;
            }
            field("IMP Source Settl. Statement"; Rec."IMP Source Settl. Statement")
            {
                ApplicationArea = All;
            }
            field("IMP Accounting Description"; Rec."IMP Accounting Description")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        addlast("&Job")
        {
            action(ActJobJobTasksOverview)
            {
                Caption = 'Job Tasks Overview';
                ApplicationArea = All;
                Image = JobLines;
                Promoted = true;
                PromotedCategory = Category7;

                trigger OnAction()
                var
                    lc_JT: Record "Job Task";
                begin
                    lc_JT.Reset();
                    lc_JT.SetRange("Job No.", Rec."No.");
                    if lc_JT.FindSet() then;
                    Page.Run(Page::"Job Task List", lc_JT);
                end;
            }
        }
    }
}