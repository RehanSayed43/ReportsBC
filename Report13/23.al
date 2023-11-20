// report 50121 "PostedPurchase Invoice"
// {
//     UsageCategory = ReportsAndAnalysis;
//     ApplicationArea = All;
//     DefaultLayout = RDLC;
//     Caption = 'pkkkkkk';
//     RDLCLayout = '.Posted11111.rdl';

//     dataset
//     {
//         dataitem("Purch. Inv. Header"; "Purch. Inv. Header")
//         {
//             DataItemTableView = sorting("No.");
//             RequestFilterFields = "No.";
//             column(No; "No.") { }
//             column(Pay_to_Name; "Pay-to Name") { }
//             column(Pay_to_Address; "Pay-to Address") { }
//             column(Location_State_Code; "Location State Code") { }
//             column(Vendor_GST_Reg__No_; "Vendor GST Reg. No.") { }
//             column(Ship_to_Post_Code; "Ship-to Post Code") { }
//             column(Pay_to_Contact; "Pay-to Contact") { }
//             column(Posting_Date; "Posting Date") { }

//             column(companyname; company.Name) { }
//             column(companyaddress; company.Address) { }
//             column(companygstno; company."GST Registration No.") { }
//             column(companyCity; company.City) { }
//             column(companyStatecode; company."State Code") { }
//             column(companyBankname; company."Bank Name") { }
//             column(companybankaccno; company."Bank Account No.") { }
//             column(companyifsccode; company."Bank Branch No.") { }
//             column(companyswiftcode; company."SWIFT Code") { }
//             column(companypanno; company."P.A.N. No.") { }

//             dataitem("Purch. Inv. Line"; "Purch. Inv. Line")
//             {
//                 DataItemLinkReference = "Purch. Inv. Header";
//                 DataItemLink = "Document No." = field("No.");
//                 column(Nos; "No.") { }
//                 column(Description; Description) { }
//                 column(Quantity; Quantity) { }
//                 column(Unit_Cost; "Unit Cost") { }
//                 column(Unit_of_Measure_Code; "Unit of Measure Code") { }
//                 column(Line_Amount; "Line Amount") { }
//                 column(Amountinwrds; Amountinwrds) { }
//                 column(HSN_SAC_Code; "HSN/SAC Code") { }
//                 column(CGST; CGST) { }
//                 column(SGST; SGST) { }
//                 column(IGST; IGST) { }
//                 column(CGSTRate; CGSTRate) { }
//                 column(SGTRate; SGTRate) { }
//                 column(IGSTRate; IGSTRate) { }
//                 column(TotalCGST; TotalCGST) { }
//                 column(TotalSGST; TotalSGST) { }
//                 column(TotalIGST; TotalIGST) { }
//                 column(TaxTotal; TaxTotal) { }
//                 column(AmountToVendor; AmountToVendor) { }

//                 trigger OnAfterGetRecord()
//                 var
//                     myInt: Integer;
//                 begin
//                     ClearData();
//                     RecPurchaseline.Reset();
//                     RecPurchaseline.SetRange("Document No.", "Purch. Inv. Header"."No.");
//                     RecPurchaseline.SetFilter("GST Group Code", '<>%1', '');
//                     if RecPurchaseline.FindSet() then
//                         repeat
//                             TaxRecordId := RecPurchaseline.RecordId;

//                             TaxTransactionValue.Reset();
//                             TaxTransactionValue.SetRange("Tax Record ID", TaxRecordId);
//                             TaxTransactionValue.SetRange("Value Type", TaxTransactionValue."Value Type"::COMPONENT);
//                             TaxTransactionValue.SetFilter("Tax Type", '=%1', 'GST');
//                             TaxTransactionValue.SetFilter(Percent, '<>%1', 0);
//                             TaxTransactionValue.SetRange("Visible on Interface", true);
//                             TaxTransactionValue.SetFilter("Value ID", '%1|%2', 6, 2);
//                             if TaxTransactionValue.FindSet() then begin
//                                 CGSTRate := TaxTransactionValue.Percent;
//                                 SGTRate := TaxTransactionValue.Percent;

//                                 CGST := TaxTransactionValue.Amount;
//                                 SGST := TaxTransactionValue.Amount;

//                                 TotalCGST += CGST;
//                                 TotalSGST += SGST;
//                             end else begin
//                                 TaxTransactionValue.Reset();
//                                 TaxTransactionValue.SetRange("Tax Record ID", TaxRecordId);
//                                 TaxTransactionValue.SetRange("Value Type", TaxTransactionValue."Value Type"::COMPONENT);
//                                 TaxTransactionValue.SetFilter("Tax Type", '=%1', 'GST');
//                                 TaxTransactionValue.SetFilter(Percent, '<>%1', 0);
//                                 TaxTransactionValue.SetRange("Visible on Interface", true);
//                                 TaxTransactionValue.SetFilter("Value ID", '%1', 3);
//                                 if TaxTransactionValue.FindSet() then
//                                     IGSTRate := TaxTransactionValue.Percent;
//                                 IGST := TaxTransactionValue.Amount;
//                                 TotalIGST += IGST;
//                             end;

//                             Total += RecPurchaseline.Amount;
//                         until RecPurchaseline.Next() = 0;
//                     AmountToVendor := Total + CGST + SGST + IGST;


//                     PostedVoucher.InitTextVariable();
//                     "Purch. Inv. Header".CalcFields(Amount);
//                     PostedVoucher.FormatNoText(AmountinWords, Round(AmountToVendor), "Purch. Inv. Header"."Currency Code");
//                     Amountinwrds := AmountinWords[1] + AmountinWords[2];

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
//         company.get();
//     end;

//     var
//         myInt: Integer;
//         company: Record "Company Information";
//         Vendor: Record Vendor;
//         TaxTransactionValue: Record "Tax Transaction Value";
//         TaxRecordId: RecordId;
//         RecPurchaseline: Record "Purch. Inv. Line";
//         PostedVoucher: Report "Posted Voucher";
//         Currency: Code[20];
//         AmountToVendor: Decimal;
//         AmountinWords: array[2] of Text;
//         Amountinwrds: Text;
//         Amount: Decimal;
//         WholeAmount: Decimal;
//         FractionalAmount: Decimal;
//         CGST: Decimal;
//         SGST: Decimal;
//         IGST: Decimal;
//         CGSTRate: Decimal;
//         SGTRate: Decimal;
//         IGSTRate: Decimal;
//         Total: Decimal;
//         TaxTotal: Decimal;
//         TotalCGST: Decimal;
//         TotalIGST: Decimal;
//         TotalSGST: Decimal;


//     local procedure ClearData()
//     var
//         myInt: Integer;
//     begin
//         CGST := 0;
//         SGST := 0;
//         IGST := 0;

//         CGSTRate := 0;
//         SGTRate := 0;
//         IGSTRate := 0;

//         TotalCGST := 0;
//         TotalSGST := 0;
//         TotalIGST := 0;
//         Clear(AmountinWords);
//         AmountToVendor := 0;
//     end;


// }