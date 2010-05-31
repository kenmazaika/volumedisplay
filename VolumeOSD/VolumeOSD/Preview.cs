using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using System.IO;
using System.Threading;

namespace VolumeOSD
{
    public partial class Preview : Form
    {
        Form[] forms;
        public Preview()
        {
            InitializeComponent();
        }

        private string[] getThemeNames()
        {
            string[] dirs = Directory.GetDirectories(System.Environment.GetFolderPath(Environment.SpecialFolder.CommonApplicationData) + "\\KenMazaika\\VolumeOSD\\themes\\");
            string[] themeNames = new string[dirs.Length];
            char[] del = new char[1];
            del[0] = '\\';
            for(int i=0; i<dirs.Length; i++)
            {
                string dir = dirs[i];
                string[] splitDir = dir.Split(del);
                themeNames[i] = splitDir[splitDir.Length - 1];
            }
            return themeNames;
        }

        private void Preview_Load(object sender, EventArgs e)
        {
            ActiveSettings setting = ActiveSettings.Deserialize(System.Environment.GetFolderPath(Environment.SpecialFolder.CommonApplicationData) + "\\KenMazaika\\VolumeOSD\\Settings.xml");
            string themeName = setting.Name;

            lblActiveTheme.Text = "Active Theme: " + themeName;
            comboBox1.DataSource = getThemeNames();
            comboBox1.Text = themeName;
            txtX.Text = setting.X.ToString();
            txtY.Text = setting.Y.ToString();
            txtOpacity.Text = setting.Opacity.ToString();

            
        }

        private void button1_Click(object sender, EventArgs e)
        {
            try
            {
                btnKillPreview.Enabled = true;
                btnPreview.Enabled = false;
                string themeName = comboBox1.Text;
                ProgramSettings settings = ProgramSettings.Deserialize(System.Environment.GetFolderPath(Environment.SpecialFolder.CommonApplicationData) + "\\KenMazaika\\VolumeOSD\\themes\\" + themeName + "\\ProgramSettings.xml");
                forms = new Form[settings.Settings.Count];
                for (int i = 0; i < settings.Settings.Count; i++)
                {
                    DisplaySettings ds = settings.Settings[i];
                    frmDisplay form =
                        new frmDisplay(ds, System.Environment.GetFolderPath(Environment.SpecialFolder.CommonApplicationData) + "\\KenMazaika\\VolumeOSD\\themes\\" + settings.Name + "\\",
                            System.Convert.ToInt32(txtX.Text),
                            System.Convert.ToInt32(txtY.Text),
                            System.Convert.ToDouble(txtOpacity.Text)
                            );
                    form.Visible = true;
                    form.ShowIcon = true;
                    form.ShowInTaskbar = true;
                    Thread t = new Thread(new ParameterizedThreadStart(RunForm));
                    forms[i] = form;
                    t.Start(form);
                }
            }
            catch (Exception)
            {
                MessageBox.Show("The display failed.  Please validate data");
            }

        }

        void RunForm(object o)
        {
            frmDisplay form = (frmDisplay)o;
            form.Show();
        }

        private void btnKillPreview_Click(object sender, EventArgs e)
        {
            btnKillPreview.Enabled = false;
            btnPreview.Enabled = true;
            
            if (forms != null)
            {
                foreach (Form t in forms)
                    t.Dispose();

                forms = null;
            }
            else
            {
                MessageBox.Show("cannot kill, nothing running");
            }
        }

        private void btnActivate_Click(object sender, EventArgs e)
        {
            try
            {
                // Serialize Active Theme
                ActiveSettings settings = new ActiveSettings();
                settings.Name = comboBox1.Text;
                settings.X = System.Convert.ToInt32(txtX.Text);
                settings.Y = System.Convert.ToInt32(txtY.Text);
                settings.Opacity = System.Convert.ToDouble(txtOpacity.Text);

                string filename = Environment.GetFolderPath(Environment.SpecialFolder.CommonApplicationData) + "\\KenMazaika\\VolumeOSD\\Settings.xml";

                ActiveSettings.Serialize(filename, settings);


                // Reload from XML as a sanity check
                string themeName = ActiveSettings.Deserialize(System.Environment.GetFolderPath(Environment.SpecialFolder.CommonApplicationData) + "\\KenMazaika\\VolumeOSD\\Settings.xml").Name;
                lblActiveTheme.Text = "Active Theme: " + themeName;
            }
            catch (Exception)
            {
                MessageBox.Show("Saving failed.  Please validate data");
            }

        }

        private void comboBox1_SelectedIndexChanged(object sender, EventArgs e)
        {
            txtX.Text = "0";
            txtY.Text = "0";
            txtOpacity.Text = "0.0";
        }

        protected override void OnClosing(CancelEventArgs e)
        {
            base.OnClosing(e);
            Program.RunDaemonAsync();
        }
    }
}
