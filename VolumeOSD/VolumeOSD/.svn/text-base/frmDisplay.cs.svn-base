using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using CoreAudioApi;
using System.Threading;
using System.IO.Compression;
using System.Drawing.Imaging;

namespace VolumeOSD
{
    public partial class frmDisplay : Form
    {
        IVolumeDetector vol;
        DisplaySettings settings;
        System.DateTime lastMove;
        DeviceInfo lastInfo;

        string BasePath;
        int _X;
        int _Y;
        double _Opacity;

        public frmDisplay(DisplaySettings setting, string basePath, int X, int Y, double Opacity)
        {
            this.Visible = false;
            CheckForIllegalCrossThreadCalls = false;
            InitializeComponent();
            settings = setting;
            this.Opacity = settings.Opacity +Opacity;
            this.Location = new Point(settings.X+X, settings.Y+Y);

            this.Width = settings.Width;
            this.Height = settings.Height;
            BasePath = basePath;
            _X = X;
            _Y = Y;
            _Opacity = Opacity;

        }

        private void frmDisplay_Load(object sender, EventArgs e)
        {
            if (Environment.OSVersion.Version.Major < 6)
            {
                // Version is 5 or less, XP or Windows Server 2k3 perhaps?
                vol = new VolumeDetectorXP();
            }
            else
            {
                // Vista on up
                vol = new VolumeDetectorVista();
            }


            
            vol.RegisterCallback(this.AudioChanged);
        }

        // Callback from VolumeDetector
        public void AudioChanged(DeviceInfo info)
        {

            // Windows7 sometimes triggers callback when volume hasn't changed. 
            if (lastInfo != null)
            {
                if (info.Muted == lastInfo.Muted && info.Volume == lastInfo.Volume )
                    return;
            }
            lastInfo = info;


            try
            {
                this.Opacity = settings.Opacity + _Opacity;
                if (this.Visible == false)
                    this.Visible = true; // throw in preview

                // Manually draw the image to get the transparency
                string image = ResolveImage(info, settings, BasePath);
                System.Drawing.Image actualImage = System.Drawing.Image.FromFile(image);
                ImageAttributes attr = new ImageAttributes();
                Rectangle dstRect = new Rectangle(0, 0, actualImage.Width, actualImage.Height);
                CreateGraphics().DrawImage(actualImage, dstRect, 0, 0, actualImage.Width, actualImage.Height,
                    GraphicsUnit.Pixel, attr);

                System.Threading.Thread t = new System.Threading.Thread(new ThreadStart(WaitAndHide));
                lastMove = System.DateTime.Now;
                t.Start();
            }
            catch (ObjectDisposedException)
            {
                // In preview we recieved a callback from an item that we cannot
                // access
                return;
            }
        }

        // Called async, wait and if a button hasn't been pressed in a while, hide the window
        private void WaitAndHide()
        {
            System.Threading.Thread.Sleep(settings.Delay);
            if (IsCloseTo(System.DateTime.Now, lastMove, System.Convert.ToInt32(settings.Delay/1000)))
            {
                double fade = this.Opacity/20;
                this.Opacity -= fade;
                for (int i = 0; i < 19; i++)
                {
                    if (this.Opacity == (settings.Opacity+_Opacity))
                    {
                        return;
                    }
                    System.Threading.Thread.Sleep(10);
                    this.Opacity = this.Opacity - fade;
                }

                this.Visible = false;
                this.Opacity = fade * 20;
            }
        }

        // Has it pretty much taken the amount of time we expect?
        private bool IsCloseTo(System.DateTime first, System.DateTime second,  int SecondsOff)
        {
            TimeSpan span = first - second;
            if((span.Seconds - SecondsOff) == 0)
                return true;
            
            return false;
        }

        // Resolve the image that the device info corresponds to
        private string ResolveImage(DeviceInfo info, DisplaySettings settings, string basePath)
        {
            if (info.Muted)
                return basePath + settings.Images[0].ImageName;

            int images = settings.Images.Count;
            images--; // take into account the mute item

            double interval = (double)1 / (double)images;
            double estimatedItem = info.Volume / interval;
            int imageNumber = System.Convert.ToInt32(System.Math.Round(estimatedItem));
            return basePath + settings.Images[System.Math.Min(images, imageNumber + 1)].ImageName;
        }
    }
}
