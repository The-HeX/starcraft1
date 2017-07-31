using System;
using System.Drawing;
using System.IO;
using Patagames.Ocr;
using Patagames.Ocr.Enums;

namespace ConsoleApplication1
{
    internal class Program
    {
        private static void Main(string[] args)
        {
            CropDisplay();

            foreach (var file in Directory.GetFiles(@"c:\temp\screenshots\display\"))
                ParseData(file);

            Console.WriteLine("done");
            Console.Read();
        }

        private static void ParseData(string imagename)
        {
            using (var api = OcrApi.Create())
            {
                api.Init(Languages.English);

                var plainText = api.GetTextFromImage(imagename);

                var format = plainText.Split('\n')[0];
                if (format.Contains("Terran"))
                {
                    format = format.Substring(format.IndexOf("Terran"), format.Length - format.IndexOf("Terran"));
                }
                Console.WriteLine(format);
            }
        }


        private static void CropDisplay()
        {
            var dir = Environment.GetFolderPath(Environment.SpecialFolder.MyDocuments);
            foreach (var input in Directory.GetFiles(dir + @"\Starcraft\Screenshots"))
            {
                var src = Image.FromFile(input);

                CropItem(src, input);
                MiniMapItem(src, input);
            }
        }

        private static void CropItem(Image src, string input)
        {
            var y1 = 776;
            var y2 = 954;
            var x1 = 321;
            var x2 = 790;
            var rect = new Rectangle(x1, y1, x2 - x1, y2 - y1);
            var cropped = cropImage(src, rect);
            var filename = @"c:\temp\screenshots\display\" + Path.GetFileName(input);
            if (File.Exists(filename))
                File.Delete(filename);
            cropped.Save(filename);
        }

        private static void MiniMapItem(Image src, string input)
        {
            var y1 = 690;
            var y2 = 960;
            var x1 = 5;
            var x2 = 270;
            var rect = new Rectangle(x1, y1, x2 - x1, y2 - y1);
            var cropped = cropImage(src, rect);
            var filename = @"c:\temp\screenshots\minimap\" + Path.GetFileName(input);
            if (File.Exists(filename))
                File.Delete(filename);
            cropped.Save(filename);
        }

        private static Image cropImage(Image img, Rectangle cropArea)
        {
            var bmpImage = new Bitmap(img);
            return bmpImage.Clone(cropArea, bmpImage.PixelFormat);
        }
    }
}