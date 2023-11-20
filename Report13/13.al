// report 50125 "Sales Order"
// {
//     UsageCategory = ReportsAndAnalysis;
//     ApplicationArea = All;
//     DefaultLayout = RDLC;
//     Caption = 'CRRRRR';
//     // RDLCLayout = './Srrs.rdl';
//     RDLCLayout = './perfect.rdl';

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
//             column(Statesss; Statesss) { }
//             column(PostCodee; PostCodee) { }



//             //Column
//             column(Posting_Date; "Posting Date") { }
//             column(Bill_to_Contact; "Bill-to Contact") { }
//             column(Orderno; "Sell-to Customer No.") { }


//             column(Ship_to_Name; "Ship-to Name") { }
//             column(Ship_to_Address; "Ship-to Address") { }


//             column(CompanyinfoName; Companyinfo.Name) { }
//             column(CompanyinfoAddress; Companyinfo.Address) { }
//             column(Companyinfogstmo; Companyinfo."GST Registration No.") { }
//             column(CompanyinfoState; Companyinfo.City) { }
//             column(CompanyinfoCinno; Companyinfo.IBAN) { }
//             column(Companyinfoemail; Companyinfo."E-Mail") { }

//             //Company Bank Account
//             column(CompanyinfoBankName; Companyinfo."Bank Name") { }
//             column(CompanyinfoBankAccno; Companyinfo."Bank Account No.") { }
//             column(CompanyinfoSwiftCode; Companyinfo."SWIFT Code") { }
//             column(CompanyinfoIfsccode; Companyinfo."Bank Branch No.") { }
//             column(CompanyinfoPanno; Companyinfo."P.A.N. No.") { }


//             column(AmntinWrds; AmntinWrds) { }







//             dataitem("Sales Line"; "Sales Line")
//             {
//                 DataItemLinkReference = "Sales Header";
//                 DataItemLink = "Document No." = field("No.");
//                 column(No; "No.") { }
//                 column(Description; Description) { }
//                 column(Quantity; Quantity) { }
//                 column(Rate; "Unit Price") { }
//                 column(Amount; "Line Amount") { }
//                 column(HSN_SAC_Code; "HSN/SAC Code") { }
//                 column(Shipment_Date; "Shipment Date") { }
//                 column(CGSTRate; CGSTRate) { }
//                 column(SGSTRate; SGSTRate) { }
//                 column(IGSTRate; IGSTRate) { }
//                 column(CGST; CGST) { }
//                 column(SGST; SGST) { }
//                 column(IGST; IGST) { }
//                 column(TaxTotal; TaxTotal) { }
//                 column(Total; Total) { }
//                 column(Grandtotal; Grandtotal) { }


//                 trigger OnAfterGetRecord()
//                 var
//                     myInt: Integer;
//                 begin
//                     customer.Reset();
//                     customer.SetRange("No.", "Sell-to Customer No.");
//                     if customer.Find('-') then begin
//                         gstno := customer."GST Registration No.";
//                         Statesss := customer.County;
//                         PostCodee := customer."Post Code";
//                     end;

//                     // if "Sales Header"."Currency Code" <>" then begin
//                     if "Sales Header"."Currency Code" <> '' then begin
//                         Currency := "Sales Header"."Currency Code";
//                     end else begin
//                         Currency := 'INR';
//                     end;

//                     sales.Reset();
//                     sales.SetRange("Document Type", "Sales Header"."Document Type");
//                     sales.SetRange("Document No.", "Sales Header"."No.");
//                     sales.SetFilter("GST Group Code", '<>%1', '');
//                     if sales.FindSet() then
//                         repeat
//                             TaxRecordId := sales.RecordId;

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
//                                 if TaxTransactionValue.FindSet() then
//                                     IGSTRate := TaxTransactionValue.Percent;
//                                 IGST := TaxTransactionValue.Amount;
//                                 TotalIGST := IGST;
//                             end;
//                             Total := Total + "Sales Line".Amount;
//                             TaxTotal += TotalCGST + TotalSGST + TotalIGST;
//                             Grandtotal := +TaxTotal + Total;
//                         until sales.Next() = 0;

//                     if "Sales Header"."Currency Code" <> '' then begin
//                         Postedvoucher.InitTextVariable();
//                         Postedvoucher.FormatNoText(AmountInWords, Round(Grandtotal), "Sales Header"."Currency Code");
//                         AmntinWrds := AmountInWords[1] + AmountInWords[2];
//                     end
//                     else begin
//                         Postedvoucher.InitTextVariable();
//                         Postedvoucher.FormatNoText(AmountInWords, Round(Grandtotal), '');
//                         AmntinWrds := AmountInWords[1] + AmountInWords[2];
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
//     var
//         myInt: Integer;
//     begin
//         Companyinfo.get();
//     end;

//     trigger OnPostReport()
//     var
//         myInt: Integer;
//     begin


//     end;



//     var
//         gstno: Code[20];
//         Statesss: Text[30];
//         PostCodee: Code[20];
//         customer: Record Customer;
//         Companyinfo: Record "Company Information";
//         Amount: Decimal;
//         TotalAmount: Decimal;
//         FractionalAmount: Decimal;
//         AmountInVendors: Decimal;
//         CGST: Decimal;
//         SGST: Decimal;
//         IGST: Decimal;
//         CGSTRate: Decimal;
//         SGSTRate: Decimal;
//         IGSTRate: Decimal;
//         TotalIGST: Decimal;
//         TotalSGST: Decimal;
//         TotalCGST: Decimal;
//         TaxTotal: Decimal;
//         Total: Decimal;
//         Grandtotal: Decimal;
//         Currency: Code[20];
//         AmountInWords: array[2] of Text;
//         AmntinWrds: Text;
//         TaxRecordId: RecordId;

//         Postedvoucher: Report "Posted Voucher";
//         TaxTransactionValue: Record "Tax Transaction Value";
//         sales: Record "Sales Line";


//     local procedure ClearData()
//     var
//         myInt: Integer;
//     begin
//         IGST := 0;
//         SGST := 0;
//         CGST := 0;

//         CGSTRate := 0;
//         SGSTRate := 0;
//         IGSTRate := 0;


//         TotalCGST := 0;
//         TotalIGST := 0;
//         TotalSGST := 0;
//     end;



// }