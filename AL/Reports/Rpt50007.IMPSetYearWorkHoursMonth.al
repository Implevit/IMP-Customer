report 50007 "IMP Set Year Work. Hours Month"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    ProcessingOnly = true;

    dataset
    {
        dataitem(Integer; Integer)
        {
            trigger OnPreDataItem()
            begin
                SETRANGE(Number,g_MonthStart,g_Month);
                g_StartingDate := dmy2date(1,1,2023);
                //g_ResFilter := 'JHE|FST|RWI|DED|YMA|RME';
                g_ResFilter := 'JHE|FST|RWI|DED|YMA';
                g_NextDate := g_StartingDate;
            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(Options)
                {
                    field(g_MonthStart; g_MonthStart)
                    {
                        ApplicationArea = All;
                        Caption = 'From Month';
                    }
                    field(g_Month; g_Month)
                    {
                        ApplicationArea = All;
                        Caption = 'To Month';
                    }
                    field(g_ResFilter; g_ResFilter)
                    {
                        ApplicationArea = All;
                        Caption = 'Ressourcenfilter';
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
            g_Month := DATE2DMY(WORKDATE, 2) - 1;
            g_MonthStart := 1;
            g_ResFilter := 'JHE|FST|RWI|DED|YMA';

        end;
    }



    var
        g_StartingDate: Date;
        g_NextDate: Date;
        g_Year: Integer;
        g_ResFilter: Code[50];
        g_Month: Integer;
        g_MonthStart: Integer;
}