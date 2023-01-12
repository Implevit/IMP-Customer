page 50018 "IMP Job Cons. Inv. Ev. List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "IMP Job Evaluation Line";

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field("Job No."; "Job No.")
                {
                    ApplicationArea = All;

                }
                field(Month; Rec.Month)
                {
                    ApplicationArea = All;
                }
                field(Year; Rec.Year)
                {
                    ApplicationArea = All;
                }

                field("Job Task No."; Rec."Job Task No.")
                {
                    ApplicationArea = All;
                }

                field("Ressource No."; Rec."Resource No.")
                {
                    ApplicationArea = All;
                }

                field("Job Task Description"; Rec."Job Task Description")
                {
                    ApplicationArea = All;
                }
                field("Quantity (act. Period)"; Rec."Quantity (act. Period)")
                {
                    ApplicationArea = All;
                }
                field("Quantity (prev. Periods)"; Rec."Quantity (prev. Periods)")
                {
                    ApplicationArea = All;
                }
                field("Quantity (Total)"; "Quantity (act. Period)"+"Quantity (prev. Periods)")
                {
                    ApplicationArea = All;
                }
                field(Budget;Budget)
                {
                    ApplicationArea = All;
                }
                field("Actual Balance";Budget-"Quantity (prev. Periods)"-"Quantity (act. Period)")
                {
                    ApplicationArea = All;
                }
                field("Not Inv. Qty. (prev. Periods)";"Not Inv. Qty. (prev. Periods)")
                {
                    ApplicationArea = All;
                }
                field("Not Inv. Qty. (act. Period)";"Not Inv. Qty. (act. Period)")
                {
                    ApplicationArea = All;
                }
                field("Goodwill (Total)";"Not Inv. Qty. (prev. Periods)"+"Not Inv. Qty. (act. Period)")
                {
                    ApplicationArea = All;
                }

            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}