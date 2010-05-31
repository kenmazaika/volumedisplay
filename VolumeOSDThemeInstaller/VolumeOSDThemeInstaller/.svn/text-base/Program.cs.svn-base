using System;
using System.Collections.Generic;
using System.Linq;
using System.Windows.Forms;
using VolumeOSD;
using System.IO;

namespace VolumeOSDThemeInstaller
{
    static class Program
    {
        private static void Initialize()
        {
            string folderPath = System.Environment.GetFolderPath(Environment.SpecialFolder.CommonApplicationData) + "\\KenMazaika\\VolumeOSD\\themes\\";
            if(System.IO.Directory.Exists(folderPath))
                return;

            System.IO.Directory.CreateDirectory(System.Environment.GetFolderPath(Environment.SpecialFolder.CommonApplicationData) + "\\KenMazaika");
            System.IO.Directory.CreateDirectory(System.Environment.GetFolderPath(Environment.SpecialFolder.CommonApplicationData) + "\\KenMazaika\\VolumeOSD");
            System.IO.Directory.CreateDirectory(folderPath);


            System.Diagnostics.Process.Start("icacles", System.Environment.GetFolderPath(Environment.SpecialFolder.CommonApplicationData) + "\\KenMazaika" + "  Everyone:(OI)(CI)");
        }



        /// <summary>
        /// The main entry point for the application.
        /// </summary>
        [STAThread]
        static void Main()
        {
            // If the program is running, close it:
            string daemonString = Path.GetDirectoryName(Application.ExecutablePath) + @"\VolumeOSD.exe";
            System.Diagnostics.Process.Start(daemonString, "-Q");
            Initialize();
            Application.EnableVisualStyles();
            Application.SetCompatibleTextRenderingDefault(false);
            bool silent = Environment.GetCommandLineArgs().Length > 2 && Environment.GetCommandLineArgs()[2].ToUpper().Equals("-S");
            bool activate = Environment.GetCommandLineArgs().Length > 2 && Environment.GetCommandLineArgs()[2].ToUpper().Equals("-A");

            string file = Environment.GetCommandLineArgs()[1];
            FolderZipper.ZipUtil.UnZipFiles(file,
                System.Environment.GetFolderPath(Environment.SpecialFolder.CommonApplicationData) + "\\KenMazaika\\VolumeOSD\\themes\\",
                null,
                false);


            if (activate)
            {
                VolumeOSD.ActiveSettings settings = new ActiveSettings();
                char[] del = new char[2];
                del[0] = '\\';
                del[1] = '.';


                string[] splitFilename = file.Split(del);
                settings.Name = splitFilename[splitFilename.Length - 2];
                settings.X = 0;
                settings.Y = 0;
                settings.Opacity = 0.0;
                ActiveSettings.Serialize(System.Environment.GetFolderPath(Environment.SpecialFolder.CommonApplicationData) + "\\KenMazaika\\VolumeOSD\\Settings.xml", settings);
            }
            else if (!silent)
                MessageBox.Show("Theme Installed");

            // Launch the previewer if this was a normal double click action
            if (!activate && !silent)
            {
                System.Diagnostics.Process.Start(daemonString,"-P");
            }
        }
    }
}
