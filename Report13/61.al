// report 50131 "Comercial Invoice"
// {
//     UsageCategory = ReportsAndAnalysis;
//     ApplicationArea = All;
//     Caption = 'ccit';
//     DefaultLayout = RDLC;
//     RDLCLayout = 'comercial.rdl';

//     dataset
//     {
//         dataitem("Sales Header"; "Sales Header")
//         {
//             DataItemTableView = sorting("No.");
//             RequestFilterFields = "No.";
//             column(No_; "No.") { }
//             column(Bill_to_Name; "Bill-to Name") { }
//             column(Bill_to_Address; "Bill-to Address") { }
//             column(Gstno; Gstno) { }
//             column(phoneno; phoneno) { }
//             column(Mobilephno; Mobilephno) { }
//             column(Email; Email) { }
//             column(Posting_Date; "Posting Date") { }
//             column(Bill_to_Country_Region_Code; "Bill-to Country/Region Code") { }
//             column(countryname; country.Name) { }


//             column(companyinfoname; companyinfo.Name) { }
//             column(companyinfoaddress; companyinfo.Address) { }
//             column(companyinfoffsai; companyinfo."VAT Registration No.") { }
//             column(companyinfophoneno; companyinfo."Phone No.") { }
//             column(companyinfoemail; companyinfo."E-Mail") { }
//             column(companyinfopanno; companyinfo."P.A.N. No.") { }
//             column(companyinfoCinno; companyinfo.IBAN) { }
//             column(companyinfoiecno; companyinfo."Giro No.") { }
//             column(companyinfogstno; companyinfo."GST Registration No.") { }
//             column(companyinfocity; companyinfo.City) { }
//             column(companyinfostatecode; companyinfo."State Code") { }
//             column(companyinfobankname; companyinfo."Bank Name") { }
//             column(companyinfoaccno; companyinfo."Bank Account No.") { }
//             column(companyinfoifsccode; companyinfo."Bank Branch No.") { }
//             column(companyinfoSwiftcode; companyinfo."SWIFT Code") { }

//             dataitem("Sales Line"; "Sales Line")
//             {
//                 DataItemLinkReference = "Sales Header";
//                 DataItemLink = "Document No." = field("No.");
//                 column(No; "No.") { }
//                 column(Description; Description) { }
//                 column(HSN_SAC_Code; "HSN/SAC Code") { }
//                 column(Quantity; Quantity) { }
//                 column(Unit_Cost; "Unit Cost") { }
//                 column(Line_Amount; "Line Amount") { }
//                 column(CGST; CGST) { }
//                 column(SGST; SGST) { }
//                 column(IGST; IGST) { }
//                 column(CGSTRATE; CGSTRATE) { }
//                 column(SGSTRATE; SGSTRATE) { }
//                 column(IGSTRATE; IGSTRATE) { }
//                 column(TotalCGST; TotalCGST) { }
//                 column(TotalSGST; TotalSGST) { }
//                 column(TotalIGST; TotalIGST) { }
//                 column(Taxtotal; Taxtotal) { }
//                 column(Total; Total) { }
//                 column(Amntinwrds; Amntinwrds) { }
//                 column(GrnadTotal; GrnadTotal) { }


//                 trigger OnAfterGetRecord()
//                 var
//                     myInt: Integer;
//                 begin
//                     customer.Reset();
//                     customer.SetRange("No.", "Sell-to Customer No.");
//                     if customer.Find('-') then begin
//                         Gstno := customer."GST Registration No.";
//                         Email := customer."E-Mail";
//                         Mobilephno := customer."Mobile Phone No.";
//                     end;

//                     salesline.Reset();
//                     salesline.SetRange("Document No.", "Sales Header"."No.");
//                     salesline.SetRange("Document Type", "Sales Header"."Document Type");
//                     salesline.SetFilter("GST Group Code", '<>%1', '');
//                     if salesline.FindSet() then
//                         repeat
//                             TaxRecordid := salesline.RecordId;


//                             TaxtransactionValue.Reset();
//                             TaxtransactionValue.SetRange("Tax Record ID", TaxRecordid);
//                             TaxtransactionValue.SetRange("Value Type", TaxtransactionValue."Value Type"::COMPONENT);
//                             TaxtransactionValue.SetFilter("Tax Type", '=%1', 'GST');
//                             TaxtransactionValue.SetFilter(Percent, '<>%1', 0);
//                             TaxtransactionValue.SetRange("Visible on Interface", true);
//                             TaxtransactionValue.SetFilter("Value ID", '%1|%2', 6, 2);
//                             IF TaxtransactionValue.FindSet() then begin
//                                 CGSTRATE := TaxtransactionValue.Percent;
//                                 SGSTRATE := TaxtransactionValue.Percent;
//                                 CGST := TaxtransactionValue.Amount;
//                                 SGST := TaxtransactionValue.Amount;
//                                 TotalCGST += CGST;
//                                 TotalSGST += SGST;
//                             end else begin
//                                 TaxtransactionValue.Reset();
//                                 TaxtransactionValue.SetRange("Tax Record ID", TaxRecordid);
//                                 TaxtransactionValue.SetRange("Value Type", TaxtransactionValue."Value Type"::COMPONENT);
//                                 TaxtransactionValue.SetRange("Visible on Interface", true);
//                                 TaxtransactionValue.SetFilter(Percent, '<>%1', 0);
//                                 TaxtransactionValue.SetFilter("Tax Type", '=%1', 'GST');
//                                 TaxtransactionValue.SetFilter("Value ID", '%1', 3);
//                                 if TaxtransactionValue.FindSet() then
//                                     IGSTRATE := TaxtransactionValue.Percent;
//                                 IGST := TaxtransactionValue.Amount;
//                             end;

//                             Total := Total + salesline.Amount;
//                             GrnadTotal := Total + TotalCGST + TotalSGST + TotalIGST;
//                         until salesline.Next() = 0;
//                     PostedVoucher.InitTextVariable();
//                     PostedVoucher.FormatNoText(AmountinWords, Round(GrnadTotal), "Sales Header"."Currency Code");
//                     Amntinwrds := AmountinWords[1] + AmountinWords[2];







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
//                     RunObject = report "Comercial Invoice";

//                 }
//             }
//         }
//     }

//     trigger OnInitReport()
//     var
//         myInt: Integer;
//     begin
//         companyinfo.get();
//     end;


//     var
//         myInt: Integer;
//         customer: Record Customer;
//         Mobilephno: text[30];
//         Email: Text[80];
//         PostedVoucher: Report "Posted Voucher";
//         Gstno: Code[20];
//         country: Record "Country/Region";
//         Cname: Text;
//         phoneno: Text[30];
//         companyinfo: Record "Company Information";
//         TaxtransactionValue: Record "Tax Transaction Value";
//         TaxRecordid: RecordId;
//         CGST: Decimal;
//         SGST: Decimal;
//         IGST: Decimal;
//         CGSTRATE: Decimal;
//         SGSTRATE: Decimal;
//         IGSTRATE: Decimal;
//         TotalCGST: Decimal;
//         TotalSGST: Decimal;
//         TotalIGST: Decimal;
//         AmountinWords: array[2] of Text;
//         Amntinwrds: Text;
//         Taxtotal: Decimal;
//         Total: Decimal;
//         GrnadTotal: Decimal;
//         salesline: Record "Sales Line";

// }