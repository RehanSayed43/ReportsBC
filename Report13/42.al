// report 50141 "Purchase Order Reportt"
// {
//     UsageCategory = ReportsAndAnalysis;
//     ApplicationArea = All;
//     DefaultLayout = RDLC;
//     Caption = 'Purchase12345s.rdl';
//     RDLCLayout = 'rehan675ts.rdl';

//     dataset
//     {
//         dataitem("Purchase Header"; "Purchase Header")
//         {
//             DataItemTableView = sorting("No.");
//             RequestFilterFields = "No.";
//             column(No_; "No.") { }
//             column(Pay_to_Name; "Pay-to Name") { }
//             column(Gstno; Gstno) { }
//             column(Citys; Citys) { }
//             column(Posting_Date; "Posting Date") { }

//             column(Pay_to_Address; "Pay-to Address") { }
//             column(Location_State_Code; "Location State Code") { }
//             column(Companyinfoname; Companyinfo.Name) { }
//             column(Companyinfoaddress; Companyinfo.Address) { }
//             column(Companyinfogstno; Companyinfo."GST Registration No.") { }
//             column(CompanyinfoCity; Companyinfo.City) { }
//             column(Companyinfostatecode; Companyinfo."Location Code") { }
//             column(Companyinfobankname; Companyinfo."Bank Name") { }
//             column(Companyinfobankaccno; Companyinfo."Bank Account No.") { }
//             column(Companyinfobankifsccode; Companyinfo."Bank Branch No.") { }
//             column(Companyinfoswiftcode; Companyinfo."SWIFT Code") { }
//             dataitem("Purchase Line"; "Purchase Line")
//             {
//                 DataItemLinkReference = "Purchase Header";
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
//                 column(TotalCGST; TotalCGST) { }
//                 column(ToatlSGST; ToatlSGST) { }
//                 column(TotalIGST; TotalIGST) { }
//                 column(TaxTotal; TaxTotal) { }
//                 column(Total; Total) { }
//                 column(AmountinVendors; AmountinVendors) { }
//                 trigger OnAfterGetRecord()
//                 var
//                     myInt: Integer;
//                 begin
//                     vendor.Reset();
//                     vendor.SetRange("No.", "Buy-from Vendor No.");
//                     if vendor.Find('-') then begin
//                         Gstno := vendor."GST Registration No.";
//                         Citys := vendor.City;
//                     end;

//                     Purchasleine.Reset();
//                     Purchasleine.SetRange("Document No.", "Purchase Header"."No.");
//                     Purchasleine.SetRange("Document Type", "Purchase Header"."Document Type");
//                     if Purchasleine.FindSet() then
//                         repeat
//                             TaxRecordID := Purchasleine.RecordId;

//                             TaxTransactionValue.Reset();
//                             TaxTransactionValue.SetRange("Value Type", TaxTransactionValue."Value Type");
//                             TaxTransactionValue.SetRange("Visible on Interface", true);
//                             TaxTransactionValue.SetRange("Tax Record ID", TaxRecordID);
//                             TaxTransactionValue.SetFilter("Value ID", '%1|%2', 6, 3);
//                             TaxTransactionValue.SetFilter("Tax Type", '=%1', 'GST');
//                             TaxTransactionValue.SetFilter(Percent, '<>%1', 0);
//                             // TaxTransactionValue.SetFilter("Value ID",'%1|%2',);
//                             if TaxTransactionValue.FindSet() then begin
//                                 CGSTRate := TaxTransactionValue.Percent;
//                                 SGSTRate := TaxTransactionValue.Percent;
//                                 CGST := TaxTransactionValue.Amount;
//                                 SGST := TaxTransactionValue.Amount;
//                                 TotalCGST += CGST;
//                                 ToatlSGST += SGST;
//                             end else begin
//                                 TaxTransactionValue.Reset();
//                                 TaxTransactionValue.SetRange("Value Type", TaxTransactionValue."Value Type");
//                                 TaxTransactionValue.SetRange("Visible on Interface", true);
//                                 TaxTransactionValue.SetFilter("Value ID", '%1', 3);
//                                 TaxTransactionValue.SetRange("Visible on Interface", true);
//                                 TaxTransactionValue.SetFilter("Tax Type", '=%1', 'GST');
//                                 TaxTransactionValue.SetFilter(Percent, '<>%1', 0);
//                                 TaxTransactionValue.SetRange("Tax Record ID", TaxRecordID);
//                                 if TaxTransactionValue.FindSet() then
//                                     IGSTRate := TaxTransactionValue.Percent;
//                                 IGST := TaxTransactionValue.Amount;
//                                 TotalIGST += IGST;

//                             end;
//                             Total := Total + Purchasleine.Amount;
//                         until Purchasleine.Next() = 0;
//                     AmountinVendors := Total + CGST + SGST + IGST;


//                     PostedVoucher.InitTextVariable();
//                     PostedVoucher.FormatNoText(AmntinWords, Round(AmountinVendors), "Purchase Header"."Currency Code");
//                     AmntinWrds := AmntinWords[1] + AmntinWords[2];

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
//         vendor: Record Vendor;
//         Purchasleine: Record "Purchase Line";
//         Gstno: Code[20];
//         Citys: Text[30];
//         Companyinfo: Record "Company Information";
//         TaxTransactionValue: Record "Tax Transaction Value";
//         TaxRecordID: RecordId;
//         PostedVoucher: Report "Posted Voucher";
//         CGSTRate: Decimal;
//         SGSTRate: Decimal;
//         IGSTRate: Decimal;
//         TotalCGST: Decimal;
//         ToatlSGST: Decimal;
//         TotalIGST: Decimal;
//         CGST: Decimal;
//         SGST: Decimal;
//         IGST: Decimal;
//         AmountinVendors: Decimal;
//         AmntinWords: array[2] of Text;
//         AmntinWrds: Text;
//         TaxTotal: Decimal;
//         Total: Decimal;
// }