page 50026 "IMP Work Time Activities"
{
    Caption = 'Work Time Activities';
    PageType = CardPart;
    RefreshOnActivate = true;
    SourceTable = "IMP Job Consulting InvHdr Cue";

    layout
    {
        area(content)
        {
            
            
            cuegroup("Work Time")
            {
                Caption = 'Last Month';
                ShowCaption = true;

               
                field("Last Period Month Hours"; Rec."Last Period Month Hours")
                {
                    ApplicationArea = All;
                    

                }
                field("Last Period Month Target"; Rec."Last Period Month Target")
                {
                    ApplicationArea = All;
                    
                    
                }
                field("Last Period Month Balance"; Rec."Last Period Month Hours" - Rec."Last Period Month Target")
                {
                    ApplicationArea = All;
                    Style = Attention; 
                    
                    
                }
            }
            cuegroup("Work Time Week")
            {
                Caption = 'Last Week';
                ShowCaption = true;

               
                field("Last Period Week Hours"; Rec."Last Period Week Hours")
                {
                    ApplicationArea = All;
                    

                }
                field("Last Period Week Target"; Rec."Last Period Week Target")
                {
                    ApplicationArea = All;
                    
                    
                }
                field("Last Period Week Balance"; Rec."Last Period Week Hours" - Rec."Last Period Week Target")
                {
                    ApplicationArea = All;
                    Style = Attention; 
                    
                    
                }
            }
           
        }
    }

    /*
    actions
    {
        area(Processing)
        {
            action("SetWorkDate")
            {
                Caption = 'Set Work Date';

                trigger OnAction()
                begin
                    Rec.Reset();
                    if not Rec.Get() then begin
                        Rec.Init();
                        Rec.Insert();
                    end;

                    FromDate := CalcDate('<-CM-1M>', WorkDate()); // erster Tag des Vormonats
                    ToDate := CalcDate('<-1M+CM>', WorkDate());   // letzter Tag des Vormonats
                    ActualPeriod := FromLbl + Format(FromDate) + ToLbl + Format(ToDate);

                    Rec.SetRange("Created by User", UserId);
                    Rec.SetRange("Date Filter", FromDate, ToDate);
                    CurrPage.Activate();
                end;
            }
        }
    }
    */

    trigger OnOpenPage()
    var
    l_UserSetup: Record "User Setup";
    begin
        Rec.Reset();
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert();
        end;

        FromDate := CalcDate('<-CM-1M>', WorkDate()); // erster Tag des Vormonats
        ToDate := CalcDate('<-1M+CM>', WorkDate());   // letzter Tag des Vormonats
        //FromDateYTD := DMY2Date(1,1,date2dmy(workdate,3));
        ActualPeriod := FromLbl + Format(FromDate) + ToLbl + Format(ToDate);
        FromDateLastWeek := CalcDate('<-7D>',DWY2Date(1,Date2DWY(Workdate,2)));
        ToDateLastWeek := CalcDate('<-1D>',DWY2Date(1,Date2DWY(Workdate,2)));

        if not l_userSetup.get(UserId) then
            l_userSetup.Init();
        
        
        Rec.SetRange("Created by User", l_userSetup."IMP Job Resource No.");
        Rec.SetRange("Date Filter", FromDate, ToDate);
        Rec.SetRange("Date Filter YTD",FromDateYTD,ToDate);
        Rec.SetRange("Date Filter Last Week",FromDateLastWeek,ToDateLastWeek);
    end;

    trigger OnAfterGetCurrRecord()
    var
    l_UserSetup: Record "User Setup";
    begin
        Rec.Reset();
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert();
        end;

        FromDate := CalcDate('<-CM-1M>', WorkDate()); // erster Tag des Vormonats
        ToDate := CalcDate('<-1M+CM>', WorkDate());   // letzter Tag des Vormonats
        FromDateYTD := DMY2Date(1,1,date2dmy(workdate,3));
        FromDateLastWeek := CalcDate('<-7D>',DWY2Date(1,Date2DWY(Workdate,2)));
        ToDateLastWeek := CalcDate('<-1D>',DWY2Date(1,Date2DWY(Workdate,2)));
        ActualPeriod := FromLbl + Format(FromDate) + ToLbl + Format(ToDate);

        if not l_userSetup.get(UserId) then
            l_userSetup.Init();
        
        
        Rec.SetRange("Created by User", l_userSetup."IMP Job Resource No.");
        Rec.SetRange("Date Filter", FromDate, ToDate);
        Rec.SetRange("Date Filter YTD",FromDateYTD,ToDate);
        Rec.SetRange("Date Filter Last Week",FromDateLastWeek,ToDateLastWeek);
        Rec.FindSet();
        CurrPage.Update();
    end;

    var
        FromDate: Date;
        ToDate: Date;
        FromDateYTD: date;
        FromDateLastWeek: date;
        ToDateLastWeek: date;
        ActualPeriod: Text[30];
        FromLbl: Label 'From: ';
        ToLbl: Label ' To ';

}