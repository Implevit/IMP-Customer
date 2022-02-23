codeunit 50003 "IMP Events"
{
    #region Codeunits


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

    var
        ImpMgmt: Codeunit "IMP Management";
}