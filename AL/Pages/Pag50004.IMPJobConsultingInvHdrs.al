page 50004 "IMP Job Consulting Inv. Hdrs"
{
    Caption = 'Project settlements';
    //CardPageID = "IMP Job Consulting Inv. Card";
    Editable = false;
    PageType = List;
    SourceTable = "IMP Job Invoice Header";

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
        area(reporting)
        {
            action(CreateAccounting)
            {
                Caption = 'Create Accounting';
                Image = JobSalesInvoice;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    lc_Job: Record Job;
                    lc_rptCreateJobInv: Report "Create Contract Invoices"; // "Create Job Cons. Invoice";
                begin
                    //lc_Job.SETRANGE("No.","Job No.");
                    if GetRes() <> '' then
                        lc_Job.SetRange("IMP Project Manager IMPL", GetRes());
                    //lc_rptCreateJobInv.SetPeriod(Month, Rec.Year);
                    lc_rptCreateJobInv.SetTableView(lc_Job);
                    lc_rptCreateJobInv.RunModal();
                end;
            }
            action(Evaluation)
            {
                Caption = 'Evaluation';
                Image = JobRegisters;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    lc_JobConsHeader: Record "IMP Job Invoice Header";
                    lc_rptCreateJobEval: Report "Create Contract Invoices"; //  Report "Create Job Eval.";
                begin

                    lc_JobConsHeader.SetRange("Job No.", "Job No.");
                    lc_JobConsHeader.SetRange(Month, Month);
                    lc_JobConsHeader.SetRange(Year, Year);
                    lc_rptCreateJobEval.SetTableView(lc_JobConsHeader);
                    lc_rptCreateJobEval.UseRequestPage(false);
                    lc_rptCreateJobEval.RunModal();
                end;
            }
            action(SetStateChecked)
            {
                Caption = 'Set settlements to checked';
                Image = ChangeStatus;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    lc_JobConsInv: Record "IMP Job Invoice Header";
                begin
                    CurrPage.SetSelectionFilter(lc_JobConsInv);
                    lc_JobConsInv.SetRange("Modified after creation", true);
                    if lc_JobConsInv.FindFirst() then
                        Error(Txt3_Txt, lc_JobConsInv."Job No.", lc_JobConsInv.Year, lc_JobConsInv.Month);
                    lc_JobConsInv.SetRange("Modified after creation");
                    if Confirm(StrSubstNo(StrSubstNo(Txt1_Txt, lc_JobConsInv.Status::checked, lc_JobConsInv.Count))) then begin
                        lc_JobConsInv.ModifyAll(Status, lc_JobConsInv.Status::checked);
                        Message(StrSubstNo(Txt2_Txt, lc_JobConsInv.Count));
                    end;
                end;
            }
            action(SetStateOpen)
            {
                Caption = 'Setze Abrechnungen auf erstellt';
                Image = ChangeTo;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    lc_JobConsInv: Record "IMP Job Invoice Header";
                begin
                    CurrPage.SetSelectionFilter(lc_JobConsInv);
                    lc_JobConsInv.SetRange(Exported, false);
                    if Confirm(StrSubstNo(StrSubstNo(Txt1_Txt, lc_JobConsInv.Status::created, lc_JobConsInv.Count))) then begin
                        lc_JobConsInv.ModifyAll(Status, lc_JobConsInv.Status::created);
                        Message(Txt2_Txt, lc_JobConsInv.Count);
                    end;
                end;
            }
            action(SetActualPeriod)
            {
                Caption = 'Filter akt. Abrechsperiode';
                Image = PeriodStatus;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    lc_Date: Date;
                begin
                    lc_Date := CalcDate('<-1M>', Today());
                    Rec.SetRange(Year, Date2DMY(lc_Date, 3));
                    Rec.SetRange(Month, Date2DMY(lc_Date, 2) - 1);
                end;
            }
            action("Abrechnungsnachweis Implevit")
            {
                Caption = 'Abrechnungsnachweis Implevit';
                Image = Report2;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;

                trigger OnAction()
                var
                    lc_JobConsultingInvoiceHeader: Record "IMP Job Invoice Header";
                    lc_ConsultingProofImplevit: Report "Create Contract Invoices"; //"Consulting proof IMPL New";
                begin
                    lc_JobConsultingInvoiceHeader.SetRange("Job No.", Rec."Job No.");
                    lc_JobConsultingInvoiceHeader.SetRange(Year, Rec.Year);
                    lc_JobConsultingInvoiceHeader.SetRange(Month, Rec.Month);
                    lc_ConsultingProofImplevit.SetTableView(lc_JobConsultingInvoiceHeader);
                    lc_ConsultingProofImplevit.Run();
                end;
            }
        }
    }

    var
        Txt1_Txt: Label 'Do you want to set the %2 marked settlements to %1 status?';
        Txt2_Txt: Label '%1 settlements were processed.';
        Txt3_Txt: Label 'Changes have been made to the project capture journal lines for billing for %1 month %2 year %3 after creation. The settlement must be created and checked again.';
}

