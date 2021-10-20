page 50101 "IMP All Objects"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = AllObjWithCaption;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("App Runtime Package ID"; Rec."App Runtime Package ID")
                {
                    ApplicationArea = All;
                }
                field("App Package ID"; Rec."App Package ID")
                {
                    ApplicationArea = All;
                }
                field("Object Type"; Rec."Object Type")
                {
                    ApplicationArea = All;
                }
                field("Object ID"; Rec."Object ID")
                {
                    ApplicationArea = All;
                }
                field("Object Name"; Rec."Object Name")
                {
                    ApplicationArea = All;
                }
                field("Object Caption"; Rec."Object Caption")
                {
                    ApplicationArea = All;
                }
                field("Object Subtype"; Rec."Object Subtype")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}