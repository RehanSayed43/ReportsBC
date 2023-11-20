// report 50131 "SalesReportssssssss"
// {
//     UsageCategory = ReportsAndAnalysis;
//     ApplicationArea = All;
//     DefaultLayout = RDLC;
//     RDLCLayout = 'SalesOrderrr71.rdl';
//     Caption = 'Sales1234786';

//     dataset
//     {
//         dataitem("Sales Header"; "Sales Header")
//         {
//             DataItemTableView = sorting("No.");
//             RequestFilterFields = "No.";
//             column(No_; "No.") { }
//             column(Bill_to_Name; "Bill-to Name") { }
//             column(Companyinfopanno; Companyinfo."P.A.N. No.") { }
//             column(Posting_Date; "Posting Date") { }
//             column(Nature_of_Supply; "Nature of Supply") { }
//             column(Ship_to_Name; "Ship-to Name") { }
//             column(Bill_to_Address; "Bill-to Address") { }
//             column(Companyinfoname; Companyinfo.Name) { }
//             column(GSTNO; GSTNO) { }
//             column(City; City) { }
//             column(Companyinfoaddress; Companyinfo.Address) { }
//             column(Companyinfocity; Companyinfo.City) { }
//             column(Companyinfogstno; Companyinfo."GST Registration No.") { }
//             column(Companyinfostatecode; Companyinfo."State Code") { }
//             column(Companyinfobankname; Companyinfo."Bank Name") { }
//             column(Companyinfobankaccno; Companyinfo."Bank Account No.") { }
//             column(Companyinfobankbranchno; Companyinfo."Bank Branch No.") { }
//             column(Companyinfoswiftcode; Companyinfo."SWIFT Code") { }

//             dataitem("Sales Line"; "Sales Line")
//             {
//                 DataItemLinkReference = "Sales Header";
//                 DataItemLink = "Document No." = field("No.");
//                 column(No; "No.") { }
//                 column(Description; Description) { }
//                 column(Quantity; Quantity) { }
//                 column(HSN_SAC_Code; "HSN/SAC Code") { }
//                 column(CGST; CGST) { }
//                 column(SGST; SGST) { }
//                 column(IGST; IGST) { }
//                 column(Unit_of_Measure_Code; "Unit of Measure Code") { }
//                 column(CGSTRate; CGSTRate) { }
//                 column(SGSTRate; SGSTRate) { }
//                 column(IGSTRate; IGSTRate) { }
//                 column(TotalCGST; TotalCGST) { }
//                 column(TotalSGST; TotalSGST) { }
//                 column(TotalIGST; TotalIGST) { }
//                 column(AmntinWrds; AmntinWrds) { }
//                 column(GrandTotal; GrandTotal) { }
//                 column(Unit_Cost; "Unit Cost") { }
//                 column(Line_Amount; "Line Amount") { }
//                 trigger OnAfterGetRecord()
//                 var
//                     myInt: Integer;
//                 begin
//                     customer.Reset();
//                     customer.SetRange("No.", "Sell-to Customer No.");
//                     if customer.Find() then begin
//                         GSTNO := customer."GST Registration No.";
//                         City := customer.City;
//                     end;

//                     SalesLines.Reset();
//                     SalesLines.SetRange("Document No.", "Sales Header"."No.");
//                     SalesLines.SetRange("Document Type", "Sales Header"."Document Type");
//                     SalesLines.SetFilter("GST Group Code", '<>%1', '');
//                     if SalesLines.FindSet() then
//                         repeat
//                             TaxRecordId := "Sales Line".RecordId;

//                             TaxTransactionValue.Reset();
//                             TaxTransactionValue.SetRange("Value Type", TaxTransactionValue."Value Type"::COMPONENT);
//                             TaxTransactionValue.SetRange("Tax Record ID", TaxRecordId);
//                             TaxTransactionValue.SetRange("Visible on Interface", true);
//                             TaxTransactionValue.SetFilter("Tax Type", '=%1', 'GST');
//                             TaxTransactionValue.SetFilter(Percent, '<>%1', 0);
//                             TaxTransactionValue.SetFilter("Value ID", '%1|%2', 6, 3);
//                             if TaxTransactionValue.FindSet() then begin
//                                 CGSTRate := TaxTransactionValue.Percent;
//                                 SGSTRate := TaxTransactionValue.Percent;

//                                 CGST := TaxTransactionValue.Amount;
//                                 SGST := TaxTransactionValue.Amount;
//                                 TotalCGST += CGST;
//                                 TotalSGST += SGST;

//                             end else begin
//                                 TaxTransactionValue.Reset();
//                                 TaxTransactionValue.SetRange("Value Type", TaxTransactionValue."Value Type"::COMPONENT);
//                                 TaxTransactionValue.SetRange("Tax Record ID", TaxRecordId);
//                                 TaxTransactionValue.SetRange("Visible on Interface", true);
//                                 TaxTransactionValue.SetFilter("Tax Type", '=%1', 'GST');
//                                 TaxTransactionValue.SetFilter(Percent, '<>%1', 0);
//                                 TaxTransactionValue.SetFilter("Value ID", '%1', 3);
//                                 if TaxTransactionValue.FindSet() then
//                                     IGSTRate := TaxTransactionValue.Percent;
//                                 IGST := TaxTransactionValue.Amount;
//                                 TotalIGST += IGST;
//                             end;
//                             Total += Total + SalesLines.Amount;
//                             GrandTotal := Total + TotalCGST + TotalSGST + TotalIGST;
//                         until SalesLines.Next() = 0;
//                     PostedVoucher.InitTextVariable();
//                     PostedVoucher.FormatNoText(AmountinWords, Round(GrandTotal), "Sales Header"."Currency Code");
//                     AmntinWrds := AmountinWords[1] + AmountinWords[2];

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
//     trigger OnInitReport()
//     var
//         myInt: Integer;
//     begin
//         Companyinfo.get();
//     end;



//     var
//         myInt: Integer;
//         customer: Record Customer;
//         SalesLines: Record "Sales Line";
//         Companyinfo: Record "Company Information";
//         PostedVoucher: Report "Posted Voucher";
//         GSTNO: Code[20];
//         City: Text[30];
//         CGSTRate: Decimal;
//         SGSTRate: Decimal;
//         IGSTRate: Decimal;
//         CGST: Decimal;
//         SGST: Decimal;
//         IGST: Decimal;
//         TotalCGST: Decimal;
//         TotalSGST: Decimal;
//         TotalIGST: Decimal;
//         TaxTransactionValue: Record "Tax Transaction Value";
//         TaxRecordId: RecordId;
//         Amount: Decimal;
//         WholeAmount: Decimal;
//         FractionalAmount: Decimal;
//         AmountinWords: array[2] of text;
//         AmntinWrds: Text;
//         TaxTotal: Decimal;
//         Total: Decimal;
//         GrandTotal: Decimal;
// }