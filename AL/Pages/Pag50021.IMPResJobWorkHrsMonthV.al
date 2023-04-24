page 50021 "IMP R. Job Wrk. Hrs. Mth. View"
{
    Caption = 'Ressource Job Working Hours Month';
    //CardPageID = "IMP Cust. Consulting Inv. Card";
    Editable = false;
    PageType = List;
    SourceTable = "IMP Job Working Hours Month";
    DeleteAllowed = true;
    //TODO Multiline Delete with Status Check
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Year; Year)
                {
                    ApplicationArea = All;
                }
                field("Month"; DATE2DMY("Month Start", 2))
                {
                    ApplicationArea = All;
                    Caption = 'Month';
                }

                field("Month Start"; Rec."Month Start")
                {
                    ApplicationArea = All;
                }
                
                field(No; Rec."No.")
                {
                    ApplicationArea = All;
                }
                /*
                field("Sell-to Customer No.."; Rec."Sell-to Customer No..")
                {
                    ApplicationArea = All;
                }
                */
                field(ExternalJobtoInvoice; Rec."External Job to Invoice")
                {
                    ApplicationArea = All;
                }
                field(ExternalJobNot2Invoice; "External Job Total" - "External Job to Invoice")
                {
                    ApplicationArea = All;
                    Caption = 'External Job not to invoice';
                }
                field(ExternalJobTotal; "External Job Total")
                {
                    ApplicationArea = All;
                }
                field(Admin; Rec.Admin)
                {
                    ApplicationArea = All;
                }
                field(Education; Rec.Education)
                {
                    ApplicationArea = All;
                }
                field(Vacation; Rec.Vacation)
                {
                    ApplicationArea = All;
                }
                field(Illness; Rec.Illness)
                {
                    ApplicationArea = All;
                }
                field(Akquisition; Rec.Acquisition)
                {
                    ApplicationArea = All;
                }
                field(InternalJob; Rec."Internal Job")
                {
                    ApplicationArea = All;
                }
                field(Total; Rec.Total)
                {
                    ApplicationArea = All;
                }
                field(Assignment; Rec.Assignment)
                {
                    ApplicationArea = All;
                }
                field(TargetTime; Rec."Target Time")
                {
                    ApplicationArea = All;
                }
                field(Balance; Rec.Total - "Target Time")
                {
                    ApplicationArea = All;
                    Caption = 'Balance';
                }
                field(g_ToInvoicePerc; g_ToInvoicePerc)
                {
                    ApplicationArea = All;
                }
                
                field(Closed; Rec.Closed)
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
        CALCFIELDS("External Job to Invoice");
        IF Total <> 0 THEN BEGIN
            g_ToInvoicePerc := "External Job to Invoice" * 100 / Total
        END;
    end;

    




    var
        Txt1_Txt: Label 'Do you want to set the %2 marked settlements to %1 status?';
        Txt2_Txt: Label '%1 settlements were processed.';
        Txt3_Txt: Label 'Changes have been made to the project capture journal lines for billing for %1 month %2 year %3 after creation. The settlement must be created and checked again.';
        Text50000: Label 'Should the Period be closed?';
        Text50001: Label 'Should the Period be opened?';

        
        
}

