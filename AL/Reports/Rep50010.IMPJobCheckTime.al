report 50010 "IMP Job Check Time"
{

    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = './src/ReportLayout/Rep50010.IMPJobCheckTime.rdlc';
    Caption = 'IMP Project check time';
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem("Job Journal Line"; "Job Journal Line")
        {
            DataItemTableView = sorting("Journal Template Name", "Journal Batch Name", "Line No.");
            MaxIteration = 1;

            dataitem("Integer"; Integer)
            {
                DataItemTableView = sorting(Number);
                column(TempJobJourLineRec_JourTemplName; TempJobJourLineRec."Journal Template Name")
                {
                }
                column(TempJobJourLineRec_JourName; TempJobJourLineRec."Journal Batch Name")
                {
                }
                column(TempJobJourLineRec_PostDate; TempJobJourLineRec."Posting Date")
                {
                }
                column(TempJobJourLineRec_No; TempJobJourLineRec."No.")
                {
                }
                column(TempJobJourLineRec_JobNo; TempJobJourLineRec."Job No.")
                {
                }
                column(TempJobJourLineRec_JobTaskNo; TempJobJourLineRec."Job Task No.")
                {
                }
                column(TempJobJourLineRec_Time1from; TempJobJourLineRec."IMP Time 1 from")
                {
                }
                column(TempJobJourLineRec_Time1to; TempJobJourLineRec."IMP Time 1 to")
                {
                }
                column(TempJobJourLineRec_Descr; TempJobJourLineRec.Description)
                {
                }
                column(TempJobJourLineRec_LineNo; TempJobJourLineRec."Line No.")
                {
                }
                column(TodayDate; FORMAT(TODAY, 0, 4))
                {
                }
                column(CompanyNameDB; COMPANYNAME)
                {
                }
                column(UserIDDB; USERID)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    if Number = 1 then
                        TempJobJourLineRec.FindSet()
                    ELSE
                        TempJobJourLineRec.Next();
                end;

                trigger OnPreDataItem()
                begin
                    Integer.Reset();
                    Integer.SetRange(Number, 1, TempJobJourLineRec.Count);
                end;
            }

            trigger OnAfterGetRecord()
            begin
                TempJobJourLineRec.DeleteAll();
                JobJourLineRec.Reset();
                JobJourLineRec.SetCurrentKey("No.", "Posting Date", "IMP Time 1 from", "IMP Time 1 to");
                JobJourLineRec.SetRange("No.", EmployeeCode);

                if JobJourLineRec.FIND('-') then begin

                    LineNoInt := 10000;
                    REPEAT
                        if (JobJourLineRec."IMP Time 1 from" <> 0) and (JobJourLineRec."IMP Time 1 to" <> 0) then begin
                            LineNoInt += 10000;
                            TempJobJourLineRec.Init();
                            TempJobJourLineRec.TransferFields(JobJourLineRec);
                            TempJobJourLineRec."Posting Date" := JobJourLineRec."Posting Date";
                            TempJobJourLineRec."Applies-to Entry" := JobJourLineRec."Line No.";
                            TempJobJourLineRec."Line No." := LineNoInt;
                            TempJobJourLineRec.Insert();
                        end;

                        if (JobJourLineRec."IMP Time 2 from" <> 0) and (JobJourLineRec."IMP Time 2 to" <> 0) then begin
                            LineNoInt += 10000;
                            TempJobJourLineRec.Init();
                            TempJobJourLineRec.TransferFields(JobJourLineRec);
                            TempJobJourLineRec."Applies-to Entry" := JobJourLineRec."Line No.";
                            TempJobJourLineRec."Line No." := LineNoInt;
                            TempJobJourLineRec."IMP Time 1 from" := JobJourLineRec."IMP Time 2 from";
                            TempJobJourLineRec."IMP Time 1 to" := JobJourLineRec."IMP Time 2 to";
                            TempJobJourLineRec.Insert();
                        end;

                        if (JobJourLineRec."IMP Time 3 from" <> 0) and (JobJourLineRec."IMP Time 3 to" <> 0) then begin
                            LineNoInt += 10000;
                            TempJobJourLineRec.Init();
                            TempJobJourLineRec.TransferFields(JobJourLineRec);
                            TempJobJourLineRec."Applies-to Entry" := JobJourLineRec."Line No.";
                            TempJobJourLineRec."Line No." := LineNoInt;
                            TempJobJourLineRec."IMP Time 1 from" := JobJourLineRec."IMP Time 3 from";
                            TempJobJourLineRec."IMP Time 1 to" := JobJourLineRec."IMP Time 3 to";
                            TempJobJourLineRec.Insert();
                        end;

                    until JobJourLineRec.Next() = 0;
                end;


                TempJobJourLineRec.SetCurrentKey("No.", "Posting Date", "IMP Time 1 from", "IMP Time 1 to");
                if TempJobJourLineRec.FindSet() then begin
                    FirstBool := true;
                    TempJobJourLineRec.Delete();

                    repeat
                        if ((TempJobJourLineRec."No." = Nummer1Code) and
                           (TempJobJourLineRec."Posting Date" = Datum1Date) and
                           (TempJobJourLineRec."IMP Time 1 from" < Zeitbis1Dec)) then begin
                            Nummer1Code := TempJobJourLineRec."No.";
                            Datum1Date := TempJobJourLineRec."Posting Date";
                            Zeitvon1Dec := TempJobJourLineRec."IMP Time 1 from";
                            Zeitbis1Dec := TempJobJourLineRec."IMP Time 1 to";
                        end else begin
                            Nummer1Code := TempJobJourLineRec."No.";
                            Datum1Date := TempJobJourLineRec."Posting Date";
                            Zeitvon1Dec := TempJobJourLineRec."IMP Time 1 from";
                            Zeitbis1Dec := TempJobJourLineRec."IMP Time 1 to";
                            if not FirstBool then
                                TempJobJourLineRec.Delete();
                        end;
                        FirstBool := false;
                    until TempJobJourLineRec.Next() = 0;
                end;
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Allgemein)
                {
                    Caption = 'Options';
                    field(EmployeeCodeOpt; EmployeeCode)
                    {
                        Caption = 'Employee';
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
        ReportNameLbl = 'Plausibility check hr journal';
        JourTempNameLbl = 'Journal Template Name ';
        JourNameLbl = 'Journal Name';
        PostDateLbl = 'Posting Date';
        NoLbl = 'No.';
        JobNoLbl = 'Project no.';
        JobTaskNoLbl = 'Job Task No.';
        DescrLbl = 'Description';
        TimefromLbl = 'Time from';
        TimetoLbl = 'Time to';
    }

    trigger OnInitReport()
    begin
    end;

    var
        JobJourLineRec: Record "Job Journal Line";
        TempJobJourLineRec: Record "Job Journal Line" temporary;
        LineNoInt: Integer;
        Nummer1Code: Code[20];
        Datum1Date: Date;
        Zeitvon1Dec: Decimal;
        Zeitbis1Dec: Decimal;
        FirstBool: Boolean;
        EmployeeCode: Code[20];
}
