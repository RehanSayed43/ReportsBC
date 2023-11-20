// report 50112 Posted_Sales_Invoices
// {
//     UsageCategory = ReportsAndAnalysis;
//     ApplicationArea = All;
//     DefaultLayout = RDLC;
//     RDLCLayout = 'Posted1901.rdl';
//     Caption = 'POSTED';

//     //Not proper code do not run or give to some one.

//     dataset
//     {
//         dataitem("Sales Invoice Header"; "Sales Invoice Header")
//         {
//             DataItemTableView = sorting("No.");
//             RequestFilterFields = "No.";
//             column(No_; "No.") { }
//             column(Bill_to_Name; "Bill-to Name") { }
//             column(Bill_to_Address; "Bill-to Address") { }
//             column(Location_State_Code; "Location State Code") { }
//             column(gstno; gstno) { }
//             column(Cityss; Cityss) { }
//             column(Posting_Date; "Posting Date") { }
//             column(Nature_of_Supply; "Nature of Supply") { }
//             column(Companyinformationname; Companyinformation.Name) { }
//             column(Companyinformationaddress; Companyinformation.Address) { }
//             column(Companyinformationgstno; Companyinformation."GST Registration No.") { }
//             column(Companyinformationstatecode; Companyinformation."State Code") { }
//             column(CompanyinformationCity; Companyinformation.City) { }
//             column(Companyinformationbankname; Companyinformation."Bank Name") { }
//             column(Companyinformationaccno; Companyinformation."Bank Account No.") { }
//             column(CompanyinformationIFSCcode; Companyinformation."Bank Branch No.") { }
//             column(CompanyinformationSWIFTCode; Companyinformation."SWIFT Code") { }

//             dataitem("Sales Invoice Line"; "Sales Invoice Line")
//             {
//                 DataItemLinkReference = "Sales Invoice Header";
//                 DataItemLink = "Document No." = field("No.");
//                 column(No; "No.") { }
//                 column(Description; Description) { }
//                 column(Quantity; Quantity) { }
//                 column(HSN_SAC_Code; "HSN/SAC Code") { }
//                 column(Unit_Cost; "Unit Cost") { }
//                 column(Line_Amount; "Line Amount") { }
//                 column(CGST; CGST) { }
//                 column(SGST; SGST) { }
//                 column(IGST; IGST) { }
//                 column(CGSTRate; CGSTRate) { }
//                 column(SGSTRate; SGSTRate) { }
//                 column(IGSTRate; IGSTRate) { }
//                 column(Total; Total) { }
//                 column(GrandTotal; GrandTotal) { }
//                 column(AmntinWrds; AmntinWrds) { }

//                 trigger OnAfterGetRecord()
//                 var
//                     myInt: Integer;
//                 begin
//                     customer.Reset();
//                     customer.SetRange("No.", "Sell-to Customer No.");
//                     if customer.Find('-') then begin
//                         gstno := customer."GST Registration No.";
//                         Cityss := customer.City;
//                     end;
//                     Saleslines.Reset();
//                     Saleslines.SetRange("Document No.", "Sales Invoice Header"."No.");
//                     Saleslines.SetFilter("GST Group Code", '<>%1', '');
//                     if Saleslines.FindSet() then
//                         repeat
//                             TaxRecordId := "Sales Invoice Header".RecordId;
//                             Taxtransactionvalue.Reset();
//                             Taxtransactionvalue.SetRange("Tax Record ID", TaxRecordid);
//                             Taxtransactionvalue.SetRange("Value Type", Taxtransactionvalue."Value Type"::COMPONENT);
//                             Taxtransactionvalue.SetRange("Visible on Interface", true);
//                             Taxtransactionvalue.SetFilter("Tax Type", '=%1', 'GST');
//                             Taxtransactionvalue.SetFilter(Percent, '<>%1', 0);
//                             Taxtransactionvalue.SetFilter("Value ID", '%1|%2', 6, 3);
//                             IF Taxtransactionvalue.FindSet() then begin
//                                 CGSTRate := Taxtransactionvalue.Percent;
//                                 SGSTRate := Taxtransactionvalue.Percent;
//                                 CGST := Taxtransactionvalue.Amount;
//                                 SGST := Taxtransactionvalue.Amount;

//                                 TotalCGST += CGST;
//                                 TotalSGST += SGST;
//                             end else begin
//                                 Taxtransactionvalue.Reset();
//                                 Taxtransactionvalue.SetRange("Tax Record ID", TaxRecordid);
//                                 Taxtransactionvalue.SetRange("Value Type", Taxtransactionvalue."Value Type"::COMPONENT);
//                                 Taxtransactionvalue.SetRange("Visible on Interface", true);
//                                 Taxtransactionvalue.SetFilter("Tax Type", '=%1', 'GST');
//                                 Taxtransactionvalue.SetFilter(Percent, '<>%1', 0);
//                                 Taxtransactionvalue.SetFilter("Value ID", '%1', 3);
//                                 if Taxtransactionvalue.FindSet() then
//                                     IGSTRate := Taxtransactionvalue.Percent;
//                                 IGST := Taxtransactionvalue.Amount;
//                                 TotalIGST += IGST;

//                             end;
//                             Total += Saleslines.Amount;
//                             // Total+=ToatlCGST+ToatalSGST+TotalIGST;
//                             GrandTotal := Total + TotalCGST + TotalSGST + TotalIGST;
//                         until Saleslines.Next() = 0;
//                     PostedVoucher.InitTextVariable();
//                     PostedVoucher.FormatNoText(Amountinwords, Round(GrandTotal), "Sales Invoice Header"."Currency Code");
//                     AmntinWrds := Amountinwords[1] + Amountinwords[2];



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
//         Companyinformation.get();
//     end;



//     var
//         myInt: Integer;
//         customer: Record Customer;
//         gstno: Code[20];
//         Cityss: Text;
//         TaxtransactionValue: Record "Tax Transaction Value";
//         PostedVoucher: Report "Posted Voucher";
//         Companyinformation: Record "Company Information";
//         Saleslines: Record "Sales Invoice Line";
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
//         AmountinWords: array[2] of Text;
//         AmntinWrds: Text;
// }