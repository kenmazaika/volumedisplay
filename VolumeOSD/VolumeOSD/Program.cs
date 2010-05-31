using System;
using System.Collections.Generic;
using System.Windows.Forms;
using System.IO;
using System.Diagnostics;

namespace VolumeOSD
{
    static class Program
    {

        public static void RunDaemonAsync()
        {
            ActiveSettings asettings = ActiveSettings.Deserialize(System.Environment.GetFolderPath(Environment.SpecialFolder.CommonApplicationData) + "\\KenMazaika\\VolumeOSD\\Settings.xml");
            string themeName = asettings.Name;
            ProgramSettings settings = ProgramSettings.Deserialize(System.Environment.GetFolderPath(Environment.SpecialFolder.CommonApplicationData) + "\\KenMazaika\\VolumeOSD\\themes\\" + themeName + "\\ProgramSettings.xml");

            foreach (DisplaySettings ds in settings.Settings)
            {
                frmDisplay form = new frmDisplay(ds,
                    System.Environment.GetFolderPath(Environment.SpecialFolder.CommonApplicationData) + "\\KenMazaika\\VolumeOSD\\themes\\" + settings.Name + "\\",
                    asettings.X,
                    asettings.Y,
                    asettings.Opacity);
                System.Threading.Thread t = new System.Threading.Thread(RunForm);
                t.Start(form);
            }
        }


        /// <summary>
        /// The main entry point for the application.
        /// </summary>
        [STAThread]
        static void Main()
        {
            Process[] processes = System.Diagnostics.Process.GetProcessesByName("VolumeOSD");
            foreach (Process p in processes)
            {
                if (p.Id != System.Diagnostics.Process.GetCurrentProcess().Id)
                {
                    p.Kill();
                    //MessageBox.Show("Detected that the application is already running...killing old process");
                }
            }

            Application.EnableVisualStyles();
            Application.SetCompatibleTextRenderingDefault(false);

            // If we have been asked to quit, we simply want to squash other VolumeOSD processes
            if (Environment.GetCommandLineArgs().Length == 2 && Environment.GetCommandLineArgs()[1].ToUpper().Equals("-Q"))
                return;

            // If it's not in preview mode, do the normal action
            if (Environment.GetCommandLineArgs().Length != 2 || ! Environment.GetCommandLineArgs()[1].ToUpper().Equals("-P")) 
            {
                RunDaemonAsync();
            }
            else
            {
                // -P was the command line arg, show preview window
                Application.Run(new Preview());
            }

        }


        static void RunForm(object o)
        {
            Application.Run((Form) o);
        }
    }
}
