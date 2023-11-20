// report 50143 "Sales Invoice Report"
// {
//     UsageCategory = ReportsAndAnalysis;
//     ApplicationArea = All;
//     DefaultLayout = RDLC;
//     RDLCLayout = 'SalesInvoiceooooooo.rdl';

//     dataset
//     {
//         dataitem("Sales Header"; "Sales Header")
//         {
//             DataItemTableView = sorting("No.");
//             RequestFilterFields = "No.";

//             column(No_; "No.") { }
//             column(Bill_to_Name; "Bill-to Name") { }
//             column(Bill_to_Address; "Bill-to Address") { }
//             column(Location_State_Code; "Location State Code") { }
//             column(Companyinfoname; Companyinfo.Name) { }
//             column(Companyinfoaddress; Companyinfo.Address) { }
//             column(CompanyinfoGstno; Companyinfo."GST Registration No.") { }
//             column(Companyinfostatcode; Companyinfo."State Code") { }
//             column(Companyinfobankname; Companyinfo."Bank Name") { }
//             column(Companyinfobankaccno; Companyinfo."Bank Account No.") { }
//             column(CompanyinfoIFSC; Companyinfo."Bank Branch No.") { }
//             column(CompanyinfoSWIFT; Companyinfo."SWIFT Code") { }


//             dataitem("Sales Line"; "Sales Line")
//             {
//                 DataItemLinkReference = "Sales Header";
//                 DataItemLink = "Document No." = field("No.");
//                 column(No; "No.") { }
//                 column(Description; Description) { }
//                 column(Quantity; Quantity) { }
//                 column(Unit_of_Measure_Code; "Unit of Measure Code") { }
//                 column(Unit_Cost; "Unit Cost") { }
//                 column(Line_Amount; "Line Amount") { }



//                 trigger OnAfterGetRecord()
//                 var
//                     myInt: Integer;
//                 begin
//                     customer.Reset();
//                     customer.SetRange("No.", "Sell-to Customer No.");
//                     if customer.Find('-') then begin
//                         Gstno := customer."GST Registration No.";
//                     end;



//                     Salesline.Reset();
//                     Salesline.SetRange("Document Type", "Sales Header"."Document Type");
//                     Salesline.SetRange("Document No.", "Sales Header"."No.");
//                     Salesline.SetFilter("GST Group Code", '<>%1', '');
//                     if Salesline.FindSet() then
//                         repeat
//                             TaxRecordId := Salesline.RecordId;


//                             TaxTransactionValue.Reset();
//                             TaxTransactionValue.SetRange("Value Type", TaxTransactionValue."Value Type"::COMPONENT);
//                             TaxTransactionValue.SetRange("Visible on Interface", true);
//                             TaxTransactionValue.SetRange("Tax Record ID", TaxRecordId);
//                             TaxTransactionValue.SetFilter("Tax Type", '=%1', 'GST');
//                             TaxTransactionValue.SetFilter(Percent, '<>%1', 0);
//                             TaxTransactionValue.SetFilter("Value ID", '%1|%2', 6, 2);
//                             if TaxTransactionValue.FindSet() then begin
//                                 CGSTRate := TaxTransactionValue.Percent;
//                                 SGSTRate := TaxTransactionValue.Percent;
//                                 CGST := TaxTransactionValue.Amount;
//                                 SGST := TaxTransactionValue.Amount;
//                             end else begin

//                                 TaxTransactionValue.Reset();
//                                 TaxTransactionValue.SetRange("Value Type", TaxTransactionValue."Value Type"::COMPONENT);
//                                 TaxTransactionValue.SetRange("Visible on Interface", true);

//                             end;
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

//     // rendering
//     // {
//     //     layout(LayoutName)
//     //     {
//     //         Type = RDLC;
//     //         LayoutFile = 'mylayout.rdl';
//     //     }
//     // }

//     var
//         myInt: Integer;
//         Gstno: Code[20];
//         Salesline: Record "Sales Line";
//         customer: Record Customer;
//         Companyinfo: Record "Company Information";
//         TaxTransactionValue: Record "Tax Transaction Value";
//         PostedVoucher: Report "Posted Voucher";
//         TaxRecordId: RecordId;
//         CGST: Decimal;
//         SGST: Decimal;
//         IGST: Decimal;
//         CGSTRate: Decimal;
//         SGSTRate: Decimal;
//         IGSTRate: Decimal;
//         TotalCGST: Decimal;
//         TotalSGST: Decimal;
//         TotalIGST: Decimal;
//         TaxTotal: Decimal;
//         Total: Decimal;
//         GrandTotal: Decimal;
// }