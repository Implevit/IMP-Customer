page 50015 "IMP Cust. Consulting Inv. Hdrs"
{
    Caption = 'Customer Project Settlements';
    CardPageID = "IMP Cust. Consulting Inv. Card";
    Editable = false;
    PageType = List;
    SourceTable = "IMP Cust. Cons. Inv. Header";
    DeleteAllowed = true;    
    //TODO Multiline Delete with Status Check
    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                }
                field("Period Code"; Rec."Period Code")
                {
                    ApplicationArea = All;
                }
                field("Creation Date"; Rec."Creation Date")
                {
                    ApplicationArea = All;
                }
                field("Document Date"; Rec."Document Date")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                }
                /*
                field("Sell-to Customer No.."; Rec."Sell-to Customer No..")
                {
                    ApplicationArea = All;
                }
                */
                field("Bill-to Customer No."; Rec."Bill-to Customer No.")
                {
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Created by User"; Rec."Created by User")
                {
                    ApplicationArea = All;
                }
                field(Year; Rec.Year)
                {
                    ApplicationArea = All;
                }
                field(Month; Rec.Month)
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
                field("Quantity Travel Time"; Rec."Quantity Travel Time")
                {
                    ApplicationArea = All;
                }
                field("Quantity KM"; Rec."Quantity KM")
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
                field("Source Quantity Travel Time"; Rec."Source Quantity Travel Time")
                {
                    ApplicationArea = All;
                }
                field("Source Quantity KM"; Rec."Source Quantity KM")
                {
                    ApplicationArea = All;
                }
                field("Project Manager IMPL"; Rec."Project Manager IMPL")
                {
                    ApplicationArea = All;
                }
                field("Filter Quantity"; Rec."Filter Quantity")
                {
                    ApplicationArea = All;
                }
                field("Filter Quantity to Invoice"; Rec."Filter Quantity to Invoice")
                {
                    ApplicationArea = All;
                }
                field("Filter Quantity not to Invoice"; Rec."Filter Quantity not to Invoice")
                {
                    ApplicationArea = All;
                }
                field("Modified after creation"; Rec."Modified after creation")
                {
                    ApplicationArea = All;
                }
                field("Job Accounting Description"; Rec."Job Accounting Description")
                {
                    ApplicationArea = All;
                }
                field("Accounting Description"; Rec."Accounting Description")
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
            action(CreateAccounting)
            {
                Caption = 'Create Accounting';
                ApplicationArea = All;
                Image = JobSalesInvoice;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;               

                trigger OnAction()
                var
                    l_Customer: record Customer;
                    l_rptCreateJobInv: Report "IMP Create Cust. Cons. Inv.";
                begin
                    l_Customer.SETRANGE("No.","Customer No.");
                    l_rptCreateJobInv.SetPeriod(Month,Year);
                    l_rptCreateJobInv.SETTABLEVIEW(l_Customer);
                    l_rptCreateJobInv.RUNMODAL;
                    
                end;
            }
            action(SetStateChecked)
            {
                Caption = 'Set State to Checked';
                ApplicationArea = All;
                Image = ChangeStatus;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;               

                trigger OnAction()
                var
                    l_JobConsInv: Record "IMP Job Consulting Inv. Header";
                begin
                    CurrPage.SETSELECTIONFILTER(l_JobConsInv);
                    l_JobConsInv.SETRANGE("Modified after creation",TRUE);
                    IF l_JobConsInv.FINDFIRST THEN
                        ERROR(STRSUBSTNO(Txt3_Txt,l_JobConsInv."Job No.",l_JobConsInv.Year,l_JobConsInv.Month));
                    l_JobConsInv.SETRANGE("Modified after creation");
                    IF CONFIRM(STRSUBSTNO(STRSUBSTNO(Txt1_Txt,l_JobConsInv.Status::checked,l_JobConsInv.COUNT))) THEN BEGIN
                        l_JobConsInv.MODIFYALL(Status,l_JobConsInv.Status::checked);
                        MESSAGE(STRSUBSTNO(Txt2_Txt,l_JobConsInv.COUNT));
                    END;

                end;
            }
            action(SetStateOpen)
            {
                Caption = 'Set State to Open';
                ApplicationArea = All;
                Image = ChangeTo;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;               

                trigger OnAction()
                var
                    l_JobConsInv: Record "IMP Job Consulting Inv. Header";
                begin
                    CurrPage.SETSELECTIONFILTER(l_JobConsInv);
                    l_JobConsInv.SETRANGE(Exported,FALSE);
                    IF CONFIRM(STRSUBSTNO(STRSUBSTNO(Txt1_Txt,l_JobConsInv.Status::created,l_JobConsInv.COUNT))) THEN BEGIN
                    l_JobConsInv.MODIFYALL(Status,l_JobConsInv.Status::created);
                    MESSAGE(STRSUBSTNO(Txt2_Txt,l_JobConsInv.COUNT));
                    END;
                end;
            }
            action(Evaluation)
            {
                Caption = 'Evaluation';
                ApplicationArea = All;
                Image = JobRegisters;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;               

                trigger OnAction()
                var
                    l_JobConsHeader: Record "IMP Cust. Cons. Inv. Header";
                    l_rptCreateJobEval: Report "IMP Create Cust. Job Eval.Acc.";
                begin
                    
                    l_JobConsHeader.SETRANGE("Customer No.","Customer No.");
                    l_JobConsHeader.SETRANGE(Month,Month);
                    l_JobConsHeader.SETRANGE(Year,Year);

                    l_rptCreateJobEval.SETTABLEVIEW(l_JobConsHeader);
                    l_rptCreateJobEval.USEREQUESTPAGE(FALSE);
                    l_rptCreateJobEval.RUNMODAL;
                end;
            }
            action(ProofOfBilling)
            {
                Caption = 'Proof of Billing';
                ApplicationArea = All;
                Image = Report2;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;               

                trigger OnAction()
                var
                    l_JobConsHeader: Record "IMP Job Consulting Inv. Header";
                begin
                    //TODO Report Proof of Billing
                    /*
                    l_JobConsHeader.SETRANGE("Job No.","Job No.");
                    l_JobConsHeader.SETRANGE(Year,Year);
                    l_JobConsHeader.SETRANGE(Month,Month);
                    
                    l_ConsultingProofImplevit.SETTABLEVIEW(l_JobConsultingInvoiceHeader);
                    l_ConsultingProofImplevit.RUN;
                    */
                end;
            }
        }
    }

    var
        Txt1_Txt: Label 'Do you want to set the %2 marked settlements to %1 status?';
        Txt2_Txt: Label '%1 settlements were processed.';
        Txt3_Txt: Label 'Changes have been made to the project capture journal lines for billing for %1 month %2 year %3 after creation. The settlement must be created and checked again.';
}

