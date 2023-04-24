page 50023 "IMP Job ConsInvHdr Activities"
{
    Caption = 'Job Consulting Invoice Activities';
    PageType = CardPart;
    RefreshOnActivate = true;
    SourceTable = "IMP Job Consulting InvHdr Cue";

    layout
    {
        area(content)
        {
            
            field(ActualPeriod; ActualPeriod)
            {
                Caption = 'Actual Period';
                Editable = false;
                ApplicationArea = All;
            }

            cuegroup("My Job Consulting Inv. Actual Period")
            {
                Caption = 'My - Actual Period';
                ShowCaption = true;

                field("Created My Actul Period"; Rec."Created My Actul Period")
                {
                    ApplicationArea = All;
                    DrillDownPageID = "IMP Job Consulting Inv. Hdrs";
                    
                }
                field("Checked My All Actul Period"; Rec."Checked My All Actul Period")
                {
                    ApplicationArea = All;
                    DrillDownPageID = "IMP Job Consulting Inv. Hdrs";
                    
                }
                field("All My Actul Period"; Rec."All My Actul Period")
                {
                    ApplicationArea = All;
                    DrillDownPageID = "IMP Job Consulting Inv. Hdrs";
                    
                }
            }
                cuegroup("Job Consulting Inv. Actual Period")
            {
                Caption = 'All - Actual Period';
                ShowCaption = true;
                field("Created All Actul Period"; Rec."Created All Actul Period")
                {
                    ApplicationArea = All;
                    DrillDownPageID = "IMP Job Consulting Inv. Hdrs";
                    
                }
                field("Checked All Actul Period"; Rec."Checked All Actul Period")
                {
                    ApplicationArea = All;
                    DrillDownPageID = "IMP Job Consulting Inv. Hdrs";
                    
                }
                field("All Actul Period"; Rec."All Actul Period")
                {
                    ApplicationArea = All;
                    DrillDownPageID = "IMP Job Consulting Inv. Hdrs";
                    
                }
            }
            cuegroup("Job Consulting Inv. All")
            {
                Caption = 'All YTD';
                ShowCaption = true;

                field("Created All"; Rec."Created All")
                {
                    ApplicationArea = All;
                    DrillDownPageID = "IMP Job Consulting Inv. Hdrs";
                    
                }
                field("Checked All"; Rec."Checked All")
                {
                    ApplicationArea = All;
                    DrillDownPageID = "IMP Job Consulting Inv. Hdrs";
                    
                }
                field("All"; Rec."All")
                {
                    ApplicationArea = All;
                    DrillDownPageID = "IMP Job Consulting Inv. Hdrs";
                    
                }
               
            }
            /*
             cuegroup("Work Time")
            {
                Caption = 'Work Time';
                ShowCaption = true;

                field("Last Period Month Hours"; Rec."Last Period Month Hours")
                {
                    ApplicationArea = All;
                    
                    ToolTip = '';
                }
                
                field("Last Period Month Target"; Rec."Last Period Month Target")
                {
                    ApplicationArea = All;
                    
                    ToolTip = '';
                }
                
                field("Last Period Month Balance"; Rec."Last Period Month Target"-Rec."Last Period Month Hours")
                {
                    ApplicationArea = All;
                    Caption = 'Balance';
                    
                    ToolTip = '';
                }
                
                

            }
            */
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