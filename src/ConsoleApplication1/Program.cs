using System;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Threading;
using Patagames.Ocr;
using Patagames.Ocr.Enums;

namespace ConsoleApplication1
{
    internal class Program
    {
        private static void Main(string[] args)
        {

            // FIND THE MOST RECENT FILE
            var dir = Environment.GetFolderPath(Environment.SpecialFolder.MyDocuments);
            var file=Directory.GetFiles(dir + @"\Starcraft\Screenshots")
                .Select(a => new {Date = File.GetLastWriteTime(a), Name = a}).OrderByDescending(a => a.Date).FirstOrDefault();
            if (file != null)
            {
                var count = 1;
                var success = false;
                do
                {
                    try
                    {
                        // CROP DISPLAY . RETURN FILENAME
                        var cropped = CropScreenSections(file.Name);
                        // PARSE FILE NAME
                        var value = ParseData(cropped);
                        // WRITE FILE, TO ARG LOCATION
                        var path = args.Length > 0 ? args[0] : Path.GetTempFileName();
                        Console.WriteLine($"writing results {value} to {path}");
                        using (var output = File.CreateText(path))
                        {
                            output.WriteLine(value);
                        }
                        success = true;
                    }
                    catch (Exception e)
                    {
                        Console.WriteLine(e);
                        Thread.Sleep(750);
                    }
                } while (!success && count < 3);
            }
        }

        private static string ParseData(string imagename)
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
                return format.Replace("Terran ", "").Replace("‘", "").TrimStart(' ').TrimEnd(' ');
            }
        }


        private static string CropScreenSections(string filename)
        {
                var src = Image.FromFile(filename);
                return CropDisplay(src, filename);
                CropMiniMap(src, filename);
        }

        private static string CropDisplay(Image src, string input)
        {
            var y1 = 776;
            var y2 = 954;
            var x1 = 321;
            var x2 = 790;
            if (y2 > src.Height)
                y2 = src.Height;
            var rect = new Rectangle(x1, y1, x2 - x1, y2 - y1);
            var cropped = cropImage(src, rect);
            var filename = Path.GetTempFileName();
            //var filename = @"c:\temp\screenshots\display\" + Path.GetFileName(input);
            if (File.Exists(filename))
                File.Delete(filename);
            cropped.Save(filename);
            return filename;
        }

        private static void CropMiniMap(Image src, string input)
        {
            
            var y1 = 690;
            var y2 = 960;
            var x1 = 5;
            var x2 = 270;
            if (y2 > src.Height)
                y2 = src.Height;
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