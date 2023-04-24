page 50025 "IMP Job Activities"
{
    Caption = 'Job Activities';
    PageType = CardPart;
    RefreshOnActivate = true;
    SourceTable = "IMP Job Consulting InvHdr Cue";

    layout
    {
        area(content)
        {
            
           

            cuegroup("MyJobs")
            {
                Caption = 'My - Jobs';
                ShowCaption = true;

                field("My Jobs"; Rec."My Jobs")
                {
                    ApplicationArea = All;
                    DrillDownPageID = "Job List";
                    
                }
                field("My Jobs - Planning"; Rec."My Jobs - Planning")
                {
                    ApplicationArea = All;
                    DrillDownPageID = "Job List";
                    
                }
                field("My Jobs - Quote"; Rec."My Jobs - Quote")
                {
                    ApplicationArea = All;
                    DrillDownPageID = "Job List";
                    
                }
                field("My Jobs - Open"; Rec."My Jobs - Open")
                {
                    ApplicationArea = All;
                    DrillDownPageID = "Job List";
                    
                }
                field("My Jobs - Completed"; Rec."My Jobs - Completed")
                {
                    ApplicationArea = All;
                    DrillDownPageID = "Job List";
                    
                }
                
            }
            cuegroup("AllJobs")
            {
                Caption = 'All - Jobs';
                ShowCaption = true;

                field("All Jobs"; Rec."All Jobs")
                {
                    ApplicationArea = All;
                    DrillDownPageID = "Job List";
                    
                }
                field("All Jobs - Planning"; Rec."All Jobs - Planning")
                {
                    ApplicationArea = All;
                    DrillDownPageID = "Job List";
                    
                }
                field("All Jobs - Quote"; Rec."All Jobs - Quote")
                {
                    ApplicationArea = All;
                    DrillDownPageID = "Job List";
                    
                }
                field("All Jobs - Open"; Rec."All Jobs - Open")
                {
                    ApplicationArea = All;
                    DrillDownPageID = "Job List";
                    
                }
                field("All Jobs - Completed"; Rec."All Jobs - Completed")
                {
                    ApplicationArea = All;
                    DrillDownPageID = "Job List";
                    
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
        l_userSetup:Record "User Setup";
    begin
        Rec.Reset();
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert();
        end;

        FromDate := CalcDate('<-CM-1M>', WorkDate()); // erster Tag des Vormonats
        ToDate := CalcDate('<-1M+CM>', WorkDate());   // letzter Tag des Vormonats
        FromDateYTD := DMY2Date(1,1,date2dmy(workdate,3));
        ActualPeriod := FromLbl + Format(FromDate) + ToLbl + Format(ToDate);

        if not l_userSetup.get(UserId) then
            l_userSetup.Init();
        
        
        Rec.SetRange("Created by User", l_userSetup."IMP Job Resource No.");
        Rec.SetRange("Date Filter", FromDate, ToDate);
        Rec.SetRange("Date Filter YTD",FromDateYTD,ToDate);
    end;

    trigger OnAfterGetCurrRecord()
    var
    l_userSetup:Record "User Setup";
    begin
        Rec.Reset();
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert();
        end;

        FromDate := CalcDate('<-CM-1M>', WorkDate()); // erster Tag des Vormonats
        ToDate := CalcDate('<-1M+CM>', WorkDate());   // letzter Tag des Vormonats
        FromDateYTD := DMY2Date(1,1,date2dmy(workdate,3));
        ActualPeriod := FromLbl + Format(FromDate) + ToLbl + Format(ToDate);

        if not l_userSetup.get(UserId) then
            l_userSetup.Init();
        
        
        Rec.SetRange("Created by User", l_userSetup."IMP Job Resource No.");
        Rec.SetRange("Date Filter", FromDate, ToDate);
        Rec.SetRange("Date Filter YTD",FromDateYTD,ToDate);
        Rec.FindSet();
        CurrPage.Update();
    end;

    var
        FromDate: Date;
        ToDate: Date;
        FromDateYTD: date;
        ActualPeriod: Text[30];
        FromLbl: Label 'From: ';
        ToLbl: Label ' To ';

}