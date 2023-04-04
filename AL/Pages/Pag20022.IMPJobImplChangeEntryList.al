page 50022 "IMP Job Change Entry List"
{
    Caption = 'Ressource Job Working Hours Month';
    //CardPageID = "IMP Cust. Consulting Inv. Card";
    Editable = true;
    PageType = List;
    SourceTable = "IMP Job Impl. Change Entry";
    DeleteAllowed = true;
    InsertAllowed = true;
    //TODO Multiline Delete with Status Check
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Implevit Cust Short Mark"; rec."Implevit Cust Short Mark")
                {
                    ApplicationArea = All;
                }
                field("Change No."; "Change No.")
                {
                    ApplicationArea = All;
                }

                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = All;
                }
                field("Create Date"; Rec."Creation Date")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
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
        }
    }
    var
        g_ToInvoicePerc: decimal;

    trigger OnAfterGetRecord()
    begin

    end;








    var
        Txt1_Txt: Label 'Do you want to set the %2 marked settlements to %1 status?';
        Txt2_Txt: Label '%1 settlements were processed.';
        Txt3_Txt: Label 'Changes have been made to the project capture journal lines for billing for %1 month %2 year %3 after creation. The settlement must be created and checked again.';
        Text50000: Label 'Should the Period be closed?';
        Text50001: Label 'Should the Period be opened?';



}

