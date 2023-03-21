report 50012 "IMP Get Job Wor. Hrs. Month"
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
                dataitem("IMP Job Types"; "IMP Job Types")
                {
                    trigger OnAfterGetRecord()
                    var

                        l_JobWorkingHours: Record "IMP Job Res. Work. Hrs. Month";
                        l_Year: Integer;
                        l_JobJnlLine: Record "Job Journal Line";
                        l_Job: Record Job;
                        l_Option: Integer;
                        I: Integer;
                    begin
                        //FOR I := g_WeekStart TO g_Week DO BEGIN
                        l_Year := DATE2DMY(g_Date, 3);

                        l_JobJnlLine.SETRANGE("No.", Resource."No.");
                        l_JobJnlLine.SETRANGE("Posting Date", g_Date, g_LastDate);
                        //l_JobJnlLine.SETRANGE("Job No.",l_Job."No.");
                        IF "IMP Job Types"."Filter Type" = "IMP Job Types"."Filter Type"::"Internal Type" THEN BEGIN
                            EVALUATE(l_Option, "IMP Job Types"."Internal Filter");
                            //l_JobJnlLine.SETRANGE("Internal Job",l_Option);
                            l_JobJnlLine.SETRANGE("IMP Internal Job", l_JobJnlLine."IMP Internal Job"::" ");                            
                        END;
                        IF "IMP Job Types"."Filter Type" = "IMP Job Types"."Filter Type"::"Job No. Filter" THEN BEGIN
                            l_JobJnlLine.SETFILTER("Job No.", "IMP Job Types"."Job No. Filter");
                        END;
                        IF l_JobJnlLine.FINDSET THEN
                            REPEAT
                                IF "IMP Job Types"."Job Type Code" = 'SOLL' THEN BEGIN
                                    IF NOT l_JobWorkingHours.GET(l_Year, g_Date, Resource."No.", 'SOLL') THEN BEGIN
                                        l_JobWorkingHours.INIT;
                                        l_JobWorkingHours.Year := l_Year;
                                        l_JobWorkingHours."Month Start" := g_Date;
                                        l_JobWorkingHours."No." := Resource."No.";
                                        l_JobWorkingHours."Job Type Code" := 'SOLL';
                                        l_JobWorkingHours.Quantity := 164;
                                        l_JobWorkingHours.INSERT;
                                    END;
                                END ELSE BEGIN
                                    IF NOT l_JobWorkingHours.GET(l_Year, g_Date, Resource."No.", "Job Type Code") THEN BEGIN
                                        l_JobWorkingHours.INIT;
                                        l_JobWorkingHours.Year := l_Year;
                                        l_JobWorkingHours."Month Start" := g_Date;
                                        l_JobWorkingHours."No." := Resource."No.";
                                        l_JobWorkingHours."Job Type Code" := "IMP Job Types"."Job Type Code";
                                        l_JobWorkingHours.Quantity := l_JobJnlLine.Quantity;
                                        l_JobWorkingHours."Quantity not to Invoice" := l_JobJnlLine."IMP Hours not to invoice";
                                        l_JobWorkingHours."Quantity to Invoice" := l_JobJnlLine."IMP Hours to invoice";
                                        l_JobWorkingHours.INSERT;
                                        //MESSAGE(STRSUBSTNO('Datum: %1, Menge: %2',l_JobJnlLine."Posting Date",l_JobJnlLine.Quantity));
                                    END ELSE BEGIN
                                        l_JobWorkingHours.Quantity := l_JobWorkingHours.Quantity + l_JobJnlLine.Quantity;
                                        l_JobWorkingHours."Quantity not to Invoice" := l_JobWorkingHours."Quantity not to Invoice" + l_JobJnlLine."IMP Hours not to invoice";
                                        l_JobWorkingHours."Quantity to Invoice" := l_JobWorkingHours."Quantity to Invoice" + l_JobJnlLine."IMP Hours to invoice";
                                        l_JobWorkingHours.MODIFY;
                                        //MESSAGE(STRSUBSTNO('Datum: %1, Menge: %2',l_JobJnlLine."Posting Date",l_JobJnlLine.Quantity));
                                    END;
                                END;
                            UNTIL l_JobJnlLine.NEXT = 0;
                        //  UNTIL l_Job.NEXT = 0;
                    end;
                }
                trigger OnPreDataItem()
                begin
                    SETFILTER("No.", g_ResFilter);
                end;

                trigger OnAfterGetRecord()
                var
                    l_JobWorkingHours: Record "IMP Job Res. Work. Hrs. Month";
                begin
                    l_JobWorkingHours.SETRANGE(l_JobWorkingHours."Month Start", g_Date);
                    l_JobWorkingHours.SETFILTER(l_JobWorkingHours."Job Type Code", '<>%1', 'SOLL');
                    l_JobWorkingHours.SETRANGE("No.", "No.");
                    l_JobWorkingHours.SETRANGE(Status, l_JobWorkingHours.Status::Fixed);
                    IF l_JobWorkingHours.FINDSET THEN
                        l_JobWorkingHours.TESTFIELD(Status, l_JobWorkingHours.Status::Open);
                    l_JobWorkingHours.SETRANGE(Status);
                    l_JobWorkingHours.DELETEALL;

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
                    field(ResFilter; g_ResFilter)
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
            g_ResFilter := 'JHE|FST|RWI|DED|YMA|SKA';
        end;

    }

    procedure SetRes(p_ResNo: Code[20])
    begin
        g_ResNo := p_ResNo;
    end;

    trigger OnPostReport()
    begin
        //TODO Seite zum Anzeigen
        //IF g_JobWorkingHoursTemp.FINDFIRST THEN;
        //PAGE.RUN(PAGE::"IMP R. Job Wrk. Hrs. Mth. View", g_JobWorkingHoursTemp);
    end;


    var


        g_ResNo: Code[50];
        g_Month: Integer;
        g_MonthStart: Integer;
        g_Date: Date;
        g_LastDate: Date;
        g_Year: Integer;
        g_JobWorkingHoursTemp: Record "IMP Job Working Hours Month" temporary;
        g_ResFilter: Code[100];
}