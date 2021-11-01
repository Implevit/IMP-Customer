page 50009 "IMP Server List"
{
    Caption = 'Servers';
    PageType = List;
    SourceTable = "IMP Server";
    UsageCategory = Lists;
    ApplicationArea = All;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                }
                field(SSL; Rec.SSL)
                {
                    ApplicationArea = All;
                }
                field(Location; Rec.Location)
                {
                    ApplicationArea = All;
                }
                field(Dns; Rec.Dns)
                {
                    ApplicationArea = All;
                }
                field(Connections; Rec.Connections)
                {
                    ApplicationArea = All;
                }
                field("NAV Versions"; Rec."NAV Versions")
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
            action(ActLoadVersions)
            {
                Caption = 'Load Navision Versions';
                ApplicationArea = All;
                Image = Import;
                Enabled = EnableLoadVersion;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    ImpAdmn.CallVersionList();
                    CurrPage.Update(false);
                end;
            }
        }
    }

    #region Triggers

    trigger OnAfterGetCurrRecord()
    begin
        EnableLoadVersion := (Rec.Name = ImpAdmn.GetCurrentComputerName().ToUpper());
    end;

    #endregion Triggers

    var
        ImpAdmn: Codeunit "IMP Administration";
        EnableLoadVersion: Boolean;
}
