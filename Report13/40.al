// report 50119 "Posted Sales invoice"
// {
//     UsageCategory = ReportsAndAnalysis;
//     ApplicationArea = All;
//     DefaultLayout=RDLC;
//     RDLCLayout='postedsalesee.rdl';

//     dataset
//     {
//         dataitem(DataItemName; SourceTableName)
//         {
//             column(ColumnName; SourceFieldName)
//             {

//             }
//         }
//     }

//     requestpage
//     {
//         layout
//         {
//             area(Content)
//             {
//                 group(GroupName)
//                 {

//                 }
//             }
//         }

//         actions
//         {
//             area(processing)
//             {
//                 action(ActionName)
//                 {
//                     ApplicationArea = All;

//                 }
//             }
//         }
//     }



//     var
//         myInt: Integer;
// }