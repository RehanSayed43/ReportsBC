// report 50138 MyReport
// {
//     UsageCategory = ReportsAndAnalysis;
//     ApplicationArea = All;
//     Caption = 'SalesReporttssssss';
//     DefaultLayout = RDLC;
//     RDLCLayout = 'salesss.rdl';

//     dataset
//     {
//         dataitem("Sales Header"; "Sales Header")
//         {
//             DataItemTableView = sorting("No.");
//             RequestFilterFields = "No.";
//             column(No_; "No.") { }
//             column(Bill_to_Name; "Bill-to Name") { }
//             column(Posting_Date; "Posting Date") { }
//             column(Nature_of_Supply; "Nature of Supply") { }
//             column(Sell_to_Customer_No_; "Sell-to Customer No.") { }
//             column(Bill_to_Address; "Bill-to Address") { }

//             column(Gstno; Gstno) { }
//             column(Statess; Statess) { }
//             column(Companyinfoname; Companyinfo.Name) { }
//             column(Companyinfoaddress; Companyinfo.Address) { }
//             column(Companyinfogstno; Companyinfo."GST Registration No.") { }
//             column(CompanyinfoStateCode; Companyinfo."Location Code") { }
//             column(CompanyinfoBankname; Companyinfo."Bank Name") { }
//             column(Companyinfobankaccno; Companyinfo."Bank Account No.") { }
//             column(Companyinfoifsccode; Companyinfo."Bank Branch No.") { }
//             column(CompanyinfoSwiftcode; Companyinfo."SWIFT Code") { }
//             dataitem("Sales Line"; "Sales Line")
//             {
//                 DataItemLinkReference = "Sales Header";
//                 DataItemLink = "Document No." = field("No.");
//                 column(No; "No.") { }
//                 column(Description; Description) { }
//                 column(Quantity; Quantity) { }
//                 column(Unit_Cost; "Unit Cost") { }
//                 column(Unit_of_Measure_Code; "Unit of Measure Code") { }
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
//                 column(TaxTotal; TaxTotal) { }
//                 column(Amntinwrds; Amntinwrds) { }
//                 column(GrandTotol; GrandTotol) { }

//                 trigger OnAfterGetRecord()
//                 var
//                     myInt: Integer;
//                 begin
//                     customer.Reset();
//                     customer.SetRange("No.", "Sell-to Customer No.");
//                     if customer.Find('-') then begin
//                         Gstno := customer."GST Registration No.";
//                         Statess := customer.City;
//                     end;


//                     salesline.Reset();
//                     salesline.SetRange("Document Type", "Sales Header"."Document Type");
//                     salesline.SetRange("Document No.", "Sales Header"."No.");
//                     salesline.SetFilter("GST Group Code", '<>%1', '');
//                     if salesline.FindSet() then
//                         repeat
//                             TaxReocrdID := salesline.RecordId;

//                             TaxTransactionValue.Reset();
//                             TaxTransactionValue.SetRange("Tax Record ID", TaxReocrdID);
//                             TaxTransactionValue.SetRange("Visible on Interface", true);
//                             TaxTransactionValue.SetFilter("Tax Type", '=%1', 'GST');
//                             TaxTransactionValue.SetFilter(Percent, '<>%1', 0);
//                             TaxTransactionValue.SetFilter("Value ID", '%1|%2', 6, 2);
//                             if TaxTransactionValue.FindSet() then begin
//                                 CGSTRate := TaxTransactionValue.Percent;
//                                 SGSTRate := TaxTransactionValue.Percent;
//                                 CGST := TaxTransactionValue.Amount;
//                                 SGST := TaxTransactionValue.Amount;

//                                 TotalCGST += CGST;
//                                 TotalSGST += SGST;
//                             end else begin
//                                 TaxTransactionValue.Reset();
//                                 TaxTransactionValue.SetRange("Tax Record ID", TaxReocrdID);
//                                 TaxTransactionValue.SetRange("Visible on Interface", true);
//                                 TaxTransactionValue.SetFilter("Tax Type", '=%1', 'GST');
//                                 TaxTransactionValue.SetFilter(Percent, '<>%1', 0);
//                                 if TaxTransactionValue.FindSet() then
//                                     IGSTRate := TaxTransactionValue.Percent;
//                                 IGST := TaxTransactionValue.Amount;
//                                 TotalIGST += IGST;
//                             end;
//                             Total += salesline.Amount;
//                             GrandTotol := Total + TotalCGST + TotalSGST + TotalIGST;
//                         until salesline.Next() = 0;

//                     PostedVoucher.InitTextVariable();
//                     PostedVoucher.FormatNoText(AmountinWords, Round(GrandTotol), "Sales Header"."Currency Code");
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
//         PostedVoucher: Report "Posted Voucher";
//         Companyinfo: Record "Company Information";
//         Gstno: Code[20];
//         Statess: Text[30];
//         salesline: Record "Sales Line";
//         TaxReocrdID: RecordId;
//         TaxTransactionValue: Record "Tax Transaction Value";

//         CGST: Decimal;
//         SGST: Decimal;
//         IGST: Decimal;
//         CGSTRate: Decimal;
//         SGSTRate: Decimal;
//         IGSTRate: Decimal;
//         TotalCGST: Decimal;
//         TotalSGST: Decimal;
//         TotalIGST: Decimal;
//         AmountinWords: array[2] of Text;
//         Amntinwrds: Text;
//         TaxTotal: Decimal;
//         Total: Decimal;
//         GrandTotol: Decimal;


// }