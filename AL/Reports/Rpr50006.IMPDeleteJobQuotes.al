report 50006 "IMP Delete Job Quotes"
{
    UsageCategory = Tasks;
    ApplicationArea = All;
    ProcessingOnly = true;
    Caption = 'Delete Job Quotes';
    
    dataset
    {
        dataitem("Sales Header"; "Sales Header")
        {
            trigger OnPreDataItem()
            begin
                g_Filter := Format(g_Year-2000)+'-';
                if g_Month < 10 then
                    g_Filter := g_Filter+'0'+Format(g_Month)+'*'
                else
                    g_Filter := g_Filter+Format(g_Month)+'*';
                                   
                SetFilter("No.",g_Filter);
                
            end;

            trigger OnAfterGetRecord()
            var 
                l_SalesHeader: Record "Sales Header";
            begin
                if l_SalesHeader.get("Document Type","No.") then begin
                    l_SalesHeader.Delete(true);
                    g_i := g_i + 1;
                end;

            end;
            trigger OnPostDataItem()
            begin
                if not confirm(strsubstno(g_Label01,g_i)) then
                    Error(g_Label02);
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
                    field(Year; g_Year)
                    {
                        ApplicationArea = All;
                        Caption = 'Year';
                        
                    }
                    field(Month; g_Month)
                    {
                        ApplicationArea = All;
                        Caption = 'Month';
                        
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
            g_Year := Date2DMY(WorkDate,3);
            g_Month := Date2DMY(WorkDate,2-1);
            if g_Month = 0 then begin
               g_Month := 12;
               g_Year := g_Year-1; 
            end;
        end;
    }
    
    
    
    var
        g_Month: Integer;
        g_Year: Integer;
        g_i: Integer;
        g_Label01: Label '%1 Quotes will be deleted. Do you wnat to continue?';
        g_Label02: Label 'Aborted!';
        g_Filter: Code[20];
}