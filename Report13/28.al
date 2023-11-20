// report 50139 "Sales Report 9/23"
// {
//     UsageCategory = ReportsAndAnalysis;
//     ApplicationArea = All;
//     DefaultLayout = RDLC;
//     Caption = 'newwww';
//     RDLCLayout = './salespr.rdl';

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
//             column(gstno; gstno) { }
//             column(States; States) { }
//             column(Phoneno; Phoneno) { }
//             column(Panno; Panno) { }
//             column(Posting_Date; "Posting Date") { }
//             column(Sell_to_Customer_No_; "Sell-to Customer No.") { }







//             column(Ship_to_Name; "Ship-to Name") { }
//             column(Ship_to_Address; "Ship-to Address") { }
//             column(Location_State_CodeS; "Location State Code") { }
//             column(Companyinfoname; Companyinfo.Name) { }
//             column(Companyinfoaddress; Companyinfo.Address) { }
//             column(CompanyinfoCity; Companyinfo.City) { }
//             column(CompanyinfoStateCode; Companyinfo."State Code") { }
//             column(CompanyinfoBankname; Companyinfo."Bank Name") { }
//             column(CompanyinfoBankaccno; Companyinfo."Bank Account No.") { }
//             column(Companyinfoifsccode; Companyinfo."Bank Branch No.") { }
//             column(CompanyinfoSwiftCode; Companyinfo."SWIFT Code") { }
//             column(EncodeStr; EncodeStr) { }


//             dataitem("Sales Line"; "Sales Line")
//             {
//                 DataItemLinkReference = "Sales Header";
//                 DataItemLink = "Document No." = field("No.");
//                 column(No; "No.") { }
//                 column(Quantity; Quantity) { }
//                 column(Description; Description) { }
//                 column(HSN_SAC_Code; "HSN/SAC Code") { }
//                 column(Unit_Cost; "Unit Cost") { }
//                 column(Unit_of_Measure_Code; "Unit of Measure Code") { }
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
//                 column(AmninWrds; AmninWrds) { }
//                 column(GrandTotal; GrandTotal) { }
//                 // column(EncodeStr; EncodeStr) { }

//                 trigger OnAfterGetRecord()
//                 var
//                     myInt: Integer;
//                     BarcodeSymb: Enum "Barcode Symbology 2D";
//                     BarcodeProvider: Interface "Barcode Font Provider 2D";
//                 begin
//                     // EncodeStr := Companyinfo.Name;
//                     // BarcodeProvider := Enum::"Barcode Font Provider 2D"::IDAutomation2D;
//                     // BarcodeSymb := Enum::"Barcode Symbology 2D"::"QR-Code";
//                     // EncodeStr := BarcodeProvider.EncodeFont(EncodeStr, BarcodeSymb);
//                     // customer.Reset();
//                     customer.SetRange("No.", "Sell-to Customer No.");
//                     if customer.Find('-') then begin
//                         gstno := customer."GST Registration No.";
//                         States := customer.City;
//                         Panno := customer."P.A.N. No.";
//                     end;


//                     sales.Reset();
//                     sales.SetRange("Document Type", "Sales Header"."Document Type");
//                     sales.SetRange("Document No.", "Sales Header"."No.");
//                     sales.SetFilter("GST Group Code", '<>%1', '');
//                     if sales.FindSet() then
//                         repeat
//                             Taxrecordid := sales.RecordId;
//                             Taxtransactionvalue.Reset();
//                             Taxtransactionvalue.SetRange("Tax Record ID", Taxrecordid);
//                             Taxtransactionvalue.SetRange("Value Type", Taxtransactionvalue."Value Type"::COMPONENT);
//                             Taxtransactionvalue.SetFilter("Tax Type", '=%1', 'GST');
//                             Taxtransactionvalue.SetFilter(Percent, '<>%1', 0);
//                             Taxtransactionvalue.SetFilter("Value ID", '%1|%2', 6, 2);
//                             Taxtransactionvalue.SetRange("Visible on Interface", true);
//                             if Taxtransactionvalue.FindSet() then begin
//                                 CGSTRate := Taxtransactionvalue.Percent;
//                                 SGSTRate := Taxtransactionvalue.Percent;
//                                 CGST := Taxtransactionvalue.Amount;
//                                 SGST := Taxtransactionvalue.Amount;

//                                 TotalCGST += CGST;
//                                 TotalSGST += SGST;

//                             end else begin


//                                 Taxtransactionvalue.Reset();
//                                 Taxtransactionvalue.SetRange("Tax Record ID", Taxrecordid);
//                                 Taxtransactionvalue.SetRange("Value Type", Taxtransactionvalue."Value Type"::COMPONENT);
//                                 Taxtransactionvalue.SetFilter("Tax Type", '=%1', 'GST');
//                                 Taxtransactionvalue.SetFilter(Percent, '<>%1', 0);
//                                 Taxtransactionvalue.SetFilter("Value ID", '%1', 3);
//                                 Taxtransactionvalue.SetRange("Visible on Interface", true);
//                                 if Taxtransactionvalue.FindSet() then
//                                     IGSTRate := Taxtransactionvalue.Percent;
//                                 IGST := Taxtransactionvalue.Amount;
//                                 TotalIGST += IGST;
//                             end;

//                             // Taxtotal += TotalCGST + TotalSGST + TotalIGST;
//                             Total := Total + sales.Amount;
//                             GrandTotal := Total + TotalCGST + TotalSGST + TotalIGST;
//                         until sales.Next() = 0;

//                     PostedVoucher.InitTextVariable();
//                     PostedVoucher.FormatNoText(AmountinWords, Round(GrandTotal), "Sales Header"."Currency Code");
//                     AmninWrds := AmountinWords[1] + AmountinWords[2];





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
//         EncodeStr: Text;
//         gstno: Code[20];
//         States: Text[30];
//         Taxrecordid: RecordId;
//         Panno: Code[20];
//         Phoneno: Text[30];


//         customer: Record Customer;
//         Companyinfo: Record "Company Information";
//         Taxtransactionvalue: Record "Tax Transaction Value";
//         sales: Record "Sales Line";
//         PostedVoucher: Report "Posted Voucher";

//         CGST: Decimal;
//         SGST: Decimal;
//         IGST: Decimal;
//         CGSTRate: Decimal;
//         SGSTRate: Decimal;
//         IGSTRate: Decimal;
//         TotalCGST: Decimal;
//         TotalIGST: Decimal;
//         TotalSGST: Decimal;
//         AmountinWords: array[2] of Text;
//         AmninWrds: Text;
//         Total: Decimal;
//         Taxtotal: Decimal;
//         GrandTotal: Decimal;


// }