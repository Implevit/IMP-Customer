page 50014 "IMP Job Consulting Inv. Subf."
{
    PageType = ListPart;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "IMP Job Consulting Inv. Line";
    Caption = 'Job Consultion Invoice Subform';
    InsertAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(General)
            {

                field("Job No."; "Job No.")
                {
                    ApplicationArea = All;

                }
                field(Month; Month)
                {
                    ApplicationArea = All;

                }
                field(Year; Year)
                {
                    ApplicationArea = All;

                }
                field("Job Journal Template"; "Job Journal Template")
                {
                    ApplicationArea = All;

                }
                field("Job Journal Batch"; "Job Journal Batch")
                {
                    ApplicationArea = All;

                }
                field("Ressource No."; "Resource No.")
                {
                    ApplicationArea = All;

                }
                field("Job Journal Line No."; "Job Journal Line No.")
                {
                    ApplicationArea = All;

                }
                field("Posting Date"; "Posting Date")
                {
                    ApplicationArea = All;

                }
                field("Job Task No."; "Job Task No.")
                {
                    ApplicationArea = All;

                }
                field("Job Task Description"; "Job Task Description")
                {
                    ApplicationArea = All;

                }
                field(Description; Description)
                {
                    ApplicationArea = All;

                }

                field("Source Quantity"; "Source Quantity")
                {
                    ApplicationArea = All;

                }
                field("Source Quantity to Invoice"; "Source Quantity to Invoice")
                {
                    ApplicationArea = All;

                }
                field("Source Quantity not to Invoice";"Source Quantity not to Invoice")
                {
                    ApplicationArea = All;

                }
                field("Source Travel Time Quantity";"Source Travel Time Quantity")
                {
                    ApplicationArea = All;

                }
                field("Source Distance KM Quantity";"Source Distance KM Quantity")
                {
                    ApplicationArea = All;

                }
                field(Quantity;Quantity)
                {
                    ApplicationArea = All;

                }
                field("Quantity to Invoice";"Quantity to Invoice")
                {
                    ApplicationArea = All;

                }
                field("Quantity not to Invoice";"Quantity not to Invoice")
                {
                    ApplicationArea = All;

                }
                field("Travel Time Quantity";"Travel Time Quantity")
                {
                    ApplicationArea = All;

                }
                field("Ticket No.";"Ticket No.")
                {
                    ApplicationArea = All;

                }
                field("all inclusive";"all inclusive")
                {
                    ApplicationArea = All;

                }
                field(Check;Check)
                {
                    ApplicationArea = All;

                }
            }
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