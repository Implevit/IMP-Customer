page 50007 "IMP AL Object Apps"
{
    Caption = 'AL Object Apps';
    PageType = List;
    SourceTable = "IMP AL Object App";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                    Visible = ShowCustomer;
                }
                field("Customer Name"; Rec."Customer Name")
                {
                    ApplicationArea = All;
                    Visible = ShowCustomer;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    trigger OnDrillDown()
                    begin
                        ShowObjects();
                    end;
                }
                field("No. Range From"; Rec."No. Range From")
                {
                    ApplicationArea = All;
                }
                field("No. Range To"; Rec."No. Range To")
                {
                    ApplicationArea = All;
                }
                field(Objects; Rec.Objects)
                {
                    ApplicationArea = All;

                    trigger OnDrillDown()
                    begin
                        ShowObjects();
                    end;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActLoad)
            {
                Caption = 'Load';
                ApplicationArea = All;
                Image = Import;
                PromotedCategory = Process;
                Promoted = true;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                var
                    lc_Txt1_Txt: Label 'Select customer first';
                begin
                    if (CurrCustomer = '') then
                        if (Rec."Customer No." = '') then
                            Error(lc_Txt1_Txt)
                        else
                            CurrCustomer := Rec."Customer No.";
                    Rec.ImportApps(CurrCustomer, true, true);
                    CurrPage.Update(false);
                end;
            }
        }
    }

    #region Triggers

    trigger OnOpenPage()
    begin
        ShowCustomer := not (Rec.GetFilter("Customer No.") <> '');
        if not ShowCustomer then
            CurrCustomer := CopyStr(Rec.GetFilter("Customer No."), 1, MaxStrLen(CurrCustomer));
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        if not ShowCustomer then
            Rec."Customer No." := CurrCustomer;
    end;

    #endregion Triggers

    #region Methodes

    procedure ShowObjects()
    var
        lc_Page: Page "IMP AL Object Numbers";
    begin
        lc_Page.SetLevel1(Rec."Customer No.", Rec."No.", 0);
        lc_Page.Run();
    end;

    #endregion Methodes

    var
        ShowCustomer: Boolean;
        CurrCustomer: Code[20];
}
