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
                lc_ISI: Record "IMP Connection";
                lc_BscMgmt: Codeunit "IMP Basic Management";
                lc_Txt1_Txt: Label 'this tenant id has already been used by customer %1';
                lc_Txt2_Txt: Label 'It still has server instances that have to be deleted first.\\Should this be done now?';
                lc_Txt3_Txt: Label '%1 cannot be deleted until the server instance entries are deleted.';
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
                    lc_ISI.Reset();
                    lc_ISI.SetRange(Environment, lc_ISI.Environment::Cloud);
                    lc_ISI.SetRange("Environment Id", xRec."IMP Tenant Id");
                    if lc_ISI.FindSet() then
                        if Confirm(lc_Txt2_Txt) then
                            lc_ISI.DeleteAll(true)
                        else
                            Error(lc_Txt3_Txt);
                end;
                // Create server instance for this tenant
                if ((Rec."IMP Tenant Id" <> '') and (Rec."IMP Tenant Id" <> xRec."IMP Tenant Id")) then begin
                    // Check abbreviation first
                    Rec.TestField("IMP Abbreviation");
                    // Check entry
                    lc_ISI.Reset();
                    lc_ISI.SetRange(Environment, lc_ISI.Environment::Cloud);
                    lc_ISI.SetRange("Environment Id", xRec."IMP Tenant Id");
                    lc_ISI.SetRange("Customer No.", Rec."No.");
                    if lc_ISI.FindSet() then
                        repeat
                            lc_ISI."Environment Id" := Rec."IMP Tenant Id";
                            lc_ISI.Modify(true);
                            lc_ISI.SetUrl();
                        until lc_ISI.Next() = 0
                    else begin
                        // Add entry
                        lc_ISI.Init();
                        lc_ISI."Customer No." := Rec."No.";
                        lc_ISI.Dns := CopyStr(lc_BscMgmt.System_GetBaseUrlBC(), 1, MaxStrLen(lc_ISI.Dns));
                        lc_ISI.Environment := lc_ISI.Environment::Cloud;
                        lc_ISI."Environment Type" := lc_ISI."Environment Type"::Production;
                        lc_ISI."Environment Id" := Rec."IMP Tenant Id";
                        lc_ISI."Environment Name" := 'Production';
                        lc_ISI.SetListName();
                        lc_ISI.SetUrl();
                        lc_ISI.Insert(true);
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
    }
}