report 50008 "IMP Get Job Wor. Hrs. Month V."
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    ProcessingOnly = true;
    Caption = 'Get Job Working Hours View';


    dataset
    {
        dataitem(Integer; Integer)
        {
            dataitem(Resource; Resource)
            {
                trigger OnPreDataItem()
                begin
                    SETRANGE("No.", g_ResNo);
                end;

                trigger OnAfterGetRecord()
                var
                    l_JobWorkingHours: Record "IMP Job Working Hours Month";
                begin
                    l_JobWorkingHours.SETRANGE(l_JobWorkingHours."Month Start", g_Date);
                    l_JobWorkingHours.SETRANGE(Year, g_Year);
                    l_JobWorkingHours.SETRANGE("No.", "No.");
                    IF l_JobWorkingHours.FINDSET THEN
                        REPEAT
                            g_JobWorkingHoursTemp.INIT;
                            g_JobWorkingHoursTemp.TRANSFERFIELDS(l_JobWorkingHours);
                            g_JobWorkingHoursTemp.INSERT;
                        UNTIL l_JobWorkingHours.NEXT = 0;

                end;

            }
            trigger OnPreDataItem()
            begin
                SETRANGE(Number, g_MonthStart, g_Month);
            end;

            trigger OnAfterGetRecord()
            begin
                IF g_Date = 0D THEN BEGIN
                    g_Date := DMY2DATE(1, Number, g_Year);
                    g_LastDate := CALCDATE('<1M>', g_Date);
                    g_LastDate := CALCDATE('<-1D>', g_LastDate);
                END ELSE BEGIN
                    g_Date := CALCDATE('<1M>', g_Date);
                    g_LastDate := CALCDATE('<1M>', g_Date);
                    g_LastDate := CALCDATE('<-1D>', g_LastDate);
                END;

            end;

        }

    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                    field(Year; g_Year)
                    {
                        ApplicationArea = All;
                        Caption = 'Year';
                    }
                    field(MonthStart; g_MonthStart)
                    {
                        ApplicationArea = All;
                        Caption = 'Month from';
                    }
                    field(Month; g_Month)
                    {
                        ApplicationArea = All;
                        Caption = 'Month to';
                    }
                }


            }


        }


        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;

                }
            }
        }
        trigger OnOpenPage()
        begin
            g_Year := DATE2DMY(WORKDATE, 3);
            g_Month := DATE2DMY(WORKDATE, 2) - 1;
            g_MonthStart := 1;
        end;

    }

    procedure SetRes(p_ResNo: Code[20])
    begin
        g_ResNo := p_ResNo;
    end;

    trigger OnPostReport()
    begin
        //TODO Seite zum Anzeigen
        IF g_JobWorkingHoursTemp.FINDFIRST THEN;
            PAGE.RUN(PAGE::"IMP R. Job Wrk. Hrs. Mth. View", g_JobWorkingHoursTemp);
    end;


    var


        g_ResNo: Code[50];
        g_Month: Integer;
        g_MonthStart: Integer;
        g_Date: Date;
        g_LastDate: Date;
        g_Year: Integer;
        g_JobWorkingHoursTemp: Record "IMP Job Working Hours Month" temporary;
}