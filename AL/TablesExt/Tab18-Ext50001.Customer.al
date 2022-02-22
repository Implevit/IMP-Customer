tableextension 50001 "IMP Tab18-Ext50001" extends Customer
{
    fields
    {
        field(50000; "IMP Abbreviation"; Code[10])
        {
            Caption = 'Abbreviation';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                lc_Rec: Record Customer;
                lc_Txt1_Txt: Label 'this abbreviation has already been used by customer %1';
            begin
                // Check duplicate
                if ((Rec."IMP Abbreviation" <> '') and (Rec."IMP Abbreviation" <> xRec."IMP Abbreviation")) then begin
                    lc_Rec.Reset();
                    lc_Rec.SetRange("IMP Abbreviation", Rec."IMP Abbreviation");
                    lc_Rec.SetFilter("No.", '<>%1', Rec."No.");
                    if lc_Rec.FindFirst() then
                        Error(lc_Txt1_Txt, lc_Rec."No.");
                end;
            end;
        }
        field(50010; "IMP Tenant Id"; Text[250])
        {
            Caption = 'Tenant Id';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                lc_Rec: Record Customer;
                lc_IS: Record "IMP Server";
                lc_IC: Record "IMP Connection";
                //lc_BscMgmt: Codeunit "IMP Basic Management";
                lc_Txt1_Txt: Label 'this tenant id has already been used by customer %1';
                lc_Txt2_Txt: Label 'It still has server instances that have to be deleted first.\\Should this be done now?';
                lc_Txt3_Txt: Label '%1 cannot be deleted until the server instance entries are deleted.';
                lc_Txt4_Txt: Label 'No cloud sever available in %1';
            begin
                Rec."IMP Tenant Id" := LowerCase(Rec."IMP Tenant Id");
                // Check duplicate
                if ((Rec."IMP Tenant Id" <> '') and (Rec."IMP Tenant Id" <> xRec."IMP Tenant Id")) then begin
                    lc_Rec.Reset();
                    lc_Rec.SetRange("IMP Tenant Id", Rec."IMP Tenant Id");
                    lc_Rec.SetFilter("No.", '<>%1', Rec."No.");
                    if lc_Rec.FindFirst() then
                        Error(lc_Txt1_Txt, lc_Rec."No.");
                end;
                // Remove server instance entry
                if ((Rec."IMP Tenant Id" = '') and (Rec."IMP Tenant Id" <> xRec."IMP Tenant Id")) then begin
                    lc_IC.Reset();
                    lc_IC.SetRange(Environment, lc_IC.Environment::Cloud);
                    lc_IC.SetRange("Environment Id", xRec."IMP Tenant Id");
                    if lc_IC.FindSet() then
                        if Confirm(lc_Txt2_Txt) then
                            lc_IC.DeleteAll(true)
                        else
                            Error(lc_Txt3_Txt);
                end;
                // Create server instance for this tenant
                if ((Rec."IMP Tenant Id" <> '') and (Rec."IMP Tenant Id" <> xRec."IMP Tenant Id")) then begin
                    // Set authorisation
                    if (Rec."IMP Authorisation" <> 0) then
                        SetMicrosoftAuthorisation(Rec."IMP Authorisation", Rec."IMP Tenant Id");

                    // Check abbreviation first
                    Rec.TestField("IMP Abbreviation");

                    // Check entry
                    lc_IC.Reset();
                    lc_IC.SetRange(Environment, lc_IC.Environment::Cloud);
                    lc_IC.SetRange("Environment Id", xRec."IMP Tenant Id");
                    lc_IC.SetRange("Customer No.", Rec."No.");
                    if lc_IC.FindSet() then
                        repeat
                            lc_IC."Environment Id" := Rec."IMP Tenant Id";
                            lc_IC.Modify(true);
                            lc_IC.SetUrl();
                        until lc_IC.Next() = 0
                    else begin
                        lc_IS.Reset();
                        lc_IS.SetRange(Type, lc_IS.Type::cloud);
                        if not lc_IS.FindSet() then
                            Error(lc_Txt4_Txt, lc_IS.TableCaption())
                        else
                            if (lc_IS.Count() > 1) then
                                if (Page.RunModal(Page::"IMP Server List", lc_IS)) <> Action::LookupOK then
                                    exit;

                        // Add entry                        
                        lc_IC.Init();
                        lc_IC."Customer No." := Rec."No.";
                        //lc_IC.Dns := CopyStr(lc_BscMgmt.System_GetBaseUrlBC(), 1, MaxStrLen(lc_IC.Dns));
                        lc_IC.Server := lc_IS.Name;
                        lc_IC.Environment := lc_IC.Environment::Cloud;
                        lc_IC."Environment Type" := lc_IC."Environment Type"::Production;
                        lc_IC."Environment Id" := Rec."IMP Tenant Id";
                        lc_IC."Environment Name" := 'Production';
                        lc_IC.SetListName();
                        lc_IC.SetUrl();
                        lc_IC.Insert(true);
                    end;
                end;
            end;
        }
        field(50020; "IMP Apps"; Integer)
        {
            Caption = 'Apps';
            FieldClass = FlowField;
            CalcFormula = count("IMP AL Object App" where("Customer No." = field("No.")));
            TableRelation = "IMP AL Object App";
            Editable = false;
        }
        field(50030; "IMP Connections"; Integer)
        {
            Caption = 'Connections';
            FieldClass = FlowField;
            CalcFormula = count("IMP Connection" where("Customer No." = field("No.")));
            TableRelation = "IMP Connection";
            Editable = false;
        }
        field(50040; "IMP Authorisations"; Integer)
        {
            Caption = 'Authorisations';
            FieldClass = FlowField;
            CalcFormula = count("IMP Authorisation" where("Customer No." = field("No.")));
            TableRelation = "IMP Connection";
            Editable = false;
        }
        field(50050; "IMP Authorisation"; Integer)
        {
            Caption = 'BC Authorisation';
            DataClassification = CustomerContent;
            TableRelation = "IMP Authorisation"."Entry No." where("Customer No." = field("No."));

            trigger OnValidate()
            begin
                if ((Rec."IMP Authorisation" <> 0) and (rec."IMP Authorisation" <> xRec."IMP Authorisation")) then
                    SetMicrosoftAuthorisation(Rec."IMP Authorisation", Rec."IMP Tenant Id");
            end;
        }
    }

    keys
    {
        key(IMP1; "IMP Tenant Id")
        {
        }
    }

    #region Methods

    procedure SetMicrosoftAuthorisation(_Authoristaion: Integer; _TenantId: Text)
    var
        lc_IA: Record "IMP Authorisation";
    begin
        if lc_IA.Get(_Authoristaion) then
            lc_IA.SetMicrosoftAuthorisation(_TenantId);
    end;

    #endregion Methods

}