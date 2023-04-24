page 50024 "IMP Res. Job Work. Hrs. Week"
{
    Caption = 'Ressource Job Working Hours Month';
    //CardPageID = "IMP Cust. Consulting Inv. Card";
    Editable = false;
    PageType = List;
    SourceTable = "IMP Job Working Hours Week";
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
                field(Week; DATE2DWY("Week Start", 2))
                {
                    ApplicationArea = All;
                    Caption = 'Week';
                }

                field(WeekStart; Rec."Week Start")
                {
                    ApplicationArea = All;
                }
                field(WeekEnd; Rec."Week Start" + 6)
                {
                    ApplicationArea = All;
                    Caption = 'Week End';
                }
                field("Week End"; Rec."Week End")
                {
                    ApplicationArea = All;
                    Caption = 'Week End';
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
                    Caption = 'Accountable %';
                }
                field(AssignmentHours; Rec."Assignment Hours")
                {
                    ApplicationArea = All;
                }
                field(AssignmentVacation; Rec."Assignment Vacation")
                {
                    ApplicationArea = All;
                }
                field(Closed; Rec."Period Closed")
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
            action(SetJobWorkingHoursMonth)
            {
                ApplicationArea = All;
                Caption = 'Set Job Working Hours Week';
                RunObject = Report "IMP Set Year Work. Hours Week";
                
                Image = CreateWorkflow;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;


            }
            action(GetJobWorkingHoursMonth)
            {
                ApplicationArea = All;
                Caption = 'Get Job Working Hours Week';
                RunObject = Report "IMP Get Job Wor. Hrs. Week";
                Image = RefreshPlanningLine;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;


            }
            action(SetStatusOpen)
            {
                ApplicationArea = All;
                Caption = 'Set Status Open';

                trigger OnAction()
                begin
                    SetStateOpen();

                end;
            }
            action(SetStatusFixed)
            {
                ApplicationArea = All;
                Caption = 'Set Status Fixed';

                trigger OnAction()
                begin
                    SetStateFixed();

                end;
            }
             action(ActDeleteSelected)
            {
                ApplicationArea = All;
                Caption = 'Delete Selected';
                Promoted = true;

                trigger OnAction()
                begin
                    DeleteSelected();


                end;
            }
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
    trigger OnOpenPage()
    var
    l_UserSetup: Record "User Setup";
    begin
         if not l_userSetup.get(UserId) then
            l_userSetup.Init();
        
        if not l_userSetup."Time Sheet Admin." then
            Error(STRSUBSTNO(Text50002,UserId));
    end;

    procedure SetStateFixed()
    var
        l_JobWorkingHoursWeek: Record "IMP Job Working Hours Week";
        l_JobResWorkingHoursWeek: Record "IMP Job Res. Working Hours";
        g_i: Integer;

    begin
        CurrPage.SETSELECTIONFILTER(l_JobWorkingHoursWeek);
        IF l_JobWorkingHoursWeek.FINDSET THEN
            IF CONFIRM(STRSUBSTNO(Text50000)) THEN BEGIN
                REPEAT
                    l_JobResWorkingHoursWeek.SETRANGE("No.", l_JobWorkingHoursWeek."No.");
                    l_JobResWorkingHoursWeek.SETRANGE(Year, l_JobWorkingHoursWeek.Year);
                    l_JobResWorkingHoursWeek.SETRANGE("Week Start", l_JobWorkingHoursWeek."Week Start");
                    //l_JobResWorkingHoursMonth.SETFILTER("Job Type Code",'<>%1','SOLL');
                    l_JobResWorkingHoursWeek.MODIFYALL(Status, l_JobResWorkingHoursWeek.Status::Fixed);
                    g_i := g_i + 1;
                UNTIL l_JobWorkingHoursWeek.NEXT = 0;
                MESSAGE(STRSUBSTNO(Text50003, g_i));
            END;
    end;

    procedure SetStateOpen()
    var
        l_JobWorkingHoursWeek: Record "IMP Job Working Hours Week";
        l_JobResWorkingHoursWeek: Record "IMP Job Res. Working Hours";
        g_i: Integer;
        l_UserSetup: Record "User Setup";

    begin
        if not l_userSetup.get(UserId) then
            l_userSetup.Init();
        
        if not l_userSetup."Time Sheet Admin." then
            Error(STRSUBSTNO(Text50002,UserId));

        CurrPage.SETSELECTIONFILTER(l_JobWorkingHoursWeek);
        IF l_JobWorkingHoursWeek.FINDSET THEN
            IF CONFIRM(STRSUBSTNO(Text50001)) THEN BEGIN
                REPEAT
                    l_JobResWorkingHoursWeek.SETRANGE("No.", l_JobWorkingHoursWeek."No.");
                    l_JobResWorkingHoursWeek.SETRANGE(Year, l_JobWorkingHoursWeek.Year);
                    l_JobResWorkingHoursWeek.SETRANGE("Week Start", l_JobWorkingHoursWeek."Week Start");
                    //l_JobResWorkingHoursMonth.SETFILTER("Job Type Code",'<>%1','SOLL');
                    l_JobResWorkingHoursWeek.MODIFYALL(Status, l_JobResWorkingHoursWeek.Status::Open);
                    g_i := g_i + 1;
                UNTIL l_JobWorkingHoursWeek.NEXT = 0;
                MESSAGE(STRSUBSTNO(Text50004, g_i));
            END;
    end;
    procedure DeleteSelected()
    var
        l_JobWorkingHoursWeek: Record "IMP Job Working Hours Week";
    begin
        CurrPage.SETSELECTIONFILTER(l_JobWorkingHoursWeek);
        if Confirm('Alle löschen?') then begin
            l_JobWorkingHoursWeek.DeleteAll();
        end;
        

    end;





    var
        Txt1_Txt: Label 'Do you want to set the %2 marked settlements to %1 status?';
        Txt2_Txt: Label '%1 settlements were processed.';
        Txt3_Txt: Label 'Changes have been made to the project capture journal lines for billing for %1 month %2 year %3 after creation. The settlement must be created and checked again.';
        Text50000: Label 'Should the Period be closed?';
        Text50001: Label 'Should the Period be opened?';
        Text50002: Label 'Action is not allowed by %1!';
        Text50003: Label '%1 Periods were closed.';
        Text50004: Label '%1 Periods were opened.';



}

