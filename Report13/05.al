// report 50124 "Sales Invoice customer"
// {
//     UsageCategory = ReportsAndAnalysis;
//     ApplicationArea = All;
//     DefaultLayout = RDLC;
//     Caption = 'SAYEDDDDDDD';
//     RDLCLayout = './rshipment.rdl';

//     dataset
//     {
//         dataitem("Sales Header"; "Sales Header")
//         {
//             DataItemTableView = sorting("No.");
//             RequestFilterFields = "No.";
//             //Customer Information
//             column(No_; "No.") { }
//             column(Bill_to_Name; "Bill-to Name") { }
//             column(Bill_to_Address; "Bill-to Address") { }
//             column(Bill_to_City; "Bill-to City") { }
//             column(customergstno; customer."GST Registration No.") { }
//             column(Location_State_Code; "Location State Code") { }


//             //Column
//             column(Posting_Date; "Posting Date") { }
//             column(Nature_of_Supply; "Nature of Supply") { }

//             //Company Information
//             column(companyname; company.Name) { }
//             column(companyaddress; company.Address) { }
//             column(companygst; company."GST Registration No.") { }
//             column(companycity; company.City) { }
//             column(companystatecode; company."State Code") { }

//             //Amount in Words
//             column(Amntinwrds; Amntinwrds) { }
//             // column(Barcode;Encodestr)
//             // trigger OnAfterGetRecord()
//             // var
//             //     myInt: Integer;
//             //     BarcodeStr:Code[20];
//             //     BarcodeFontProvider:Enum "Barcode Font Provider"::"Integration Update Conflict Resolution";
//             // begin

//             // end;


//             dataitem("Sales Line"; "Sales Line")
//             {
//                 DataItemLinkReference = "Sales Header";
//                 DataItemLink = "Document No." = FIELD("No.");
//                 column(Noo; "No.") { }
//                 column(Quantity; Quantity) { }
//                 column(Description; Description) { }
//                 column(Rate; "Unit Cost") { }
//                 column(Duedate; "Posting Date") { }
//                 column(HSN_SAC_Code; "HSN/SAC Code") { }
//                 column(Amount; "Line Amount") { }
//                 column(CGST; CGST) { }
//                 column(IGST; IGST) { }
//                 column(SGST; SGST) { }
//                 column(TotalCGST; TotalCGST) { }
//                 column(TotalIGST; TotalIGST) { }
//                 column(TotalSGST; TotalSGST) { }
//                 column(CGSTRate; CGSTRate) { }
//                 column(SGSTRate; SGSTRate) { }
//                 column(IGSTRate; IGSTRate) { }


//             }

//             trigger OnAfterGetRecord()
//             var
//                 myInt: Integer;
//             //To retrive the gst data from the customer to sales header table
//             begin
//                 customer.Reset();
//                 customer.SetRange("No.", "Sell-to Customer No.");
//                 if customer.Find('-') then begin
//                     gstno := customer."GST Registration No.";
//                 end;

//                 //To convert the Total Amount into Words
//                 ClearMyData();

//                 sales.Reset();

//                 sales.SetRange("Document Type", "Sales Header"."Document Type");
//                 sales.SetRange("Document No.", "Sales Header"."No.");
//                 sales.SetFilter("GST Group Code", '<>%1', '');
//                 if sales.FindSet() then
//                     repeat
//                         TaxTransactionValue.Reset();
//                         TaxTransactionValue.SetRange("Value Type", TaxTransactionValue."Value Type"::COMPONENT);
//                         TaxTransactionValue.SetFilter("Tax Type", '=%1', 'GST');
//                         TaxTransactionValue.SetFilter(Percent, '<>%1', 0);
//                         if TaxTransactionValue.FindSet() then
//                             repeat
//                                 if ("Sales Line"."GST Jurisdiction Type" = "Sales Line"."GST Jurisdiction Type"::Interstate)
//                                 then begin
//                                     CGSTRate := TaxTransactionValue.Percent;
//                                     SGSTRate := TaxTransactionValue.Percent;
//                                     CGST := TaxTransactionValue.Amount;
//                                     SGST := TaxTransactionValue.Amount;



//                                 end
//                                 else
//                                     IF ("Sales Line"."GST Jurisdiction Type" = "Sales Line"."GST Jurisdiction Type"::Interstate) THEN BEGIN
//                                         IGSTRate := TaxTransactionValue.Percent;
//                                         IGST := TaxTransactionValue.Amount;
//                                     end;
//                             until TaxTransactionValue.Next() = 0;
//                         TotalCGST += CGST;
//                         TotalSGST += SGST;
//                         TotalIGST += IGST;
//                         Total := Total + "Sales Line".Amount;
//                         TaxTotal += TotalIGST + TotalCGST + TotalSGST;
//                         GrandTotal := Total + TaxTotal;

//                         Total := sales.Amount;
//                     until sales.Next() = 0;
//                 AmountinVendors := Total;
//                 PostedVoucher.InitTextVariable();
//                 "Sales Header".CalcFields(Amount);
//                 PostedVoucher.FormatNoText(AmountinWords, Round(AmountinVendors), "Sales Header"."Currency Code");
//                 Amntinwrds := AmountinWords[1] + AmountinWords[2];
//             end;
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

//     trigger OnPostReport()
//     var
//         myInt: Integer;
//     begin
//         sales.get();
//     end;



//     var
//     Encodestr:Text;

//         gstno: Code[20];
//         myInt: Integer;
//         company: Record "Company Information";
//         customer: Record Customer;
//         sales: Record "Sales Line";
//         PostedVoucher: Report "Posted Voucher";
//         AmountinVendors: Decimal;
//         TextAmount: Text;
//         NumberWords: Text;
//         TaxTransactionValue: Record "Tax Transaction Value";

//         Amount: Decimal;
//         WholeAmount: Decimal;
//         FractionalAmount: Decimal;
//         Amntinwrds: Text;
//         AmountinWords: array[2] of Text;
//         CGST: Decimal;
//         IGST: Decimal;
//         SGST: Decimal;

//         CGSTRate: Decimal;
//         IGSTRate: Decimal;
//         SGSTRate: Decimal;

//         TotalIGST: Decimal;
//         TotalCGST: Decimal;
//         TotalSGST: Decimal;

//         IGSTtxt: Text[10];
//         SGSTtxt: Text[10];
//         CGSTtxt: Text[10];
//         Total: Decimal;
//         GrandTotal: Decimal;
//         TaxTotal: Decimal;


//         RecState: Record State;
//         CmpStateName: Text;
//         BankAcc: Record "Bank Account";
//         BankBrach: Text;
//         SWIFTCode: Code[20];
//         NoLbl: Label 'SR No.';
//         DesLbl: Label 'Product Description';
//         HSNLbl: Label 'HSN Code';
//         DueLbl: Label 'Due On';
//         qtyLbl: Label 'Qty';
//         RateLbl: Label 'Rate';
//         AmtLbl: Label 'Amount';
//         DisLbl: Label 'Discount';
//         TaxValLbl: Label 'Taxable Value';
//         TotLbl: Label 'Total';

//         Notext: array[2] of Text;


//     local procedure ClearMyData()
//     begin
//         IGSTRate := 0;
//         CGSTRate := 0;
//         SGSTRate := 0;

//         TotalCGST := 0;
//         TotalIGST := 0;
//         TotalSGST := 0;

//         IGST := 0;
//         CGST := 0;
//         SGST := 0;

//     end;



// }