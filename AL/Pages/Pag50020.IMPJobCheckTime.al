page 50020 "IMP Job Check Time"
{
    ApplicationArea = All;
    Caption = 'IMP Job Check Time';
    PageType = List;
    SourceTable = "Job Journal Line";
    SourceTableTemporary = true;
    LinksAllowed = true;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Job No."; Rec."Job No.")
                {
                    ApplicationArea = All;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                }
                field("IMP Time 1 from"; Rec."IMP Time 1 from")
                {
                    ApplicationArea = All;
                }
                field("IMP Time 1 to"; Rec."IMP Time 1 to")
                {
                    ApplicationArea = All;
                }
                field("IMP Time 2 from"; Rec."IMP Time 2 from")
                {
                    ApplicationArea = All;
                }
                field("IMP Time 2 to"; Rec."IMP Time 2 to")
                {
                    ApplicationArea = All;
                }
                field("IMP Time 3 from"; Rec."IMP Time 3 from")
                {
                    ApplicationArea = All;
                }
                field("IMP Time 3 to"; Rec."IMP Time 3 to")
                {
                }
            }
        }
    }
}
