pageextension 50000 "IMP Pag1-Ext50000" extends "Company Information"
{
    layout
    {
        addafter(GrpImplBasicGeneral)
        {
            group(GrpImplBasicCustomer)
            {
                Caption = 'Customer';

                field("IMP Connection Nos."; Rec."IMP Connection Nos.")
                {
                    ApplicationArea = All;
                }
                field("IMP Gitlab Url"; Rec."IMP Gitlab Url")
                {
                    ApplicationArea = All;

                    trigger OnAssistEdit()
                    begin
                        if (Rec."IMP Gitlab Url" <> '') then
                            Hyperlink(Rec."IMP Gitlab Url");
                    end;
                }
                field("IMP Basic Dns"; Rec."IMP Basic Dns")
                {
                    ApplicationArea = All;
                }
                field("IMP Customers Path"; Rec."IMP Customers Path")
                {
                    ApplicationArea = All;

                    trigger OnAssistEdit()
                    var
                        lc_Path: Text;
                    begin
                        // Init
                        if (Rec."IMP Customers Path" = '') then
                            lc_Path := '\\impfps01\Daten\04_Entwicklung\Kunden\';
                        // Select
                        lc_Path := BscMgmt.GetFolder(lc_Path);
                        // Set
                        if (lc_Path <> '') then
                            if (lc_Path.ToLower() <> Rec."IMP Customers Path".ToLower()) then
                                Rec."IMP Customers Path" := CopyStr(lc_Path, 1, MaxStrLen(Rec."IMP Customers Path"));
                    end;
                }
                field("IMP Delete Info File"; Rec."IMP Delete Info File")
                {
                    ApplicationArea = All;
                }
                field("IMP DeepL URL"; Rec."IMP DeepL URL")
                {
                    ApplicationArea = All;
                }
                field("IMP DeepL Token"; Rec."IMP DeepL Token")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
        addafter(ActImplBasic)
        {
            group(ActImplCustomer)
            {
                Caption = 'Customer';

                action(DoImplCustomerDeeplUsageShow)
                {
                    Caption = 'DeepL show usage';
                    ApplicationArea = All;
                    Image = Action;

                    trigger OnAction()
                    begin
                        BscMgmt.DeeplUsageShow();
                    end;
                }
                action(DoImplCustomerDeeplTranslate)
                {
                    Caption = 'DeepL translate xlf-file';
                    ApplicationArea = All;
                    Image = Action;

                    trigger OnAction()
                    begin
                        ImpMgmt.TranslateXlfFile(true, true);
                    end;
                }

            }
        }
    }

    var
        BscMgmt: Codeunit "IMP Basic Management";
        ImpMgmt: Codeunit "IMP Management";
}
