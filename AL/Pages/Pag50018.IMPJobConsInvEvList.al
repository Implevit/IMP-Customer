page 50018 "IMP Job Cons. Inv. Ev. List"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "IMP Job Evaluation Line";
    InsertAllowed = false;
    Editable = false;

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
                    Style = Strong;
                    StyleExpr = g_Format;
                }

                field("Ressource No."; Rec."Resource No.")
                {
                    ApplicationArea = All;
                    Style = Strong;
                    StyleExpr = g_Format;
                }

                field("Job Task Description"; Rec."Job Task Description")
                {
                    ApplicationArea = All;
                    Style = Strong;
                    StyleExpr = g_Format;
                }
                field("Quantity (act. Period)"; Rec."Quantity (act. Period)")
                {
                    ApplicationArea = All;
                    Style = Strong;
                    StyleExpr = g_Format;
                }
                field("Quantity (prev. Periods)"; Rec."Quantity (prev. Periods)")
                {
                    ApplicationArea = All;
                    Style = Strong;
                    StyleExpr = g_Format;
                }
                field("Quantity (Total)"; "Quantity (act. Period)"+"Quantity (prev. Periods)")
                {
                    ApplicationArea = All;
                    Style = Strong;
                    StyleExpr = g_Format;
                }
                field(Budget;Budget)
                {
                    ApplicationArea = All;
                    Style = Strong;
                    StyleExpr = g_Format;
                }
                field("Actual Balance";Budget-"Quantity (prev. Periods)"-"Quantity (act. Period)")
                {
                    ApplicationArea = All;
                    Style = Strong;
                    StyleExpr = g_Format;
                }
                field("Not Inv. Qty. (prev. Periods)";"Not Inv. Qty. (prev. Periods)")
                {
                    ApplicationArea = All;
                    Style = Strong;
                    StyleExpr = g_Format;
                }
                field("Not Inv. Qty. (act. Period)";"Not Inv. Qty. (act. Period)")
                {
                    ApplicationArea = All;
                    Style = Strong;
                    StyleExpr = g_Format;
                }
                field("Goodwill (Total)";"Not Inv. Qty. (prev. Periods)"+"Not Inv. Qty. (act. Period)")
                {
                    ApplicationArea = All;
                    Style = Strong;
                    StyleExpr = g_Format;
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
    var
        g_Format: Boolean;

    trigger OnAfterGetRecord()
    begin
        g_Format := "Job Task Type" <> "Job Task Type"::Posting;

    end;
}