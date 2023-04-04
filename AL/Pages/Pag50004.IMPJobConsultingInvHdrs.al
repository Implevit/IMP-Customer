page 50004 "IMP Job Consulting Inv. Hdrs"
{
    Caption = 'Project settlements';
    CardPageID = "IMP Job Consulting Inv. Card";
    Editable = false;
    PageType = List;
    SourceTable = "IMP Job Consulting Inv. Header";
    DeleteAllowed = true;
    //TODO Multiline Delete with Status Check
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
                    l_Job.SETRANGE("No.", "Job No.");
                    l_rptCreateJobInv.SetPeriod(Month, Year);
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
                    l_JobConsInv.SETRANGE("Modified after creation", TRUE);
                    IF l_JobConsInv.FINDFIRST THEN
                        ERROR(STRSUBSTNO(Txt3_Txt, l_JobConsInv."Job No.", l_JobConsInv.Year, l_JobConsInv.Month));
                    l_JobConsInv.SETRANGE("Modified after creation");
                    IF CONFIRM(STRSUBSTNO(STRSUBSTNO(Txt1_Txt, l_JobConsInv.Status::checked, l_JobConsInv.COUNT))) THEN BEGIN
                        l_JobConsInv.MODIFYALL(Status, l_JobConsInv.Status::checked);
                        MESSAGE(STRSUBSTNO(Txt2_Txt, l_JobConsInv.COUNT));
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
                    l_JobConsInv.SETRANGE(Exported, FALSE);
                    IF CONFIRM(STRSUBSTNO(STRSUBSTNO(Txt1_Txt, l_JobConsInv.Status::created, l_JobConsInv.COUNT))) THEN BEGIN
                        l_JobConsInv.MODIFYALL(Status, l_JobConsInv.Status::created);
                        MESSAGE(STRSUBSTNO(Txt2_Txt, l_JobConsInv.COUNT));
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
                    l_rptCreateJobEval: Report "IMP Create Job Eval.Acc.";
                begin
                    l_JobConsHeader.SETRANGE("Job No.", "Job No.");
                    l_JobConsHeader.SETRANGE(Month, Month);
                    l_JobConsHeader.SETRANGE(Year, Year);
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
                    l_ConsultingProofImplevit: Report "IMP Job Consulting Proof";

                begin
                    l_JobConsHeader.SETRANGE("Job No.", "Job No.");
                    l_JobConsHeader.SETRANGE(Year, Year);
                    l_JobConsHeader.SETRANGE(Month, Month);
                    l_ConsultingProofImplevit.SETTABLEVIEW(l_JobConsHeader);
                    l_ConsultingProofImplevit.RUN;

                end;
            }
            action(ProofOfBillingPDF)
            {
                Caption = 'PDF Export Proof of Billing';
                ApplicationArea = All;
                Image = SendAsPDF;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    
                    lc_Setup: Record "Jobs Setup";
                    lc_Rec: Record "IMP Job Consulting Inv. Header";
                    lc_Rec2: Record "IMP Job Consulting Inv. Header";                    
                    lc_Report: Report "IMP Job Consulting Proof";
                    lc_Counter: Integer;
                    lc_FullFileName: Text;
                begin
                    IF NOT CONFIRM('Sollen die ausgewählten Abrechnungen als PDF gespeichert werden?') THEN BEGIN
                        EXIT;
                    END;

                    lc_Setup.GET;
                    lc_Setup.TESTFIELD(lc_Setup."IMP Job Consulting Invoice PDF");
                    IF COPYSTR(lc_Setup."IMP Job Consulting Invoice PDF", STRLEN(lc_Setup."IMP Job Consulting Invoice PDF"), 1) <> '\' THEN BEGIN
                        lc_Setup."IMP Job Consulting Invoice PDF" += '\';
                        lc_Setup.MODIFY;
                    END;

                    lc_Counter := 0;

                    CurrPage.SETSELECTIONFILTER(lc_Rec);
                    IF lc_Rec.FIND('-') THEN BEGIN
                        REPEAT
                            lc_Rec2.SETRANGE("Job No.", lc_Rec."Job No.");
                            lc_Rec2.SETRANGE(Year, lc_Rec.Year);
                            lc_Rec2.SETRANGE(Month, lc_Rec.Month);
                            IF lc_Rec2.FINDSET THEN BEGIN
                                CLEAR(lc_Report);
                                lc_FullFileName := lc_Setup."IMP Job Consulting Invoice PDF" + lc_Rec2."Job No." + '-' + FORMAT(lc_Rec.Year) + '-' + FORMAT(lc_Rec.Month) + '.pdf';
                                lc_Report.SETTABLEVIEW(lc_Rec2);
                                IF lc_Report.SAVEASPDF(lc_FullFileName) THEN BEGIN
                                    lc_Counter += 1;
                                END;
                            END;
                        UNTIL lc_Rec.NEXT = 0;
                    END;

                    MESSAGE('%1 Abrechnungen wurden als PDF gespeichert', lc_Counter);

                end;
            }

        }
    }

    var
        Txt1_Txt: Label 'Do you want to set the %2 marked settlements to %1 status?';
        Txt2_Txt: Label '%1 settlements were processed.';
        Txt3_Txt: Label 'Changes have been made to the project capture journal lines for billing for %1 month %2 year %3 after creation. The settlement must be created and checked again.';
}

