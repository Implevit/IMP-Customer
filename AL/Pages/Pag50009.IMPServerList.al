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
                field("Certificate Thumbprint"; Rec."Certificate Thumbprint")
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
            action(ActRefresh)
            {
                Caption = 'Refresh';
                ApplicationArea = All;
                Image = Refresh;
                Enabled = EnableLoadVersion;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    lc_Response: JsonObject;
                begin
                    case Rec.Type of
                        Rec.Type::App:
                            if ((Rec.Name = BscMgmt.System_GetCurrentComputerName().ToUpper())) then begin
                                ImpAdmn.CallVersionList(true, true);
                                CurrPage.Update(false);
                            end else
                                ShowOtherServerList(Rec);
                        Rec.Type::Sql:
                            ImpAdmn.CallSQLServerFullList(Rec.Name, '', lc_Response, true, true)
                    end;
                end;
            }
            action(ActShowInstances)
            {
                Caption = 'Instances';
                ApplicationArea = All;
                Image = Database;
                Enabled = EnableShowInstances;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    lc_Rec: Record "IMP Connection";
                begin
                    lc_Rec.Reset();
                    lc_Rec.SetRange(Environment, lc_Rec.Environment::SQLInstance);
                    lc_Rec.SetRange(DatabaseServer, Rec.Name);
                    if lc_Rec.FindSet() then;
                    lc_Rec.SetRange(DatabaseInstance);
                    Page.RunModal(Page::"IMP Databases", lc_Rec);
                end;
            }
        }
    }

    #region Triggers

    trigger OnAfterGetCurrRecord()
    begin
        EnableLoadVersion := (Rec.Type <> Rec.Type::cloud);
        EnableShowInstances := (Rec.Type = Rec.Type::Sql);
    end;

    #endregion Triggers

    #region Methodes

    local procedure ShowOtherServerList(var _Rec: Record "IMP Server")
    var
        lc_AS: Record "Active Session";
        lc_Current: Text;
        lc_Server: Text;
        lc_Url: Text;
    begin
        // Get current server
        lc_Current := BscMgmt.System_GetCurrentComputerName().ToLower();
        lc_Server := _Rec.Name;
        // Get sesssion
        lc_AS.Get(ServiceInstanceId(), SessionId());
        // Set url
        lc_Url := 'http://' + lc_Server.ToLower() + ':8080/' + lc_AS."Server Instance Name";
        lc_Url += '?Company=' + CompanyName + '&page=50009&mode=View';
        lc_Url += '&filter=''Name'' IS ''' + _Rec.Name + '''';

        // Call url
        Hyperlink(lc_Url);
    end;

    #endregion Methodes

    var
        BscMgmt: Codeunit "IMP Basic Management";
        ImpAdmn: Codeunit "IMP Administration";
        EnableLoadVersion: Boolean;
        EnableShowInstances: Boolean;
}
