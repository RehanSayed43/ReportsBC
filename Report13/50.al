// report 50119 "Posted Purchase"
// {
//     UsageCategory = ReportsAndAnalysis;
//     ApplicationArea = All;
//     DefaultLayout = RDLC;
//     Caption = 'Posted50';
//     RDLCLayout = 'Posted50.rdl';

//     dataset
//     {
//         dataitem("Purch. Inv. Header"; "Purch. Inv. Header")
//         {
//             DataItemTableView = sorting("No.");
//             RequestFilterFields = "No.";
//             column(No_; "No.") { }
//             column(Pay_to_Name; "Pay-to Name") { }
//             column(Pay_to_Address; "Pay-to Address") { }
//             column(Pay_to_Contact; "Pay-to Contact") { }
//             column(Posting_Date; "Posting Date") { }
//             column(Vendor_Order_No_; "Vendor Order No.") { }
//             column(Gstno; Gstno) { }
//             column(Cityss; Cityss) { }
//             column(CompanyinformationPANNO; Companyinformation."P.A.N. No.") { }

//             column(Location_State_Code; "Location State Code") { }
//             column(Companyinformationname; Companyinformation.Name) { }
//             column(Companyinformationaddress; Companyinformation.Address) { }
//             column(Companyinformationgstno; Companyinformation."GST Registration No.") { }
//             column(Companyinformationstatecode; Companyinformation."State Code") { }
//             column(Companyinformationcity; Companyinformation.City) { }
//             column(Companyinformationbankname; Companyinformation."Bank Name") { }
//             column(Companyinformationbankaccno; Companyinformation."Bank Account No.") { }
//             column(Companyinformationbankbranchno; Companyinformation."Bank Branch No.") { }
//             column(Companyinformationswiftcode; Companyinformation."SWIFT Code") { }

//             dataitem("Purch. Inv. Line"; "Purch. Inv. Line")
//             {
//                 DataItemLinkReference = "Purch. Inv. Header";
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
//                 column(TotalSGST; TotalSGST) { }
//                 column(TotalIGST; TotalIGST) { }
//                 column(TaxTotal; TaxTotal) { }
//                 column(Total; Total) { }
//                 column(AmntinWrds; AmntinWrds) { }
//                 column(GrandTotal; GrandTotal) { }


//                 trigger OnAfterGetRecord()
//                 var
//                     myInt: Integer;
//                 begin
//                     Vendor.Reset();
//                     Vendor.SetRange("No.", "Buy-from Vendor No.");
//                     if Vendor.Find('-') then begin
//                         Gstno := Vendor."GST Registration No.";
//                         Cityss := Vendor.City;

//                     end;

//                     RecPurchase.Reset();
//                     RecPurchase.SetRange("Document No.", "Purch. Inv. Header"."No.");
//                     RecPurchase.SetRange("GST Group Code", '<>%1', '');
//                     if RecPurchase.FindSet() then
//                         repeat
//                             TaxRecordId := RecPurchase.RecordId;



//                             TaxtransactionValue.Reset();
//                             TaxtransactionValue.SetRange("Tax Record ID", TaxRecordId);
//                             TaxtransactionValue.SetRange("Visible on Interface", true);
//                             TaxtransactionValue.SetRange("Value Type", TaxtransactionValue."Value Type"::COMPONENT);
//                             TaxtransactionValue.SetFilter("Tax Type", '=%1', 'GST');
//                             TaxtransactionValue.SetFilter(Percent, '<>%1', 0);
//                             TaxtransactionValue.SetFilter("Value ID", '%1|%2', 6, 2);
//                             if TaxtransactionValue.FindSet() then begin
//                                 CGSTRate := TaxtransactionValue.Percent;
//                                 SGSTRate := TaxtransactionValue.Percent;
//                                 CGST := TaxtransactionValue.Amount;
//                                 SGST := TaxtransactionValue.Amount;
//                                 TotalCGST += CGST;
//                                 TotalSGST += SGST;

//                             end else begin

//                                 TaxtransactionValue.Reset();
//                                 TaxtransactionValue.SetRange("Tax Record ID", TaxRecordId);
//                                 TaxtransactionValue.SetRange("Visible on Interface", true);
//                                 TaxtransactionValue.SetRange("Value Type", TaxtransactionValue."Value Type"::COMPONENT);
//                                 TaxtransactionValue.SetFilter("Tax Type", '=%1', 'GST');
//                                 TaxtransactionValue.SetFilter(Percent, '<>%1', 0);
//                                 TaxtransactionValue.SetFilter("Value ID", '%1', 3);
//                                 if TaxtransactionValue.FindSet() then
//                                     IGSTRate := TaxtransactionValue.Percent;
//                                 IGST := TaxtransactionValue.Amount;
//                                 TotalIGST += IGST;

//                             end;
//                             Total := Total + RecPurchase.Amount;
//                         until RecPurchase.Next() = 0;
//                     Grandtotal := Total + CGST + SGST + IGST;

//                     PostedVucher.InitTextVariable();
//                     // "Purch. Inv. Header".CalcFields(Amount);
//                     PostedVucher.FormatNoText(AmountinWords, Round(GrandTotal), "Purch. Inv. Header"."Currency Code");
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
//         Companyinformation.get();
//     end;

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
//         Vendor: Record Vendor;
//         PostedVucher: Report "Posted Voucher";
//         Companyinformation: Record "Company Information";
//         TaxtransactionValue: Record "Tax Transaction Value";
//         RecPurchase: Record "Purch. Inv. Line";
//         TaxRecordId: RecordId;
//         AmountinWords: array[2] of Text;
//         AmntinWrds: Text;
//         Gstno: Code[20];
//         Cityss: Text[20];
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