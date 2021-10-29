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
