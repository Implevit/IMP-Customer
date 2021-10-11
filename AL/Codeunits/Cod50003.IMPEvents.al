codeunit 50003 "IMP Events"
{
    #region Codeunits

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"IMP Data Management", 'OnHasImpCustomerInstalled', '', true, true)]
    local procedure "C70025-OnHasImpCustomerInstalled"(var RetValue: Boolean)
    begin
        RetValue := true;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"IMP Data Management", 'OnGetConnection', '', true, true)]
    local procedure "C70025-OnGetConnection"(var Object: JsonObject; var ConnectionNo: Code[20]; var Url: Text; var Tenant: Text; var CustomerNo: Text; var CompanyName: Text; var CompanyId: Text; var AuthNo: Integer; var Username: Text; var Password: Text; var Token: Text; var ClientId: Text; var SecretId: Text; var Found: Boolean)
    begin
        ImpMgmt.C70025_OnGetConnection(Object, ConnectionNo, Url, Tenant, CustomerNo, CompanyName, CompanyId, AuthNo, Username, Password, Token, ClientId, SecretId, Found);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"IMP Data Management", 'OnSelectConnection', '', true, true)]
    local procedure "C70025-OnSelectConnection"(var Object: JsonObject; var ConnectionNo: Code[20]; var Url: Text; var Tenant: Text; var CustomerNo: Text; var CompanyName: Text; var CompanyId: Text; var AuthNo: Integer; var Username: Text; var Password: Text; var Token: Text; var ClientId: Text; var SecretId: Text; var Selected: Boolean; var Skip: Boolean)
    begin
        ImpMgmt.C70025_OnSelectConnection(Object, ConnectionNo, Url, Tenant, CustomerNo, CompanyName, CompanyId, AuthNo, Username, Password, Token, ClientId, SecretId, Selected, Skip);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"IMP Data Management", 'OnGetAuthorisation', '', true, true)]
    local procedure "C70025-OnGetAuthorisation"(AuthNo: Integer; var Username: Text; var Password: Text; var ClientId: Text; var SecretId: Text; var Token: Text; var Found: Boolean);
    begin
        ImpMgmt.C70025_OnGetAuthorisation(AuthNo, Username, Password, ClientId, SecretId, Token, Found);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"IMP Data Management", 'OnSelectAuthorisation', '', true, true)]
    local procedure "C70025-OnSelectAuthorisation"(CustomerNo: Text; var AuthNo: Integer; var Username: Text; var Password: Text; var ClientId: Text; var SecretId: Text; var Token: Text; var Selected: Boolean; var Skip: Boolean);
    begin
        ImpMgmt.C70025_OnSelectAuthorisation(CustomerNo, AuthNo, Username, Password, ClientId, SecretId, Token, Selected, Skip);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"IMP Data WebService", 'OnODataBeforeProcess', '', true, true)]
    local procedure "C70026-OnODataBeforeProcess"(Request: JsonObject; var Response: JsonObject; var Skip: Boolean)
    begin
        ImpMgmt.C70026_OnODataBeforeProcess(Request, Response, Skip);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"IMP Data WebService", 'OnODataAfterProcess', '', true, true)]
    local procedure "C70026-OnODataAfterProcess"(Request: JsonObject; var Response: JsonObject)
    begin
        ImpMgmt.C70026_OnODataAfterProcess(Request, Response);
    end;

    #endregion Codeunits

    #region Tables

    [EventSubscriber(ObjectType::Table, Database::"Job Journal Line", 'OnBeforeValidateJobTaskNo', '', true, true)]
    local procedure "T210-OnBeforeValidateJobTaskNo"(var JobJournalLine: Record "Job Journal Line"; var xJobJournalLine: Record "Job Journal Line"; var IsHandled: Boolean)
    begin
        ImpMgmt.T210_OnBeforeValidateJobTaskNo(JobJournalLine, xJobJournalLine, IsHandled);
    end;


    [EventSubscriber(ObjectType::Table, Database::"Job Journal Line", 'OnAfterSetUpNewLine', '', true, true)]
    local procedure "T210-OnAfterSetUpNewLine"(var JobJournalLine: Record "Job Journal Line"; LastJobJournalLine: Record "Job Journal Line"; JobJournalTemplate: Record "Job Journal Template"; JobJournalBatch: Record "Job Journal Batch")
    begin
        ImpMgmt.T210_OnAfterSetUpNewLine(JobJournalLine, LastJobJournalLine, JobJournalTemplate, JobJournalBatch);
    end;

    #endregion Tables

    #region Pages


    #endregion Pages

    var
        ImpMgmt: Codeunit "IMP Management";
}