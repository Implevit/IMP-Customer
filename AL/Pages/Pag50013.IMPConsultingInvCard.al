page 50013 "IMP Job Consulting Inv. Card"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "IMP Job Consulting Inv. Header";
    Caption = 'Job Consulting Invoice Card';

    layout
    {
        area(Content)
        {
            group(General)
            {

                field("Job No."; "Job No.")
                {
                    ApplicationArea = All;

                }
                field(Year; Year)
                {
                    ApplicationArea = All;

                }
                field(Month; Month)
                {
                    ApplicationArea = All;

                }
                field("Creation Date"; "Creation Date")
                {
                    ApplicationArea = All;

                }
                field("Document Date"; "Document Date")
                {
                    ApplicationArea = All;

                }
                field(Status; Status)
                {
                    ApplicationArea = All;

                }
                field("Sell-to Customer No.."; "Sell-to Customer No.")
                {
                    ApplicationArea = All;

                }
                field("Bill-to Customer No."; "Bill-to Customer No.")
                {
                    ApplicationArea = All;

                }
                field(Description; Description)
                {
                    ApplicationArea = All;

                }
                field("Job Accounting Description"; "Job Accounting Description")
                {
                    ApplicationArea = All;

                }
                field("Accounting Description"; "Accounting Description")
                {
                    ApplicationArea = All;

                }
                field("Created by User"; "Created by User")
                {
                    ApplicationArea = All;

                }
                field("Modified after creation"; "Modified after creation")
                {
                    ApplicationArea = All;

                }
                field(Quantity; Quantity)
                {
                    ApplicationArea = All;

                }
                field("Quantity to Invoice"; "Quantity to Invoice")
                {
                    ApplicationArea = All;

                }
                field("Quantity not to Invoice"; "Quantity not to Invoice")
                {
                    ApplicationArea = All;

                }
                field("Quantity Travel Time"; "Quantity Travel Time")
                {
                    ApplicationArea = All;

                }
                field("Quantity KM"; "Quantity KM")
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
                field("Source Quantity not to Invoice"; "Source Quantity not to Invoice")
                {
                    ApplicationArea = All;

                }
                field("Source Quantity Travel Time"; "Source Quantity Travel Time")
                {
                    ApplicationArea = All;

                }
                field("Source Quantity KM"; "Source Quantity KM")
                {
                    ApplicationArea = All;

                }
                field("Project Manager IMPL"; "Project Manager IMPL")
                {
                    ApplicationArea = All;

                }
                field("Filter Quantity"; "Filter Quantity")
                {
                    ApplicationArea = All;

                }
                field("Filter Quantity to Invoice"; "Filter Quantity to Invoice")
                {
                    ApplicationArea = All;

                }
                field("Filter Quantity not to Invoice"; "Filter Quantity not to Invoice")
                {
                    ApplicationArea = All;

                }
               

            }
             part(Lines; "IMP Job Consulting Inv. Subf.")
                {
                    SubPageLink = "Job No." = FIELD("Job No."), Month = FIELD(Month), Year = FIELD(Year);
                    ApplicationArea = All;
                    UpdatePropagation = Both;
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

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        myInt: Integer;
}