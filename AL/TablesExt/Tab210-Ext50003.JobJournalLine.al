tableextension 50003 "IMP Tab210-Ext50003" extends "Job Journal Line"
{
    fields
    {
        field(50000; "IMP Travel Time"; Decimal)
        {
            Caption = 'Travel Time';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                ComesFromField := FieldNo(Rec."IMP Travel Time");
                TimeJob();
            end;
        }
        field(50010; "IMP km"; Decimal)
        {
            Caption = 'km';
            DataClassification = CustomerContent;
        }
        field(50020; "IMP Hours Not To Invoice"; Decimal)
        {
            Caption = 'Hours not to invoice';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if Rec."IMP Expenses" then begin
                    Rec."IMP Hours not to invoice" := 0;
                    Error(Txt1_Txt);
                end else begin
                    GetJob();
                    if (Job."IMP Internal Job" <> Job."IMP Internal Job"::" ") then
                        Error(Txt2_Txt);
                    ComesFromField := FieldNo(Rec."IMP Hours not to invoice");
                    TimeJob();
                end;
            end;
        }
        field(50030; "IMP Hours To Invoice"; Decimal)
        {
            Caption = 'Hours to invoice';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if ((Rec."IMP Hours to invoice" = 0) and (xRec."IMP Hours to invoice" <> 0)) then begin
                    ComesFromField := FieldNo(Rec."IMP Hours to invoice");
                    TimeJob();
                end else
                    if Rec."IMP Expenses" then begin
                        Rec."IMP Hours not to invoice" := 0;
                        Error(Txt1_Txt);
                    end else begin
                        GetJob();
                        if (Job."IMP Internal Job" <> Job."IMP Internal Job"::" ") then
                            Error(Txt2_Txt);
                        ComesFromField := FieldNo(Rec."IMP Hours to invoice");
                        TimeJob();
                    end;
            end;
        }
        field(50040; "IMP Time 1 from"; Decimal)
        {
            Caption = 'Time 1 from';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                lc_Test: Decimal;
                lc_Rest: Decimal;
            begin
                if ((Rec."IMP Time 1 from" > 0) and (Rec."IMP Time 1 to" > 0) and (Rec."IMP Time 1 from" > Rec."IMP Time 1 to")) then
                    Rec."IMP Time 1 to" := 0;

                TimeCheck(Rec."IMP Time 1 from", lc_Test, lc_Rest);
                //JobSetup.Get();
                //if JobSetup."IMP Report 15 Minutes Unit" then
                if ((lc_Test < 1) and ((lc_Rest = 0) or (lc_Rest = 0.15) or (lc_Rest = 0.3) or (lc_Rest = 0.45))) then
                    lc_Rest := lc_Rest
                else
                    Error(Txt3_Txt);
                TimeCalc(true); // JobSetup."Report 15 Minutes Unit");
            end;
        }
        field(50041; "IMP Time 1 to"; Decimal)
        {
            Caption = 'Time 1 to';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                lc_Test: Decimal;
                lc_Rest: Decimal;
            begin
                if ((Rec."IMP Time 1 from" > 0) and (Rec."IMP Time 1 to" > 0) and (Rec."IMP Time 1 from" > Rec."IMP Time 1 to")) then
                    Rec."IMP Time 1 to" := 0;

                TimeCheck(Rec."IMP Time 1 to", lc_Test, lc_Rest);
                //JobSetup.Get();
                //if JobSetup."IMP Report 15 Minutes Unit" then
                if ((lc_Test < 1) and ((lc_Rest = 0) or (lc_Rest = 0.15) or (lc_Rest = 0.3) or (lc_Rest = 0.45))) then
                    lc_Rest := lc_Rest
                else
                    Error(Txt3_Txt);
                TimeCalc(true); // lc_JobSetup."IMP Report 15 Minutes Unit");
            end;
        }
        field(50050; "IMP Time 2 from"; Decimal)
        {
            Caption = 'Time 2 from';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                lc_Test: Decimal;
                lc_Rest: Decimal;
            begin
                if ((Rec."IMP Time 2 from" > 0) and (Rec."IMP Time 2 to" > 0) and (Rec."IMP Time 2 from" > Rec."IMP Time 2 to")) then
                    Rec."IMP Time 2 to" := 0;

                TimeCheck(Rec."IMP Time 2 from", lc_Test, lc_Rest);
                //JobSetup.Get();
                //IF JobSetup."IMP Report 15 Minutes Unit" then
                if ((lc_Test < 1) and ((lc_Rest = 0) or (lc_Rest = 0.15) or (lc_Rest = 0.3) or (lc_Rest = 0.45))) then
                    lc_Rest := lc_Rest
                else
                    Error(Txt3_Txt);
                TimeCalc(true); // JobSetup."IMP Report 15 Minutes Unit");
            end;
        }
        field(50051; "IMP Time 2 to"; Decimal)
        {
            Caption = 'Time 2 to';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                lc_Test: Decimal;
                lc_Rest: Decimal;
            begin
                if ((Rec."IMP Time 2 from" > 0) and (Rec."IMP Time 2 to" > 0) and (Rec."IMP Time 2 from" > Rec."IMP Time 2 to")) then
                    Rec."IMP Time 2 to" := 0;

                TimeCheck(Rec."IMP Time 2 to", lc_Test, lc_Rest);
                //JobSetup.Get();
                //if JobSetup."IMP Report 15 Minutes Unit" then
                if ((lc_Test < 1) and ((lc_Rest = 0) or (lc_Rest = 0.15) or (lc_Rest = 0.3) or (lc_Rest = 0.45))) then
                    lc_Rest := lc_Rest
                else
                    Error(Txt3_Txt);
                TimeCalc(true); // JobSetup."IMP Report 15 Minutes Unit");
            end;
        }
        field(50060; "IMP Time 3 from"; Decimal)
        {
            Caption = 'Time 3 from';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                lc_Test: Decimal;
                lc_Rest: Decimal;
            begin
                if ((Rec."IMP Time 3 from" > 0) and (Rec."IMP Time 3 to" > 0) and (Rec."IMP Time 3 from" > Rec."IMP Time 3 to")) then
                    Rec."IMP Time 3 to" := 0;

                TimeCheck(Rec."IMP Time 3 from", lc_Test, lc_Rest);
                //JobSetup.Get();
                //if JobSetup."IMP Report 15 Minutes Unit" then
                if ((lc_Test < 1) and ((lc_Rest = 0) or (lc_Rest = 0.15) or (lc_Rest = 0.3) or (lc_Rest = 0.45))) then
                    lc_Rest := lc_Rest
                else
                    Error(Txt3_Txt);
                TimeCalc(true); // JobSetup."IMP Report 15 Minutes Unit");
            end;
        }
        field(50061; "IMP Time 3 to"; Decimal)
        {
            Caption = 'Time 3 to';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                lc_Test: Decimal;
                lc_Rest: Decimal;
            begin
                if ((Rec."IMP Time 3 from" > 0) and (Rec."IMP Time 3 to" > 0) and (Rec."IMP Time 3 from" > Rec."IMP Time 3 to")) then
                    Rec."IMP Time 3 to" := 0;

                TimeCheck(Rec."IMP Time 3 to", lc_Test, lc_Rest);
                //JobSetup.Get();
                //if JobSetup."IMP Report 15 Minutes Unit" then
                if ((lc_Test < 1) and ((lc_Rest = 0) or (lc_Rest = 0.15) or (lc_Rest = 0.3) or (lc_Rest = 0.45))) then
                    lc_Rest := lc_Rest
                else
                    Error(Txt3_Txt);
                TimeCalc(true); // JobSetup."IMP Report 15 Minutes Unit");
            end;
        }
        field(50070; "IMP Time 0 from"; Decimal)
        {
            Caption = 'Time 0 from';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                lc_Test: Decimal;
                lc_Rest: Decimal;
            begin
                if ((Rec."IMP Time 0 from" > 0) and (Rec."IMP Time 0 to" > 0) and (Rec."IMP Time 0 from" > Rec."IMP Time 0 to")) then
                    Rec."IMP Time 0 to" := 0;

                TimeCheck(Rec."IMP Time 0 from", lc_Test, lc_Rest);
            end;
        }
        field(50071; "IMP Time 0 to"; Decimal)
        {
            Caption = 'Time 0 to';
            DataClassification = CustomerContent;

            trigger OnValidate()
            var
                lc_Test: Decimal;
                lc_Rest: Decimal;
            begin
                if ((Rec."IMP Time 0 from" > 0) and (Rec."IMP Time 0 to" > 0) and (Rec."IMP Time 0 from" > Rec."IMP Time 0 to")) then
                    Rec."IMP Time 0 to" := 0;

                TimeCheck(Rec."IMP Time 0 to", lc_Test, lc_Rest);
            end;
        }
        field(50072; "IMP Total 0 from/to"; Decimal)
        {
            Caption = 'Total 0 from/to';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
            end;
        }
        field(50080; "IMP Time On Job"; Decimal)
        {
            Caption = 'Time on job';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
            end;
        }
        field(50090; "IMP Total from/to"; Decimal)
        {
            Caption = 'Total from/to';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
            end;
        }
        field(50100; "IMP Expenses"; Boolean)
        {
            Caption = 'Expenses';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if Rec."IMP Expenses" then begin
                    Rec."IMP Time 1 from" := 0;
                    Rec."IMP Time 1 to" := 0;
                    Rec."IMP Time 2 from" := 0;
                    Rec."IMP Time 2 to" := 0;
                    Rec."IMP Time 3 from" := 0;
                    Rec."IMP Time 3 to" := 0;
                    Rec."IMP Hours not to invoice" := 0;
                    Rec."IMP Hours to invoice" := 0;
                    Rec.Validate(Quantity, 1);
                end else
                    Validate(Quantity, 0);
            end;
        }
        field(50110; "IMP Job Task Description"; Text[50])
        {
            Caption = 'Job Task Description';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
            end;
        }
        field(50120; "IMP Ticket No."; Text[50])
        {
            Caption = 'Ticket No.';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
            end;
        }
        field(50130; "IMP All Inclusive"; Boolean)
        {
            Caption = 'All inclusive';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
            end;
        }
        field(50140; "IMP In Accounting"; Boolean)
        {
            Caption = 'IN Accounting';
            FieldClass = FlowField;
            CalcFormula = Exist("IMP Job Consulting Inv. Line" where("Job Journal Template" = Field("Journal Template Name"), "Job Journal Batch" = Field("Journal Batch Name"), "Job Journal Line No." = Field("Line No.")));
        }
    }

    #region Triggers

    trigger OnAfterModify()
    var
        lc_JobConsInvLine: Record "IMP Job Consulting Inv. Line";
        lc_JobConsInvHead: Record "IMP Job Consulting Inv. Header";
    begin
        Rec.CalcFields("IMP In Accounting");
        if (Rec."IMP In Accounting") then begin
            lc_JobConsInvLine.SetRange("Job Journal Template", Rec."Journal Template Name");
            lc_JobConsInvLine.SetRange(lc_JobConsInvLine."Job Journal Batch", Rec."Journal Batch Name");
            lc_JobConsInvLine.SetRange("Job Journal Line No.", Rec."Line No.");
            if lc_JobConsInvLine.FindFirst() then
                if lc_JobConsInvHead.Get(lc_JobConsInvLine."Job No.", lc_JobConsInvLine.Year, lc_JobConsInvLine.Month) then begin
                    lc_JobConsInvHead.TestField(Status, lc_JobConsInvHead.Status::created);
                    lc_JobConsInvHead."Modified after creation" := true;
                    lc_JobConsInvHead."Modified by User" := CopyStr(Userid(), 1, MaxStrLen(lc_JobConsInvHead."Modified by User"));
                    lc_JobConsInvHead."Modified at Time" := CreateDateTime(Today, Time);
                    lc_JobConsInvHead.Modify(true);
                end;
        end;
    end;

    trigger OnAfterDelete()
    var
    begin
        Rec.CalcFields("IMP In Accounting");
        Rec.TestField("IMP In Accounting", false);
    end;

    trigger OnAfterRename()
    var
    begin
        Rec.CalcFields("IMP In Accounting");
        Rec.TestField("IMP In Accounting", false);
    end;

    #endregion Triggers


    #region Methodes

    local procedure GetJob()
    var
        lc_Currency: Record Currency;
    begin
        TestField("Job No.");

        Clear(lc_Currency);
        lc_Currency.InitRoundingPrecision();

        IF ("Job No." <> Job."No.") OR (lc_Currency."Unit-Amount Rounding Precision" = 0) THEN
            Job.Get("Job No.");
    end;

    local procedure ValidateResource()
    var
        lc_UserSetup: Record "User Setup";
        lc_Res: Record Resource;
        lc_ResCode: Text;
    begin
        if ((Rec."No." = '') and (Rec."Job No." <> '')) then begin
            lc_UserSetup.Get(UserId());
            IF (lc_UserSetup."IMP Job Resource No." <> '') then
                lc_ResCode := lc_UserSetup."IMP Job Resource No."
            else
                lc_ResCode := Rec."Journal Batch Name";

            if lc_Res.Get(lc_ResCode) then
                Validate("No.", lc_ResCode);
        end;
    end;

    procedure TimeJob()
    var
    //lc_JobTask: Record "Job Task";
    begin
        case ComesFromField of
            Rec.FieldNo("IMP Travel Time"):
                if (Rec."IMP Time on Job" - Rec."IMP Hours to invoice" - Rec."IMP Travel Time") < 0 then
                    Rec."IMP Hours not to invoice" := 0
                else
                    Rec."IMP Hours not to invoice" := Rec."IMP Time on Job" - Rec."IMP Hours to invoice" - Rec."IMP Travel Time";
            Rec.FieldNo("IMP Hours to invoice"):
                if (Rec."IMP Time on Job" - Rec."IMP Hours to invoice" - Rec."IMP Travel Time") < 0 then
                    Rec."IMP Hours not to invoice" := 0
                else
                    Rec."IMP Hours not to invoice" := Rec."IMP Time on Job" - Rec."IMP Hours to invoice" - Rec."IMP Travel Time";
            Rec.FieldNo("IMP Hours not to invoice"):
                if (Rec."IMP Time on Job" - Rec."IMP Hours not to invoice" - Rec."IMP Travel Time") < 0 then
                    Rec."IMP Hours to invoice" := 0
                else
                    Rec."IMP Hours to invoice" := Rec."IMP Time on Job" - Rec."IMP Hours not to invoice" - Rec."IMP Travel Time";
        end;

        ComesFromField := 0;

        /*
        if lc_JobTask.Get("Job No.", "Job Task No.") then
            if (lc_JobTask."IMP Not to Invoice") then begin
                Rec."IMP Hours to invoice" := 0;
                Rec."IMP Hours not to invoice" := Rec."IMP Time on Job";
            end;
        */

        Rec."Total Cost" := Round(Rec.Quantity * Rec."Unit Cost");
        Rec."Total Price" := Round(Rec.Quantity * Rec."Unit Price");
    end;

    procedure TimeCalc(_Round15Minutes: Boolean)
    var
        lc_Roundet: Decimal;
        lc_Rest: Decimal;
        lc_from: Decimal;
        lc_to: Decimal;
        lc_diff1: Decimal;
        lc_diff2: Decimal;
        lc_diff3: Decimal;
    begin
        if ((Rec."IMP Time 1 to" > 0) and (Rec."IMP Time 1 from" >= 0)) then begin
            lc_Roundet := ROUND(Rec."IMP Time 1 from", 1, '<');
            lc_Rest := Rec."IMP Time 1 from" - lc_Roundet;
            lc_from := lc_Roundet + (lc_Rest / 60 * 100);
            lc_Roundet := ROUND(Rec."IMP Time 1 to", 1, '<');
            lc_Rest := Rec."IMP Time 1 to" - lc_Roundet;
            lc_to := lc_Roundet + (lc_Rest / 60 * 100);
            lc_diff1 := lc_to - lc_from;
        end;

        if ((Rec."IMP Time 2 to" > 0) AND (Rec."IMP Time 2 from" >= 0)) then begin
            lc_Roundet := ROUND(Rec."IMP Time 2 from", 1, '<');
            lc_Rest := Rec."IMP Time 2 from" - lc_Roundet;
            lc_from := lc_Roundet + (lc_Rest / 60 * 100);
            lc_Roundet := ROUND(Rec."IMP Time 2 to", 1, '<');
            lc_Rest := Rec."IMP Time 2 to" - lc_Roundet;
            lc_to := lc_Roundet + (lc_Rest / 60 * 100);
            lc_diff2 := lc_to - lc_from;
        end;

        if ((Rec."IMP Time 3 to" > 0) AND (Rec."IMP Time 3 from" >= 0)) then begin
            lc_Roundet := ROUND(Rec."IMP Time 3 from", 1, '<');
            lc_Rest := Rec."IMP Time 3 from" - lc_Roundet;
            lc_from := lc_Roundet + (lc_Rest / 60 * 100);
            lc_Roundet := ROUND(Rec."IMP Time 3 to", 1, '<');
            lc_Rest := Rec."IMP Time 3 to" - lc_Roundet;
            lc_to := lc_Roundet + (lc_Rest / 60 * 100);
            lc_diff3 := lc_to - lc_from;
        end;

        if _Round15Minutes then
            Rec."IMP Total from/to" := ROUND(lc_diff1 + lc_diff2 + lc_diff3, 0.25)
        else
            Rec."IMP Total from/to" := lc_diff1 + lc_diff2 + lc_diff3;

        Validate(Quantity, Rec."IMP Total from/to");
    end;

    procedure TimeCheck(_Total: Decimal; var _Test: Decimal; var _Rest: Decimal)
    var
        lc_Roundet: Decimal;
    begin
        lc_Roundet := Round(_Total, 1, '<');
        _Rest := _Total - lc_Roundet;
        _Test := (_Rest / 60 * 100);
    end;

    #endregion Methodes

    var
        Job: Record Job;
        ComesFromField: Integer;
        Txt1_Txt: Label 'No hourly allocation can be made when expenses are recorded.';
        Txt2_Txt: Label 'For internal projects, the from/to time or quantity must be changed';
        Txt3_Txt: Label 'Ungültige Zeit - Gültig z.B. 7.15, 12.30, 17.45';

}