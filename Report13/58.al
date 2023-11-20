// report 50124 "Salessssreport"
// {
//     UsageCategory = ReportsAndAnalysis;
//     ApplicationArea = All;
//     DefaultLayout = RDLC;
//     RDLCLayout = 'sls.rdl';

//     dataset
//     {
//         dataitem("Sales Header"; "Sales Header")
//         {
//             DataItemTableView = sorting("No.");
//             RequestFilterFields = "No.";
//             column(No_; "No.") { }
//             column(Bill_to_Name; "Bill-to Name") { }
//             column(Bill_to_Address; "Bill-to Address") { }
//             column(Companyinfoname; Companyinfo.Name) { }
//             column(Companyinfoaddress; Companyinfo.Address) { }
//             column(Companyinfogstno; Companyinfo."GST Registration No.") { }
//             column(Companyinfobankname; Companyinfo."Bank Name") { }
//             column(Companyinfoaccno; Companyinfo."Bank Account No.") { }
//             column(Companyinfoifsccode; Companyinfo."Bank Branch No.") { }
//             column(CompanyinfoSwiftCode; Companyinfo."SWIFT Code") { }
//             column(Companyinfopanno; Companyinfo."P.A.N. No.") { }



//             dataitem("Sales Line"; "Sales Line")
//             {
//                 DataItemLinkReference = "Sales Header";
//                 DataItemLink = "Document No." = field("No.");
//                 column(No; "No.") { }
//                 column(Description; Description) { }
//                 column(Quantity; Quantity) { }
//                 column(Unit_Cost; "Unit Cost") { }
//                 column(Line_Amount; "Line Amount") { }
//                 column(TaxTotal; TaxTotal) { }
//                 column(GrandTotal; GrandTotal) { }
//                 column(AmouninVendor; AmouninVendor) { }
//                 column(TotalCGST; TotalCGST) { }
//                 column(TotalSGST; TotalSGST) { }
//                 column(TotalIGST; TotalIGST) { }
//                 column(AmntinWrds; AmntinWrds) { }


//                 trigger OnAfterGetRecord()
//                 var
//                     myInt: Integer;
//                 begin
//                     Customer.Reset();
//                     Customer.SetRange("No.", "Sell-to Customer No.");
//                     if Customer.Find('-') then begin
//                         Gstno := Customer."GST Registration No.";
//                     end;

//                     Saleslines.Reset();
//                     Saleslines.SetRange("Document Type", "Sales Header"."Document Type");
//                     Saleslines.SetRange("Document No.", "Sales Header"."No.");
//                     Saleslines.SetFilter("GST Group Code", '<>%1', '');
//                     if Saleslines.FindSet() then
//                         repeat
//                             TaxRecordid := "Sales Header".RecordId;

//                             TaxTransactionValue.Reset();
//                             TaxTransactionValue.SetRange("Value Type", TaxTransactionValue."Value Type"::COMPONENT);
//                             TaxTransactionValue.SetRange("Visible on Interface", true);
//                             TaxTransactionValue.SetRange("Tax Record ID", TaxRecordid);
//                             TaxTransactionValue.SetFilter("Value ID", '%1|%2', 6, 2);
//                             TaxTransactionValue.SetFilter("Tax Type", '<>%1', 'GST');
//                             TaxTransactionValue.SetFilter(Percent, '=%1', 0);
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
//                                 TaxTransactionValue.SetRange("Visible on Interface", true);
//                                 TaxTransactionValue.SetRange("Tax Record ID", TaxRecordid);
//                                 TaxTransactionValue.SetFilter("Value ID", '%1|%2', 6, 2);
//                                 TaxTransactionValue.SetFilter("Tax Type", '<>%1', 'GST');
//                                 TaxTransactionValue.SetFilter(Percent, '=%1', 0);
//                                 if TaxTransactionValue.FindSet() then
//                                     IGSTRate := TaxTransactionValue.Percent;
//                                 IGST := TaxTransactionValue.Amount;
//                                 TotalIGST += IGST;
//                             end;
//                             Total := Total + Saleslines.Amount;
//                         until Saleslines.Next() = 0;


//                     GrandTotal := Total + TotalCGST + TotalSGST + TotalIGST;
//                     PostedVoucher.InitTextVariable();
//                     PostedVoucher.FormatNoText(AmountinWords, Round(AmouninVendor), "Sales Header"."Currency Code");
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



//     var
//         myInt: Integer;
//         Total: Decimal;
//         Customer: Record Customer;
//         Gstno: Code[20];
//         Saleslines: Record "Sales Line";
//         Companyinfo: Record "Company Information";
//         TaxTransactionValue: Record "Tax Transaction Value";
//         TaxRecordid: RecordId;

//         PostedVoucher: Report "Posted Voucher";



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
//         GrandTotal: Decimal;
//         AmouninVendor: Decimal;
//         AmountinWords: array[2] of Text;
//         AmntinWrds: Text;

// }