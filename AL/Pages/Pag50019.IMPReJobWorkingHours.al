page 50019 "IMP Res. Job Work. Hrs. Month"
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
                field("Customer No."; DATE2DMY("Month Start", 2))
                {
                    ApplicationArea = All;
                }

                field(MonthStart; Rec."Month Start")
                {
                    ApplicationArea = All;
                }
                field(MonthEnd; Rec."Month Start" + 6)
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
                }
                field(g_ToInvoicePerc; g_ToInvoicePerc)
                {
                    ApplicationArea = All;
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
                Caption = 'Set Job Working Hours Month';
                RunObject = Report "IMP Set Year Work. Hours Month";
                Image = CreateWorkflow;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                

            }
            action(GetJobWorkingHoursMonth)
            {
                ApplicationArea = All;
                Caption = 'Get Job Working Hours Month';
                RunObject = Report "IMP Get Job Wor. Hrs. Month";
                Image = RefreshPlanningLine;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                

            }
            action(SetStatusOpen)
            {
                ApplicationArea = All;
                Caption= 'Set Status Open';
                
                trigger OnAction()
                begin
                    SetStateOpen();
                    
                end;
            }
            action(SetStatusFixed)
            {
                ApplicationArea = All;
                Caption= 'Set Status Fixed';
                
                trigger OnAction()
                begin
                    SetStateFixed();
                    
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

    procedure SetStateFixed()
    var
        l_JobWorkingHoursMonth: Record "IMP Job Working Hours Month";
        l_JobResWorkingHoursMonth: Record "IMP Job Res. Work. Hrs. Month";
        g_i: Integer;

    begin
        CurrPage.SETSELECTIONFILTER(l_JobWorkingHoursMonth);
        IF l_JobWorkingHoursMonth.FINDSET THEN
            IF CONFIRM(STRSUBSTNO(Text50000)) THEN BEGIN
                REPEAT
                    l_JobResWorkingHoursMonth.SETRANGE("No.", l_JobWorkingHoursMonth."No.");
                    l_JobResWorkingHoursMonth.SETRANGE(Year, l_JobWorkingHoursMonth.Year);
                    l_JobResWorkingHoursMonth.SETRANGE("Month Start", l_JobWorkingHoursMonth."Month Start");
                    //l_JobResWorkingHoursMonth.SETFILTER("Job Type Code",'<>%1','SOLL');
                    l_JobResWorkingHoursMonth.MODIFYALL(Status, l_JobResWorkingHoursMonth.Status::Fixed);
                    g_i := g_i + 1;
                UNTIL l_JobWorkingHoursMonth.NEXT = 0;
                MESSAGE(STRSUBSTNO(Text50001, g_i));
            END;
    end;

    procedure SetStateOpen()
    var
        l_JobWorkingHoursMonth: Record "IMP Job Working Hours Month";
        l_JobResWorkingHoursMonth: Record "IMP Job Res. Work. Hrs. Month";
        g_i: Integer;

    begin
        CurrPage.SETSELECTIONFILTER(l_JobWorkingHoursMonth);
        IF l_JobWorkingHoursMonth.FINDSET THEN
        IF CONFIRM(STRSUBSTNO(Text50000)) THEN
            BEGIN
                REPEAT
                    l_JobResWorkingHoursMonth.SETRANGE("No.", l_JobWorkingHoursMonth."No.");
                    l_JobResWorkingHoursMonth.SETRANGE(Year, l_JobWorkingHoursMonth.Year);
                    l_JobResWorkingHoursMonth.SETRANGE("Month Start", l_JobWorkingHoursMonth."Month Start");
                    //l_JobResWorkingHoursMonth.SETFILTER("Job Type Code",'<>%1','SOLL');
                    l_JobResWorkingHoursMonth.MODIFYALL(Status, l_JobResWorkingHoursMonth.Status::Open);
                    g_i := g_i + 1;
                UNTIL l_JobWorkingHoursMonth.NEXT = 0;
                MESSAGE(STRSUBSTNO(Text50001, g_i));
            END;
        end;





    var
        Txt1_Txt: Label 'Do you want to set the %2 marked settlements to %1 status?';
        Txt2_Txt: Label '%1 settlements were processed.';
        Txt3_Txt: Label 'Changes have been made to the project capture journal lines for billing for %1 month %2 year %3 after creation. The settlement must be created and checked again.';
        Text50000: Label 'Should the Period be closed?';
        Text50001: Label 'Should the Period be opened?';

        
        
}

