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

            cuegroup("Job Consulting Inv. Hdrs")
            {
                Caption = 'Job Consulting Invoice Actual Period';
                ShowCaption = true;

                field("Created My Actul Period"; Rec."Created My Actul Period")
                {
                    ApplicationArea = All;
                    DrillDownPageID = "IMP Job Consulting Inv. Hdrs";
                    ToolTip = '';
                }
                field("Checked My All Actul Period"; Rec."Checked My All Actul Period")
                {
                    ApplicationArea = All;
                    DrillDownPageID = "IMP Job Consulting Inv. Hdrs";
                    ToolTip = '';
                }
                field("All My Actul Period"; Rec."All My Actul Period")
                {
                    ApplicationArea = All;
                    DrillDownPageID = "IMP Job Consulting Inv. Hdrs";
                    ToolTip = '';
                }
                field("Created All Actul Period"; Rec."Created All Actul Period")
                {
                    ApplicationArea = All;
                    DrillDownPageID = "IMP Job Consulting Inv. Hdrs";
                    ToolTip = '';
                }
                field("Checked All Actul Period"; Rec."Checked All Actul Period")
                {
                    ApplicationArea = All;
                    DrillDownPageID = "IMP Job Consulting Inv. Hdrs";
                    ToolTip = '';
                }
                field("All Actul Period"; Rec."All Actul Period")
                {
                    ApplicationArea = All;
                    DrillDownPageID = "IMP Job Consulting Inv. Hdrs";
                    ToolTip = '';
                }
            }
            cuegroup("Job Consulting Inv. Hdrs All")
            {
                Caption = 'Job Consulting Invoice All Entries';
                ShowCaption = true;

                field("Created All"; Rec."Created All")
                {
                    ApplicationArea = All;
                    DrillDownPageID = "IMP Job Consulting Inv. Hdrs";
                    ToolTip = '';
                }
                field("Checked All"; Rec."Checked All")
                {
                    ApplicationArea = All;
                    DrillDownPageID = "IMP Job Consulting Inv. Hdrs";
                    ToolTip = '';
                }
                field("All"; Rec."All")
                {
                    ApplicationArea = All;
                    DrillDownPageID = "IMP Job Consulting Inv. Hdrs";
                    ToolTip = '';
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
    end;

    trigger OnAfterGetCurrRecord()
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
        Rec.FindSet();
        CurrPage.Update();
    end;

    var
        FromDate: Date;
        ToDate: Date;
        ActualPeriod: Text[30];
        FromLbl: Label 'From: ';
        ToLbl: Label ' To ';

}