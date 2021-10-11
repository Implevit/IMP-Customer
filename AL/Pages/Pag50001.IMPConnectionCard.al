page 50001 "IMP Connection Card"
{
    Caption = 'Connection';
    PageType = Card;
    SourceTable = "IMP Connection";

    layout
    {
        area(content)
        {
            group(GrpGeneral)
            {
                Caption = 'General';

                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                    Editable = false;
                }
                field(Computer; Rec.Computer)
                {
                    ApplicationArea = All;
                }
                field(Dns; Rec.Dns)
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                }
                field("List Name"; Rec."List Name")
                {
                    ApplicationArea = All;
                }
                field("Customer No."; Rec."Customer No.")
                {
                    ApplicationArea = All;
                }
                field("Authorisation No."; Rec."Authorisation No.")
                {
                    ApplicationArea = All;
                }
                field(Url; Rec.Url)
                {
                    ApplicationArea = All;

                    trigger OnAssistEdit()
                    begin
                        if (Rec.Url <> '') then
                            Hyperlink(Rec.Url);
                    end;
                }
            }
            group(GrpCompany)
            {
                Caption = 'Company';

                field("Company Name"; Rec."Company Name")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                }
                field("Company Id"; Rec."Company Id")
                {
                    ApplicationArea = All;
                    Importance = Promoted;
                }
            }
            group(GrpEnvironment)
            {
                Caption = 'Environment';

                field(Environment; Rec.Environment)
                {
                    ApplicationArea = All;
                }
                field("Environment Type"; Rec."Environment Type")
                {
                    ApplicationArea = All;
                }
                field("Environment Name"; Rec."Environment Name")
                {
                    ApplicationArea = All;
                }
                field("Environment Id"; Rec."Environment Id")
                {
                    ApplicationArea = All;
                }
                field("Environment State"; Rec."Environment State")
                {
                    ApplicationArea = All;
                }
            }
            group(GrpServerInstance)
            {
                Caption = 'Service';

                field("Service Name"; Rec."Service Name")
                {
                    ApplicationArea = All;
                }
                field("Service State"; Rec."Service State")
                {
                    ApplicationArea = All;
                }
                field("Service Version"; Rec."Service Version")
                {
                    ApplicationArea = All;
                }
                field("Service Full Version"; Rec."Service Full Version")
                {
                    ApplicationArea = All;
                }
                field("Service Account"; Rec."Service Account")
                {
                    ApplicationArea = All;
                }
            }
            group(GrpPorts)
            {
                Caption = 'Ports';

                field(ManagementServicesPort; Rec.ManagementServicesPort)
                {
                    ApplicationArea = All;
                }
                field(ClientServicesPort; Rec.ClientServicesPort)
                {
                    ApplicationArea = All;
                }
                field(SOAPServicesPort; Rec.SOAPServicesPort)
                {
                    ApplicationArea = All;
                }
                field(ODataServicesPort; Rec.ODataServicesPort)
                {
                    ApplicationArea = All;
                }
            }
            group(GrpDatabase)
            {
                Caption = 'SQL Server';

                field(DatabaseServer; Rec.DatabaseServer)
                {
                    ApplicationArea = All;
                }
                field(DatabaseInstance; Rec.DatabaseInstance)
                {
                    ApplicationArea = All;
                }
                field(DatabaseName; Rec.DatabaseName)
                {
                    ApplicationArea = All;
                }
            }
            group(GrpCredential)
            {
                Caption = 'Credential';

                field(ClientServicesCredentialType; Rec.ClientServicesCredentialType)
                {
                    ApplicationArea = All;
                }
                field(ServicesCertificateThumbprint; Rec.ServicesCertificateThumbprint)
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
            /*
            action(ActLoadSimpleServices)
            {
                Caption = 'Load Simple Service List';
                ApplicationArea = All;
                Image = WorkCenterLoad;

                trigger OnAction()
                begin
                    ImpAdmn.LoadSimpleServerList();
                    CurrPage.Update(true);
                end;
            }
            action(ActLoadFullServices)
            {
                Caption = 'Load Full Service List';
                ApplicationArea = All;
                Image = WorkCenterLoad;

                trigger OnAction()
                begin
                    ImpAdmn.LoadFullServerList(true, true);
                    CurrPage.Update(true);
                end;
            }
            action(ActLoadVersionList)
            {
                Caption = 'Load Version List';
                ApplicationArea = All;
                Image = WorkCenterLoad;

                trigger OnAction()
                var
                    lc_List: list of [Text];
                begin
                    lc_List := ImpAdmn.LoadVersionList()
                end;
            }
            */
            action(ActLoadImpent02)
            {
                Caption = 'Load IMPENT02';
                ApplicationArea = All;
                Image = Import;

                trigger OnAction()
                begin
                    Rec.LoadFromServer('impent02');
                    Rec.Reset();
                end;
            }
            action(ActLoadServices)
            {
                Caption = 'Load services';
                ApplicationArea = All;
                Image = Import;

                trigger OnAction()
                var
                //lc_Files: Record "Name/Value Buffer" temporary;
                //lc_Conv: Codeunit "Base64 Convert";
                //lc_ImpWeb: Codeunit "IMP WebService";
                //lc_Instream: InStream;
                //lc_Temptext: Text[1000];
                //lc_JsonText: Text;
                begin
                    //Rec.LoadFromServer('impent02');
                    /*
                    lc_JsonText := '';
                    lc_Files.Init();
                    lc_Files."Value BLOB".Import('\\impfps01\Daten\04_Entwicklung\Kunden\IMP\Admin\Log\NAV71List.json'); //NAV71List.json');
                    lc_Files."Value BLOB".CreateInStream(lc_Instream, TextEncoding::UTF16);
                    while not lc_Instream.EOS() do begin
                        lc_Instream.Read(lc_Temptext, 1000);
                        lc_JsonText += lc_Temptext;
                    end;
                    if (lc_JsonText <> '') then begin
                        lc_JsonText := lc_Conv.ToBase64(lc_JsonText, TextEncoding::UTF16);
                        Message(lc_ImpWeb.odata(lc_JsonText));
                    end;
                    */
                    ImpAdmn.CallServerList(71);
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        //ImpAdmn.CallServerList(71);
        //ImpAdmn.CallServerList(80);
        //ImpAdmn.CallServerList(90);
        //ImpAdmn.CallServerList(100);
        //ImpAdmn.CallServerList(110);
        //ImpAdmn.CallServerList(160);
        //ImpAdmn.CallServerList(170);
        //ImpAdmn.CallServerList(180);
        //Rec.LoadFromServer('impent02');
    end;

    var
        ImpAdmn: Codeunit "IMP Administration";
}
