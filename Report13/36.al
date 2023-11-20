// report 50109 "ExcelPurchases"
// {
//     UsageCategory = ReportsAndAnalysis;
//     ApplicationArea = All;
//     DefaultLayout = Excel;
//     Caption = 'rehannnn22';
//     ExcelLayout = 'rehan.xlsx';

//     dataset
//     {
//         dataitem("Purchase Header"; "Purchase Header")
//         {
//             DataItemTableView = sorting("No.");
//             RequestFilterFields = "No.";
//             column(PO; "No.") { }
//             column(PostingDate; "Posting Date") { }
//             dataitem("Purchase Line"; "Purchase Line")
//             {
//                 DataItemLinkReference = "Purchase Header";
//                 DataItemLink = "Document No." = field("No.");
//                 column(No_; "No.") { }
//                 column(Description; Description) { }
//                 column(Quantity; Quantity) { }
//                 column(Quantity_Received; "Quantity Received") { }
//                 column(Quantity_Invoiced; "Quantity Invoiced") { }
//                 column(Rate; "Unit Cost") { }
//                 column(Line_Amount; "Line Amount") { }
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