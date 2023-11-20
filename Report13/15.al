// report 50137 "Sales Invoices"
// {
//     UsageCategory = ReportsAndAnalysis;
//     ApplicationArea = All;
//     DefaultLayout = RDLC;
//     Caption = 'ssssss';
//     RDLCLayout = './rehansayedsssss.rdl';

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
//             column(Posting_Date; "Posting Date") { }
//             column(Bill_to_Contact; "Bill-to Contact") { }
//             column(GSTNO; GSTNO) { }
//             column(PHNNO; PHNNO) { }
//             column(EMAIL; EMAIL) { }

//             column(CompanyinfoName; Companyinfo.Name) { }
//             column(CompanyinfoAddress; Companyinfo.Address) { }
//             column(CompanyinfoGSTno; Companyinfo."GST Registration No.") { }
//             column(CompanyinfoState; Companyinfo.City) { }
//             column(CompanyinfoEmail; Companyinfo."E-Mail") { }
//             column(CompanyinfoPhoneno; Companyinfo."Phone No.") { }
//             column(CompanyinfoBankname; Companyinfo."Bank Name") { }
//             column(CompanyinfoBankAccount; Companyinfo."Bank Account No.") { }
//             column(CompanyinfoSwiftCode; Companyinfo."SWIFT Code") { }
//             column(CompanyinfoIFSCCODE; Companyinfo."Bank Branch No.") { }
//             column(CompanyinfoPANNO; Companyinfo."P.A.N. No.") { }
//             // column(Companyinfopanno;Companyinfo."P.A.N. No."){}
//             column(AmntInWrds; AmntInWrds) { }



//             dataitem("Sales Line"; "Sales Line")
//             {
//                 DataItemLinkReference = "Sales Header";
//                 DataItemLink = "Document No." = field("No.");

//                 column(No; "No.") { }
//                 column(Description; Description) { }
//                 column(Quantity; Quantity) { }
//                 column(Per; "Unit of Measure Code") { }
//                 column(Unit_Price; "Unit Price") { }
//                 column(Amount; "Line Amount") { }
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
//                 column(GrandTotal; GrandTotal) { }


//                 trigger OnAfterGetRecord()
//                 var
//                     myInt: Integer;
//                 begin
//                     Customer.Reset();
//                     Customer.SetRange("No.", "Sell-to Customer No.");
//                     if Customer.Find('-') then begin
//                         GSTNO := Customer."GST Registration No.";
//                         EMAIL := Customer."E-Mail";
//                         PHNNO := Customer."Phone No.";
//                     end;

//                     if "Sales Header"."Currency Code" <> '' then begin
//                         Currency := "Sales Header"."Currency Code";
//                     end else begin
//                         Currency := 'INR';
//                     end;
//                     Sales.Reset();
//                     Sales.SetRange("Document Type", "Sales Header"."Document Type");
//                     Sales.SetRange("Document No.", "Sales Header"."No.");
//                     Sales.SetFilter("GST Group Code", '<>%1', '');
//                     if Sales.FindSet() then
//                         repeat
//                             TaxRecordId := Sales.RecordId;

//                             TaxTransactionValue.Reset();
//                             TaxTransactionValue.SetRange("Tax Record ID", TaxRecordId);
//                             TaxTransactionValue.SetRange("Value Type", TaxTransactionValue."Value Type"::COMPONENT);
//                             TaxTransactionValue.SetFilter("Tax Type", '=%1', 'GST');
//                             TaxTransactionValue.SetFilter(Percent, '<>%1', 0);
//                             TaxTransactionValue.SetRange("Visible on Interface", true);
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
//                                 TaxTransactionValue.SetRange("Tax Record ID", TaxRecordId);
//                                 TaxTransactionValue.SetRange("Value Type", TaxTransactionValue."Value Type"::COMPONENT);
//                                 TaxTransactionValue.SetFilter("Tax Type", '=%1', 'GST');
//                                 TaxTransactionValue.SetFilter(Percent, '<>%1', 0);
//                                 TaxTransactionValue.SetRange("Visible on Interface", true);
//                                 TaxTransactionValue.SetFilter("Value ID", '%1', 3);
//                                 IF TaxTransactionValue.FindSet() then
//                                     IGSTRate := TaxTransactionValue.Percent;
//                                 IGST := TaxTransactionValue.Amount;
//                                 TotalIGST += IGST;

//                             end;
//                             Total := Total + "Sales Line".Amount;
//                             // TaxTotal += TotalCGST + TotalIGST + TotalSGST;
//                             GrandTotal := Total + TotalCGST + TotalSGST + TotalIGST;
//                         until Sales.Next() = 0;

//                     if "Sales Header"."Currency Code" <> '' then begin
//                         PostedVoucher.InitTextVariable();
//                         PostedVoucher.FormatNoText(AmountInWords, Round(GrandTotal), "Sales Header"."Currency Code");
//                         AmntInWrds := AmountInWords[1] + AmountInWords[2];
//                     end else begin
//                         PostedVoucher.InitTextVariable();
//                         PostedVoucher.FormatNoText(AmountInWords, Round(GrandTotal), '');
//                         AmntInWrds := AmountInWords[1] + AmountInWords[2];
//                     end;



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
//     begin
//         Companyinfo.get();
//     end;





//     var
//         myInt: Integer;
//         GSTNO: Code[20];
//         PHNNO: Text[30];
//         EMAIL: Text[80];
//         Currency: Code[20];
//         Customer: Record Customer;
//         Companyinfo: Record "Company Information";
//         Sales: Record "Sales Line";
//         TaxTransactionValue: Record "Tax Transaction Value";
//         PostedVoucher: Report "Posted Voucher";
//         TaxRecordId: RecordId;

//         Amount: Decimal;
//         WholeAmount: Decimal;
//         FractionalAmount: Decimal;
//         CGST: Decimal;
//         IGST: Decimal;
//         SGST: DecimaL;
//         IGSTRate: Decimal;
//         SGSTRate: Decimal;
//         CGSTRate: Decimal;
//         TotalCGST: Decimal;
//         TotalSGST: Decimal;
//         TotalIGST: Decimal;

//         TaxTotal: Decimal;
//         Total: Decimal;
//         GrandTotal: Decimal;
//         AmountInWords: array[2] of Text;
//         AmntInWrds: Text;



// }