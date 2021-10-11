page 50105 "IMP Job Consulting Inv. Lines"
{
    Caption = 'PProject settlement lines';
    PageType = List;
    SourceTable = "IMP Job Consulting Inv. Line";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Job No."; Rec."Job No.")
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
                field("Job Journal Template"; Rec."Job Journal Template")
                {
                    ApplicationArea = All;
                }
                field("Job Journal Batch"; Rec."Job Journal Batch")
                {
                    ApplicationArea = All;
                }
                field("Job Journal Line No."; Rec."Job Journal Line No.")
                {
                    ApplicationArea = All;
                }
                field("Job Task No."; Rec."Job Task No.")
                {
                    ApplicationArea = All;
                }
                field("Source Quantity"; Rec."Source Quantity")
                {
                    ApplicationArea = All;
                }
                field("Source Quantity to Invoice"; Rec."Source Quantity to Invoice")
                {
                    ApplicationArea = All;
                }
                field("Source Quantity not to Invoice"; Rec."Source Quantity not to Invoice")
                {
                    ApplicationArea = All;
                }
                field("Source Travel Time Quantity"; Rec."Source Travel Time Quantity")
                {
                    ApplicationArea = All;
                }
                field("Source Distance KM Quantity"; Rec."Source Distance KM Quantity")
                {
                    ApplicationArea = All;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                }
                field("Quantity to Invoice"; Rec."Quantity to Invoice")
                {
                    ApplicationArea = All;
                }
                field("Quantity not to Invoice"; Rec."Quantity not to Invoice")
                {
                    ApplicationArea = All;
                }
                field("Travel Time Quantity"; Rec."Travel Time Quantity")
                {
                    ApplicationArea = All;
                }
                field("Distance KM Quantity"; Rec."Distance KM Quantity")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Ressource No."; Rec."Resource No.")
                {
                    ApplicationArea = All;
                }
                field(Check; Rec.Check)
                {
                    ApplicationArea = All;
                }
                field("Job Task Description"; Rec."Job Task Description")
                {
                    ApplicationArea = All;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
