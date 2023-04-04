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
                //if ((lc_Test < 1) and ((lc_Rest = 0) or (lc_Rest = 0.15) or (lc_Rest = 0.3) or (lc_Rest = 0.45))) then
                //    lc_Rest := lc_Rest
                //else
                //    Error(Txt3_Txt);
                RestCheck(lc_Test, lc_Rest);
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
                //if ((lc_Test < 1) and ((lc_Rest = 0) or (lc_Rest = 0.15) or (lc_Rest = 0.3) or (lc_Rest = 0.45))) then
                //    lc_Rest := lc_Rest
                //else
                //    Error(Txt3_Txt);
                RestCheck(lc_Test, lc_Rest);
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
                //if ((lc_Test < 1) and ((lc_Rest = 0) or (lc_Rest = 0.15) or (lc_Rest = 0.3) or (lc_Rest = 0.45))) then
                //    lc_Rest := lc_Rest
                //else
                //    Error(Txt3_Txt);
                RestCheck(lc_Test, lc_Rest);
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
                //if ((lc_Test < 1) and ((lc_Rest = 0) or (lc_Rest = 0.15) or (lc_Rest = 0.3) or (lc_Rest = 0.45))) then
                //    lc_Rest := lc_Rest
                //else
                //    Error(Txt3_Txt);
                RestCheck(lc_Test, lc_Rest);
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
                //if ((lc_Test < 1) and ((lc_Rest = 0) or (lc_Rest = 0.15) or (lc_Rest = 0.3) or (lc_Rest = 0.45))) then
                //    lc_Rest := lc_Rest
                //else
                //    Error(Txt3_Txt);
                RestCheck(lc_Test, lc_Rest);
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
                //if ((lc_Test < 1) and ((lc_Rest = 0) or (lc_Rest = 0.15) or (lc_Rest = 0.3) or (lc_Rest = 0.45))) then
                //    lc_Rest := lc_Rest
                //else
                //    Error(Txt3_Txt);
                RestCheck(lc_Test, lc_Rest);

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
            ObsoleteState = Pending;
            ObsoleteReason = 'Wird nirgens verwendet';

            trigger OnValidate()
            begin
            end;
        }
        field(50080; "IMP Time On Job"; Decimal)
        {
            Caption = 'Time on job';
            DataClassification = CustomerContent;
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
        field(50110; "IMP Job Task Description"; Text[100])
        {
            Caption = 'Job Task Description';
            FieldClass = FlowField;
            Editable = false;
            CalcFormula = Lookup("Job Task".Description where("Job No." = field("Job No."), "Job Task No." = field("Job Task No.")));
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
        field(50150; "IMP Travel km + Time integrate"; Boolean)
        {
            Caption = 'Travel km + time integrate';
            DataClassification = CustomerContent;

            trigger OnValidate()
            begin
                if (Rec."IMP Travel km + Time integrate") then
                    CreateNewTravelLine()
                else
                    DeleteTravelLine();
                ComesFromField := Rec.FieldNo("IMP Travel km + Time integrate");
                TimeCalc(true);
            end;
        }
        field(50160; "IMP Belongs To Line No."; Integer)
        {
            Caption = 'Belongs to line no.';
            DataClassification = CustomerContent;
        }
        field(50170; "IMP Overlap"; Boolean)
        {
            Caption = 'Overlap';
            DataClassification = CustomerContent;
        }
        field(50180; "IMP Internal Job"; Option)
        {
            Caption = 'Internal Job';
            OptionMembers = " ",Ferien,Kompensation,Privat,Krankheit,Militär,Unfall,Ausbildung,"Int.Projekte",Jubiläumsferien,Sonstiges,"Administr.",Akquisition;
            FieldClass = FlowField;
            CalcFormula = Lookup(Job."IMP Internal Job" WHERE("No." = FIELD("Job No.")));
        }
        field(50190; "IMP Contact No."; Boolean)
        {
            Caption = 'Contact';
            DataClassification = CustomerContent;
            TableRelation = Contact;
        }
    }

    #region Triggers

    trigger OnAfterModify()
    var
        lc_JobConsInvLine: Record "IMP Job Consulting Inv. Line";
        lc_JobConsInvHead: Record "IMP Job Consulting Inv. Header";
        l_JobTask: Record "Job Task";
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
        if (rec."Job Task No." <> xRec."Job Task No.") and (rec."Job Task No." <> '') then begin
            if l_JobTask.get("Job No.","Job Task No.") then begin
                    "IMP All Inclusive" := l_JobTask."IMP All inclusive";
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

    procedure RestCheck(_Test: Decimal; _Rest: Decimal)
    begin
        if not ((_Test < 1) and ((_Rest = 0) or (_Rest = 0.15) or (_Rest = 0.3) or (_Rest = 0.45))) then
            Error(Txt3_Txt);
    end;

    procedure CreateNewTravelLine()
    var
        lc_JobSetup: Record "Jobs Setup";
        lc_Job: Record Job;
        lc_JJL: Record "Job Journal Line";
        lc_WT: Record "Work Type";
        lc_LineNo: Integer;
    begin
        // Get and check setup
        lc_JobSetup.Get();
        lc_JobSetup.TestField("IMP Job Travel Work Type Code");

        // Get work type
        lc_WT.Get(lc_JobSetup."IMP Job Travel Work Type Code");

        // Get job
        lc_Job.Get("Job No.");

        // Create new line if not exists
        if not lc_JJL.Get(Rec."Journal Template Name", Rec."Journal Batch Name", Rec."IMP Belongs to Line No.") then begin
            // Find next line no.
            lc_JJL.Reset();
            lc_JJL.SetRange("Journal Template Name", "Journal Template Name");
            lc_JJL.SetRange("Journal Batch Name", "Journal Batch Name");
            lc_JJL.SetFilter("Line No.", '>%1', "Line No.");
            if lc_JJL.Find('-') then
                lc_LineNo := "Line No." + ((lc_JJL."Line No." - "Line No.") / 2)
            else
                lc_LineNo := "Line No." + 10000;
            // Create new line
            lc_JJL.Init();
            lc_JJL.Validate("Journal Template Name", "Journal Template Name");
            lc_JJL.Validate("Journal Batch Name", "Journal Batch Name");
            lc_JJL.Validate("Line No.", lc_LineNo);
            lc_JJL.Validate("Job No.", "Job No.");
            lc_JJL.Validate("Job Task No.", "Job Task No.");
            //lc_JJL.Validate("Job Planningline Line No.", "Job Planningline Line No.");
            lc_JJL.Validate("Posting Date", "Posting Date");
            lc_JJL.Validate("Document No.", "Document No.");
            lc_JJL.Validate(Type, Type);
            lc_JJL.Validate("No.", "No.");
            lc_JJL.Validate(Description, lc_WT.Description);
            lc_JJL.Validate("Work Type Code", lc_WT.Code);
            lc_JJL.Validate("IMP Belongs to Line No.", "Line No.");
            lc_JJL.Insert(true);
        end;

        // Update line
        lc_JJL.Validate(Quantity, lc_Job."IMP Travel Time (100er units)");
        lc_JJL.Validate("IMP Travel Time", lc_Job."IMP Travel Time (100er units)");
        lc_JJL.Validate("IMP Total from/to", lc_Job."IMP Travel Time (100er units)");
        lc_JJL.Validate("IMP km", lc_Job."IMP Distance km");
        lc_JJL.Modify(true);

        // Store belongs to line no.
        Rec."IMP Belongs to Line No." := lc_JJL."Line No.";
    end;

    procedure DeleteTravelLine()
    var
        lc_JJL: Record "Job Journal Line";
    begin
        if lc_JJL.Get(Rec."Journal Template Name", Rec."Journal Batch Name", Rec."IMP Belongs to Line No.") then begin
            lc_JJL.Delete();
            Rec."IMP Belongs to Line No." := 0;
        end;
    end;

    procedure SetStyle() Style: Text
    var
        IsHandled: Boolean;
    begin


        if "IMP Overlap" then
            exit('Attention')
        else
           exit('')
;
    end;

    #endregion Methodes

    var
        Job: Record Job;
        ComesFromField: Integer;
        Txt1_Txt: Label 'No hourly allocation can be made when expenses are recorded.';
        Txt2_Txt: Label 'For internal projects, the from/to time or quantity must be changed';
        Txt3_Txt: Label 'Wrong Time - Valid e.g. 7.15, 12.30, 17.45';

}