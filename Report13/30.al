// report 50106 "QrCode"
// {
//     UsageCategory = ReportsAndAnalysis;
//     ApplicationArea = All;
//     DefaultLayout = RDLC;
//     RDLCLayout = 'rehanqr.rdl';

//     dataset
//     {
//         dataitem(Item; Item)
//         {
//             column(No_; "No.")
//             {

//             }
//             column(Description; Description) { }
//             column(EncodeStr; EncodeStr) { }
//             trigger OnAfterGetRecord()
//             var

//                 BarcodeSymb: Enum "Barcode Symbology 2D";
//                 BarcodeProvider: Interface "Barcode Font Provider 2D";
//             begin
//                 EncodeStr := Description;
//                 BarcodeProvider := Enum::"Barcode Font Provider 2D"::IDAutomation2D;
//                 BarcodeSymb := Enum::"Barcode Symbology 2D"::"QR-Code";
//                 EncodeStr := BarcodeProvider.EncodeFont(EncodeStr, BarcodeSymb);
//             end;

//         }
//     }




//     var
//         myInt: Integer;
//         EncodeStr: Text;



//         // Generate a QR code and use it in the Sales Order report
// procedure GenerateQRCodeInSalesOrderReport()
// var
//     SalesOrderReport: Record Item;
//     QRCodeGenerator: Codeunit "QR Code Generator";
//     QRCodeText: Text;
//     QRCodeBase64: Text;
// begin
//     // Get the sales order record for which the report is being generated
//     SalesOrderReport.GET;

//     // Define the text to encode in the QR code (e.g. Sales Order No.)
//     QRCodeText := SalesOrderReport."No.";

//     // Call the QR code generator function to create the base64-encoded image
//     QRCodeBase64 := QRCodeGenerator.GenerateQRCodeAsBase64(QRCodeText);

//     // Set the source for the Image control in the RDLC layout to the QR code image
//     SalesOrderReport.SETDATA(Image, QRCodeBase64);
// end;

// }