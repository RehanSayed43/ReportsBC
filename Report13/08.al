// report 50143 "Purchase Credit Memo"
// {
//     UsageCategory = ReportsAndAnalysis;
//     ApplicationArea = All;
//     DefaultLayout = RDLC;
//     RDLCLayout = './rehannssss11111111.rdl';


//     dataset
//     {
//         dataitem("Purchase Header"; "Purchase Header")
//         {
//             //Party Customer Info
//             DataItemTableView = sorting("No.");
//             RequestFilterFields = "No.";
//             column(No_; "No.") { }
//             column(Pay_to_Name; "Pay-to Name") { }
//             column(Pay_to_Address; "Pay-to Address") { }
//             column(Location_State_Code; "Location State Code") { }
//             column(Vendor_GST_Reg__No_; "Vendor GST Reg. No.") { }


//             //Company Info
//             column(companyname; company.Name) { }
//             column(companyaddress; company.Address) { }
//             column(company; company."GST Registration No.") { }
//             column(companycity; company.City) { }
//             column(companystatecode; company."State Code") { }
//             column(companypanno; company."P.A.N. No.") { }
//             column(companyacno; company."Bank Account No.") { }
//             column(companybankname; company."Bank Name") { }





//             //Column
//             column(Amntinwrds; Amntinwrds) { }
//             column(Posting_Date; "Posting Date") { }
//             column(Due_Date; "Due Date") { }
//             column(Orderno; "Vendor Cr. Memo No.") { }
//             column(Despatchedthrough; "Pay-to Contact") { }
//             column(Nature_of_Supply; "Nature of Supply") { }


//             dataitem("Purchase Line"; "Purchase Line")
//             {
//                 DataItemLinkReference = "Purchase Header";
//                 DataItemLink = "Document No." = FIELD("No.");
//                 column(Noss; "No.") { }
//                 column(Quantity; Quantity) { }
//                 column(Description; Description) { }
//                 column(Unit_Cost; "Unit Cost") { }
//                 column(Line_Amount; "Line Amount") { }
//                 column(Per; "Unit of Measure Code") { }
//             }

//             trigger OnAfterGetRecord()
//             var
//                 myInt: Integer;
//             begin
//                 //Code to get the gst no from Vendor page to Purchase Header
//                 Vendor.Reset();
//                 Vendor.SetRange("No.", "Sell-to Customer No.");
//                 if Vendor.Find('-') then begin
//                     Gstno := Vendor."GST Registration No.";
//                 end;

//                 //Code to Covert the Amount in numbers to words
//                 // ClearData();
//                 // Purchs.Reset();
//                 // Purchs.SetRange("No.", "Purchase Header"."No.");
//                 // if Purchs.FindSet() then
//                 //     repeat
//                 //         Total := Purchs.Amount;
//                 //     until Purchs.Next() = 0;
//                 // AmountToVendor := Total;
//                 // PostedVoucher.InitTextVariable();
//                 // "Purchase Header".CalcFields(Amount);
//                 // PostedVoucher.FormatNoText(AmountInWords, Round(AmountToVendor), "Purchase Header"."Currency Code");
//                 // Amntinwrds := AmountInWords[1] + AmountInWords[2];
//                 ClearData();
//                 sales.Reset();
//                 sales.SetRange("Document No.", "Purchase Header"."No.");
//                 if sales.FindSet() then
//                     repeat
//                         Total += sales.Amount;
//                     until sales.Next() = 0;
//                 AmountToVendor := Total;
//                 PostedVoucher.InitTextVariable();
//                 "Purchase Header".CalcFields(Amount);
//                 PostedVoucher.FormatNoText(AmountinWords, Round(AmountToVendor), "Purchase Header"."Currency Code");
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
//         Gstno: Code[20];
//         myInt: Integer;
//         company: Record "Company Information";
//         Vendor: Record Vendor;
//         sales: Record "Purchase Line";
//         PostedVoucher: Report "Posted Voucher";
//         AmountToVendor: Decimal;
//         TextAmount: Text;
//         NumberWords: Text;
//         Amount: Decimal;
//         WholeAmount: Decimal;
//         FractionalAmount: Decimal;
//         Amntinwrds: Text;
//         AmountInWords: array[2] of Text;
//         CGST: Decimal;
//         IGST: Decimal;
//         SGST: Decimal;
//         CGSTRate: Decimal;
//         IGSTRate: Decimal;
//         SGSTRate: Decimal;
//         TotalIGST: Decimal;
//         TotalCGST: Decimal;
//         TotalSGST: Decimal;
//         CGSTtxt: Text[10];
//         SGSTtxt: Text[10];
//         IGSTtxt: Text[10];
//         Total: Decimal;


//     local procedure ClearData()
//     begin
//         IGST := 0;
//         SGST := 0;
//         CGST := 0;

//         TotalCGST := 0;
//         TotalSGST := 0;
//         TotalIGST := 0;

//         CGSTRate := 0;
//         SGSTRate := 0;
//         IGSTRate := 0;
//     end;



// }