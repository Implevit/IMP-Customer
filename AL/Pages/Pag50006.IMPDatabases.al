page 50006 "IMP Databases"
{
    Caption = 'Databases';
    PageType = List;
    SourceTable = "IMP Connection";
    SourceTableView = sorting("List Name") where(Environment = Filter(SQLServer | SQLInstance | SQLDatabase));
    UsageCategory = Lists;
    ApplicationArea = All;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("List Name"; Rec."List Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = false;
                }
                field(Environment; Rec.Environment)
                {
                    ApplicationArea = All;
                    Visible = ShowEnvironment;
                }
                field("Environment Type"; Rec."Environment Type")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Environment Name"; Rec."Environment Name")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field("Environment Id"; Rec."Environment Id")
                {
                    ApplicationArea = All;
                    Visible = false;
                }
                field(DatabaseServer; Rec.DatabaseServer)
                {
                    ApplicationArea = All;
                    Visible = ShowServer;
                }
                field(DatabaseInstance; Rec.DatabaseInstance)
                {
                    ApplicationArea = All;
                    Visible = ShowInstance;
                }
                field(DatabaseName; Rec.DatabaseName)
                {
                    ApplicationArea = All;
                    Visible = ShowDatabase;
                }
                field("Environment State"; Rec."Environment State")
                {
                    ApplicationArea = All;
                    Visible = ShowStatus;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActLoadSQLServer)
            {
                Caption = 'Load';
                ApplicationArea = All;
                Image = ImportDatabase;
                PromotedCategory = Process;
                Promoted = true;
                PromotedIsBig = true;
                PromotedOnly = true;
                visible = ShowAction;

                trigger OnAction()
                begin
                    if ImpAdmn.GetCurrentComputerName().ToLower() <> 'impent02' then
                        Message('Only on impent02 possible!')
                    else begin
                        ImpAdmn.CallSQLServerFullList();
                        CurrPage.Update(false);
                    end;
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        ShowAction := true;

        ShowEnvironment := true;
        ShowServer := true;
        ShowInstance := true;
        ShowDatabase := true;
        ShowStatus := true;

        case Rec.GetFilter(Environment).ToLower() of
            Format(Rec.Environment::SQLServer).ToLower():
                begin
                    ShowEnvironment := false;
                    ShowServer := true;
                    ShowInstance := false;
                    ShowDatabase := false;
                    ShowStatus := false;
                end;
            Format(Rec.Environment::SQLInstance).ToLower():
                begin
                    ShowEnvironment := false;
                    ShowServer := false;
                    ShowInstance := true;
                    ShowDatabase := false;
                    ShowStatus := true;
                end;
            Format(Rec.Environment::SQLDatabase).ToLower():
                begin
                    ShowEnvironment := false;
                    ShowServer := false;
                    ShowInstance := true;
                    ShowDatabase := true;
                    ShowStatus := true;
                end;
        end;
    end;

    var
        ImpAdmn: Codeunit "IMP Administration";
        ShowAction: Boolean;
        ShowEnvironment: Boolean;
        ShowServer: Boolean;
        ShowInstance: Boolean;
        ShowDatabase: Boolean;
        ShowStatus: Boolean;
}
