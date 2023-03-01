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
            }
        }

        addlast(Control1)
        {

            field("IMP Time 1 from"; Rec."IMP Time 1 from")
            {
                ApplicationArea = All;
            }
            field("IMP Time 1 to"; Rec."IMP Time 1 to")
            {
                ApplicationArea = All;
            }
            field("IMP Time 2 from"; Rec."IMP Time 2 from")
            {
                ApplicationArea = All;
            }
            field("IMP Time 2 to"; Rec."IMP Time 2 to")
            {
                ApplicationArea = All;
            }
            field("IMP Time 3 from"; Rec."IMP Time 3 from")
            {
                ApplicationArea = All;
            }
            field("IMP Time 3 to"; Rec."IMP Time 3 to")
            {
                ApplicationArea = All;
            }
            field("IMP Total from/to"; Rec."IMP Total from/to")
            {
                ApplicationArea = All;
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
            
        }
    }

    #region Trigger

    trigger OnOpenPage()
    var
        lc_userSetup: Record "User Setup";
        lc_CurrentJnlBatchName: Code[10];
        lc_JobJnlManagement: Codeunit JobJnlManagement;
    begin

        if not lc_userSetup.get(UserId) then begin
            lc_userSetup.Init();
        end else begin
            if (lc_UserSetup."Journal Batch Name" <> '') and (lc_UserSetup."Journal Template Name" <> '') then begin
                lc_CurrentJnlBatchName := lc_UserSetup."Journal Batch Name";
                SetRange("Journal Template Name", lc_UserSetup."Journal Template Name");
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
}