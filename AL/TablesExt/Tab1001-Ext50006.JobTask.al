tableextension 50006 "IMP Tab1001-Ext50006" extends "Job Task"
{
    Fields
    {
        Field(50000; "IMP Total Inv. In Accounting"; Decimal)
        {
            Caption = 'Total Inv. In Accounting';
            Editable = false;
            FieldClass = FlowField;
            BlankZero = true;
            CalcFormula = Sum("IMP Job Invoice Line"."Quantity to Invoice" Where("Job No." = Field("Job No."),
                                                                                         "Job Task No." = Field("Job Task No."),
                                                                                         "Posting Date" = Field("Posting Date Filter")));
        }
        Field(50010; "IMP Total In Accounting"; Decimal)
        {
            Caption = 'Total In Accounting';
            Editable = false;
            FieldClass = FlowField;
            BlankZero = true;
            CalcFormula = Sum("IMP Job Invoice Line".Quantity Where("Job No." = Field("Job No."),
                                                                            "Job Task No." = Field("Job Task No."),
                                                                            "Posting Date" = Field("Posting Date Filter")));
        }
        Field(50020; "IMP Total not. Inv. In Acc."; Decimal)
        {
            Caption = 'Total not. Inv. In Accounting';
            Editable = false;
            FieldClass = FlowField;
            BlankZero = true;
            CalcFormula = Sum("IMP Job Invoice Line"."Quantity not to Invoice" Where("Job No." = Field("Job No."),
                                                                                             "Job Task No." = Field("Job Task No."),
                                                                                             "Posting Date" = Field("Posting Date Filter")));
        }
        Field(50030; "IMP Schedule (Total hours)"; Decimal)
        {
            Caption = 'Schedule (Total hours)';
            Editable = false;
            FieldClass = FlowField;
            AutoFormatType = 1;
            BlankZero = true;
            CalcFormula = Sum("Job Planning Line".Quantity Where("Job No." = Field("Job No."),
                                                                  "Job Task No." = Field("Job Task No."),
                                                                  "Job Task No." = Field(FILTER(Totaling)),
                                                                  "Schedule Line" = CONST(true),
                                                                  "Planning Date" = Field("Planning Date Filter"),
                                                                  Type = CONST(Resource)));
        }
        Field(50040; "IMP Usage (Total hours)"; Decimal)
        {
            Caption = 'Usage (Total hours)';
            Editable = false;
            FieldClass = FlowField;
            BlankZero = true;
            CalcFormula = Sum("Job Ledger Entry".Quantity Where("Job No." = Field("Job No."),
                                                                 "Job Task No." = Field("Job Task No."),
                                                                 "Job Task No." = Field(FILTER(Totaling)),
                                                                 "Entry Type" = CONST(Usage),
                                                                 "Posting Date" = Field("Posting Date Filter"),
                                                                 Type = CONST(Resource)));
        }
        Field(50050; "IMP Total Inv. In Journal"; Decimal)
        {
            Caption = 'Total Inv. In Journal';
            Editable = false;
            FieldClass = FlowField;
            BlankZero = true;
            CalcFormula = Sum("Job Journal Line"."IMP Hours to invoice" Where("Job No." = Field("Job No."),
                                                                           "Job Task No." = Field("Job Task No."),
                                                                           "Posting Date" = Field("Posting Date Filter")));
        }
        Field(50060; "IMP Closed"; Boolean)
        {
            Caption = 'Closed';
            DataClassification = CustomerContent;
        }
        Field(50070; "IMP All inclusive"; Boolean)
        {
            Caption = 'All inclusive';
            DataClassification = CustomerContent;
        }
        Field(50080; "IMP Total Not Inv. In Journal"; Decimal)
        {
            Caption = 'Total Not Inv. In Journal';
            Editable = false;
            FieldClass = FlowField;
            BlankZero = true;
            CalcFormula = Sum("Job Journal Line"."IMP Hours not to invoice" Where("Job No." = Field("Job No."),
                                                                               "Job Task No." = Field("Job Task No."),
                                                                               "Posting Date" = Field("Posting Date Filter")));
        }
        Field(50090; "IMP Achieved Percent"; Decimal)
        {
            Caption = 'Achieved %';
            DataClassification = CustomerContent;

            /*            
            trigger OnValidate()
            var
                //lc_JobSetup: Record "Jobs Setup";
                lc_Plan: Record "Job Planning Line";
            begin
                if (Rec."IMP Achieved Percent" <> xRec."IMP Achieved Percent") and (Rec."IMP Closed" = false) then begin
                    Rec.CalcFields("IMP Usage (Total hours)", "IMP Total Inv. In Journal", "IMP Schedule (Total hours)");

                    if (Rec."Achieved Percent" <> 0) then
                        if (Rec."Usage (Total hours)" + Rec."Total Inv. In Journal") <> 0 then
                            Rec."Calc Expected Quantity" := (Rec."Usage (Total hours)" + Rec."Total Inv. In Journal") * 100 / Rec."Achieved Percent"
                        else
                            Rec."Calc Expected Quantity" := Rec."Schedule (Total hours)"
                    else
                        Rec."Calc Expected Quantity" := 0;

                    //lc_JobSetup.Get();
                    //if (lc_JobSetup."IMP Transfer Achieved Percent to" <> lc_JobSetup."IMP Transfer Achieved Percent to"::job) then begin
                    lc_Plan.Reset();
                    lc_Plan.SetRange("Job No.", Rec."Job No.");
                    lc_Plan.SetRange("Job Task No.", Rec."Job Task No.");
                    lc_Plan.SetRange(Type, lc_Plan.Type::Resource);
                    //lc_Plan.SetRange("Achieved Fixed", false);
                    lc_Plan.SetFilter("Line Type", '%1|%2', lc_Plan."Line Type"::Budget, lc_Plan."Line Type"::"Both Budget and Billable");
                    if lc_Plan.Find('-') then
                        repeat
                        if (Rec."Schedule (Total hours)" <> 0) then
                            lc_Plan.Validate("Achieved Percent", Rec."Achieved Percent")
                        else
                            lc_Plan.Validate("Achieved Percent", 0);

                        if (Rec."Calc Expected Quantity" = 0) then
                            lc_Plan."Expected Quantity" := lc_Plan.Quantity
                        else
                            lc_Plan."Expected Quantity" := "Calc Expected Quantity";

                        lc_Plan."Expected Amount" := lc_Plan."Unit Price" * lc_Plan."Expected Quantity";

                        lc_Plan.Modify;
                        until lc_Plan.Next() = 0;
                    //end;
                end;
            end;
            */
        }
        Field(50100; "IMP Sched. (Sales Amount LCY)"; Decimal)
        {
            Caption = 'Schedule (Sales Amount LCY)';
            Editable = false;
            FieldClass = FlowField;
            AutoFormatType = 1;
            BlankZero = true;
            CalcFormula = Sum("Job Planning Line"."Line Amount (LCY)" Where("Job No." = Field("Job No."),
                                                                             "Job Task No." = Field("Job Task No."),
                                                                             "Job Task No." = Field(FILTER(Totaling)),
                                                                             "Schedule Line" = CONST(true),
                                                                             "Planning Date" = Field("Planning Date Filter")));
        }
        Field(50110; "IMP Schedule (Sales Amount)"; Decimal)
        {
            Caption = 'Schedule (Sales Amount)';
            Editable = false;
            FieldClass = FlowField;
            AutoFormatType = 1;
            BlankZero = true;
            CalcFormula = Sum("Job Planning Line"."Line Amount (LCY)" Where("Job No." = Field("Job No."),
                                                                             "Job Task No." = Field("Job Task No."),
                                                                             "Job Task No." = Field(FILTER(Totaling)),
                                                                             "Schedule Line" = CONST(true),
                                                                             "Planning Date" = Field("Planning Date Filter")));
        }
    }

    #region Methodes

    procedure CalcDiffToBudget(_Rec: Record "Job Task"): Decimal
    var
        lc_JJL: Record "Job Journal Line";
    begin
        lc_JJL.Reset();
        lc_JJL.SetRange("Job No.", _Rec."Job No.");
        lc_JJL.SetRange("Job Task No.", _Rec."Job Task No.");
        if lc_JJL.Find('-') then
            lc_JJL.CalcSums(lc_JJL."IMP Time on Job");

        Rec.CalcFields("IMP Schedule (Total hours)");
        if Rec."IMP Schedule (Total hours)" = 0 then
            exit(0);

        if (lc_JJL."IMP Time on Job" = 0) then
            exit(0);

        exit(Round(lc_JJL."IMP Time on Job" / ("IMP Schedule (Total hours)" / 100), 0.01, '='));
    end;

    #endregion Methodes

}