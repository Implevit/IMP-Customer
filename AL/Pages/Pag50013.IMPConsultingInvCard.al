page 50013 "IMP Job Consulting Inv. Card"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;
    SourceTable = "IMP Job Consulting Inv. Header";
    Caption = 'Job Consulting Invoice Card';
    ShowFilter = true;

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
                    l_Job: record job;
                    l_rptCreateJobInv: Report "IMP Create Job Cons. Invoice";
                begin
                    l_Job.SETRANGE("No.","Job No.");
                    l_rptCreateJobInv.SetPeriod(Month,Year);
                    l_rptCreateJobInv.SETTABLEVIEW(l_Job);
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
                        ERROR(STRSUBSTNO(Text50002,l_JobConsInv."Job No.",l_JobConsInv.Year,l_JobConsInv.Month));
                    l_JobConsInv.SETRANGE("Modified after creation");
                    IF CONFIRM(STRSUBSTNO(STRSUBSTNO(Text50000,l_JobConsInv.Status::checked,l_JobConsInv.COUNT))) THEN BEGIN
                        l_JobConsInv.MODIFYALL(Status,l_JobConsInv.Status::checked);
                        MESSAGE(STRSUBSTNO(Text50001,l_JobConsInv.COUNT));
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
                    IF CONFIRM(STRSUBSTNO(STRSUBSTNO(Text50000,l_JobConsInv.Status::created,l_JobConsInv.COUNT))) THEN BEGIN
                    l_JobConsInv.MODIFYALL(Status,l_JobConsInv.Status::created);
                    MESSAGE(STRSUBSTNO(Text50001,l_JobConsInv.COUNT));
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
                    l_JobConsHeader: Record "IMP Job Consulting Inv. Header";
                begin
                    l_JobConsHeader.SETRANGE("Job No.","Job No.");
                    l_JobConsHeader.SETRANGE(Month,Month);
                    l_JobConsHeader.SETRANGE(Year,Year);
                    //TODO Create Evaluation
                    /*
                    l_rptCreateJobEval.SETTABLEVIEW(l_JobConsHeader);
                    l_rptCreateJobEval.USEREQUESTPAGE(FALSE);
                    l_rptCreateJobEval.RUNMODAL;
                    */
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
                    l_ConsultingProofImplevit: Report "IMP Job Consulting Proof";

                begin
                    l_JobConsHeader.SETRANGE("Job No.","Job No.");
                    l_JobConsHeader.SETRANGE(Year,Year);
                    l_JobConsHeader.SETRANGE(Month,Month);                    
                    l_ConsultingProofImplevit.SETTABLEVIEW(l_JobConsHeader);
                    l_ConsultingProofImplevit.RUN;
                    
                end;
            }
        }
    }

    var
        
        Text50000: Label 'Möchten Sie die %2 markierten Abrechnungen auf den Status %1 setzen?';
        Text50001: Label '%1 Abrechnungen wurden verarbeitet';
        Text50002: Label 'Es wurden Änderungen an den Projekterfassungsjournalzeilen für die Abrechnung für %1 Monat %2 Jahr %3 nach Erstellung vorgenommen. Die Abrechnung muss erneut erzeugt und geprüft werden.';
}