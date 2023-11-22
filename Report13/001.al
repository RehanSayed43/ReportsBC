page 50129 MyPagesrt
{
    PageType = Card;
yash
    ApplicationArea = All;
    UsageCategory = Administration;
    // SourceTable = TableName;

    layout
    {
        area(Content)
        {
            group(GroupName)
            {
                field(name; name)
                {
                    ApplicationArea = All;

                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction()
                begin

                end;
            }
        }
    }

    var
        myInt: Integer;
        name: Text[30];
}
