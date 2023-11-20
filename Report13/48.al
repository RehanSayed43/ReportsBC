// report 50144 "Posted SalesInvoice"
// {
//     UsageCategory = ReportsAndAnalysis;
//     ApplicationArea = All;
//     DefaultLayout = RDLC;
//     RDLCLayout = 'PostedSlesInvoice.rdl';

//     dataset
//     {
//         dataitem("Sales Invoice Header"; "Sales Invoice Header")
//         {
//             DataItemTableView = sorting("No.");
//             RequestFilterFields = "No.";
//             column(No; "No.") { }
//             column(Bill_to_Name; "Bill-to Name") { }
//             column(Bill_to_Address; "Bill-to Address") { }
//             column(Location_State_Code; "Location State Code") { }
//             column(Companyinfoname; Companyinfo.Name) { }
//             column(CompanyinfoAddress; Companyinfo.Address) { }
//             column(Companyinfogstno; Companyinfo."GST Registration No.") { }
//             column(CompanyinfoStateCode; Companyinfo."State Code") { }
//             column(Companyinfobankname; Companyinfo."Bank Name") { }
//             column(Companyinfobankaccno; Companyinfo."Bank Account No.") { }
//             column(Companyinfobankifsccode; Companyinfo."Bank Branch No.") { }
//             column(CompanyinfoSwiftCode; Companyinfo."SWIFT Code") { }
//             dataitem("Sales Invoice Line"; "Sales Invoice Line")
//             {
//                 DataItemLinkReference = "Sales Invoice Header";
//                 DataItemLink = "Document No." = field("No.");
//                 column(No_; "No.") { }
//                 column(Description; Description) { }
//                 column(Quantity; Quantity) { }
//                 column(Unit_Cost; "Unit Cost") { }
//                 column(Line_Amount; "Line Amount") { }
//                 column(HSN_SAC_Code; "HSN/SAC Code") { }
//                 column(CGST; CGST) { }
//                 column(SGST; SGST) { }
//                 column(IGST; IGST) { }
//                 column(CGSTRate; CGSTRate) { }
//                 column(SGSTRate; SGSTRate) { }
//                 column(IGSTRate; IGSTRate) { }
//                 column(TotalCGST; TotalCGST) { }
//                 column(TotalSGST; TotalSGST) { }
//                 column(TotalIGST; TotalIGST) { }

//                 trigger OnAfterGetRecord()
//                 var
//                     myInt: Integer;
//                 begin
//                     customer.Find();
//                     customer.SetRange("No.","Sell-to Customer No.");
//                     if customer.Find('-')then 
//                     begin
//                       Gstno:=customer."GST Registration No.";
//                       City:=customer.City;
//                     end;

//                     Salesline.Reset();
//                     Salesline.SetRange("Document No.","Sales Invoice Header"."No.");
//                     if Salesline.FindSet() then
//                     repeat
//                     TaxRecordId:=Salesline.RecordId;






//                 end;
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
//         TaxRecordId:RecordId;
//         customer: Record Customer;
//         Salesline:Record "Sales Invoice Line";
//         Companyinfo: Record "Company Information";
//         TaxtransactionValue:Record "Tax Transaction Value";
//         Gstno:Code[20];
//         City:Text;
//         CGST: Decimal;
//         SGST: Decimal;
//         IGST: Decimal;
//         CGSTRate: Decimal;
//         SGSTRate: Decimal;
//         IGSTRate: Decimal;
//         TotalCGST: Decimal;
//         TotalSGST: Decimal;
//         TotalIGST: Decimal;
//         Amount: Decimal;
//         WholeAmount: Decimal;
// }