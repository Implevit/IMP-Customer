pageextension 50005 "IMP Pag201-Ext50005" extends "Job Journal"
{
    layout
    {

        modify(CurrentJnlBatchName)
        {
            Editable = AllowJnlChange;
        }

        modify("Line Type")
        {
            Visible = false;
        }

        modify("Document No.")
        {
            Visible = false;
        }

        modify("Location Code")
        {
            Visible = false;
        }

        modify("Bin Code")
        {
            Visible = false;
        }

        modify("Unit Cost")
        {
            Visible = false;
        }

        modify("Unit Cost (LCY)")
        {
            Visible = false;
        }

        modify("Unit Price")
        {
            Visible = false;
        }

        modify("Applies-to Entry")
        {
            Visible = false;
        }

        modify("Line Amount")
        {
            Visible = false;
        }

        modify("Line Discount %")
        {
            Visible = false;
        }

        modify("Line Discount Amount")
        {
            Visible = false;
        }

        modify("Direct Unit Cost (LCY)")
        {
            Visible = false;
        }

        modify("Total Cost (LCY)")
        {
            Visible = false;
        }

        modify("Total Cost")
        {
            Visible = false;
        }

        addbefore(Description)
        {
            field("IMP Job Task Description"; "IMP Job Task Description")
            {
                ApplicationArea = All;

                StyleExpr = g_StyleText;

            }
        }

        addlast(Control1)
        {

            field("IMP Time 1 from"; Rec."IMP Time 1 from")
            {
                ApplicationArea = All;
                StyleExpr = g_StyleText;
            }
            field("IMP Time 1 to"; Rec."IMP Time 1 to")
            {
                ApplicationArea = All;
                StyleExpr = g_StyleText;
            }
            field("IMP Time 2 from"; Rec."IMP Time 2 from")
            {
                ApplicationArea = All;
                StyleExpr = g_StyleText;
            }
            field("IMP Time 2 to"; Rec."IMP Time 2 to")
            {
                ApplicationArea = All;
                StyleExpr = g_StyleText;
            }
            field("IMP Time 3 from"; Rec."IMP Time 3 from")
            {
                ApplicationArea = All;
                StyleExpr = g_StyleText;
            }
            field("IMP Time 3 to"; Rec."IMP Time 3 to")
            {
                ApplicationArea = All;
                StyleExpr = g_StyleText;
            }
            field("IMP Total from/to"; Rec."IMP Total from/to")
            {
                ApplicationArea = All;
                StyleExpr = g_StyleText;
            }
            field("IMP Travel Time"; Rec."IMP Travel Time")
            {
                ApplicationArea = All;

            }
            field("IMP km"; Rec."IMP km")
            {
                ApplicationArea = All;
            }
            field("IMP Travel km + Time integrate"; Rec."IMP Travel km + Time integrate")
            {
                ApplicationArea = All;
            }
            field("IMP Time on Job"; Rec."IMP Time on Job")
            {
                ApplicationArea = All;
            }
            field("IMP Hours to invoice"; Rec."IMP Hours to invoice")
            {
                ApplicationArea = All;
            }
            field("IMP Hours not to invoice"; Rec."IMP Hours not to invoice")
            {
                ApplicationArea = All;
            }
            field("IMP Ticket No."; Rec."IMP Ticket No.")
            {
                ApplicationArea = All;
            }
            field("IMP All inclusive"; Rec."IMP All inclusive")
            {
                ApplicationArea = All;
            }

        }
        addafter("Account Name")
        {
            group(GrpOverlappings)
            {
                Caption = 'Overlappings';
                field(NoOfOverlapps; NoOfOverlapps)
                {
                    Editable = false;
                    ShowCaption = false;
                }
            }
            group(GrpPercentToBudget)
            {
                Caption = '% to budget';
                field(DiffToBudget; DiffToBudget)
                {
                    Editable = false;
                    ShowCaption = false;
                }
            }
            group(GrpTotalDay)
            {
                Caption = 'Total day';
                field(TotalDay; TotalDay)
                {
                    Editable = false;
                    ShowCaption = false;
                }
            }
            group(GrpTotalFromTo)
            {
                Caption = 'Total von/bis';
                field(TotalFromTo; TotalFromTo)
                {
                    Editable = false;
                    ShowCaption = false;
                }
            }
            group(GrpTimeOnJob)
            {
                Caption = 'Time on job';
                field(TimeOnJob; TimeOnJob)
                {
                    Editable = false;
                    ShowCaption = false;
                }
            }
            group(GrpHourInvoicable)
            {
                Caption = 'Hours invoicable';
                field(HoursInvoicable; HoursInvoicable)
                {
                    Editable = false;
                    ShowCaption = false;
                }
            }
            group(GrpTravelTime)
            {
                Caption = 'Tavel time';
                field(CommuteTime; CommuteTime)
                {
                    Editable = false;
                    ShowCaption = false;
                }
            }
            group(GrpHoursNotInvoicable)
            {
                Caption = 'Hours not invoicable';
                field(HoursNotInvoicable; HoursNotInvoicable)
                {
                    Editable = false;
                    ShowCaption = false;
                }
            }

        }
    }

    actions
    {

        addafter(Dimensions)
        {
            /*
            action(CreateAccounting)
            {
                Caption = 'Employye Working Hours';
                ApplicationArea = All;
                Image = Timesheet;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    //l_rptGetResHours: Report GET Res;
                    
                begin
                    
                    //l_rptGetResHours.SetRes(CurrentJnlBatchName);
                    //l_rptGetResHours.RUN;
                end;
            }
            */
            action(JobCheckTimeAction)
            {
                ApplicationArea = All;
                Caption = 'Job Check Time';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = CheckDuplicates;

                trigger OnAction()
                var
                begin
                    JobCheckTime(Rec, false, true);
                end;
            }
            action(ResWorkingHours)
            {
                ApplicationArea = All;
                Caption = 'Ressource Working Hours';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = CheckDuplicates;

                trigger OnAction()
                var
                    l_rptGetResHours: Report "IMP Get Job Wor. Hrs. Month V.";
                begin
                    l_rptGetResHours.SetRes(lc_userSetup."IMP Job Resource No.");
                    l_rptGetResHours.RUN;
                end;
            }
            action(ChangeList)
            {
                ApplicationArea = All;
                Caption = 'Object Change List';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = ChangeLog;

                trigger OnAction()
                var
                    lc_Job: Record Job;
                    lc_Msg1: Label 'Please insert %1 first!';
                    lc_ChangeEntry: Record "IMP Job Impl. Change Entry";
                begin
                    IF lc_Job.GET("Job No.") THEN BEGIN
                        IF lc_Job."IMP New Cust Short Mark" = '' THEN BEGIN
                            MESSAGE(STRSUBSTNO(lc_Msg1, lc_Job.FIELDCAPTION("IMP New Cust Short Mark")));
                        END ELSE BEGIN
                            lc_ChangeEntry.RESET;
                            lc_ChangeEntry.SETRANGE("Job No.", "Job No.");
                            PAGE.RUNMODAL(PAGE::"IMP Job Change Entry List", lc_ChangeEntry);
                        END;
                    END;
                end;

            }
        }
    }

    #region Trigger

    trigger OnOpenPage()
    var

        lc_JobJnlManagement: Codeunit JobJnlManagement;
        lc_CurrentJnlBatchName: Code[10];
    begin
        g_JobSetup.get;
        if not lc_userSetup.get(UserId) then
            lc_userSetup.Init()
        else begin
            if (lc_UserSetup."Journal Batch Name" <> '') and (lc_UserSetup."Journal Template Name" <> '') then begin
                lc_CurrentJnlBatchName := lc_UserSetup."Journal Batch Name";
                Rec.SetRange("Journal Template Name", lc_UserSetup."Journal Template Name");
                lc_JobJnlManagement.OpenJnl(lc_CurrentJnlBatchName, Rec);
            end;
            AllowJnlChange := lc_userSetup."IMP Job Jnl. changes allowed";
        end;

    end;


    trigger OnAfterGetCurrRecord()
    begin
        TotalFromTo := FORMAT(Rec."IMP Total from/to", 0, '<Precision,2:3><Standard Format,0>');
        TimeOnJob := FORMAT(Rec."IMP Time on Job", 0, '<Precision,2:3><Standard Format,0>');
        HoursInvoicable := FORMAT(Rec."IMP Hours to invoice", 0, '<Precision,2:3><Standard Format,0>');
        HoursNotInvoicable := FORMAT(Rec."IMP Hours not to invoice", 0, '<Precision,2:3><Standard Format,0>');
        CommuteTime := FORMAT(Rec."IMP Travel Time", 0, '<Precision,2:3><Standard Format,0>');
        TotalDay := Format(CalcDay(Rec), 0, '<Precision,2:3><Standard Format,0>');
        NoOfOverlapps := Format(CalcOverlappings(Rec));
        DiffToBudget := Format(CalcDiffToBudget(Rec), 0, '<Precision,2:3><Standard Format,0>');

        JobCheckTime(Rec, true, false);
        //g_StyleText := SetStyle();


    end;

    trigger OnAfterGetRecord()
    begin
        if g_JobSetup."IMP Mark Journal Overlap" then
            g_StyleText := SetStyle();
    end;

    #endregion Triggers

    #region Methodes

    procedure CalcDay(_Rec: Record "Job Journal Line"): Decimal
    var
        lc_JJL: Record "Job Journal Line";
    begin
        lc_JJL.Reset();
        lc_JJL.SetRange("Posting Date", _Rec."Posting Date");
        lc_JJL.SetRange("Journal Template Name", _Rec."Journal Template Name");
        lc_JJL.SetRange("Journal Batch Name", _Rec."Journal Batch Name");
        lc_JJL.SetRange("No.", _Rec."No.");
        lc_JJL.CalcSums("IMP Total from/to");
        exit(lc_JJL."IMP Total from/to");
    end;

    procedure CalcOverlappings(_Rec: Record "Job Journal Line") RetValue: Integer
    var
        lc_JJLTemp: Record "Job Journal Line" temporary;
        lc_JJL: Record "Job Journal Line";
        lc_LineNo: Integer;
        lc_Number: Code[20];
        lc_Date: Date;
        lc_TimeTo: Decimal;
        lc_First: Boolean;
    begin
        // Init
        RetValue := 0;

        // Clear
        lc_JJLTemp.DeleteAll(true);

        // Find journal lines for the same day
        lc_JJL.Reset();
        lc_JJL.SetRange("Posting Date", _Rec."Posting Date");
        lc_JJL.SetRange("Journal Template Name", _Rec."Journal Template Name");
        lc_JJL.SetRange("Journal Batch Name", _Rec."Journal Batch Name");

        if lc_JJL.Find('-') then begin
            lc_LineNo := 10000;
            // Store the lines temporary
            repeat
                if (lc_JJL."IMP Time 1 from" <> 0) and (lc_JJL."IMP Time 1 to" <> 0) then begin
                    lc_LineNo += 10000;
                    lc_JJLTemp.Init();
                    lc_JJLTemp.TransferFields(lc_JJL);
                    lc_JJLTemp."Applies-to Entry" := lc_JJL."Line No.";
                    lc_JJLTemp."Line No." := lc_LineNo;
                    lc_JJLTemp.Insert();
                end;

                if (lc_JJL."IMP Time 2 from" <> 0) and (lc_JJL."IMP Time 2 to" <> 0) then begin
                    lc_LineNo += 10000;
                    lc_JJLTemp.Init();
                    lc_JJLTemp.TransferFields(lc_JJL);
                    lc_JJLTemp."Applies-to Entry" := lc_JJL."Line No.";
                    lc_JJLTemp."Line No." := lc_LineNo;
                    lc_JJLTemp."IMP Time 1 from" := lc_JJL."IMP Time 2 from";
                    lc_JJLTemp."IMP Time 1 to" := lc_JJL."IMP Time 2 to";
                    lc_JJLTemp.Insert();
                end;

                if (lc_JJL."IMP Time 3 from" <> 0) and (lc_JJL."IMP Time 3 to" <> 0) then begin
                    lc_LineNo += 10000;
                    lc_JJLTemp.Init();
                    lc_JJLTemp.TransferFields(lc_JJL);
                    lc_JJLTemp."Applies-to Entry" := lc_JJL."Line No.";
                    lc_JJLTemp."Line No." := lc_LineNo;
                    lc_JJLTemp."IMP Time 1 from" := lc_JJL."IMP Time 3 from";
                    lc_JJLTemp."IMP Time 1 to" := lc_JJL."IMP Time 3 to";
                    lc_JJLTemp.Insert();
                end;
            until lc_JJL.Next() = 0;
        end;

        // Process temporary lines
        lc_JJLTemp.SetCurrentKey("No.", "Posting Date", "IMP Time 1 from", "IMP Time 1 to");
        if lc_JJLTemp.Find('-') then begin
            lc_First := true;
            lc_Number := '';
            lc_Date := 0D;
            lc_TimeTo := 0;
            repeat
                if ((lc_JJLTemp."No." = lc_Number) and (lc_JJLTemp."Posting Date" = lc_Date) and (lc_JJLTemp."IMP Time 1 from" < lc_TimeTo)) then begin
                    lc_Number := lc_JJLTemp."No.";
                    lc_Date := lc_JJLTemp."Posting Date";
                    lc_TimeTo := lc_JJLTemp."IMP Time 1 to";
                end else begin
                    lc_Number := lc_JJLTemp."No.";
                    lc_Date := lc_JJLTemp."Posting Date";
                    lc_TimeTo := lc_JJLTemp."IMP Time 1 to";
                    if not lc_First then begin
                        lc_JJLTemp.Delete();
                        //TODO Overloop Check
                        _Rec.TransferFields(lc_JJLTemp);


                    end;
                end;
                lc_First := false;
            until lc_JJLTemp.Next() = 0;
        end;

        // Clear if only one entry
        if lc_JJLTemp.Count = 1 then
            lc_JJLTemp.DeleteAll();

        // Return
        RetValue := lc_JJLTemp.Count();
    end;

    procedure CalcDiffToBudget(_Rec: Record "Job Journal Line") RetValue: Decimal
    var
        lc_JJL: Record "Job Journal Line";
        lc_JT: Record "Job Task";
    begin
        // Init 
        RetValue := 0;

        // Task notfound
        if not lc_JT.Get(_Rec."Job No.", _Rec."Job Task No.") then
            exit;

        // Get journal lines for this task
        lc_JJL.Reset();
        lc_JJL.SetRange("Job No.", _Rec."Job No.");
        lc_JJL.SetRange("Job Task No.", _Rec."Job Task No.");
        if lc_JJL.Find('-') then
            lc_JJL.CalcSums(lc_JJL."IMP Time on Job");

        // Exit with not budget
        lc_JT.CalcFields("IMP Schedule (Total hours)");
        if lc_JT."IMP Schedule (Total hours)" = 0 then
            exit;

        // Exit with no time on job
        if (lc_JJL."IMP Time on Job" = 0) then
            exit;

        // Return
        RetValue := (Round(lc_JJL."IMP Time on Job" / (lc_JT."IMP Schedule (Total hours)" / 100), 0.01, '='));
    end;

    local procedure JobCheckTime(_JobJournalLine: Record "Job Journal Line"; _SetPostingDate: Boolean; _Modify: Boolean): Boolean
    var
        JobJourLineRec: Record "Job Journal Line";
        TempJobJourLineRec: Record "Job Journal Line" temporary;
        LineNoInt: Integer;
        Nummer1Code: Code[20];
        Datum1Date: Date;
        Zeitvon1Dec: Decimal;
        Zeitbis1Dec: Decimal;
        FirstBool: Boolean;
        NoEmployeesMsg: Label 'No employee recorded.';
        l_JJL: Record "Job Journal Line";
    begin



        if _JobJournalLine.Quantity = 0 then
            exit(true);

        if _JobJournalLine."No." = '' then begin
            Message(NoEmployeesMsg);
            exit(true);
        end;

        Nummer1Code := '';
        Datum1Date := _JobJournalLine."Posting Date";
        Zeitvon1Dec := 0;
        Zeitbis1Dec := 0;

        TempJobJourLineRec.DeleteAll();
        JobJourLineRec.Reset();
        JobJourLineRec.SetCurrentKey("No.", "Posting Date", "IMP Time 1 from", "IMP Time 1 to");
        if _SetPostingDate then
            JobJourLineRec.SetRange("Posting Date", _JobJournalLine."Posting Date");
        JobJourLineRec.SetRange("No.", _JobJournalLine."No.");

        if JobJourLineRec.FindSet() then begin

            LineNoInt := 10000;
            repeat
                if (JobJourLineRec."IMP Time 1 from" <> 0) and (JobJourLineRec."IMP Time 1 to" <> 0) then begin
                    LineNoInt += 10000;
                    TempJobJourLineRec.Init();
                    TempJobJourLineRec.TransferFields(JobJourLineRec);
                    TempJobJourLineRec."Posting Date" := JobJourLineRec."Posting Date";
                    TempJobJourLineRec."Applies-to Entry" := JobJourLineRec."Line No.";
                    TempJobJourLineRec."Line No." := LineNoInt;
                    TempJobJourLineRec."IMP km" := JobJourLineRec."Line No.";
                    TempJobJourLineRec.Insert();

                end;

                if (JobJourLineRec."IMP Time 2 from" <> 0) and (JobJourLineRec."IMP Time 2 to" <> 0) then begin
                    LineNoInt += 10000;
                    TempJobJourLineRec.Init();
                    TempJobJourLineRec.TransferFields(JobJourLineRec);
                    TempJobJourLineRec."Applies-to Entry" := JobJourLineRec."Line No.";
                    TempJobJourLineRec."Line No." := LineNoInt;
                    TempJobJourLineRec."IMP Time 1 from" := JobJourLineRec."IMP Time 2 from";
                    TempJobJourLineRec."IMP Time 1 to" := JobJourLineRec."IMP Time 2 to";
                    TempJobJourLineRec."IMP km" := JobJourLineRec."Line No.";
                    TempJobJourLineRec.Insert();
                end;

                if (JobJourLineRec."IMP Time 3 from" <> 0) and (JobJourLineRec."IMP Time 3 to" <> 0) then begin
                    LineNoInt += 10000;
                    TempJobJourLineRec.Init();
                    TempJobJourLineRec.TransferFields(JobJourLineRec);
                    TempJobJourLineRec."Applies-to Entry" := JobJourLineRec."Line No.";
                    TempJobJourLineRec."Line No." := LineNoInt;
                    TempJobJourLineRec."IMP Time 1 from" := JobJourLineRec."IMP Time 3 from";
                    TempJobJourLineRec."IMP Time 1 to" := JobJourLineRec."IMP Time 3 to";
                    TempJobJourLineRec."IMP km" := JobJourLineRec."Line No.";
                    TempJobJourLineRec.Insert();
                end;

            until JobJourLineRec.Next() = 0;
        end;


        TempJobJourLineRec.SetCurrentKey("No.", "Posting Date", "IMP Time 1 from", "IMP Time 1 to");
        if TempJobJourLineRec.FindSet() then begin
            FirstBool := true;
            TempJobJourLineRec.Delete();

            repeat
                if ((TempJobJourLineRec."No." = Nummer1Code) and
                   (TempJobJourLineRec."Posting Date" = Datum1Date) and
                   (TempJobJourLineRec."IMP Time 1 from" < Zeitbis1Dec)) then begin
                    Nummer1Code := TempJobJourLineRec."No.";
                    Datum1Date := TempJobJourLineRec."Posting Date";
                    Zeitvon1Dec := TempJobJourLineRec."IMP Time 1 from";
                    Zeitbis1Dec := TempJobJourLineRec."IMP Time 1 to";
                end else begin
                    Nummer1Code := TempJobJourLineRec."No.";
                    Datum1Date := TempJobJourLineRec."Posting Date";
                    Zeitvon1Dec := TempJobJourLineRec."IMP Time 1 from";
                    Zeitbis1Dec := TempJobJourLineRec."IMP Time 1 to";
                    if not FirstBool then
                        TempJobJourLineRec.Delete();
                end;
                FirstBool := false;
            until TempJobJourLineRec.Next() = 0;

            TempJobJourLineRec.Reset();

            //
            if g_JobSetup."IMP Mark Journal Overlap" and _Modify then begin
                l_JJL.copyFilters(rec);
                l_JJL.ModifyAll("IMP Overlap", false);
                if TempJobJourLineRec.FindSet() then
                    repeat
                        l_JJL.get(TempJobJourLineRec."Journal Template Name", TempJobJourLineRec."Journal Batch Name", TempJobJourLineRec."IMP km");
                        l_JJL."IMP Overlap" := true;
                        l_JJL.Modify;                        
                    until TempJobJourLineRec.next = 0;
                Commit();
            end;

            if TempJobJourLineRec.FindSet() then
                RunModal(Page::"IMP Job Check Time", TempJobJourLineRec);




        end;

        exit(true);
    end;
    #endregion Methodes

    var
        TotalFromTo: Text[50];
        TimeOnJob: Text[50];
        HoursInvoicable: Text[50];
        HoursNotInvoicable: Text[50];
        CommuteTime: Text[50];
        TotalDay: Text[50];
        NoOfOverlapps: Text[50];
        DiffToBudget: Text[50];
        AllowJnlChange: Boolean;
        lc_userSetup: Record "User Setup";
        g_JobSetup: Record "Jobs Setup";
        g_StyleText: Text;
}